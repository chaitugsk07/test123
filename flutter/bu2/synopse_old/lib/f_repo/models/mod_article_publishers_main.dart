class SynopseArticlesTV1Outlet {
  SynopseArticlesTV1Outlet({
    required this.logoUrl,
    required this.outletDisplay,
    required this.outletDescription,
    required this.outletId,
  });

  final String logoUrl;
  final String outletDisplay;
  final String outletDescription;
  final int outletId;

  factory SynopseArticlesTV1Outlet.fromJson(Map<String, dynamic> json) {
    return SynopseArticlesTV1Outlet(
      logoUrl: json["logo_url"] ?? "",
      outletDisplay: json["outlet_display"] ?? "",
      outletDescription: json["outlet_description"] ?? "",
      outletId: json["outlet_id"] ?? 0,
    );
  }
}
