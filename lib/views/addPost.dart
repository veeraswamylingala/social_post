import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample/databaseHelper.dart';
import 'package:sample/models/post_model.dart';
import 'package:sample/views/postFeedPage.dart';

class AddPostPage extends StatefulWidget {
  final PostModel? postDetails;
  const AddPostPage({super.key, this.postDetails});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  PostModel? postInfo;
  File? secletedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTFC = TextEditingController();
  final TextEditingController _descTFC = TextEditingController();
  @override
  void initState() {
    super.initState();
    assignDefaulVale();
  }

  Future assignDefaulVale() async {
    if (widget.postDetails != null) {
      postInfo = widget.postDetails!;
      _titleTFC.text = widget.postDetails!.postTitle;
      _descTFC.text = widget.postDetails!.postDescription;
      secletedImage = widget.postDetails!.postImage;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.postDetails == null ? "Create Post" : "Post"),
        actions: [
          Visibility(
            visible: widget.postDetails == null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // String img = "";
                      // if (secletedImage != null) {
                      //   final bytes =
                      //       File(secletedImage!.path).readAsBytesSync();

                      //   img = base64Encode(bytes);
                      // }

                      _dbHelper.insert({
                        "title": _titleTFC.text,
                        "description": _descTFC.text,
                        "picture":
                            secletedImage != null ? secletedImage!.path : "",
                        "datetime": DateFormat('yyyy-MM-dd – kk:mm')
                            .format(DateTime.now())
                      }).then((value) {
                        Navigator.pop(context, "Post Created Successfully!");
                      });
                    }
                  },
                  child: const Text("Post")),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: widget.postDetails != null,
                child: GestureDetector(
                  onTap: () async {
                    //delete post from database
                    await _dbHelper
                        .deleteRecord(id: widget.postDetails!.id)
                        .then((value) {
                      log(value.toString());
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostFeedPage()),
                          (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 100.0),
                          content: Text("Deleted Post Successfully"),
                          dismissDirection: DismissDirection.none));
                    });
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.postDetails == null,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ImagePicker()
                            .pickImage(source: ImageSource.camera)
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              secletedImage = File(value.path);
                            });
                          }
                        });
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.camera_enhance,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              secletedImage = File(value.path);
                            });
                          }
                        });
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.photo_album,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: const AssetImage('assets/virat_user.png'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _titleTFC,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Require!";
                              } else {
                                return null;
                              }
                            },
                            readOnly: widget.postDetails != null,
                            //initialValue: postInfo!.postTitle,
                            onChanged: (value) {
                              postInfo?.postTitle = value;
                            },
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                            decoration: const InputDecoration(
                                hintText: 'Give your title',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300)

                                //  border: OutlineInputBorder(),
                                ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _descTFC,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Require!";
                              } else {
                                return null;
                              }
                            },
                            readOnly: widget.postDetails != null,
                            onChanged: (value) {
                              postInfo!.postDescription = value;
                            },
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            maxLines: null,
                            maxLength: 100,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                                hintText: "Write what's on your mind?"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (secletedImage != null)
                            Stack(
                              children: [
                                Image.file(
                                  secletedImage!,
                                  fit: BoxFit.contain,
                                ),
                                Visibility(
                                  visible: widget.postDetails == null,
                                  child: Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Card(
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              secletedImage = null;
                                            });
                                          },
                                          icon: const Icon(Icons.close)),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
