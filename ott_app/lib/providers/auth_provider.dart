import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({
    required this.isLoggedIn,
    required this.loginMethod, // 'email'|'phone'
    required this.showOtp,
  });

  final bool isLoggedIn;
  final String loginMethod;
  final bool showOtp;

  AuthState copyWith({
    bool? isLoggedIn,
    String? loginMethod,
    bool? showOtp,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      loginMethod: loginMethod ?? this.loginMethod,
      showOtp: showOtp ?? this.showOtp,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
      : super(const AuthState(
            isLoggedIn: false, loginMethod: 'phone', showOtp: false));

  void setLoginMethod(String method) {
    state = state.copyWith(loginMethod: method, showOtp: false);
  }

  void sendOtp() {
    state = state.copyWith(showOtp: true);
  }

  void login() {
    state = state.copyWith(isLoggedIn: true, showOtp: false);
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false, showOtp: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
