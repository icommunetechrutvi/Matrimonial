import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:matrimony/utils/Constant.dart';
import 'package:matrimony/webservices/Webservices.dart';


class WebServiceClient {
  static Future<dynamic> getAPICallForRowResponse(
    String apiName,
    Map<String, dynamic> params,
  ) async {
    var url = Webservices.baseUrl + apiName;

    var postUri = Uri.parse(url);
    //  var postUri = Uri.parse(apiName);

    var response = await http.get(postUri);

    var jsValue = json.decode(response.body);

    return jsValue;
  }


  static Future<String> getStatsAPICall(
      String apiName,
      ) async {
    var url = Webservices.baseUrl + apiName;

    if (apiName.startsWith("http")) {
      url = apiName;
    }
    var completer = Completer<String>();

    var postUri = Uri.parse(url);
    var checkInternet = await Constant.checkInternet();
    ServerResponse serverResponse = ServerResponse();
    if (!checkInternet) {
      serverResponse = ServerResponse();
      serverResponse.isSuccess = false;
      serverResponse.message = "Please check your internet connection";
      completer.complete("Please check your internet connection");
    } else {
      var header = Webservices.defaultHeaders();
      var response = await http
          .get(
        postUri,
        headers: header,
      )
          .catchError((error) {
        serverResponse.message = "Please check your internet connection";
        serverResponse.isSuccess = false;
      });
      print("RESPONSE${response}");
      if (response != null) {
        if (response.body != null) {
          print("URL@@@${url}");
          completer.complete(response.body);
        }
      }
    }
    return completer.future;
  }
/*  static Future<dynamic> getChatAPICallForRowResponse(
    String apiName,
    Map<String, dynamic> params,
  ) async {
    var url = Webservices.chatBaseUrl + apiName;

    var postUri = Uri.parse(url);
    //  var postUri = Uri.parse(apiName);

    var response = await http.get(postUri);

    var jsValue = json.decode(response.body);

    return jsValue;
  }*/

 /* static Future<String> getAPICallWithParam(
    String apiName,
  ) async {
    var url = Webservices.baseUrl + apiName;
    print('-------------------');
    print(url);
    print('-------------------');

    if (apiName.startsWith("http")) {
      url = apiName;
    }
    var completer = Completer<String>();

    var postUri = Uri.parse(url);
    var checkInternet = await Constant.checkInternet();
    ServerResponse serverResponse = ServerResponse();

    if (!checkInternet) {
      serverResponse = ServerResponse();
      serverResponse.isSuccess = false;
      serverResponse.message = "Please check your internet connection";
      completer.complete("Please check your internet connection");
    } else {
      var header = Webservices.defaultHeaders();
      print("Token------------------------------------------");
      print(Constant.accessToken);
      print(header);
      print("------------------------------------------");
      var response = await http
          .get(
        postUri,
        headers: header,
      )
          .catchError((error) {
        serverResponse.message = "Please check your internet connection";
        serverResponse.isSuccess = false;
        // completer.complete(serverResponse);
      });

      if (response != null) {
        if (response.body != null) {
          print("------------------------------");
          print(response.body);
          print("------------------------------");
          completer.complete(response.body);
          print("Data######${response.body}");
        }
      }
    }

    return completer.future;
  }
*/

 /* static Future<String> getAPICall(String apiName, String urlState) async {
    var url = Webservices.baseUrl + apiName;
    print('-------------------');
    print(url);
    print('-------------------');

    if (apiName.startsWith("http")) {
      url = apiName;
    }
    var completer = Completer<String>();

    var postUri = Uri.parse(url);
    var checkInternet = await Constant.checkInternet();
    ServerResponse serverResponse = ServerResponse();
    if (!checkInternet) {
      serverResponse = ServerResponse();
      serverResponse.isSuccess = false;
      serverResponse.message = "Please check your internet connection";
      completer.complete("Please check your internet connection");
    } else {
      var header = Webservices.defaultHeaders();
      print("Token------------------------------------------");
      print(Constant.accessToken);
      print(header);
      print("------------------------------------------");
      var response = await http
          .get(
        postUri,
        headers: header,
      )
          .catchError((error) {
        serverResponse.message = "Please check your internet connection";
        serverResponse.isSuccess = false;
        // completer.complete(serverResponse);
      });

      if (response != null) {
        if (response.body != null) {
          print("------------------------------");
          print(response.body);
          print("------------------------------");
          completer.complete(response.body);
        }
      }
    }

    return completer.future;
  }*/

