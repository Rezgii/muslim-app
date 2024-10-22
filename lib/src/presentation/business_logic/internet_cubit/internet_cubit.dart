// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  StreamSubscription? _subscription;
  InternetCubit() : super(InternetInitial());

  void connected() {
    emit(ConnectedState(isConnected: true));
  }

  void notConnected() {
    emit(NotConnectedState(isConnected: false));
  }

  void checkConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (results) {
        if (results.contains(ConnectivityResult.mobile) ||
            results.contains(ConnectivityResult.wifi)) {
          connected();
        } else {
          notConnected();
        }
      },
    );
  }

  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}
