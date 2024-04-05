part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final List<LanguageElement> languageElement;
  final LanguageStatus status;

  const LanguageState(
      {this.languageElement = const <LanguageElement>[],
      this.status = LanguageStatus.initial});

  LanguageState copyWith({
    List<LanguageElement>? languageElement,
    LanguageStatus? status,
  }) {
    return LanguageState(
      languageElement: languageElement ?? this.languageElement,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [languageElement, status];
}
