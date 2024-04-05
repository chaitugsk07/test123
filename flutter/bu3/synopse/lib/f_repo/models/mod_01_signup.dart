class Signup {
  Signup({
    required this.editPhNo,
    required this.needHelp,
    required this.otpEnter,
    required this.otpResend,
    required this.otpVerify,
    required this.resendOtpin,
    required this.verify,
    required this.another,
    required this.apple,
    required this.backToSignup,
    required this.code,
    required this.google,
    required this.guest,
    required this.login,
    required this.or,
    required this.phno,
    required this.phno10Digits,
    required this.phnoReq,
    required this.projectName,
    required this.register,
    required this.seconds,
    required this.standard,
    required this.terms,
    required this.title,
    required this.tos1,
    required this.tos2,
    required this.tos3,
    required this.tos4,
    required this.tryDiffAccount,
    required this.wrong,
  });

  final String editPhNo;
  final String needHelp;
  final String otpEnter;
  final String otpResend;
  final String otpVerify;
  final String resendOtpin;
  final String verify;
  final String another;
  final String apple;
  final String backToSignup;
  final String code;
  final String google;
  final String guest;
  final String login;
  final String or;
  final String phno;
  final String phno10Digits;
  final String phnoReq;
  final String projectName;
  final String register;
  final String seconds;
  final String standard;
  final String terms;
  final String title;
  final String tos1;
  final String tos2;
  final String tos3;
  final String tos4;
  final String tryDiffAccount;
  final String wrong;

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      editPhNo: json["EditPhNo"] ?? "",
      needHelp: json["NeedHelp"] ?? "",
      otpEnter: json["OTPEnter"] ?? "",
      otpResend: json["OTPResend"] ?? "",
      otpVerify: json["OTPVerify"] ?? "",
      resendOtpin: json["ResendOtpin"] ?? "",
      verify: json["Verify"] ?? "",
      another: json["another"] ?? "",
      apple: json["apple"] ?? "",
      backToSignup: json["backToSignup"] ?? "",
      code: json["code"] ?? "",
      google: json["google"] ?? "",
      guest: json["guest"] ?? "",
      login: json["login"] ?? "",
      or: json["or"] ?? "",
      phno: json["phno"] ?? "",
      phno10Digits: json["phno10Digits"] ?? "",
      phnoReq: json["phnoReq"] ?? "",
      projectName: json["project_name"] ?? "",
      register: json["register"] ?? "",
      seconds: json["seconds"] ?? "",
      standard: json["standard"] ?? "",
      terms: json["terms"] ?? "",
      title: json["title"] ?? "",
      tos1: json["tos1"] ?? "",
      tos2: json["tos2"] ?? "",
      tos3: json["tos3"] ?? "",
      tos4: json["tos4"] ?? "",
      tryDiffAccount: json["tryDiffAccount"] ?? "",
      wrong: json["wrong"] ?? "",
    );
  }
}