  // static Future<String> getAPICallWithParam(
  //   String apiName,
  // ) async {
  //   var url = Webservices.baseUrl + apiName;
  //   print('-------------------');
  //   print(url);
  //   print('-------------------');
  //
  //   if (apiName.startsWith("http")) {
  //     url = apiName;
  //   }
  //
  //   var completer = Completer<String>();
  //
  //   var postUri = Uri.parse(url);
  //   var checkInternet = await Constant.checkInternet();
  //   ServerResponse serverResponse = ServerResponse();
  //   if (!checkInternet) {
  //     serverResponse = ServerResponse();
  //     serverResponse.isSuccess = false;
  //     serverResponse.message = "Please check your internet connection";
  //     completer.complete("Please check your internet connection");
  //   } else {
  //     var header = Webservices.defaultHeaders();
  //     print("Token------------------------------------------");
  //     print(Constant.accessToken);
  //     print(header);
  //     print("------------------------------------------");
  //     var response = await http
  //         .get(
  //       postUri,
  //       headers: header,
  //     )
  //         .catchError((error) {
  //       serverResponse.message = "Please check your internet connection";
  //       serverResponse.isSuccess = false;
  //       // completer.complete(serverResponse);
  //     });
  //
  //     if (response != null) {
  //       if (response.body != null) {
  //         print("------------------------------");
  //         print(response.body);
  //         print("------------------------------");
  //         completer.complete(response.body);
  //       }
  //     }
  //   }
  //
  //   return completer.future;
  // }

/*  static Future<ServerResponse> postAPICall(
      String apiName, Map<String, dynamic> params) async {
    var url = Webservices.baseUrl + apiName;
    print('-------------------');
    print(url);
    print('-------------------');

    if (apiName.startsWith("http")) {
      url = apiName;
    }
    var postUri = Uri.parse(url);
    print("\n");
    print("Request URL: $url");
    print("Request parameters: $params");
    print("\n");

    var completer = Completer<ServerResponse>();

    var checkInternet = await Constant.checkInternet();

    if (!checkInternet) {
      var response = ServerResponse();
      response.isSuccess = false;
      response.message = "Please check your internet connection";
      completer.complete(response);
    } else {
      print("Header :- " + Webservices.defaultHeaders().toString());
      var header = Webservices.defaultHeaders();
      http
          .post(postUri, headers: header, body: jsonEncode(params))
          .then((response) {
        print(response.body);
        var statusCode = response.statusCode;
        if (statusCode == 401) {}
        if (response.body.contains("User not found.")) {
          print("Hello True");
          Navigator.pushAndRemoveUntil(
              Constant.context!,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
          return;
        }
        var header = response.headers['access_token'];
        if (header != null) {
          // PrefUtils.setStringValue(PrefUtils.token, header);

          if (Constant.authUser == null) Constant.authUser = AuthUser();
          //  Constant.authUser!.access_token = header;
        }
        var jsValue = json.decode(response.body);

        var serverResponseObj = ServerResponse.withJson(jsValue);

        completer.complete(serverResponseObj);
      }).catchError((error) {
        var response = ServerResponse();

        if (error.runtimeType == SocketException) {
          print("socket exception");
          response.message = "Please check your internet connection";
        } else {
          response.message = error.toString();
        }
        response.isSuccess = false;
        completer.complete(response);
      });
    }

    return completer.future;
  }

  static Future<ServerResponse> postDataArrayAPICall(
      String apiName, Map<String, dynamic> params) async {
    var url = Webservices.baseUrl + apiName;

    if (apiName.startsWith("http")) {
      url = apiName;
    }
    var postUri = Uri.parse(url);
    print("\n");
    print("Request URL: $url");
    print("Request parameters: $params");
    print("\n");

    var completer = Completer<ServerResponse>();

    var checkInternet = await Constant.checkInternet();
    if (!checkInternet) {
      var response = ServerResponse();
      response.isSuccess = false;
      response.message = "Please check your internet connection";
      completer.complete(response);
    } else {
      print("Header :- " + Webservices.defaultHeaders().toString());
      var header = Webservices.defaultHeaders();
      http.post(postUri, headers: header, body: params).then((response) {
        print(response.body);
        var statusCode = response.statusCode;
        if (statusCode == 401) {}
        if (response.body.contains("User not found.")) {
          print("Hello True");
          Navigator.pushAndRemoveUntil(
              Constant.context!,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
          return;
        }
        var header = response.headers['access_token'];
        if (header != null) {
          // PrefUtils.setStringValue(PrefUtils.token, header);
          if (Constant.authUser == null) Constant.authUser = AuthUser();
          //Constant.authUser!.access_token = header;
        }
        var jsValue = json.decode(response.body);

        var serverResponseObj = ServerResponse.withJson(jsValue);

        completer.complete(serverResponseObj);
      }).catchError((error) {
        var response = ServerResponse();

        if (error.runtimeType == SocketException) {
          print("socket exception");
          response.message = "Please check your internet connection";
        } else {
          response.message = error.toString();
        }
        response.isSuccess = false;
        completer.complete(response);
      });
    }

    return completer.future;
  }

  //
  static Future<ServerResponse> postChatDataArrayAPICall(String apiName,
      {Map<String, dynamic>? params}) async {
    var url = Webservices.baseUrl + apiName;

    if (apiName.startsWith("http")) {
      url = apiName;
    }
    var postUri = Uri.parse(url);
    print("\n");
    print("Request URL: $url");
    print("Request parameters: $params");
    print("\n");

    var completer = Completer<ServerResponse>();

    var checkInternet = await Constant.checkInternet();
    if (!checkInternet) {
      var response = ServerResponse();
      response.isSuccess = false;
      response.message = "Please check your internet connection";
      completer.complete(response);
    } else {
      print("Header :- " + Webservices.defaultHeaders().toString());
      var header = Webservices.defaultHeaders();
      http.post(postUri, headers: header, body: params).then((response) {
        print(response.body);
        var statusCode = response.statusCode;
        if (statusCode == 401) {}
        if (response.body.contains("User not found.")) {
          Navigator.pushAndRemoveUntil(
              Constant.context!,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
          return;
        }
        var header = response.headers['access_token'];
        if (header != null) {
          Constant.authUser ??= AuthUser();
          //Constant.authUser!.authToken = header;
        }
        var jsValue = json.decode(response.body);

        var serverResponseObj = ServerResponse.withJson(jsValue);

        completer.complete(serverResponseObj);
      }).catchError((error) {
        var response = ServerResponse();

        if (error.runtimeType == SocketException) {
          print("socket exception");
          response.message = "Please check your internet connection";
        } else {
          response.message = error.toString();
        }
        response.isSuccess = false;
        completer.complete(response);
      });
    }

    return completer.future;
  }*/

