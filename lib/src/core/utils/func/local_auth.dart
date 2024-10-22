import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;
      return await _auth.authenticate(
          authMessages: const [
            AndroidAuthMessages(
                signInTitle: 'Sign in', cancelButton: 'No Thanks'),
          ],
          localizedReason: 'Use Biometric to Authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ));
    } catch (e) {
      return false;
    }
  }
}
