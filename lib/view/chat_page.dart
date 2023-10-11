import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fireapp/provider/room_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends ConsumerWidget {
  final types.Room room;
  final String token;
  final String currentUserName;
  ChatPage(
      {required this.currentUserName, required this.room, required this.token});

  @override
  Widget build(BuildContext context, ref) {
    final msgStream = ref.watch(messageStream(room));
    return Scaffold(
      body: SafeArea(
          child: msgStream.when(
              data: (data) {
                return Chat(
                    messages: data,
                    onSendPressed: (types.PartialText message) async {
                      final dio = Dio();
                      try {
                        final response = await dio.post(
                            'https://fcm.googleapis.com/fcm/send',
                            data: {
                              "notification": {
                                "title": currentUserName,
                                "body": message.text,
                                "android_channel_id": "High_importance_channel"
                              },
                              "to": token
                            },
                            options: Options(headers: {
                              HttpHeaders.authorizationHeader:
                                  'key=AAAABr2WaLo:APA91bF2rnvtEK5C8IMFvRdo0RkRwC29X_YZfb0o7IasE-JKxOtbiHKusJsWCf_JP_9p232nYHpM6WaMbT5nhnCIDJI1E-d6NkXe943unU3TuN4py68AABZuFGnd_xGG4gabt0m5kd0f'
                            }));

                        FirebaseChatCore.instance.sendMessage(message, room.id);
                      } on FirebaseException catch (e) {
                        print(e);
                      } catch (e) {
                        print(e);
                      }
                    },
                    showUserAvatars: true,
                    showUserNames: true,
                    onAttachmentPressed: () {
                      final pickImage = ImagePicker();
                      pickImage
                          .pickImage(source: ImageSource.gallery)
                          .then((image) async {
                        if (image != null) {
                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('ChatImage/${image.name}');
                          await ref.putFile(File(image.path));
                          final url = await ref.getDownloadURL();
                          FirebaseChatCore.instance.sendMessage(
                              types.PartialImage(
                                name: image.name,
                                size: File(image.path).lengthSync(),
                                uri: url,
                              ),
                              room.id);
                        }
                      });
                    },
                    user:
                        types.User(id: FirebaseAuth.instance.currentUser!.uid));
              },
              error: (error, stack) => Center(child: Text('$error')),
              loading: () => Center(child: CircularProgressIndicator()))),
    );
  }
}
