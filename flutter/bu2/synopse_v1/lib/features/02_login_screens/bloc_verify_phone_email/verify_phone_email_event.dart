part of 'verify_phone_email_bloc.dart';

@immutable
abstract class VerifyPhoneEmailEvent extends Equatable {
  const VerifyPhoneEmailEvent();
  @override
  List<Object?> get props => [];
}

class VerifyPhoneEmailForValidPhNo extends VerifyPhoneEmailEvent {
  final String country;
  final String phoneno;
  final String email;
  final String accountType;
  const VerifyPhoneEmailForValidPhNo(
      {required this.country,
      required this.phoneno,
      required this.email,
      required this.accountType});

  @override
  List<Object> get props => [country, phoneno, email, accountType];
}
