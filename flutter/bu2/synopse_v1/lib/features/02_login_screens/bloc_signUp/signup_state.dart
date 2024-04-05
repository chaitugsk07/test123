part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  final List<Signup> signUp;
  final SignUpStatus status;

  const SignUpState(
      {this.signUp = const <Signup>[], this.status = SignUpStatus.initial});

  SignUpState copyWith({
    List<Signup>? signUp,
    SignUpStatus? status,
  }) {
    return SignUpState(
      signUp: signUp ?? this.signUp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [signUp, status];
}
