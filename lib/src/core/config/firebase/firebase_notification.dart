import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('**** onBackgroundMessage ****');
  log('*Data: ${message.data}');
  log('*Notification body: ${message.notification?.body}');
  log('*Notification title: ${message.notification?.title}');
}

class FirebaseNotification {
  FirebaseNotification._();
  static final FirebaseNotification _instance = FirebaseNotification._();
  static FirebaseNotification get instance => _instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.defaultImportance,
  );

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;
    log('**** handleMessage ****');
    log('*Data: ${message.data}');
    log('*Notification body: ${message.notification?.body}');
    log('*Notification title: ${message.notification?.title}');
  }

  Future<void> initNotifications() async {
    try {
      await _initPushNotification();
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> _initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<String?> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    log('**** token: $token');
    return token;
  }

  Future<void> sendNotification({
    required String userToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final String serviceKey = await _getAccessToken();
      const String endPointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/muslim-app-9d5a2/messages:send';
      final Map<String, dynamic> message = {
        'message': {
          'token': userToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data,
        },
      };

      final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: {
          'Authorization': 'Bearer $serviceKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message),
      );
      log('**** response: ${response.body}');
      if (response.statusCode != 200) throw Exception('sendNotification error');
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getAccessToken() async {
    await dotenv.load(fileName: ".env");
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "muslim-app-9d5a2",
      "private_key_id": "9d15dd92166baf48da234091b875fa9a0e213a15",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCvXFnjvWa7K4hl\nM4CSpH/0hn1P0Jr+9N29AHuc7TT9fld+Od9inqxDBxRba+3tt755D/JXFej54Fmr\n0Qa0oLb57p723TIU+tGjAF2OIIs5hvU7ncx/GjJvr2KPQXPvgIjeA1ceOlCKIedp\nKShc3u30nllqVg+pOPG789QPJmeDdv8KigXaSzKsOM+kvU5vuF/ffSdVr7ijG8rE\nLiUuj5vRMMKkviZoWCOjXYgb40peRbUq1HN+o4XyvPCoa2K9xPz9i1dU2LVu2fRI\nERenxadow6eyxQlfZtyjtY9XoBGSe30Gq8STCUsgIsHRvQAdyLzh4qPIpkepKOGf\no5tUVewPAgMBAAECggEAAbEHhvGv7invK2FnTJgnSdG1n2b45Rux5d2oKO0wKn/P\np+k2qpSy6a9FoX91hepUp9tLsE5cTHNpugVj+1W6M3Kl+DtNp958K4aDNdiXhIsK\nON8pS/08iPpCnkojLFIWP+SoBaPKB2299d7j7kgSOIlXKHZDDr6nX55BqJHAxDJb\nYba5wdgZaSpB6oBw9ys6LYkVfL9D7rcXPwy2BY08pJGM5jJ1ap6mKOxuRjJaqqKy\nRH32w1FQyHhnfcpkPfw3/LesoF7Fs14a9cIqTxFg7pN+ahLmXpF3mpCVlct+HM8f\n0PojzJJdpiHjipmKWF/5pn2KFBBy3zJEW/Yy6MacVQKBgQDn/HKEBfIqbqkMZml7\nR24tCLcvJz+YKoALMrYeH1M4PK3jCkewGgGTaNbYdRF/SZFYdxbxKEZccMKA7Sff\nG4jMP4ZIo/jVTW6llvHlKUZPG9TqKQAf2JPgm6TjTeCTMRqy+k/Kv5scFYnxMEas\nxXHK40w7c18F0i7PY1NTXW7ZDQKBgQDBg1nL+cwBC/Qotw/wvfpqrx3V9qd3NQnp\nfenKnVah4yEoMV3ZST/oWED0GuwrvBMX/FYTEBJ5cDgj7PxdE+ilQrZsjighrUZ1\na58AUfGcN2614lPRPf+HDbnQzZSbE941HkM6qxIIxhOU1jVaMjYiMsAF0blYhqv1\nqTku71XaiwKBgE3zCHOOH+ncFxdgjg7rWHzvUcYZVQgHN9ELcCA8/FSIJxGD0cS9\naEwkzRQceg2gJaNpGJ9dng7PoLt7dItGEDg5HCDqX+EkTIp9ZrhOnx5Txr4LmswY\nlM/C3Ku37j7nIAaFjywcJ71PC3OsegLxsSOwLlxHjuVA05PB1yzK10U9AoGAM62+\nZ2jYgFcO52isCyDRJXiKwT9TzdQOR5rmusN2BVnA2xkD9SlIteYLwqUF+VAK0VcE\nLacXJ/M+Kun5I2pTsP619RupwASkUmthVRaNLajoGg7NT439FbYmr4qXayrNJuZk\nEeDpugob5J2oNeQ+7Lcc7PDrTKb6eWqt6Mjl5q0CgYEArH04KdvS//rbz6apdxw0\n71hD0EfYRXuaAEivvt4qpj/Pjy/j7cYd2skKCzX55MYvvZxCPOgSy15ZF4pCkp1D\nDUOPtty9j3eipgDPBpMLJsNuvTPU2lO+2+ShBUr3xxBF2BhUijwpi56ly/0JqCh7\nKbpicVUTWvvVv0GNpf1kh+U=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "muslim-app-abderrazak@muslim-app-9d5a2.iam.gserviceaccount.com",
      "client_id": "108270755270164165405",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/muslim-app-abderrazak%40muslim-app-9d5a2.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

}
