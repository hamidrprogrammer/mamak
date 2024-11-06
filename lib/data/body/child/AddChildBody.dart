import 'package:json_annotation/json_annotation.dart';
import 'package:mamak/data/body/user/profile/FileDataBody.dart';

part 'AddChildBody.g.dart';

@JsonSerializable(explicitToJson: true)
class AddDateBody {
  AddDateBody({
    required this.executionDate,
  });

  String executionDate;

  AddDateBody fromJson(Map<String, dynamic> json) =>
      _$AddDatedBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddDateBodyToJson(this);
}

class AddChildBody {
  AddChildBody(
      {required this.childFirstName,
      required this.childLastName,
      required this.birtDate,
      required this.userName,
      this.childPicture});

  String childFirstName, childLastName, birtDate, userName;
  final FileDataBody? childPicture;

  AddChildBody fromJson(Map<String, dynamic> json) =>
      _$AddChildBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddChildBodyToJson(this);
}

class EditChildBody {
  EditChildBody(
      {required this.childFirstName,
      required this.childLastName,
      required this.userChildId,
      required this.id,
      this.childPicture});

  String childFirstName, childLastName, userChildId, id;
  final FileDataBody? childPicture;

  EditChildBody fromJson(Map<String, dynamic> json) =>
      _$EditChildBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EditChildBodyToJson(this);
}
