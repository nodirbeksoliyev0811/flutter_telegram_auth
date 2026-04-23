/// Telegram user model extracted from JWT token.
class TelegramUser {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? photoUrl;
  final int? authDate;

  TelegramUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.photoUrl,
    this.authDate,
  });

  factory TelegramUser.fromJson(Map<String, dynamic> json) {
    return TelegramUser(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      photoUrl: json['photo_url'],
      authDate: json['auth_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'photo_url': photoUrl,
      'auth_date': authDate,
    };
  }
}
