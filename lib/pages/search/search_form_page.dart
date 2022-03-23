import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/search/search_cubit.dart';
import 'package:pts/components/app_datetime.dart';
import 'package:pts/components/app_grid.dart';
import 'package:pts/const.dart';
import 'package:pts/models/city.dart';
import 'package:pts/models/place_search.dart';
import 'package:pts/pages/search/map_view_page.dart';
import 'package:pts/pages/search/sliver/searchbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchFormPage extends StatefulWidget {
  SearchFormPage({Key? key}) : super(key: key);

  @override
  State<SearchFormPage> createState() => _SearchFormPageState();
}

class _SearchFormPageState extends State<SearchFormPage> {
  final FocusNode _focusNode = FocusNode();

  String? destination;

  late PanelController _panelController;

  double _hiddenPaddingFactor = 1;

  @override
  void initState() {
    _panelController = PanelController();
    Future.delayed(const Duration(milliseconds: 300))
        .then((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Image.asset("assets/back-btn.png"),
              onPressed: () {
                if (_panelController.isPanelClosed) {
                  _panelController.open();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SECONDARY_COLOR,
                  ICONCOLOR,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                SECONDARY_COLOR,
                ICONCOLOR,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
            ),
          ),
          child: SlidingUpPanel(
            panelSnapping: false,
            borderRadius: BorderRadius.circular(40),
            body: Padding(
              padding: EdgeInsets.only(top: 50 * _hiddenPaddingFactor),
              child: CalendarContent(destination: destination),
            ),
            maxHeight: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 20),
            minHeight: 0,
            defaultPanelState: PanelState.OPEN,
            controller: _panelController,
            isDraggable: false,
            onPanelSlide: (value) {
              setState(() {
                _hiddenPaddingFactor = value;
              });
            },
            panelBuilder: (sc) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 20),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SearchBarContent(focusNode: _focusNode),
                    BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                      var result = state.results;
                      if (result == null || result.isEmpty) {
                        return NoResultContent();
                      }
                      return ResultsContent(
                        results: result,
                        onTileTapped: (value) async {
                          _focusNode.unfocus();
                          setState(() {
                            destination = value;
                          });
                          await Future.delayed(const Duration(
                            milliseconds: 200,
                          ));
                          _panelController.close();
                        },
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// StatelessWidgets

class SearchBarContent extends StatelessWidget {
  final FocusNode focusNode;
  SearchBarContent({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 20, left: 20, right: 20),
      child: Hero(
        tag: 'search-widget',
        child: SearchBar(
          hintText: 'Où vas-tu ?',
          borderColor: ICONCOLOR,
          hintColor: ICONCOLOR,
          onChanged: (value) {
            context.read<SearchCubit>().fetchResults(value);
          },
          focusNode: focusNode,
        ),
      ),
    );
  }
}

class NoResultContent extends StatelessWidget {
  NoResultContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "N'importe où, n'importe quand".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: TextButton(
              style: TextButton.styleFrom(
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.3),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explorer",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
              onPressed: () {},
            ),
          ),
          Text(
            "Là où il y a du monde...".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          BlocProvider(
              create: (context) => PartiesCubit(), child: CitiesListContent()),
        ],
      ),
    ));
  }
}

class CitiesListContent extends StatelessWidget {
  const CitiesListContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<City>>(
      future:
          BlocProvider.of<PartiesCubit>(context).fetchCitiesByPartiesNumber(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return Container();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: snapshots.data
                  ?.map<Widget>((e) => ListTile(
                        title: Text(
                          e.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        subtitle: Text("${e.partiesNumber} soirée(s)"),
                      ))
                  .toList() ??
              [],
        );
      },
    );
  }
}

class ResultsContent extends StatelessWidget {
  final List<PlaceSearch> results;
  final void Function(String?)? onTileTapped;
  const ResultsContent({Key? key, required this.results, this.onTileTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            if (onTileTapped != null) {
              onTileTapped!(results[index].description!);
            }
          },
          title: Text(results[index].description!),
        ),
      ),
    );
  }
}

