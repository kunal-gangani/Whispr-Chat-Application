class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;
  final bool isOnline;
  final String initials;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
    this.isOnline = false,
    this.initials = '',
  });

  /// Factory constructor to create a `UserModel` from JSON data.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      isOnline: json['isOnline'] ?? false,
      initials: json['name'] != null ? json['name'][0].toUpperCase() : '',
    );
  }

  /// Converts the `UserModel` object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'isOnline': isOnline,
      'initials': name.isNotEmpty ? name[0].toUpperCase() : '',
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePictureUrl,
    bool? isOnline,
    String? initials,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isOnline: isOnline ?? this.isOnline,
      initials: initials ?? this.initials,
    );
  }
}
