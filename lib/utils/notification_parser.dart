
class NotificationParser {
  static double? extractAmount(String text) {
    final r = RegExp(r'(?:Rs\.?|INR|₹)\s?([0-9,]+(?:\.[0-9]{1,2})?)', caseSensitive: false);
    final m = r.firstMatch(text);
    if (m != null) {
      final raw = m.group(1)!.replaceAll(',', '');
      return double.tryParse(raw);
    }
    final r2 = RegExp(r'([0-9,]+(?:\.[0-9]{1,2})?)');
    final m2 = r2.firstMatch(text);
    if (m2 != null) {
      final raw = m2.group(1)!.replaceAll(',', '');
      return double.tryParse(raw);
    }
    return null;
  }

  static String categorize(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('grocery') || lower.contains('grocer') || lower.contains('supermarket') || lower.contains('kirana')) return 'Food';
    if (lower.contains('uber') || lower.contains('ola') || lower.contains('taxi') || lower.contains('bus') || lower.contains('metro') || lower.contains('transport')) return 'Transport';
    if (lower.contains('pharm') || lower.contains('hospital') || lower.contains('clinic') || lower.contains('medicine')) return 'Health';
    if (lower.contains('book') || lower.contains('stationery') || lower.contains('study') || lower.contains('exam') || lower.contains('coaching')) return 'Study';
    if (lower.contains('hotel') || lower.contains('restaurant') || lower.contains('cafe')) return 'Food';
    if (lower.contains('mobikwik') || lower.contains('recharge') || lower.contains('airtel') || lower.contains('jio')) return 'Recharge';
    return 'Misc';
  }
}
