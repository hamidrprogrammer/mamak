// To parse this JSON data, do
//
//     final questions = questionsFromJson(jsonString);

import 'dart:convert';

import 'package:mamak/data/serializer/user/GetUserProfileResponse.dart';

List<Questions> questionsFromJson(String str) => List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
  int? categoryId;
  String? categoryTitle;
  List<Question>? questions;
  int? id;
  List<dynamic>? errorMessages;
  int? statusCode;
  List<dynamic>? successfulMessages;

  Questions({
    this.categoryId,
    this.categoryTitle,
    this.questions,
    this.id,
    this.errorMessages,
    this.statusCode,
    this.successfulMessages,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
    categoryId: json["categoryId"],
    categoryTitle: json["categoryTitle"],
    questions: json["questions"] == null ? [] : List<Question>.from(json["questions"]!.map((x) => Question.fromJson(x))),
    id: json["id"],
    errorMessages: json["errorMessages"] == null ? [] : List<dynamic>.from(json["errorMessages"]!.map((x) => x)),
    statusCode: json["statusCode"],
    successfulMessages: json["successfulMessages"] == null ? [] : List<dynamic>.from(json["successfulMessages"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryTitle": categoryTitle,
    "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
    "id": id,
    "errorMessages": errorMessages == null ? [] : List<dynamic>.from(errorMessages!.map((x) => x)),
    "statusCode": statusCode,
    "successfulMessages": successfulMessages == null ? [] : List<dynamic>.from(successfulMessages!.map((x) => x)),
  };
}

class Question {
  int? questionId;
  String? questionTitle;
  UserAvatar? questionPicture;
  List<Option>? options;
  int? id;
  List<dynamic>? errorMessages;
  int? statusCode;
  List<dynamic>? successfulMessages;

  Question({
    this.questionId,
    this.questionPicture,
    this.questionTitle,
    this.options,
    this.id,
    this.errorMessages,
    this.statusCode,
    this.successfulMessages,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionId: json["questionId"],
    questionPicture: json["questionPicture"] != null ? UserAvatar.fromJson(json["questionPicture"])  : null,
    questionTitle: json["questionTitle"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    id: json["id"],
    errorMessages: json["errorMessages"] == null ? [] : List<dynamic>.from(json["errorMessages"]!.map((x) => x)),
    statusCode: json["statusCode"],
    successfulMessages: json["successfulMessages"] == null ? [] : List<dynamic>.from(json["successfulMessages"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "questionTitle": questionTitle,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
    "id": id,
    "errorMessages": errorMessages == null ? [] : List<dynamic>.from(errorMessages!.map((x) => x)),
    "statusCode": statusCode,
    "successfulMessages": successfulMessages == null ? [] : List<dynamic>.from(successfulMessages!.map((x) => x)),
  };
}

class Option {
  int? optionId;
  String? optionTitle;
  int? rate;
  int? id;
  List<dynamic>? errorMessages;
  int? statusCode;
  List<dynamic>? successfulMessages;

  Option({
    this.optionId,
    this.optionTitle,
    this.rate,
    this.id,
    this.errorMessages,
    this.statusCode,
    this.successfulMessages,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    optionId: json["optionId"],
    optionTitle: json["optionTitle"],
    rate: json["rate"],
    id: json["id"],
    errorMessages: json["errorMessages"] == null ? [] : List<dynamic>.from(json["errorMessages"]!.map((x) => x)),
    statusCode: json["statusCode"],
    successfulMessages: json["successfulMessages"] == null ? [] : List<dynamic>.from(json["successfulMessages"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "optionId": optionId,
    "optionTitle": optionTitle,
    "rate": rate,
    "id": id,
    "errorMessages": errorMessages == null ? [] : List<dynamic>.from(errorMessages!.map((x) => x)),
    "statusCode": statusCode,
    "successfulMessages": successfulMessages == null ? [] : List<dynamic>.from(successfulMessages!.map((x) => x)),
  };
}
