
import 'package:fireapp/services/crud_sevice.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../model/common_state.dart';

final crudProvider = StateNotifierProvider<CrudProvider, CommonState>((ref) =>
    CrudProvider(CommonState(
        errText: '', isError: false, isLoad: false, isSuccess: false)));

class CrudProvider extends StateNotifier<CommonState> {
  CrudProvider(super.state);

  Future<void> addPost(
      {required String title,
      required String detail,
      required String userId,
      required XFile image}) async {
    state = state.copyWith(
        errText: '', isLoad: true, isSuccess: false, isError: false);
    final response = await CrudService.addPost(
        title: title, detail: detail, userId: userId, image: image);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isLoad: false, isSuccess: false, isError: true);
    }, (r) {
      state = state.copyWith(
          errText: '', isLoad: false, isSuccess: r, isError: false);
    });
  }

  Future<void> deletePost(
      {required String postId, required String imageId}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response =
        await CrudService.deletePost(postId: postId, imageId: imageId);
    response.fold(
        (l) => {
              state = state.copyWith(
                  errText: l, isError: true, isLoad: false, isSuccess: false)
            },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }

  Future<void> updatePost(
      {required String title,
      required String detail,
      required String postId,
      String? imageId,
      XFile? image}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response = await CrudService.updatePost(
        title: title,
        detail: detail,
        postId: postId,
        image: image,
        imageId: imageId);
    response.fold(
        (l) => {
              state = state.copyWith(
                  errText: l, isError: true, isLoad: false, isSuccess: false)
            },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }
}
