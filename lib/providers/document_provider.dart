import 'package:docs_clone/services/document_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentServiceProvider = Provider<DocumentService>((ref) {
  return DocumentService(client: Client());
});