import '../../exceptions/auth_exceptions.dart';
import '../../exceptions/data_exceptions.dart';
import '../../models/location_model.dart';
import '../../utils/utils.dart';

class CheckVaidation {
  static Future<void> loginUser({String? email, String? password}) async {
    if (email == null || email == "") {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: email)) {
      throw AuthExceptionInvalidEmail();
    }

    if (password == null || password == "") {
      throw AuthExceptionPasswordRequired();
    }
  }

  static Future<void> onCreateEvent({
    required String title,
    required List<String> images,
    DateTime? dateTime,
    LocationModel? location,
    String? maxPersons,
  }) async {
    if (title == "") {
      throw DataExceptionRequiredField(
          message: "Please Enter Event name.", errorCode: 1);
    }

    if (maxPersons == "" || maxPersons == null) {
      throw DataExceptionRequiredField(
          message:
              "Please add the value of maximum persons can join the event.");
    }

    if (location == null) {
      throw DataExceptionRequiredField(message: "Please select location");
    }

    if (dateTime == null) {
      throw DataExceptionRequiredField(message: "Please select date and time.");
    }

    if (images.isEmpty) {
      throw DataExceptionRequiredField(
          message: "Please upload at least 1 image");
    }
  }

  static Future<void> addItem(
      {required String title, required String category}) async {
    if (title == "") {
      throw AuthExceptionRequiredField(
          message: "Please Enter item name.", errorCode: 1);
    }

    if (category == "") {
      throw AuthExceptionRequiredField(message: "Please select a category");
    }
  }

  static Future<void> onCreateUser({
    String? name,
    String? password,
    // String? confirmPassword,
    String? email,
    // String? phone,
  }) async {
    if (name == null || name == "") {
      throw AuthExceptionFullNameRequired();
    }

    if (email == null || email == "") {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: email)) {
      throw AuthExceptionInvalidEmail();
    }

    // if (phone == null || phone == "") {
    //   throw AuthExceptionRequiredPhone();
    // }

    if (password == null || password == "") {
      throw AuthExceptionPasswordRequired();
    }

    if (password.length < 6) {
      throw AuthExceptionWeekPassword();
    }

    // if (confirmPassword == null || confirmPassword == "") {
    //   throw AuthExceptionConfirmPasswordRequired();
    // }

    // if (confirmPassword != password) {
    //   throw AuthExceptionConfirmPasswordDoesntMatching();
    // }
  }

  static Future<void> updateUser({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (name == null || name == "") {
      throw AuthExceptionFullNameRequired();
    }

    if (email == null) {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: email)) {
      throw AuthExceptionInvalidEmail();
    }

    if (phone == null || phone == "") {
      throw AuthExceptionRequiredPhone();
    }
  }
}
