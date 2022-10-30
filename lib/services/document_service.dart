import 'dart:convert';

import 'package:docs_clone/models/document.dart';
import 'package:http/http.dart';

import '../constants/url_constants.dart';
import '../models/error.dart';

class DocumentService {
  final Client _client;

  DocumentService({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: "Some unexpected Error Occured", data: null);
    try {
      Response res = await _client.post(
        Uri.parse("${URLConstants.host}/docs/create"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode(
          {
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );

      switch (res.statusCode) {
        case 200:
          errorModel = ErrorModel(
            error: null,
            data: Document.fromJson(res.body),
          );
          break;
        default:
          errorModel = ErrorModel(
            error: res.body,
            data: null,
          );
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: "Some unexpected Error Occured", data: null);
    try {
      Response res = await _client.get(
        Uri.parse("${URLConstants.host}/docs/me"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );
      print(res.body);
      switch (res.statusCode) {
        case 200:
          List<Document> documents = [];
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              Document.fromJson(
                jsonEncode(jsonDecode(res.body)[i]),
              ),
            );
          }
          print("document length is");
          print(documents.length);
          errorModel = ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          errorModel = ErrorModel(
            error: res.body,
            data: null,
          );
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }
}
