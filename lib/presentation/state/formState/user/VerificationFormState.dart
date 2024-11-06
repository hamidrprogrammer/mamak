import 'package:mamak/data/body/user/verification/VerificationBody.dart';

class VerificationFormState {
  String Username, activationCode;

  VerificationFormState({this.Username = '', this.activationCode = ''});

  VerificationBody createBody() {
    return VerificationBody(Username: Username, activationCode: activationCode);
  }
}
