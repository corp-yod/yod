class HttpInitialValue {
  String channel;

  HttpInitialValue({
    required this.channel,
  });

  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
    };
  }
}

class HttpInterfaceConstants {
  static String deviceId = '';
}