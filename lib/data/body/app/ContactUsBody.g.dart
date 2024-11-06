// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContactUsBody.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactUsBody _$ContactUsBodyFromJson(Map<String, dynamic> json) =>
    ContactUsBody(
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      mobile: json['mobile'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ContactUsBodyToJson(ContactUsBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'mobile': instance.mobile,
      'subject': instance.subject,
      'message': instance.message,
    };
