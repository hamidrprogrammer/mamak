import 'package:core/imagePicker/ImageFileModel.dart';
import 'package:mamak/data/body/child/AddChildBody.dart';
import 'package:mamak/presentation/viewModel/user/ProfileViewModel.dart';
import 'package:shamsi_date/shamsi_date.dart';

class AddDateFormState {
  String executionDate;

  AddDateFormState({
    this.executionDate = '',
  });

  AddDateBody createBody() {
    return AddDateBody(
      executionDate: executionDate,
    );
  }
}

class AddChildFormState {
  String childFirstName, childLastName, birtDate, userName;
  String? childFirstNameError,
      childLastNameError,
      birtDateError,
      mobileNumberError;

  AddChildFormState(
      {this.childFirstName = '',
      this.childFirstNameError,
      this.childLastName = '',
      this.childLastNameError,
      this.birtDate = '',
      this.birtDateError,
      this.userName = '',
      this.mobileNumberError});

  AddChildBody createBody(ImageFileModel? image) {
    return AddChildBody(
        childFirstName: childFirstName,
        childLastName: childLastName,
        birtDate: birtDate,
        userName: userName,
        childPicture: image?.createFileDataBody());
  }
}

class EditChildFormState {
  String childFirstName, childLastName, userChildId, id;
  String? childFirstNameError, childLastNameError, birtDateError;

  EditChildFormState({
    this.childFirstName = '',
    this.childFirstNameError,
    this.childLastName = '',
    this.userChildId = '',
    this.id = '',
    this.childLastNameError,
  });

  EditChildBody createBody(ImageFileModel? image) {
    return EditChildBody(
        childFirstName: childFirstName,
        childLastName: childLastName,
        userChildId: userChildId,
        id: id,
        childPicture: image?.createFileDataBody());
  }
}

class BirthDateTime {
  int day, month, year;

  BirthDateTime({this.day = 0, this.month = 0, this.year = 0});

  DateTime createPersianDate() {
    return Jalali(year, month, day).toDateTime();
  }

  DateTime createDate() {
    return DateTime(year, month, day);
  }
}
