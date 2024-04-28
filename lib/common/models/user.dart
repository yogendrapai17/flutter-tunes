class User {
  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    this.favourites = const [],
    this.mobileNumber,
    this.gender,
    this.isSynced,
  });

  final String userId;
  final String name;
  final String? gender;
  final String email;
  final String? mobileNumber;
  final String password;
  final List<String> favourites;
  final bool? isSynced;

  User copyWith({
    String? userId,
    String? name,
    String? gender,
    String? email,
    String? mobileNumber,
    String? password,
    List<String>? favourites,
    bool? isSynced,
  }) =>
      User(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        password: password ?? this.password,
        favourites: favourites ?? this.favourites,
        isSynced: isSynced ?? this.isSynced,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'] as String,
        name: json['name'] as String,
        gender: json['gender'] as String?,
        email: json['email'] as String,
        mobileNumber: json['mobile_number'] as String?,
        password: json['password'] as String,
        favourites: (json['favourites'] != null)
            ? List<String>.from(json['favourites'].map((x) => x))
            : [],
        isSynced: json['isSynced'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'gender': gender,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'favourites': favourites,
      };

  Map<String, dynamic> toLocalJson() => {
        'user_id': userId,
        'name': name,
        'gender': gender,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'favourites': favourites,
        'isSynced': isSynced,
      };
}
