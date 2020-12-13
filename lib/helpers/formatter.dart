String formatDateString(String baseString) {

  String year = baseString.substring(0, 4);
  String month = baseString.substring(5,7);
  String day = baseString.substring(8, 10);

  print("FORMATTER " + day);
  return day + "." + month + "." + year;
}


String formatDateTimeString(String baseString) {

  String year = baseString.substring(0, 4);
  String month = baseString.substring(5,7);
  String day = baseString.substring(8, 10);
  String hour = baseString.substring(11, 13);
  String minute = baseString.substring(14, 16);


  print("FORMATTER WITH TIME" + minute);
  return day + "." + month + "." + year + ", at " + hour + ":" + minute;
}