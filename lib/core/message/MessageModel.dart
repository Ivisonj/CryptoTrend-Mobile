class MessageModel {
  final String id;
  final String chatId;
  final String message;
  final String sender;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.message,
    required this.sender,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      message: json['message'] as String,
      sender: json['sender'] as String,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue is DateTime) {
      return dateValue;
    }

    String dateString = dateValue.toString();

    if (!dateString.endsWith('Z') && !dateString.contains('+')) {
      dateString = dateString + 'Z';
    }

    return DateTime.parse(dateString);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'message': message,
      'sender': sender,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
