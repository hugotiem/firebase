import 'package:pts/components/party_card/party_export.dart';

class CustomSliverCard extends StatefulWidget {
  final Widget? body, titleText, bottomNavigationBar;
  final String? date, image, startHour, endHour;
  final Color? color;
  final User? user;
  final Party party;

  const CustomSliverCard(
      {this.image,
      this.color,
      this.body,
      this.titleText,
      this.date,
      this.bottomNavigationBar,
      this.endHour,
      this.startHour,
      this.user,
      required this.party,
      Key? key})
      : super(key: key);

  @override
  _CustomSliverCardState createState() => _CustomSliverCardState();
}

class _CustomSliverCardState extends State<CustomSliverCard> {
  double? _size, _opacity;
  late Color _toolbarColor;
  double _note = 3;
  String _comment = "";

  @override
  void initState() {
    _size = 300;
    _toolbarColor = Colors.transparent;

    _opacity = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int countComment = 0;
    Future<void> editParty() {
      return customShowModalBottomSheet(
        context,
        children: [
          titleText("Gère ta soirée"),
          onTapContainer(context, "Modifie ta soirée", EditParty(widget.party)),
          onTapContainerToDialog(
            context,
            "Supprime ta soirée",
            title: "Supprime ta soirée",
            textButton1: "OUI",
            textButton2: "NON",
            onPressed1: () {
              FirebaseFirestore.instance
                  .collection("parties")
                  .doc(widget.party.id)
                  .delete();
              Navigator.popUntil(context, (route) {
                return countComment++ == 2;
              });
            }, //supprime la soirée
            onPressed2: () => Navigator.pop(context),
          ),
        ],
      );
    }

    Party party = widget.party;

    Future<void> commentParty() {
      return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            if (!party.commentIdList!.contains(widget.user!.id)) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText("Note la soirée"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: RatingBar.builder(
                        direction: Axis.horizontal,
                        minRating: 1,
                        initialRating: 3,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: ICONCOLOR),
                        onRatingUpdate: (rating) {
                          setModalState(() {
                            _note = rating;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Center(
                          child: Container(
                            height: 226,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: TextFormField(
                                onChanged: (value) {
                                  setModalState(() {
                                    _comment = value;
                                  });
                                },
                                style: TextStyle(
                                  fontSize: TEXTFIELDFONTSIZE,
                                ),
                                maxLength: 500,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  hintText:
                                      'Un mot sur la soirée que tu viens de passer',
                                  border: InputBorder.none,
                                  counterStyle: TextStyle(height: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => PartiesCubit(),
                      child: BlocBuilder<PartiesCubit, PartiesState>(
                          builder: (context, state) {
                        return InkWell(
                          onTap: () async {
                            if (widget.user!.id == null) throw Error();
                            await BlocProvider.of<PartiesCubit>(context)
                                .addComment(
                                    widget.user, party, _note, _comment);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: SECONDARY_COLOR,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: CText(
                                  'Envoyer',
                                  color: PRIMARY_COLOR,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 22),
                child: CText(
                  'Tu as déjà laissé un commentaire',
                  fontSize: 18,
                ),
              );
            }
          });
        },
      );
    }

    return CustomSliver(
      backgroundColor: PRIMARY_COLOR,
      toolbarColor: _toolbarColor,    
      body: widget.body!,
      searchBar: Stack(
        children: [
          Opacity(
            opacity: _opacity!,
            child: Container(
              height: _size,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: widget.color,
                image: DecorationImage(
                  image: AssetImage(widget.image!),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 55, left: 22),
              child: Container(
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Ionicons.arrow_back_outline),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          if (widget.user == null)
            Center(child: CircularProgressIndicator())
          else if (party.ownerId == widget.user?.id)
            setting(() => editParty())
          else if (party.validatedList!.contains(widget.user!.id) &&
              party.isActive == false)
            setting(() => commentParty())
          else
            Container(),
          Column(
            children: [
              SizedBox(height: _size! - 50),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 27.5, left: 27.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CText(
                              widget.party.name,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                    ),
                                    child: Icon(
                                      Ionicons.calendar_clear_outline,
                                      color: SECONDARY_COLOR,
                                      size: 25,
                                    ),
                                  ),
                                  CText(
                                    "${widget.date} : de ${widget.startHour} à ${widget.endHour}",
                                    color: SECONDARY_COLOR,
                                    fontSize: 16,
                                  )
                                ],
                              )),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Ionicons.location_outline,
                                  color: SECONDARY_COLOR,
                                  size: 25,
                                ),
                              ),
                              CText(
                                widget.party.city,
                                color: SECONDARY_COLOR,
                                fontSize: 16,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      onNotification: (notification) {
        double pixel = notification.metrics.pixels;
        if (pixel > 140) {
          setState(() {
            _size = 160;
          });
        }
        if (pixel < 140) {
          setState(() {
            _size = 300 - pixel;
          });
        }
        return true;
      },
      bottomNavigationBar: widget.bottomNavigationBar!,
    );
  }

  Widget setting(void Function()? onPressed) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 55, right: 22),
        child: Container(
          decoration: BoxDecoration(
            color: PRIMARY_COLOR.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Ionicons.ellipsis_vertical_outline),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  Widget setting1(void Function()? onPressed) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Ionicons.ellipsis_vertical_outline,
          color: ICONCOLOR,
        ),
      ),
    );
  }
}
