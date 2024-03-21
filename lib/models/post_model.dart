import 'dart:convert';
import 'dart:io';

List<PostModel> photosModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String photosModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  int id;
  String postTitle;
  String postDescription;
  String postCreatedAt;
  File? postImage;

  PostModel({
    required this.id,
    required this.postTitle,
    required this.postDescription,
    required this.postCreatedAt,
    this.postImage,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        postTitle: json["post_title"],
        postDescription: json["post_description"],
        postCreatedAt: json["post_createdAt"],
        postImage: json["post_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_title": postTitle,
        "post_description": postDescription,
        "post_createdAt": postCreatedAt,
        "post_image": postImage,
      };
}
