import 'package:fireapp/common/show_snackbar.dart';
import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/provider/auth_provider.dart';
import 'package:fireapp/provider/crud_provider.dart';
import 'package:fireapp/services/auth_service.dart';
import 'package:fireapp/services/crud_sevice.dart';
import 'package:fireapp/view/create_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomePage extends ConsumerWidget {
  late types.User user;

  @override
  Widget build(BuildContext context, ref) {
    final authData = FirebaseAuth.instance.currentUser;
    final userData = ref.watch(userStream);
    final singleData = ref.watch(singleStream);
    final postData = ref.watch(postStream);
    return Scaffold(
      drawer: Drawer(
          child: singleData.when(
              data: (data) {
                user = data;
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(data.imageUrl!),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.firstName!),
                              Text(data.metadata!['email']),
                            ],
                          ) // Add some spacing between the CircleAvatar and Text
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('${data.firstName}'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.mail),
                      title: Text("${data.metadata!['email']}"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Create Post'),
                      onTap: () {
                        Get.to(() => CreatePost());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('LogOut'),
                      onTap: () {
                        Navigator.of(context).pop();
                        ref.read(authProvider.notifier).userLogOut();
                      },
                    )
                  ],
                );
              },
              error: ((error, stack) => Center(child: Text('$error'))),
              loading: () => Center(child: CircularProgressIndicator()))),
      appBar: AppBar(
        title: Text('Social App'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150,
              child: userData.when(
                  data: (data) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(data[index].imageUrl!),
                              ),
                              Text('${data[index].firstName!}')
                            ],
                          );
                        });
                  },
                  error: ((error, stack) => Center(child: Text('$error'))),
                  loading: () => Center(child: CircularProgressIndicator())),
            ),
            gapH20,
            Expanded(
              child: postData.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(data[index].title)),
                                    if (authData!.uid == data[index].userId)
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.more_horiz_rounded))
                                  ],
                                ),
                                Container(
                                  height: 300,
                                  width: double.infinity,
                                  child: Image.network(
                                    data[index].imageUrl,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text('${data[index].detail}')),
                                    Row(
                                      children: [
                                        if (authData.uid != data[index].userId)
                                          IconButton(
                                              onPressed: () {
                                                if (data[index]
                                                    .like
                                                    .username
                                                    .contains(user.firstName)) {
                                                  ShowSnack.showErrorSnack(
                                                      context,
                                                      'you have already liked this post');
                                                } else {
                                                  ref
                                                      .read(
                                                          crudProvider.notifier)
                                                      .likePost(
                                                          username:
                                                              user.firstName!,
                                                          postId: data[index]
                                                              .postId,
                                                          like: data[index]
                                                              .like
                                                              .likes);
                                                }
                                              },
                                              icon: Icon(Icons.thumb_up)),
                                        if (data[index].like.likes > 0)
                                          Text(
                                            '${data[index].like.likes.toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                  error: ((error, stack) => Text('$error')),
                  loading: () => CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
