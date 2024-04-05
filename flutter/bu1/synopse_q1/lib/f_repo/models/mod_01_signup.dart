class Signup {
  Signup({
    required this.editPhNo,
    required this.needHelp,
    required this.otpEnter,
    required this.otpResend,
    required this.otpVerify,
    required this.resendOtpin,
    required this.verify,
    required this.apple,
    required this.backToSignup,
    required this.code,
    required this.google,
    required this.guest,
    required this.login,
    required this.or,
    required this.projectName,
    required this.register,
    required this.seconds,
    required this.standard,
    required this.terms,
    required this.title,
    required this.tos,
    required this.wrong,
  });

  final String editPhNo;
  final String needHelp;
  final String otpEnter;
  final String otpResend;
  final String otpVerify;
  final String resendOtpin;
  final String verify;
  final String apple;
  final String backToSignup;
  final String code;
  final String google;
  final String guest;
  final String login;
  final String or;
  final String projectName;
  final String register;
  final String seconds;
  final String standard;
  final String terms;
  final String title;
  final String tos;
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
      apple: json["apple"] ?? "",
      backToSignup: json["backToSignup"] ?? "",
      code: json["code"] ?? "",
      google: json["google"] ?? "",
      guest: json["guest"] ?? "",
      login: json["login"] ?? "",
      or: json["or"] ?? "",
      projectName: json["project_name"] ?? "",
      register: json["register"] ?? "",
      seconds: json["seconds"] ?? "",
      standard: json["standard"] ?? "",
      terms: json["terms"] ?? "",
      title: json["title"] ?? "",
      tos: json["tos"] ?? "",
      wrong: json["wrong"] ?? "",
    );
  }
}
