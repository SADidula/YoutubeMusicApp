import 'package:googleapis_auth/googleapis_auth.dart';

class CustomAuthClient {
  late AuthClient? authClient;

  CustomAuthClient({required this.authClient});

  CustomAuthClient.fromMap(
      Map map) // This Function helps to convert our Map into our User Object
      : this.authClient = map["authClient"];

  Map toMap() {
    // This Function helps to convert our User Object into a Map.
    return {
      "authClient": this.authClient,
    };
  }
}
