import '../../../../interfaces/auth_method.dart';

class EmailAuthMethod implements AuthMethod {
  final String email;
  final String password;

  EmailAuthMethod({required this.email, required this.password});
}
