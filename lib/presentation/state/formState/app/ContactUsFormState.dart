import 'package:mamak/data/body/app/ContactUsBody.dart';

class ContactUsFormState {
  String email, fullName, mobile, subject, message;

  ContactUsFormState({
    this.email = '',
    this.fullName = '',
    this.mobile = '',
    this.subject = '',
    this.message = '',
  });

  ContactUsBody createBody() => ContactUsBody(
      email: email,
      fullName: fullName,
      mobile: mobile,
      subject: subject,
      message: message);
}
