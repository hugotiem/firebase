import 'package:pts/blocs/application/application_cubit.dart';
import 'package:pts/components/party_card/party_export.dart';
import 'package:pts/pages/creation/date_page.dart';
import 'package:pts/pages/creation/description_page.dart';
import 'package:pts/pages/creation/end_page.dart';
import 'package:pts/pages/creation/guestnumber_price_page.dart';
import 'package:pts/pages/creation/hour_page.dart';
import 'package:pts/pages/creation/location_page.dart';
import 'package:pts/pages/creation/name_page.dart';
import 'package:pts/pages/creation/theme_page.dart';
import 'package:pts/blocs/parties/build_parties_cubit.dart';

class CreationPage extends StatelessWidget {
  CreationPage({Key? key}) : super(key: key);
  final PageController _controller = PageController();

  void onNext(BuildContext context) {
    _controller.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    FocusScope.of(context).unfocus();
  }

  void onPrevious(BuildContext context) {
    _controller.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<ApplicationCubit>(context).state.user == null) {
      return Connect();
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => BuildPartiesCubit(),
        child: BlocBuilder<BuildPartiesCubit, BuildPartiesState>(
            builder: (context, state) {
          var party = state.party;
          return PageView(
            controller: _controller,
            children: [
              NamePage(
                onNext: onNext,
                title: party?.name,
              ),
              ThemePage(
                onNext: onNext,
                onPrevious: onPrevious,
                party: party,
              ),
              DatePage(
                onNext: onNext,
                onPrevious: onPrevious,
                date: party?.date,
              ),
              HourPage(
                  onNext: onNext, onPrevious: onPrevious, party: state.party),
              LocationPage(
                onNext: onNext,
                onPrevious: onPrevious,
                address: party?.address,
              ),
              GuestNumber(onNext: onNext, onPrevious: onPrevious),
              DescriptionPage(onNext: onNext, onPrevious: onPrevious),
              EndPage(),
            ],
            physics: NeverScrollableScrollPhysics(),
          );
        }),
      ),
    );
  }
}
