
import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  static const _key = 'is_premium';

  Future<bool> isPremium() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_key) ?? false;
  }

  Future<void> setPremium(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_key, v);
  }
}
