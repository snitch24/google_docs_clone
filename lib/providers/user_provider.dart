import 'package:docs_clone/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Using StateProvider helps us modify the value only Provider is just for reading the values 
final userProvider = StateProvider<User?>((ref) {
  return null ;
});