import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class Posts with ChangeNotifier {
  Dio dio = new Dio();
  List _posts = [];
  bool _isFetching = false;

  List get posts {
    return _posts;
  }
  bool get isFetching{
    return _isFetching;
  }
  Future addPost(String title, String caption, String id, File mainImage,
      List<File> moreImages) async {
    var user;
    try {
      final response = await http.post (
        Uri.parse (
          '${dotenv.env['IP_ADDRESS']}/profileData',
        ),
          body: {
            'id': FirebaseAuth.instance.currentUser.uid,
          }
      );
      user = json.decode ( response.body );
      print ( user );
    }catch (err){
      print(err);
    }
    List<File> files = [];
    moreImages.forEach((file) async {
      if (file != null) {
        files.add(file);
      }
    });
    print(files);
    if (files.length == 0)
      noImages(title, caption, id, mainImage,user['profileImage'],user['full_name']);
    else if (files.length == 1)
      oneImages(title, caption, id, mainImage, files[0],user['profileImage'],user['full_name']);
    else if (files.length == 2)
      twoImages(title, caption, id, mainImage, files,user['profileImage'],user['full_name']);
    else
      threeImages(title, caption, id, mainImage, files,user['profileImage'],user['full_name']);

  }

  void noImages(String title, String caption, String id, File mainImage , String profile_pic, String full_name) async {
    try {
      var formData = FormData.fromMap({
        'userId': id,
        'title': title,
        'caption': caption,
        'full_name': full_name,
        'profile_pic': profile_pic,
        'files': [
          await MultipartFile.fromFile(
            mainImage.path,
            filename: mainImage.path.split('/').last,
          ),
        ],
      });
      var response = await dio.post(
        '${dotenv.env['IP_ADDRESS']}/addPost',
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json),
      );
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  void oneImages(String title, String caption, String id, File mainImage,
      File oneImage, String profile_pic, String full_name) async {
    try {
      var formData = FormData.fromMap({
        'userId': id,
        'title': title,
        'full_name': full_name,
        'profile_pic': profile_pic,
        'caption': caption,
        'files': [
          await MultipartFile.fromFile(
            mainImage.path,
            filename: mainImage.path.split('/').last,
          ),
          await MultipartFile.fromFile(
            oneImage.path,
            filename: oneImage.path.split('/').last,
          ),
        ],
      });
      var response = await dio.post(
        '${dotenv.env['IP_ADDRESS']}/addPost',
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json),
      );
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  void twoImages(String title, String caption, String id, File mainImage,
      List<File> images, String profile_pic, String full_name) async {
    try {
      var formData = FormData.fromMap({
        'userId': id,
        'title': title,
        'full_name': full_name,
        'profile_pic': profile_pic,
        'caption': caption,
        'files': [
          await MultipartFile.fromFile(
            mainImage.path,
            filename: mainImage.path.split('/').last,
          ),
          await MultipartFile.fromFile(
            images[0].path,
            filename: images[0].path.split('/').last,
          ),
          await MultipartFile.fromFile(
            images[1].path,
            filename: images[1].path.split('/').last,
          ),
        ],
      });
      var response = await dio.post(
        '${dotenv.env['IP_ADDRESS']}/addPost',
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json),
      );
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  void threeImages(String title, String caption, String id, File mainImage,
      List<File> images, String profile_pic, String full_name) async {
    try {
      var formData = FormData.fromMap({
        'userId': id,
        'title': title,
        'full_name': full_name,
        'profile_pic': profile_pic,
        'caption': caption,
        'files': [
          await MultipartFile.fromFile(
            mainImage.path,
            filename: mainImage.path.split('/').last,
          ),
          await MultipartFile.fromFile(
            images[0].path,
            filename: images[0].path.split('/').last,
          ),
          await MultipartFile.fromFile(
            images[1].path,
            filename: images[1].path.split('/').last,
          ),
          await MultipartFile.fromFile(
            images[2].path,
            filename: images[2].path.split('/').last,
          ),
        ],
      });
      var response = await dio.post(
        '${dotenv.env['IP_ADDRESS']}/addPost',
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json),
      );
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future getPosts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['IP_ADDRESS']}/posts/$userId'),
      );
      final result = json.decode(response.body);
      _posts = result;
      print(_posts);
      _isFetching = false;
    } catch (err) {
      print(err);
    }
  }

  void fetching(){
    _isFetching = true;
  }

  Future<void> refresh(){
    notifyListeners();
    return Future.delayed(Duration(seconds: 0));
  }
}
