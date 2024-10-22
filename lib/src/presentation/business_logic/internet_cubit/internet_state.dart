part of 'internet_cubit.dart';

@immutable
sealed class InternetState {}

class InternetInitial extends InternetState {}

class ConnectedState extends InternetState {
  final bool isConnected;

  ConnectedState({required this.isConnected});
}

class NotConnectedState extends InternetState {
  final bool isConnected;

  NotConnectedState({required this.isConnected});
}
