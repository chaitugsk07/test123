part of 'create_account_bloc.dart';

@immutable
abstract class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();
  @override
  List<Object?> get props => [];
}

class CreateAccountForValidGmail extends CreateAccountEvent {
  final String name;
  final String googleEmail;
  final String googleId;
  final String googlePhotoUrl;
  final int googlePhotoValid;

  const CreateAccountForValidGmail(
      {required this.name,
      required this.googleEmail,
      required this.googleId,
      required this.googlePhotoUrl,
      required this.googlePhotoValid});

  @override
  List<Object> get props =>
      [name, googleEmail, googleId, googlePhotoUrl, googlePhotoValid];
}
