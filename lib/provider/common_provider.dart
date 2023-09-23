import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final loginProvider =
    StateNotifierProvider<LoginProvider, bool>((ref) => LoginProvider(true));

class LoginProvider extends StateNotifier<bool> {
  LoginProvider(super.state);

  void toggle() {
    state = !state;
  }
}

final imageProvider = StateNotifierProvider.autoDispose<ImageProvider, XFile?>(
    (ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);
  final ImagePicker picker = ImagePicker();

  void pickUImage(bool isCamera) async {
    if (isCamera) {
      state = await picker.pickImage(source: ImageSource.camera);
    } else {
      state = await picker.pickImage(source: ImageSource.gallery);
    }
  }
}