class CalendarContent extends StatelessWidget {
  final String? destination;
  CalendarContent({Key? key, required this.destination}) : super(key: key);

  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Destination: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                children: [
                  TextSpan(
                    text: '$destination',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Sélectionne tes dates",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: TabBar(
                padding: EdgeInsets.all(6),
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("Calendrier"),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text("Je suis flexible"),
                  ),
                ],
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: CalendarWidget(
                      onSelectedDay: (selected) => date = selected,
                    ),
                  ),
                  IamFlexibleWidget(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 140),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white.withOpacity(0.3)),
                    child: Text(
                      "Suivant".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapViewPage(
                        result: destination ?? "Paris",
                      ),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final void Function(DateTime) onSelectedDay;
  CalendarWidget({Key? key, required this.onSelectedDay}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final List<String> _daysOfWeek = [
    'Lin',
    'Mar',
    'Mer',
    'Jer',
    'Ven',
    'Sam',
    'Dim'
  ];

  String _currentDate = DateFormat.yMMMM('fr').format(DateTime.now());

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  DateTime _firstDay = AppDateTime.now().copyWith(day: 1);

  bool isMonthAndYearEquals(DateTime date, DateTime other) {
    return date.month == other.month && date.year == other.year;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    var previous =
                        AppDateTime.from(_focusedDay).removeTime(month: 1);
                    if (previous.isAfter(_firstDay)) {
                      setState(() {
                        _focusedDay = previous;
                        _currentDate = DateFormat.yMMMM('fr').format(
                            DateTime(_focusedDay.year, _focusedDay.month));
                      });
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _currentDate,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    var next = AppDateTime.from(_focusedDay).addTime(month: 1);
                    if (next.isBefore(
                        AppDateTime.from(_firstDay).addTime(year: 1))) {
                      _focusedDay = next;
                      _currentDate = _currentDate = DateFormat.yMMMM('fr')
                          .format(
                              DateTime(_focusedDay.year, _focusedDay.month));
                    }
                  }),
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _daysOfWeek
                  .map(
                    (e) => Text(e[0],
                        style: TextStyle(
                          color: _selectedDay.weekday - 1 ==
                                      _daysOfWeek.indexOf(e) &&
                                  isMonthAndYearEquals(
                                      _selectedDay, _focusedDay)
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          fontSize: 20,
                        )),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(width: 2, color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.2),
            ),
            clipBehavior: Clip.antiAlias,
            child: TableCalendar(
              currentDay: _selectedDay,
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle),
                defaultTextStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.white),
                disabledTextStyle:
                    TextStyle(color: Colors.white.withOpacity(0.3)),
                todayDecoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle),
                todayTextStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                selectedTextStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              enabledDayPredicate: (day) {
                return isSameDay(DateTime.now(), day) ||
                    day.isAfter(DateTime.now());
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onPageChanged: (current) {
                setState(() {
                  _focusedDay = current;
                  _currentDate = DateFormat.yMMMM('fr')
                      .format(DateTime(current.year, current.month));
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
                widget.onSelectedDay(selectedDay);
              },
              daysOfWeekVisible: false,
              locale: 'fr',
              headerVisible: false,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              startingDayOfWeek: StartingDayOfWeek.monday,
              firstDay: _firstDay,
              focusedDay: _focusedDay,
              lastDay: DateTime(DateTime.now().year + 1, DateTime.now().month),
            ),
          ),
        ],
      ),
    );
  }
}

class IamFlexibleWidget extends StatefulWidget {
  const IamFlexibleWidget({Key? key}) : super(key: key);

  @override
  State<IamFlexibleWidget> createState() => _IamFlexibleWidgetState();
}

class _IamFlexibleWidgetState extends State<IamFlexibleWidget> {
  final AppDateTime _first = AppDateTime.now();

  @override
  Widget build(BuildContext context) {
    return PageView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.vertical,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: AppGrid.builder(
            col: 2,
            itemCount: 6,
            verticalSpacing: 40,
            horizontalSpacing: 40,
            builder: (context, index) {
              var _current = _first.addTime(month: index);
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.MMMM('fr').format(_current),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        DateFormat.y('fr').format(_current),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: AppGrid.builder(
            col: 2,
            itemCount: 6,
            verticalSpacing: 40,
            horizontalSpacing: 40,
            builder: (context, index) {
              var _current = _first.addTime(month: 6 + index);
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.MMMM('fr').format(_current),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        DateFormat.y('fr').format(_current),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}
