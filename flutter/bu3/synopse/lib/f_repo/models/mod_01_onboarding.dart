class Onboarding {
  Onboarding({
    required this.desc,
    required this.getStarted,
    required this.image,
    required this.next,
    required this.skip,
    required this.title,
  });

  final String desc;
  final String getStarted;
  final String image;
  final String next;
  final String skip;
  final String title;

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(
      desc: json["desc"] ?? "",
      getStarted: json["get_started"] ?? "",
      image: json["image"] ?? "",
      next: json["next"] ?? "",
      skip: json["skip"] ?? "",
      title: json["title"] ?? "",
    );
  }
}
