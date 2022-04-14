import 'package:equatable/equatable.dart';

class Slide extends Equatable {
  final String? title;
  final String? desc;
  final String? image;
  final String? btnText;
  final int? index;

  Slide({this.title, this.desc, this.image, this.btnText, this.index});

  @override
  List<Object?> get props => throw UnimplementedError();
}
