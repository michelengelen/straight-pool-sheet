import 'package:firebase_auth/firebase_auth.dart';

String getProfilePictureUrl(FirebaseUser user) {
  String avatarPicture;
  final String provider = user.providerData[0].providerId.split('.')[0];
  switch (provider) {
    case 'facebook':
      avatarPicture = user.photoUrl + '?width=400';
      break;
    case 'twitter':
      avatarPicture = user.photoUrl.replaceAll('_normal', '');
      break;
    case 'google':
    default:
      avatarPicture = user.photoUrl;
      break;
  }

  return avatarPicture;
}