 /* static Future<ServerResponse> multiPartAPI(
      String apiName, Map<String, dynamic> params, File imageFile) async {
    var url = Webservices.baseUrl + apiName;

    var postUri = Uri.parse(url);

    print("reqeust Url: \n$url");
    print("reqeust parameters: \n$params");
    var request =
        new MultipartRequest("POST", postUri, onProgress: (current, total) {});
    params.forEach((key, value) => {request.fields[key] = value});
    if (imageFile != null) {
      var ext = imageFile.uri.pathSegments.last.split(".")[1];
      var filename = "image." + ext;

      var multiPart = await http.MultipartFile.fromPath(
          "profile_picture", imageFile.path,
          filename: filename);

      request.files.add(multiPart);

      *//* var multiPart = await http.MultipartFile.fromPath(
          "profile_picture", imageFile.path,
          filename: "test.jpg");
      request.files.add(multiPart);*//*
    }

    request.headers.addAll(Webservices.defaultHeaders());

    var result = await request.send();
    var completer = Completer<ServerResponse>();

    result.stream.transform(utf8.decoder).listen((body) {
      var value = json.decode(body);
      print(value);
      var serverResponseObj = ServerResponse.withJson(value);
      completer.complete(serverResponseObj);
    });

    return completer.future;
  }*/

