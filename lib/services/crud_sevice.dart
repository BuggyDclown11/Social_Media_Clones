import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fireapp/model/post_model.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';

final postStream = StreamProvider.autoDispose((ref) => CrudService.getPost());

class CrudService {
  static final postDb = FirebaseFirestore.instance.collection('post');

  static Stream<List<Post>> getPost() {
    return postDb.snapshots().map((event) {
      return event.docs.map((e) {
        final json = e.data();
        if (json == null) {
          // Handle the case where the data is null, you can return a default value or an empty list.
          return Post(
            userImage: '',
            username: '',
            detail: '',
            imageUrl: '',
            postId: '',
            userId: '',
            imageId: '',
            like: Like(likes: 0, username: []),
            comment: [],
          );
        }
        return Post(
          userImage: json['userImage'] ?? '',
          username: json['username'] ?? '',
          detail: json['detail'] ?? '',
          imageUrl: json['imageUrl'] ?? '',
          postId: e.id,
          userId: json['userId'] ?? '',
          imageId: json['imageId'] ?? '',
          like: Like.fromJson(json['like']),
          comment: (json['comment'] as List<dynamic>?)
                  ?.map((e) => Comment.fromJson(e))
                  .toList() ??
              [],
        );
      }).toList();
    });
  }

  static Future<Either<String, bool>> addPost(
      {required String userImage,
      required String detail,
      required String username,
      required String userId,
      required XFile image}) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('postImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      await postDb.add({
        "userImage": userImage,
        "username": username,
        "detail": detail,
        "imageUrl": url,
        "userId": userId,
        "imageId": image.name,
        "like": {"likes": 0, "username": []},
        "comment": []
      });

      return right(true);
    } on FirebaseException catch (e) {
      return left(e.message.toString());
    }
  }

  static Future<Either<String, bool>> deletePost(
      {required String postId, required String imageId}) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.delete();

      await postDb.doc(postId).delete();
      return right(true);
    } on FirebaseException catch (e) {
      return left(e.message.toString());
    }
  }

  static Future<Either<String, bool>> updatePost(
      {required String title,
      required String detail,
      required String postId,
      String? imageId,
      XFile? image}) async {
    try {
      if (image == null) {
        await postDb.doc(postId).update({'title': title, 'detail': detail});
      } else {
        final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref.delete();
        final ref1 =
            FirebaseStorage.instance.ref().child('postImage/${image.name}');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();
        await postDb.doc(postId).update({
          "title": title,
          "detail": detail,
          "imageUrl": url,
          "imageId": image.name,
        });
      }

      return right(true);
    } on FirebaseException catch (e) {
      return left(e.message.toString());
    }
  }

  static Future<Either<String, bool>> likePost(
      {required String username,
      required String postId,
      required int like}) async {
    try {
      await postDb.doc(postId).update({
        'like': {
          'username': FieldValue.arrayUnion([username]),
          'likes': like + 1,
        }
      });

      return right(true);
    } on FirebaseException catch (e) {
      return left(e.message.toString());
    }
  }

  static Future<Either<String, bool>> unlikePost(
      {required String postId,
      required String username,
      required int like}) async {
    try {
      await postDb.doc(postId).update({
        'like': {
          'username': FieldValue.arrayRemove([username]),
          'likes': like - 1,
        }
      });

      return right(true);
    } on FirebaseException catch (e) {
      return left(e.message.toString());
    }
  }

  static Future<Either<String, bool>> commentPost(
      {required Comment comment, required String postId}) async {
    try {
      await postDb.doc(postId).update({
        'comment': FieldValue.arrayUnion([comment.toMap()])
      });

      return right(true);
    } on FirebaseException catch (e) {
      return left(e.message.toString());
    }
  }
}
