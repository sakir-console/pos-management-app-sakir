import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/utils/constants.dart';



Future<void> multipartApi(String endPoint, Map<String, dynamic> body, List<File> selectedImages, BuildContext context,
    {bool header = false}) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    Map<String, String> headers = {};
    if (token != null) {
      headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      };
    }

    final request = http.MultipartRequest('POST', Uri.parse(API.HOST + API.Version + endPoint));

    // Add form data fields
    body.forEach((key, value) {
      if (value is String) {
        request.fields[key] = value;
      } else if (value is List<String>) {
        // If the value is a list, add each element separately
        for (int i = 0; i < value.length; i++) {
          request.fields['$key[$i]'] = value[i];
        }
      } else {
        // Convert other types to string
        request.fields[key] = value.toString();
      }
    });

    // Add image files
    for (File image in selectedImages) {
      request.files.add(await http.MultipartFile.fromPath(
        'img[]',
        image.path,
      ));
    }

    // Add headers to the request
    request.headers.addAll(headers);

    final response = await request.send();

    // Read response body as a string
    String responseBody = await response.stream.bytesToString();
    if (kDebugMode) {
      print(API.HOST + API.Version + endPoint);
      print("Multipart Body: $body");
      print("Multipart: $responseBody");
    }
    if (!context.mounted) return;
    // Check the response status code
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product Successfully Created'),
        backgroundColor: Colors.green,
      ));
    } else {

      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text("${json.decode(responseBody)['data']}"),
        backgroundColor: Colors.red,
      ));
    }
  } catch (e) {
    throw Exception(e);
    if (kDebugMode) {
      print(e);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Something went wrong: $e'),
      backgroundColor: Colors.red,
    ));
  }
}



Future postApi(String endPoint, Map<String, dynamic> body,{bool header=false}) async {
  try{

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  Map<String, String> headers;

  if (token != null) {
    headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',

    };
  } else {
    headers = {};
  }
  var res = await http.post(Uri.parse(API.HOST + API.Version + endPoint),
      body: body, headers: headers);
  debugPrint(API.HOST + API.Version + endPoint);
  var jsonResponse = json.decode(res.body.toString());
  debugPrint("POST Body: ${body.toString()}");
  debugPrint("POST Response: ${jsonResponse.toString()}");
  return await jsonResponse;
  } catch (e) {
    throw Exception(e);
    if (kDebugMode) {
      print(e);
    }
  }
}

Future getApi(String endPoint, {bool header = false}) async {
  try{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  Map<String, String> headers;
  if (token != null) {
    headers = {"Accept": "application/json", 'Authorization': 'Bearer $token'};
  } else {
    headers = {};
  }
  var res = await http.get(Uri.parse(API.HOST + API.Version + endPoint),headers: headers);
  debugPrint(API.HOST + API.Version + endPoint);

  var jsonResponse = json.decode(res.body);
  debugPrint("GET Response: ${json.encode(jsonResponse['data'])}");
  return await jsonResponse;
  } catch (e) {
    throw Exception(e);
    if (kDebugMode) {
      print(e);
    }
  }
}

Future postRequest(String endPoint, Map<String, dynamic> body,
    {bool header=false}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  Map<String, String> headers;
  if (token != null) {
    headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };
  } else {
    headers = {};
  }
  var res = await http.post(Uri.parse(endPoint),
      body: json.encode(body), headers: headers);
  print(endPoint);
  var jsonResponse = jsonDecode(res.body);
  print("POST Response: $jsonResponse");
  return await jsonResponse;
}

Future getRequest(String endPoint, {bool header=false}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  Map<String, String> headers;
  if (token != null) {
    headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };
  } else {
    headers = {};
  }
  var res = await http.get(Uri.parse(endPoint));
  print(endPoint);
  var jsonResponse = jsonDecode(res.body);
  print("Get Response: $jsonResponse");
  return await jsonResponse;
}
