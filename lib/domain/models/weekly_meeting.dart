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
  if (startOfWeek(week).isAfter(startOfWeek(current))) return candidate;
  return candidate.isAfter(current) ? current : candidate;
}

/// The next habitual meeting after both the selected day and today.
DateTime nextMeetingDate(DateTime selected, String meetingDay, DateTime today) {
  final current = DateTime(today.year, today.month, today.day);
  final from = selected.isAfter(current) ? selected : current;
  var next = meetingDateForWeek(
    startOfWeek(from).add(const Duration(days: 7)),
    meetingDay,
    current,
  );
  final thisWeek = next.subtract(const Duration(days: 7));
  if (thisWeek.isAfter(from)) next = thisWeek;
  return next;
}