  /*static Future<ServerResponse> multipleImagesMultiPartAPI(
      String apiName,
      Map<String, dynamic> params,
      List<MultiPartFile> imageFiles,
      Function percentage,
      {String? postType}) async {
    var url = Webservices.baseUrl + apiName;

    var postUri = Uri.parse(url);

    print("reqeust Url: \n$url");
    print("reqeust parameters: \n$params");

    var request =
        new MultipartRequest("POST", postUri, onProgress: (current, total) {
      var per = (current * 100) / total;
      print("Value" + current.toString() + " Total " + total.toString());
      percentage(per);
    });

    request.persistentConnection = true;

    params.forEach((key, value) => {request.fields[key] = value});
    bool isVideo = false;
    if (imageFiles != null) {
      for (var i = 0; i < imageFiles.length; i++) {
        var mpart = imageFiles[i];
        var bytes = await mpart.file!.readAsBytes();
        var mimeType =
            lookupMimeType(mpart.file!.path, headerBytes: bytes) ?? "image/png";
        print("Mime Type: $mimeType");
        if (mimeType.contains("video/mp4")) {
          isVideo = true;
        }
        var type = mimeType.split("/")[0];
        var subType = mimeType.split("/")[1];

        var extension = subType; //Platform.isAndroid || postType == "2"
        // ? subType
        // : setupExtension(mpart);

        var filename = "image$i." + extension;
        print("FileName $filename");
        var multiPart = await http.MultipartFile.fromPath(
            mpart.paramName!, mpart.file!.path,
            filename: filename, contentType: mime.MediaType(type, subType));

        request.files.add(multiPart);
      }
    }
    request.headers.addAll(Webservices.defaultHeaders());

    var completer = Completer<ServerResponse>();

    request.send().then((result) async {
      print("found result ${result.statusCode}");
      print(result.toString());
      var resultString = await result.stream.bytesToString();
      print("rsult done========");
      print(resultString);
      var value = json.decode(resultString);
      // print(value);
      var serverResponseObj = ServerResponse.withJson(value);
      completer.complete(serverResponseObj);
    }).catchError((error) {
      print("fond error $error");
      var response = ServerResponse();

      switch (error.runtimeType) {
        case SocketException:
          if (error.osError != null) {
            if (error.osError.errorCode == 32) {
              response.message = "Connection time out";
            } else if (error.osError.errorCode == 8 ||
                error.osError.errorCode == 7) {
              response.message =
                  "Internet connection not available, check your connection and try again";
            } else {
              response.message = error.osError.message ?? error.toString();
            }
          } else {
            response.message = error.message ?? error.toString();
          }
          break;
        default:
          response.message = error.message ?? error.toString();
          break;
      }
      response.isSuccess = false;
      completer.complete(response);
    }).timeout(Duration(seconds: 600), onTimeout: () {
      var response = ServerResponse();
      response.message = "Timeout! unable to get the data";
      response.isSuccess = false;
      completer.complete(response);
    });
    return completer.future;
  }
*/
  static setupExtension(MultiPartFile file) {
    if ((file.file!.path.contains("mp4"))) {
      return "mov";
    } else if (file.file!.path.contains("MOV") ||
        file.file!.path.contains("MP4")) {
      return "mp4";
    }
  }
}

class ServerResponse {
  String message = "Something went wrong!";
  var body;
  var access_token;

  bool? isSuccess;

  var statusCode = 0;

  var offset = 0;

  ServerResponse();

  ServerResponse.withJson(Map<String, dynamic> jsonObj) {
    print("parsing response");
    var status = jsonObj["status"];
    var message = jsonObj["message"];
    String error = "";

    this.message = message.toString();

    this.access_token = jsonObj["jwt"];

    if (jsonObj.containsKey("data"))
      this.body = jsonObj["data"];
    else if (jsonObj.containsKey("user"))
      this.body = jsonObj["user"];
    else
      this.body = jsonObj;

    if (jsonObj.containsKey("error")) {
      error = jsonObj["error"];
      this.isSuccess = false;
    } else {
      this.isSuccess = true;
    }

    // this.statusCode = status;
    //   this.isSuccess = status == 1;

    // if (isSuccess!) {
    //   if (jsonObj.containsKey("offset")) {
    //     offset = jsonObj["offset"];
    //   }
    // }
    print("parsing response done");
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    required this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}

class MultiPartFile {
  String? paramName;
  File? file;
  var rowData;
  String? fileExt;

  var isFromRowData = false;

  MultiPartFile.fromFile({this.paramName, this.file});

  MultiPartFile.fromRowData({this.paramName, this.rowData, this.fileExt}) {
    isFromRowData = true;
  }
}
