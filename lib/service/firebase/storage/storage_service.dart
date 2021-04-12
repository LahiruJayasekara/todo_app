import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_app/service/network.dart';

class StorageService{
  final Reference _profile_pic_storage = FirebaseStorage.instance.ref('profile_pic');

  //save profile pic
  Future<NetworkStatus> uploadFile(File file, String fileName) async {
    try {
      await _profile_pic_storage
          .child(fileName)
          .putFile(file);
      return SuccessState(data: "success");
    } on FirebaseException catch (e) {
      return ErrorState(error: e.toString());
    } catch (e) {
      return ErrorState(error: e.toString());
    }
  }

  //get profile pic url
  Future<String> getProfilePicURL(String uid) async {
    String downloadURL = await _profile_pic_storage
        .child(uid)
        .getDownloadURL();

    return downloadURL;
  }
}