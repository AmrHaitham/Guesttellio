import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ApisEndPoint.dart';


class UserProfile{

  getUserProfileData(token)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    print(token);
    var request = http.MultipartRequest('GET', Uri.parse('${Apis.profile}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return jsonDecode(await response.stream.bytesToString());

  }

  updateUserPassword(token,email,oldPassword,newPassword)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.change_password}'));
    request.fields.addAll({
      'new_password': newPassword,
      'old_password': oldPassword
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  updateUserProfile(token,email,name,last_name,phone)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.profile}'));
    request.fields.addAll({
      'email': email,
      'first_name': name,
      'last_name':last_name,
      'phone': phone,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  updateUserProfileImage(token,email,name,last_name,phone,image)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.profile}'));
    request.fields.addAll({
      'email': email,
      'last_name':last_name,
      'first_name': name,
      'phone': phone,
    });

    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', image));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return response;
  }


}