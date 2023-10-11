import 'package:fireapp/provider/room_provider.dart';
import 'package:fireapp/view/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class RecentChat extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final roomData = ref.watch(roomStream);
    return Scaffold(
      body: SafeArea(
          child: roomData.when(
              data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final otherUser = data[index].users.firstWhere(
                          (element) =>
                              element.id !=
                              FirebaseAuth.instance.currentUser!.uid);
                      final currentUser = data[index].users.firstWhere(
                          (element) =>
                              element.id ==
                              FirebaseAuth.instance.currentUser!.uid);
                      return ListTile(
                        onTap: () {
                          Get.to(() => ChatPage(
                              currentUserName: currentUser.firstName!,
                              room: data[index],
                              token: otherUser.metadata!['token']));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data[index].imageUrl!),
                        ),
                        title: Text('${data[index].name!}'),
                      );
                    });
              },
              error: (error, stackTrace) => Text('$error'),
              loading: () => CircularProgressIndicator())),
    );
  }
}
