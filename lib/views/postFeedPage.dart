import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample/databaseHelper.dart';
import 'package:sample/views/addPost.dart';
import 'package:sample/models/post_model.dart';

class PostFeedPage extends StatefulWidget {
  const PostFeedPage({super.key});

  @override
  State<PostFeedPage> createState() => _PostFeedPageState();
}

class _PostFeedPageState extends State<PostFeedPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future fetchPosts() async {
    Directory path = await getApplicationCacheDirectory();
    await _databaseHelper.queryAllRows().then((value) async {
      if (value.isNotEmpty) {
        List<PostModel> localPosts = [];
        log(value.toString());
        for (var e in value) {
          File? secletedImage;
          //image decoding
          if (e['picture'] != null && e['picture'] != "") {
            var img = base64Decode(e['picture']);
            secletedImage = await File("${"${path.path}/${e['id']}"}.png")
                .writeAsBytes(img);
          }
          localPosts.add(PostModel(
              id: e['id'],
              postTitle: e['title'],
              postDescription: e['description'],
              postImage: secletedImage,
              postCreatedAt: e['datetime']));
        }
        setState(() {
          posts = localPosts;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          centerTitle: false,
          title: const Text("Home"),
          actions: [
            IconButton(
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(Icons.notifications))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddPostPage())).then((value) {
              fetchPosts();
              if (value.runtimeType == String) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(bottom: 100.0),
                    content: Text(value.toString()),
                    dismissDirection: DismissDirection.none));
              }
            });
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: posts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 70,
                      ),
                      Text(
                        "No Post's Found!",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black45),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: posts.length,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPostPage(
                                      postDetails: posts[index],
                                    )));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  const AssetImage('assets/virat_user.png'),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Virat Kohli",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16),
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "@virat.use22",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                            fontSize: 12),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "5 Min Ago",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black26,
                                            fontSize: 10),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 1.0,
                                    thickness: 1.0,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    posts[index].postTitle,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    posts[index].postDescription,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (posts[index].postImage != null)
                                    Image.file(
                                      posts[index].postImage!,
                                      height: 120,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        )));
  }
}
