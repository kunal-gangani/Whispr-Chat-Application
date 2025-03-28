class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl = '',
    this.isOnline = false,
  });

  /// Factory constructor to create a `UserModel` from JSON data.
  factory UserModel.fromJson(Map<String, dynamic> json,
      {required String docId}) {
    return UserModel(
      id: docId, // Assign Firestore document ID directly
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      isOnline: json['isOnline'] ?? false,
    );
  }

  /// Converts the `UserModel` object to a JSON map (for Firestore).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'isOnline': isOnline,
    };
  }

  /// Compute user initials dynamically (e.g., "John Doe" → "J")
  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '';

  /// Allows updating properties of `UserModel`
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePictureUrl,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
