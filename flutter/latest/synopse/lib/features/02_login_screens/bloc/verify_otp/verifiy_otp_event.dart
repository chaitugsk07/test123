part of 'verifiy_otp_bloc.dart';

@immutable
abstract class VerifyOTPEvent extends Equatable {
  const VerifyOTPEvent();
  @override
  List<Object?> get props => [];
}

class VerifyOTPForValidPhNo extends VerifyOTPEvent {
  final String country;
  final int phoneno;
  final int otp;
  final String name;
  final String googleEmail;
  final String googleId;
  final String googlePhotoUrl;
  final int googlePhotoValid;

  const VerifyOTPForValidPhNo(
      {required this.country,
      required this.phoneno,
      required this.otp,
      required this.name,
      required this.googleEmail,
      required this.googleId,
      required this.googlePhotoUrl,
      required this.googlePhotoValid});

  @override
  List<Object> get props => [
        country,
        phoneno,
        otp,
        name,
        googleEmail,
        googleId,
        googlePhotoUrl,
        googlePhotoValid
      ];
}
