import 'package:fireapp/services/auth_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../model/common_state.dart';

final authProvider = StateNotifierProvider<AuthProvider, CommonState>((ref) =>
    AuthProvider(CommonState(
        errText: '', isError: false, isLoad: false, isSuccess: false)));

class AuthProvider extends StateNotifier<CommonState> {
  AuthProvider(super.state);
  Future<void> userLogin(
      {required String email, required String password}) async {
    state = state.copyWith(
        errText: '', isLoad: true, isSuccess: false, isError: false);
    final response =
        await AuthService.userLogin(email: email, password: password);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isLoad: false, isSuccess: false, isError: true);
    }, (r) {
      state = state.copyWith(
          errText: '', isLoad: false, isSuccess: r, isError: false);
    });
  }

  Future<void> userSignUp(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    state = state.copyWith(
        errText: '', isLoad: true, isSuccess: false, isError: false);
    final response =
        await AuthService.userLogin(email: email, password: password);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isLoad: false, isSuccess: false, isError: true);
    }, (r) {
      state = state.copyWith(
          errText: '', isLoad: false, isSuccess: r, isError: false);
    });
  }

  Future<void> userLogOut() async {
    state = state.copyWith(
        errText: '', isLoad: true, isSuccess: false, isError: false);
    final response = await AuthService.userLogOut();
    response.fold((l) {
      state = state.copyWith(
          errText: l, isLoad: false, isSuccess: false, isError: true);
    }, (r) {
      state = state.copyWith(
          errText: '', isLoad: false, isSuccess: r, isError: false);
    });
  }
}
