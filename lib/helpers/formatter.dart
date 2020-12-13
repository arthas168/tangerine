String formatDateString(String baseString) {

  String year = baseString.substring(0, 4);
  String month = baseString.substring(5,7);
  String day = baseString.substring(8, 10);

  print("FORMATTER " + day);
  return day + "." + month + "." + year;
}
