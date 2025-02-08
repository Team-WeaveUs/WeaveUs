import 'package:flutter/material.dart';
import 'post.dart';

class PostScreen extends StatefulWidget {
  final Post postData; // Post 데이터 받기
  const PostScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(
                      widget.postData.weaveTitle,
                      style: TextStyle(fontSize: 24),
                    ),
                    //위브 타입 분류할거임.
                    //Text(widget.postData.weaveType)
                  ]),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      child:
                          IconButton(onPressed: null, icon: Icon(Icons.add))),
                ],
              ),
            ),
            if (widget.postData.urls.isNotEmpty)
              Image.network(
                  height: size.height * 0.6,
                  fit: BoxFit.cover,
                  widget.postData.urls.first),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.postData.userProfile == '0'
                            ? null
                            : NetworkImage(widget.postData.userProfile),
                        child: widget.postData.userProfile == '0'
                            ? Icon(Icons.person, color: Colors.white)
                            : null,
                        backgroundColor: Colors.grey, // 기본 배경색 설정 (선택 사항)
                      ),
                      SizedBox(width: 10,),
                      Text(widget.postData.name),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(onPressed: null, child: Text("구독"))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: size.width,
              child: Text(widget.postData.content),
            ),
          ],
        ));
  }
}
