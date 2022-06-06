import '../components/party_card/party_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function()? onPressed;
  final String? title;
  final List<Widget>? actions;
  const CustomAppBar({Key? key, this.onPressed, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      backgroundColor: Colors.transparent,
      title: title != null ? Text(title!) : null,
      elevation: 0,
      leadingWidth: 70,
      leading: onPressed != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  icon: Image.asset("assets/back-btn.png"),
                  onPressed: onPressed),
            )
          : null,
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
