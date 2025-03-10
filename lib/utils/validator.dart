class Validators {
  static String? emptyValidator(dynamic text) {
    if (text.isEmpty) {
      return "Empty field";
    }
    return null;
  }

  static String? zeroValidator(dynamic text) {
    if (text.isEmpty) {
      return "Empty field";
    }
    if (int.parse(text) < 1) return "Please enter a value greater than zero";
    return null;
  }

  static String? emailValidator(String? email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email!.trim()) ? null : "Email invalid";
  }

  static String? signUpPasswordValidator(String? text) {
    return text!.length >= 8
        ? null
        : "Password must be at least 8 characters long";
  }

  static String? firstNameValidator(String? text) {
    return (text?.length ?? 0) > 1
        ? null
        : "First name must be more than 2 characters";
  }

  static String? lastNameValidator(String? text) {
    return (text?.length ?? 0) > 1
        ? null
        : "Last name must be more than 2 characters";
  }

  static String? phoneNumberValidator(String? text) {
    String pattern = r'(^(?:[+0])?[0-9]{11,13}$)';
    RegExp regExp = new RegExp(pattern);
    if ((text?.length ?? 0) == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(text ?? "")) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static String? descriptionValidator(String? text) {
    return (text?.length ?? 0) < 400
        ? null
        : "Too many characters ${text!.length}/400";
  }

  static String? nicknameTwitterValidator(String? text) {
    return (text?.length ?? 0) < 400
        ? null
        : "Too many characters ${text!.length}/15";
  }

  static String? nicknameFacebookValidator(String? text) {
    return (text?.length ?? 0) < 400
        ? null
        : "Too many characters ${text!.length}/50";
  }

  static String? nicknameLinkedInValidator(String? text) {
    return (text?.length ?? 0) < 400
        ? null
        : "Too many characters ${text!.length}/30";
  }
}
