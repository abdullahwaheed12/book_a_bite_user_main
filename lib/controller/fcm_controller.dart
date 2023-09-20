import 'dart:convert';

import 'package:http/http.dart' as http;

sendNotificationCall(String token, String? title, String body) async {
  http.Response response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAua2fObs:APA91bEHdhD1F_e8zyWcKLlhEQprfb_v8LDuMRjlaTF5steXPkrWVlGxxXlyle-IU5ua1niq9hnD3IhOy1oieWXQTVL5RJd1ea-bZ6i7lmtQgxfhcpBcY3AkfVk98XRAY8MTlfgl2TwG',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
        },
        'to': token
      },
    ),
  );
}
