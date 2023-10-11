import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/provider/room_provider.dart';
import 'package:fireapp/services/crud_sevice.dart';
import 'package:fireapp/view/chat_page.dart';
import 'package:fireapp/view/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class UserPage extends ConsumerWidget {
  final types.User user;
  UserPage(this.user);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl!),
                    radius: 30,
                  ),
                  gapW20,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.firstName!),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(user.metadata!['email']),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final response =
                                await ref.read(roomProvider).CreateRoom(user);
                            if (response != null) {
                              final currentUser = response.users.firstWhere(
                                  (element) =>
                                      element.id ==
                                      FirebaseAuth.instance.currentUser!.uid);
                              Get.to(() => ChatPage(
                                  currentUserName: currentUser.firstName!,
                                  room: response,
                                  token: user.metadata!['token']));
                            }
                          },
                          child: Text('Start Chat'))
                    ],
                  )
                ],
              ),
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final allPost = ref.watch(postStream);
                  return allPost.when(
                      data: (data) {
                        final userPost = data
                            .where((element) => element.userId == user.id)
                            .toList();
                        return GridView.builder(
                            itemCount: userPost.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: ((context, index) {
                              return InkWell(
                                  onTap: () {
                                    Get.to(() =>
                                        DetailPage(userPost[index], user));
                                  },
                                  child:
                                      Image.network(userPost[index].imageUrl));
                            }));
                      },
                      error: (error, stack) => Text('$error'),
                      loading: () => CircularProgressIndicator());
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
