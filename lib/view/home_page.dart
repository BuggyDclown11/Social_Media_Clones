import 'package:fireapp/constant/sizes.dart';
import 'package:fireapp/provider/auth_provider.dart';
import 'package:fireapp/provider/crud_provider.dart';
import 'package:fireapp/services/auth_service.dart';
import 'package:fireapp/services/crud_sevice.dart';
import 'package:fireapp/view/create_post.dart';
import 'package:fireapp/view/detail_page.dart';
import 'package:fireapp/view/update_post.dart';
import 'package:fireapp/view/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:expandable_text/expandable_text.dart';

class HomePage extends ConsumerWidget {
  late types.User user;

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userStream);
    final singleData = ref.watch(singleStream);
    final postData = ref.watch(postStream);
    return Scaffold(
      backgroundColor: Color(0xffF0F2F5),
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
                        Get.to(() => CreatePost(user));
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 85,
                child: userData.when(
                    data: (data) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => UserPage(data[index]));
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(data[index].imageUrl!),
                                  ),
                                ),
                                Text('${data[index].firstName!}')
                              ],
                            );
                          });
                    },
                    error: ((error, stack) => Center(child: Text('$error'))),
                    loading: () => Center(child: CircularProgressIndicator())),
              ),
            ),
            gapH10,
            Expanded(
              child: postData.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final post = data[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage:
                                                  NetworkImage(post.userImage),
                                            ),
                                            gapW10,
                                            Text('${post.username}')
                                          ],
                                        )),
                                        IconButton(
                                            onPressed: () {
                                              Get.defaultDialog(
                                                  title: 'Update',
                                                  content:
                                                      Text('Customise Post'),
                                                  actions: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Get.to(() =>
                                                              UpdatePost(
                                                                  data[index]));
                                                        },
                                                        icon: Icon(Icons.edit)),
                                                    IconButton(
                                                        onPressed: () {
                                                          Get.defaultDialog(
                                                              title: 'Delete',
                                                              content: Text(
                                                                  'Are you Sure'),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      ref.read(crudProvider.notifier).deletePost(
                                                                          postId: data[index]
                                                                              .postId,
                                                                          imageId:
                                                                              data[index].imageId);
                                                                    },
                                                                    child: Text(
                                                                        'Yes')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                        'No'))
                                                              ]);
                                                        },
                                                        icon:
                                                            Icon(Icons.delete)),
                                                  ]);
                                            },
                                            icon:
                                                Icon(Icons.more_horiz_rounded))
                                      ],
                                    ),
                                    ExpandableText(
                                      '${post.detail}',
                                      expandText: 'See More',
                                      collapseText: 'See Less',
                                      maxLines: 4,
                                      linkColor:
                                          Colors.grey, // Customize link color
                                      style: TextStyle(
                                          fontSize: 16), // Customize text style
                                    ),
                                    gapH10,
                                    InkWell(
                                      onTap: () {
                                        print('InkWell Tapped');
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPage(data[index], user),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.black,
                                        elevation: 0.5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0)),
                                          ),
                                          height: 300,
                                          width: double.infinity,
                                          child: Image.network(
                                            data[index].imageUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    gapH20,
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black, // Border color
                                          width: 1.0, // Border width
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(
                                                10.0)), // Adjust the radius as needed
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                bool alreadyLiked = data[index]
                                                    .like
                                                    .username
                                                    .contains(user.firstName!);
                                                if (alreadyLiked) {
                                                  ref
                                                      .read(
                                                          crudProvider.notifier)
                                                      .unlikePost(
                                                          username:
                                                              user.firstName!,
                                                          postId: post.postId,
                                                          like:
                                                              post.like.likes);
                                                } else {
                                                  ref
                                                      .read(
                                                          crudProvider.notifier)
                                                      .likePost(
                                                          username:
                                                              user.firstName!,
                                                          postId: post.postId,
                                                          like:
                                                              post.like.likes);
                                                }
                                              },
                                              icon: post.like.username
                                                      .contains(user.firstName!)
                                                  ? Icon(Icons.thumb_up_alt)
                                                  : Icon(Icons
                                                      .thumb_up_alt_outlined),
                                              color: post.like.username
                                                      .contains(user.firstName!)
                                                  ? Colors.blue
                                                  : null,
                                            ),
                                            if (data[index].like.likes > 0)
                                              Text(
                                                '${data[index].like.likes.toString()}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
