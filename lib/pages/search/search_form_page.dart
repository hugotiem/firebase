import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pts/blocs/parties/parties_cubit.dart';
import 'package:pts/blocs/search/search_cubit.dart';
import 'package:pts/components/app_datetime.dart';
import 'package:pts/components/app_grid.dart';
import 'package:pts/components/components_export.dart';
import 'package:pts/const.dart';
import 'package:pts/models/city.dart';
import 'package:pts/models/place_search.dart';
import 'package:pts/pages/search/map_view_page.dart';
import 'package:pts/pages/search/sliver/searchbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchFormPageLauncher extends StatelessWidget {
  const SearchFormPageLauncher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SearchCubit();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SearchFormPage(
          onPop: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class SearchFormPage extends StatefulWidget {
  final String? last;
  final void Function()? onPop;
  SearchFormPage({Key? key, this.last, this.onPop}) : super(key: key);

  @override
  State<SearchFormPage> createState() => _SearchFormPageState();
}

class _SearchFormPageState extends State<SearchFormPage> {
  final FocusNode _focusNode = FocusNode();

  String? destination;

  late TextEditingController _textEditingController;
  late PanelController _panelController;

  double _hiddenPaddingFactor = 1;

  @override
  void initState() {
    if (widget.last != null) {
      BlocProvider.of<SearchCubit>(context).fetchResults(widget.last);
    }
    _textEditingController = TextEditingController(text: widget.last);
    _panelController = PanelController();
    Future.delayed(const Duration(milliseconds: 300))
        .then((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _panelController.animatePanelToPosition(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else {
                if (widget.onPop != null) {
                  widget.onPop!();
                } else {
                  Navigator.of(context).pop();
                }
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
                  SearchBarContent(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                  ),
                  BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                    var results = state.results;
                    if (results == null || results.isEmpty) {
                      return NoResultContent();
                    }
                    return ResultsContent(
                      results: results,
                      onTileTapped: (value) async {
                        if (widget.last != null) {
                          Navigator.of(context).pop({'newResult': destination});
                        } else {
                          _focusNode.unfocus();
                          setState(() {
                            destination = value;
                          });
                          BlocProvider.of<SearchCubit>(context)
                              .updateDestination(
                                  destination: value,
                                  last: _textEditingController.text);
                          await Future.delayed(const Duration(
                            milliseconds: 100,
                          ));
                          _panelController.animatePanelToPosition(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// StatelessWidgets

class SearchBarContent extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController? controller;
  SearchBarContent({Key? key, required this.focusNode, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, top: 20, left: 20, right: 20),
      child: Hero(
        tag: 'search-widget',
        child: SearchBar(
          controller: controller,
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
            style: AppTextStyle(fontWeight: FontWeight.bold),
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
                    style: AppTextStyle(
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
            style: AppTextStyle(fontWeight: FontWeight.bold),
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
                          style: AppTextStyle(
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

class CalendarContent extends StatefulWidget {
  final String? destination;
  final Color? textColor;
  final TextStyle? calendarTextStyle;
  final bool months;
  CalendarContent(
      {Key? key,
      this.destination,
      this.textColor,
      this.calendarTextStyle,
      this.months = true})
      : super(key: key);

  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTime? date;
  List<DateTime>? months;

  @override
  void initState() {
    _tabController = TabController(length: widget.months ? 2 : 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.destination != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: "Destination: ",
                  style: AppTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: '${widget.destination}',
                      style: AppTextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.destination != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Sélectionne tes dates",
                style: AppTextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          if (widget.months)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: widget.textColor?.withOpacity(.1) ??
                      Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: TabBar(
                padding: EdgeInsets.all(6),
                labelStyle: AppTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor ?? Colors.white),
                unselectedLabelStyle: AppTextStyle(
                  fontWeight: FontWeight.normal,
                  color: widget.textColor ?? Colors.white,
                ),
                controller: _tabController,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Calendrier",
                        style: AppTextStyle(color: widget.textColor),
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text("Je suis flexible",
                        style: AppTextStyle(color: widget.textColor)),
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
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: CalendarWidget(
                    onSelectedDay: (selected) => date = selected,
                    themeColor: widget.textColor,
                  ),
                ),
                if (widget.months)
                  IamFlexibleWidget(
                    onMonthSelected: (selected) => months = selected,
                    themeColor: widget.textColor,
                  ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(bottom: widget.textColor != null ? 0 : 120),
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                    style: AppTextStyle(
                      color: widget.textColor ?? Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
                onTap: () {
                  MapViewPage? page;
                  if (_tabController.index == 0 && date != null) {
                    page = MapViewPage(
                      hasDate: true,
                      date: date,
                    );
                  } else if (_tabController.index == 1 && months != null) {
                    page = MapViewPage(
                      hasDate: true,
                      months: months,
                    );
                  } else {
                    print("Aucune date séléctionné");
                  }
                  if (page != null) {
                    if (widget.destination == null) {
                      Navigator.of(context).pop({
                        "type": date != null ? "date" : "months",
                        "value": date != null ? date : months
                      });
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => page!,
                          fullscreenDialog: true,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final void Function(DateTime) onSelectedDay;
  final Color? themeColor;
  final Color? backgroundColor;
  final bool? shadow;
  final EdgeInsetsGeometry? padding;
  CalendarWidget(
      {Key? key,
      required this.onSelectedDay,
      this.themeColor,
      this.backgroundColor,
      this.shadow = false, 
      this.padding})
      : super(key: key);

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
          Container(
            padding: widget.padding ?? const EdgeInsets.only(top: 20),
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                    color: widget.themeColor ?? Colors.white,
                  ),
                ),
                Text(
                  _currentDate,
                  style: AppTextStyle(
                    color: widget.themeColor ?? Colors.white,
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
                    color: widget.themeColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _daysOfWeek
                  .map(
                    (e) => Text(e[0],
                        style: AppTextStyle(
                          color: _selectedDay.weekday - 1 ==
                                      _daysOfWeek.indexOf(e) &&
                                  isMonthAndYearEquals(
                                      _selectedDay, _focusedDay)
                              ? widget.themeColor ?? Colors.white
                              : widget.themeColor?.withOpacity(0.3) ??
                                  Colors.white.withOpacity(0.3),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(width: 2, color: Colors.white.withOpacity(0.1)),
                color: widget.backgroundColor ?? Colors.white.withOpacity(0.2),
                boxShadow: [
                  widget.shadow == true
                      ? BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 10,
                        )
                      : BoxShadow()
                ]),
            clipBehavior: Clip.antiAlias,
            child: TableCalendar(
              currentDay: _selectedDay,
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    widget.shadow == true
                        ? BoxShadow(
                            color: ICONCOLOR.withOpacity(0.5),
                            spreadRadius: 7,
                            blurRadius: 15,
                          )
                        : BoxShadow()
                  ],
                ),
                defaultTextStyle:
                    AppTextStyle(color: widget.themeColor ?? Colors.white),
                outsideDaysVisible: false,
                weekendTextStyle:
                    AppTextStyle(color: widget.themeColor ?? Colors.white),
                disabledTextStyle: AppTextStyle(
                    color: widget.themeColor?.withOpacity(0.6) ??
                        Colors.white.withOpacity(0.3)),
                todayDecoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle),
                todayTextStyle: AppTextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                selectedTextStyle: AppTextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
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
  final void Function(List<DateTime>)? onMonthSelected;
  final Color? themeColor;
  const IamFlexibleWidget({Key? key, this.onMonthSelected, this.themeColor})
      : super(key: key);

  @override
  State<IamFlexibleWidget> createState() => _IamFlexibleWidgetState();
}

class _IamFlexibleWidgetState extends State<IamFlexibleWidget> {
  final AppDateTime _first = AppDateTime.now().copyWith(day: 1);

  List<AppDateTime> _selectedDates = [];

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
              bool _isSelected = _selectedDates.contains(_current);
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.themeColor ?? Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: _isSelected
                        ? widget.themeColor?.withOpacity(.2) ??
                            Colors.white.withOpacity(0.3)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.MMMM('fr').format(_current),
                        style: AppTextStyle(
                            color: widget.themeColor ?? Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        DateFormat.y('fr').format(_current),
                        style: AppTextStyle(
                            color: widget.themeColor ?? Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (_isSelected) {
                      _selectedDates.remove(_current);
                    } else {
                      _selectedDates.add(_current);
                    }
                  });
                  if (widget.onMonthSelected != null)
                    widget.onMonthSelected!(_selectedDates);
                },
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
              bool _isSelected = _selectedDates.contains(_current);
              return GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.themeColor ?? Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                    color: _isSelected ? Colors.white.withOpacity(0.3) : null,
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.MMMM('fr').format(_current),
                        style: AppTextStyle(
                            color: widget.themeColor ?? Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        DateFormat.y('fr').format(_current),
                        style: AppTextStyle(
                            color: widget.themeColor ?? Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (_isSelected) {
                      _selectedDates.remove(_current);
                    } else {
                      _selectedDates.add(_current);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
