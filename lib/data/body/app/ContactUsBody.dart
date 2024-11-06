import 'package:json_annotation/json_annotation.dart';

part 'ContactUsBody.g.dart';
@JsonSerializable(explicitToJson: true)
class ContactUsBody {
  final String email, fullName, mobile, subject, message;

  const ContactUsBody({
    required this.email,
    required this.fullName,
    required this.mobile,
    required this.subject,
    required this.message,
  });

  ContactUsBody fromJson(Map<String, dynamic> json) =>
      _$ContactUsBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ContactUsBodyToJson(this);
}
