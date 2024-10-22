part of 'locale_cubit.dart';

sealed class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object> get props => [];
}

final class LocaleInitial extends LocaleState {}

final class ChangeLocaleState extends LocaleState {
  final Locale locale;

  const ChangeLocaleState({required this.locale});

  @override
  List<Object> get props => [locale];
}
