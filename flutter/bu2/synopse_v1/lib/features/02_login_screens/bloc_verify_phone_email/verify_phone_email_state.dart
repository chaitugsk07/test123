part of 'verify_phone_email_bloc.dart';

class VerifyPhoneEmailState extends Equatable {
  final VerifyPhoneEmailStatus status;
  final String regEmail;

  const VerifyPhoneEmailState({
    this.status = VerifyPhoneEmailStatus.loading,
    this.regEmail = '',
  });

  VerifyPhoneEmailState copyWith({
    VerifyPhoneEmailStatus? status,
    String? regEmail,
  }) {
    return VerifyPhoneEmailState(
      status: status ?? this.status,
      regEmail: regEmail ?? this.regEmail,
    );
  }

  @override
  List<Object?> get props => [status, regEmail];
}
