class WeeklyMeeting {
  const WeeklyMeeting({required this.weekStart, this.date, this.photoUrl});
  final String weekStart;
  final String? date, photoUrl;
  factory WeeklyMeeting.fromJson(Map<String, dynamic> data) => WeeklyMeeting(
    weekStart: data['weekStart'] as String,
    date: data['date'] as String?,
    photoUrl: data['photoUrl'] as String?,
  );
}

DateTime startOfWeek(DateTime date) => DateTime(
  date.year,
  date.month,
  date.day,
).subtract(Duration(days: date.weekday - 1));
DateTime meetingDateForWeek(DateTime week, String meetingDay, DateTime today) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final index = days.indexOf(meetingDay);
  final candidate = startOfWeek(
    week,
  ).add(Duration(days: index < 0 ? 5 : index));
  final current = DateTime(today.year, today.month, today.day);
  return candidate.isAfter(current) ? current : candidate;
}
