import 'package:carolie_tracking_app/src/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required super.emailVerified,
    super.photoUrl,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map, String id) {
    return AppUserModel(
      id: id,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      emailVerified: map['emailVerified'] as bool? ?? false,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'photoUrl': photoUrl,
    };
  }
}
