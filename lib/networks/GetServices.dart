import 'dart:convert';
import 'package:guesttellio/providers/UserData.dart';
import 'package:http/http.dart' as http;
import 'ApisEndPoint.dart';

class GetServices{
  getAllServices(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.get_assigned_services}"),headers: headers);
    print(response.body);
    var jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
    return jsonBody;
  }

  getAllOldServices(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.get_old_services}"),headers: headers);
    print(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  get_services_stats(token)async{
    var headers ={
      'Authorization': 'Token ${token}'
    };
    var response =await http.get(Uri.parse("${Apis.get_services_stats}"),headers: headers);
    print(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  markServiceAsDone(token,service_id, notes)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.mark_service_as_done}'));
    request.fields.addAll({
      'service_id': service_id,
      'notes': notes
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

}