
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../data/auth_repository.dart';
import '../core/dio_client.dart';

class AuthState {
  final AppUser? user;
  final bool initializing;
  final bool loading;
  final String? error;

  const AuthState({
    this.user,
    this.initializing = false,
    this.loading = false,
    this.error,
  });

  AuthState copyWith({
    AppUser? user,
    bool clearUser = false,
    bool? initializing,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      initializing: initializing ?? this.initializing,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repo =>
      ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    Future.microtask(_restore);

    return const AuthState(initializing: true);
  }

  // Restore session
  Future<void> _restore() async {
    try {
      final user = await _repo.restoreSession();

      state = AuthState(user: user);
    } catch (e) {
      state = const AuthState();
    }
  }

  // LOGIN
  Future<bool> login(
    String email,
    String password,
  ) async {
    state = state.copyWith(
      loading: true,
      clearError: true,
    );

    try {
      final user = await _repo.login(email, password);

      state = AuthState(user: user);

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: apiError(e),
      );

      return false;
    }
  }

  // REGISTER
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? companyName,
  }) async {
    state = state.copyWith(
      loading: true,
      clearError: true,
    );

    try {
      final user = await _repo.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        companyName: companyName,
      );

      state = AuthState(user: user);

      return true;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: apiError(e),
      );

      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _repo.logout();

    state = const AuthState();
  }
}
