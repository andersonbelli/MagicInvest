double parseCurrency(String value) {
  // Remove the currency symbol and any non-numeric characters except for ',' and '.'
  String cleanedValue = value.replaceAll(RegExp(r'[^\d,\.]'), '');

  // Replace all thousands separators (dots) with nothing
  cleanedValue = cleanedValue.replaceAll('.', '');

  // Replace the last comma (which is the decimal separator in Brazilian currency) with a dot
  cleanedValue =
      cleanedValue.replaceAllMapped(RegExp(r',(?=\d{2}$)'), (match) => '.');

  // Parse the cleaned value into a double
  return double.tryParse(cleanedValue) ?? 0.0;
}
