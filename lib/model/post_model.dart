final post = {
  "userImage": "temple",
  "description": "Nice temple",
  "image": "image",
  "postId": "post1",
  "userId": "user1",
  "Like": {
    "likes": 0,
    "username": ["ram", "shyam"]
  },
  "comment": [
    {"username": "ram", "comment": "nice", "image": "user.jpg"}
  ]
};

class Like {
  final int likes;
  final List<String> username;
  Like({required this.likes, required this.username});
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
        likes: json['likes'],
        username: (json['username'] as List).map((e) => e as String).toList());
  }
}

class Comment {
  final String username;
  final String comment;
  final String image;
  Comment({required this.comment, required this.image, required this.username});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        comment: json['comment'],
        image: json['image'],
        username: json['username']);
  }
  Map toMap() {
    return {
      'comment': this.comment,
      'image': this.image,
      'username': this.username
    };
  }
}

class Post {
  final String userImage;
  final String username;
  final String detail;
  final String imageId;
  final String postId;
  final String userId;
  final String imageUrl;
  final Like like;
  List<Comment> comment;

  Post(
      {required this.comment,
      required this.detail,
      required this.imageId,
      required this.like,
      required this.postId,
      required this.imageUrl,
      required this.userImage,
      required this.username,
      required this.userId});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        comment:
            (json['comment'] as List).map((e) => Comment.fromJson(e)).toList(),
        detail: json['detail'],
        imageId: json['imageId'],
        like: Like.fromJson(json['like']),
        postId: json['postId'],
        imageUrl: json['imageUrl'],
        userImage: json['userImage'],
        username: json['username'],
        userId: json['userId']);
  }
}
