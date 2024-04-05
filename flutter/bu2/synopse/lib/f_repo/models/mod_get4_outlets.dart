class SynopseArticlesVGet4Outlet {
  SynopseArticlesVGet4Outlet({
    required this.logoUrl,
    required this.outletDisplay,
  });

  final String logoUrl;
  final String outletDisplay;

  factory SynopseArticlesVGet4Outlet.fromJson(Map<String, dynamic> json) {
    return SynopseArticlesVGet4Outlet(
      logoUrl: json["logo_url"] ?? "",
      outletDisplay: json["outlet_display"] ?? "",
    );
  }
}
