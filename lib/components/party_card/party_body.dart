
import 'party_export.dart';

class CardBody extends StatefulWidget {
  final AnimalState? animal;
  final SmokeState? smoke;
  final String? desc, nomOrganisateur, nombre, photoUserProfile;
  final List? nameList, list, gender;
  final void Function()? contacter;
  final Map? acceptedUserInfo;
  final User? user;
  final List<Party>? partyOwner;

  const CardBody({
    Key? key,
    this.desc,
    this.nomOrganisateur,
    this.partyOwner,
    this.animal,
    this.smoke,
    this.nameList,
    this.list,
    this.nombre,
    this.contacter,
    this.photoUserProfile,
    this.acceptedUserInfo,
    this.user,
    this.gender,
  }) : super(key: key);

  @override
  State<CardBody> createState() => _CardBodyState();
}

class _CardBodyState extends State<CardBody> {
  dynamic countMale = 0;
  dynamic countFemale = 0;
  dynamic countOther = 0;
  int i = 0;
  int countComment = 0;
  double countNote = 0;

  @override
  void initState() {
    super.initState();

    for (var party in widget.partyOwner!) {
      if (party.commentIdList!.isNotEmpty) {
        countComment += party.commentIdList!.length;
      }
    }

    double _counter = 0;

    for (var party in widget.partyOwner!) {
      if (party.commentIdList!.isNotEmpty) {
        List nameList = party.commentIdList!;
        nameList.map((doc) {
          Map info = party.comment![doc];
          _counter += double.parse(info["note"].toString());
        }).toList();
      }
    }
    countNote = _counter;
    countNote /= countComment;

    if (widget.gender!.contains("Homme")) {
      countMale = widget.gender!.where((element) => element == "Homme").length;
    }
    if (widget.gender!.contains("Femme")) {
      countFemale =
          widget.gender!.where((element) => element == "Femme").length;
    }
    if (widget.gender!.contains("Autre")) {
      countOther = widget.gender!.where((element) => element == "Autre").length;
    }
    countMale = (countMale / widget.gender!.length) * 100;
    countFemale = (countFemale / widget.gender!.length) * 100;
    countOther = (countOther / widget.gender!.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 420,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.widget.nomOrganisateur != null
                      ? CText(this.widget.nomOrganisateur,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: SECONDARY_COLOR)
                      : CText(''),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Opacity(
                      opacity: 0.7,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Ionicons.star, color: ICONCOLOR),
                          ),
                          countNote.isNaN
                              ? CText(
                                  "$countComment avis",
                                  fontSize: 16,
                                )
                              : CText(
                                  "${countNote.toStringAsFixed(1)} / 5 - $countComment avis",
                                  fontSize: 16,
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ProfilePhoto(widget.photoUserProfile),
            ],
          ),
        ),
        this.widget.desc != ""
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: DescriptionTextWidget(text: this.widget.desc),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Opacity(
                    opacity: 0.7,
                    child: CText(
                      "Aucune description",
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
        widget.user == null
            ? Container()
            : widget.nameList!.contains(widget.user!.id)
                ? Padding(
                    padding: const EdgeInsets.only(left: 22, top: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        child: CText(
                          this.widget.nomOrganisateur != null
                              ? "contacter ${this.widget.nomOrganisateur!.split(" ")[0]}"
                              : 'Contacter',
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                        onPressed: this.widget.contacter,
                      ),
                    ),
                  )
                : Container(),
        HorzontalSeparator(),
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    this.widget.animal == AnimalState.allowed
                        ? Padding(
                            padding: const EdgeInsets.only(right: 22),
                            child: Icon(Ionicons.paw),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 22),
                            child: Stack(
                              children: [
                                Icon(Ionicons.paw),
                                Positioned(
                                  left: -5,
                                  child: Transform.rotate(
                                      angle: 45,
                                      child: Icon(
                                        Icons.horizontal_rule_outlined,
                                        size: 35,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          ),
                    Expanded(
                      child: CText(
                        this.widget.animal == AnimalState.allowed
                            ? "Le propriétaire possède un ou des animaux"
                            : "Aucun animal n'est présent sur place",
                        fontSize: 17,
                        color: SECONDARY_COLOR,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  widget.smoke != SmokeState.notAllowed
                      ? Padding(
                          padding: const EdgeInsets.only(right: 22),
                          child: (Icon(Icons.smoking_rooms_outlined)),
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 22),
                              child: Icon(Icons.smoking_rooms_outlined),
                            ),
                            Positioned(
                              left: -5,
                              child: Transform.rotate(
                                angle: 45,
                                child: Icon(
                                  Icons.horizontal_rule_outlined,
                                  size: 35,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                  CText(
                    Party.getTitleByState(widget.smoke),
                    fontSize: 17,
                    color: SECONDARY_COLOR,
                  ),
                ],
              ),
            ],
          ),
        ),
        HorzontalSeparator(),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: SECONDARY_COLOR,
                  borderRadius: BorderRadius.circular(15)),
              child: CText(
                  "Personnes acceptées : ${widget.list!.length}/${widget.nombre}",
                  color: PRIMARY_COLOR,
                  fontSize: 16)),
        ),
        this.widget.nameList!.isNotEmpty
            ? Column(
                children: [
                  // graphique pourcentage homme/femme/autre
                  PieChartInformation(
                    valueHomme: countMale,
                    titleHomme: '$countMale %',
                    valueFemme: countFemale,
                    titleFemme: '$countFemale %',
                    valueAutre: countOther,
                    titleAutre: '$countOther %',
                  ),
                  PieChartLegend(),
                  // faire la liste des personnes acceptées à la soirée
                  Column(children: this.widget.list as List<Widget>)
                ],
              )
            : Opacity(
                opacity: 0.7,
                child: CText("Il n'y a pas encore d'invité",
                    fontSize: 16, color: SECONDARY_COLOR),
              ),
        SizedBox(height: this.widget.list!.isNotEmpty ? 34 : 50)
      ],
    );
  }
}
