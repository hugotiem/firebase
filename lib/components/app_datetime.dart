class AppDateTime extends DateTime {
  AppDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : super(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );
  AppDateTime.utc(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super.utc(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );
  AppDateTime.now() : super.now();
  AppDateTime.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch)
      : super.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  AppDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch)
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  static AppDateTime from(DateTime dateTime) {
    return AppDateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }
  // : this(dateTime.year, dateTime.day, dateTime.hour, dateTime.minute,
  //       dateTime.second, dateTime.millisecond, dateTime.microsecond);

  AppDateTime copyWith(
          {int? year,
          int? month,
          int? day,
          int? hour,
          int? minute,
          int? second,
          int? millisecond,
          int? microsecond}) =>
      AppDateTime(
          year ?? this.year,
          month ?? this.month,
          day ?? this.day,
          hour ?? this.hour,
          minute ?? this.minute,
          second ?? this.second,
          millisecond ?? this.millisecond,
          microsecond ?? this.microsecond);

  AppDateTime addTime(
          {int? year,
          int? month,
          int? day,
          int? hour,
          int? minute,
          int? second,
          int? millisecond,
          int? microsecond}) =>
      AppDateTime(
          this.year + (year ?? 0),
          this.month + (month ?? 0),
          this.day + (day ?? 0),
          this.hour + (hour ?? 0),
          this.minute + (minute ?? 0),
          this.second + (second ?? 0),
          this.millisecond + (millisecond ?? 0),
          this.microsecond + (microsecond ?? 0));

  AppDateTime removeTime(
          {int? year,
          int? month,
          int? day,
          int? hour,
          int? minute,
          int? second,
          int? millisecond,
          int? microsecond}) =>
      AppDateTime(
          this.year - (year ?? 0),
          this.month - (month ?? 0),
          this.day - (day ?? 0),
          this.hour - (hour ?? 0),
          this.minute - (minute ?? 0),
          this.second - (second ?? 0),
          this.millisecond - (millisecond ?? 0),
          this.microsecond - (microsecond ?? 0));
}
