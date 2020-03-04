var monthsNames = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "July",
  "Aug",
  "Sept",
  "Oct",
  "Nov",
  "Dec"
];

String getFormattedDate(int millis) {
  print("millis = ${millis}");

  DateTime date = DateTime.fromMillisecondsSinceEpoch(millis);
  return "${date.day}-${monthsNames[date.month - 1]}-${date.year}";
}

String getShortDate(int millis) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millis);
  return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}";
}