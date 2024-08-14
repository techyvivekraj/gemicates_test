import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:gemicates/utils/constants.dart';

class FirebaseService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> fetchDiscountConfig() async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getBool(remoteConfigKeyShowDiscountedPrice)
        ? _remoteConfig.getBool(remoteConfigKeyShowDiscountedPrice)
        : false;
  }
}
