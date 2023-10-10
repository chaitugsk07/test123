class ArticlesTV1ArticalsGroupsL1Detail {
  ArticlesTV1ArticalsGroupsL1Detail({
    required this.articleGroupId,
    required this.title,
    required this.updatedAt,
    required this.logoUrls,
    required this.imageUrls,
    required this.articleGroupsL1ToComments,
    required this.articleGroupsL1ToLikes,
    required this.articleGroupsL1ToViews,
    required this.tV1ArticalsGroupsL1ViewsLikes,
  });

  final int articleGroupId;
  final String title;
  final DateTime? updatedAt;
  final List<String> logoUrls;
  final List<String> imageUrls;
  final ArticleGroupsL1ToComments? articleGroupsL1ToComments;
  final ArticleGroupsL1ToLikes? articleGroupsL1ToLikes;
  final ArticleGroupsL1ToViews? articleGroupsL1ToViews;
  final List<TV1ArticalsGroupsL1ViewsLike> tV1ArticalsGroupsL1ViewsLikes;

  factory ArticlesTV1ArticalsGroupsL1Detail.fromJson(
      Map<String, dynamic> json) {
    return ArticlesTV1ArticalsGroupsL1Detail(
      articleGroupId: json["article_group_id"] ?? 0,
      title: json["title"] ?? "",
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      logoUrls: json["logo_urls"] == null
          ? []
          : List<String>.from(json["logo_urls"]!.map((x) => x)),
      imageUrls: json["image_urls"] == null
          ? []
          : List<String>.from(json["image_urls"]!.map((x) => x)),
      articleGroupsL1ToComments: json["article_groups_l1_to_comments"] == null
          ? null
          : ArticleGroupsL1ToComments.fromJson(
              json["article_groups_l1_to_comments"]),
      articleGroupsL1ToLikes: json["article_groups_l1_to_likes"] == null
          ? null
          : ArticleGroupsL1ToLikes.fromJson(json["article_groups_l1_to_likes"]),
      articleGroupsL1ToViews: json["article_groups_l1_to_views"] == null
          ? null
          : ArticleGroupsL1ToViews.fromJson(json["article_groups_l1_to_views"]),
      tV1ArticalsGroupsL1ViewsLikes:
          json["t_v1_articals_groups_l1_views_likes"] == null
              ? []
              : List<TV1ArticalsGroupsL1ViewsLike>.from(
                  json["t_v1_articals_groups_l1_views_likes"]!
                      .map((x) => TV1ArticalsGroupsL1ViewsLike.fromJson(x))),
    );
  }
}

class ArticleGroupsL1ToComments {
  ArticleGroupsL1ToComments({
    required this.commentCount,
  });

  final num commentCount;

  factory ArticleGroupsL1ToComments.fromJson(Map<String, dynamic> json) {
    return ArticleGroupsL1ToComments(
      commentCount: json["comment_count"] ?? 0,
    );
  }
}

class ArticleGroupsL1ToLikes {
  ArticleGroupsL1ToLikes({
    required this.likeCount,
  });

  final num likeCount;

  factory ArticleGroupsL1ToLikes.fromJson(Map<String, dynamic> json) {
    return ArticleGroupsL1ToLikes(
      likeCount: json["like_count"] ?? 0,
    );
  }
}

class ArticleGroupsL1ToViews {
  ArticleGroupsL1ToViews({
    required this.viewCount,
  });

  final num viewCount;

  factory ArticleGroupsL1ToViews.fromJson(Map<String, dynamic> json) {
    return ArticleGroupsL1ToViews(
      viewCount: json["view_count"] ?? 0,
    );
  }
}

class TV1ArticalsGroupsL1ViewsLike {
  TV1ArticalsGroupsL1ViewsLike({
    required this.type,
  });

  final num type;

  factory TV1ArticalsGroupsL1ViewsLike.fromJson(Map<String, dynamic> json) {
    return TV1ArticalsGroupsL1ViewsLike(
      type: json["type"] ?? 0,
    );
  }
}

/*
{
	"data": {
		"articles_t_v1_articals_groups_l1_detail": [
			{
				"article_group_id": 40,
				"title": " Home Equity Loans: Dream Big with a Home Equity Loan",
				"updated_at": "2023-10-02T07:19:35.32685+00:00",
				"logo_urls": [
					"https://i.postimg.cc/d18BZd6t/81762-cnn-icon.png"
				],
				"image_urls": [
					"https://cdn.cnn.com/cnnnext/dam/assets/221020124036-lendingtree-housemoneystack-super-169.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 14,
				"title": " India's Jaishankar holds meetings with U.S. Adviser Jake Sullivan and Secretary of State Antony Blinken",
				"updated_at": "2023-10-02T07:19:32.004933+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/hde4ui/article67360592.ece/alternates/LANDSCAPE_1200/2023-09-28T172658Z_171827947_RC2Y9X9B39DI_RTRMADP_3_CANADA-INDIA-TRUDEAU.JPG",
					"https://th-i.thgim.com/public/incoming/xteumf/article67336255.ece/alternates/LANDSCAPE_1200/2023-09-22T174555Z_1348072916_RC2TD3AWLBEW_RTRMADP_3_UKRAINE-CRISIS-CANADA-ZELENSKIY.JPG",
					"https://th-i.thgim.com/public/incoming/ra1kd/article67350742.ece/alternates/LANDSCAPE_1200/2023-09-25T211113Z_486429288_RC2VF3A7OQ5Q_RTRMADP_3_CANADA-INDIA.JPG",
					"https://th-i.thgim.com/public/incoming/v9gq2c/article67351976.ece/alternates/LANDSCAPE_1200/PTI09_27_2023_000046A.jpg",
					"https://th-i.thgim.com/public/incoming/pdbai/article67350573.ece/alternates/LANDSCAPE_1200/UN_General_Assembly_35675.jpg",
					"https://th-i.thgim.com/public/incoming/abq3up/article67355821.ece/alternates/LANDSCAPE_1200/IMG_S_Jaishankar_meets_w_2_1_UTB8PM9P.jpg",
					"https://th-i.thgim.com/public/incoming/uz68e1/article67348199.ece/alternates/LANDSCAPE_1200/2023-09-25T175144Z_1684877990_RC2TF3ASYXYP_RTRMADP_3_CANADA-POLITICS.JPG",
					"https://th-i.thgim.com/public/videos/wo2om0/article67362006.ece/alternates/LANDSCAPE_1200/72.png",
					"https://th-i.thgim.com/public/incoming/x3fept/article67360269.ece/alternates/LANDSCAPE_1200/AP09_21_2023_000037A.jpg",
					"https://th-i.thgim.com/public/incoming/iu73dd/article67359972.ece/alternates/LANDSCAPE_1200/2023-09-28T192908Z_1116361575_RC2QH3A8L6WI_RTRMADP_3_USA-INDIA.JPG",
					"https://th-i.thgim.com/public/incoming/a6b6xw/article67364710.ece/alternates/LANDSCAPE_1200/20230929018L.jpg",
					"https://th-i.thgim.com/public/incoming/6jyw9l/article67323354.ece/alternates/LANDSCAPE_1200/Canada_India_Sikh_Slain_55599.jpg",
					"https://th-i.thgim.com/public/incoming/da0q0i/article67354474.ece/alternates/LANDSCAPE_1200/Canada_Air_India_Bombing_FNG104.jpg",
					"https://th-i.thgim.com/public/incoming/2z9l6t/article67358826.ece/alternates/LANDSCAPE_1200/US_India_18820.jpg",
					"https://th-i.thgim.com/public/incoming/zcgox4/article67350312.ece/alternates/LANDSCAPE_1200/2022-04-09T073749Z_1499988660_RC2JJT9KH6NZ_RTRMADP_3_SRI-LANKA-CRISIS-FINMIN.JPG"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 10,
				"title": " Maldivians vote in run-off presidential election",
				"updated_at": "2023-10-02T07:19:22.104795+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/s1gjls/article67364915.ece/alternates/LANDSCAPE_1200/AFP_33X483L.jpg",
					"https://th-i.thgim.com/public/incoming/nki8fn/article67363384.ece/alternates/LANDSCAPE_1200/Maldives_Presidential_Election_22966.jpg",
					"https://th-i.thgim.com/public/incoming/ftmuep/article67366848.ece/alternates/LANDSCAPE_1200/Maldives_Presidential_Election_88562.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 39,
				"title": " South Korea parades troops and shows powerful weapons",
				"updated_at": "2023-10-02T07:19:19.219232+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/tut69s/article67356379.ece/alternates/LANDSCAPE_1200/AP09_28_2023_000026B.jpg",
					"https://th-i.thgim.com/public/incoming/40w6cs/article67348659.ece/alternates/LANDSCAPE_1200/2023-09-26T115302Z_1146519160_RC27G3ADK5SN_RTRMADP_3_SOUTHKOREA-MILITARY.JPG",
					"https://th-i.thgim.com/public/incoming/874rsk/article67350579.ece/alternates/LANDSCAPE_1200/UN_General_Assembly_96368.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 53,
				"title": " Armenians Exodus from Nagorno-Karabakh",
				"updated_at": "2023-10-02T07:19:16.341943+00:00",
				"logo_urls": [
					"https://i.postimg.cc/26x7kWCp/Fox-News-Channel-logo-svg-1.png",
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/k0vbau/article67354619.ece/alternates/LANDSCAPE_1200/AFP_33WM6FE.jpg",
					"https://a57.foxnews.com/static.foxnews.com/foxnews.com/content/uploads/2023/09/931/523/armenia.jpg?ve=1&tl=1",
					"https://th-i.thgim.com/public/incoming/9te41g/article67348082.ece/alternates/LANDSCAPE_1200/2023-09-26T043625Z_1533803420_RC24G3ASHB4T_RTRMADP_3_ARMENIA-AZERBAIJAN.JPG",
					"https://th-i.thgim.com/public/incoming/7yw6sj/article67365933.ece/alternates/LANDSCAPE_1200/2023-09-29T171531Z_1392460369_RC20H3AQABG8_RTRMADP_3_ARMENIA-AZERBAIJAN-KARABAKH.JPG",
					"https://th-i.thgim.com/public/incoming/ovsueq/article67358703.ece/alternates/LANDSCAPE_1200/AFP_33WZ6NW.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 25,
				"title": " Canadian Parliament Speaker Resigns After Praising Former Nazi Soldier",
				"updated_at": "2023-10-02T07:19:12.465177+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/h7btd0/article67350450.ece/alternates/LANDSCAPE_1200/2023-09-25T192148Z_1545650185_RC2VF3AFEYBK_RTRMADP_3_CANADA-POLITICS.JPG",
					"https://th-i.thgim.com/public/incoming/iq9905/article67354931.ece/alternates/LANDSCAPE_1200/Canada_Ukraine_Apology_26354.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 17,
				"title": " U.S. Congress Moving Into Crisis Mode, With Government Shutdown Just Days Away",
				"updated_at": "2023-10-02T07:19:10.142812+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/r7rimt/article67350584.ece/alternates/LANDSCAPE_1200/2023-09-26T201507Z_1780424248_RC2EG3AB25YR_RTRMADP_3_USA-SHUTDOWN.JPG",
					"https://th-i.thgim.com/public/incoming/56yilh/article67363513.ece/alternates/LANDSCAPE_1200/2023-09-29T151320Z_768487190_RC2FI3AZRLXB_RTRMADP_3_USA-SHUTDOWN.JPG"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 37,
				"title": " Wells Fargo Reflect® Card vs. Citi Simplicity® Card",
				"updated_at": "2023-10-02T07:19:07.679893+00:00",
				"logo_urls": [
					"https://i.postimg.cc/d18BZd6t/81762-cnn-icon.png"
				],
				"image_urls": [
					"https://cdn.cnn.com/cnnnext/dam/assets/220722105849-theascent-blackcard722-super-169.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 44,
				"title": " NATO Secretary-General Jens Stoltenberg meets with Ukrainian President Volodymyr Zelenskyy",
				"updated_at": "2023-10-02T07:19:04.905385+00:00",
				"logo_urls": [
					"https://i.postimg.cc/26x7kWCp/Fox-News-Channel-logo-svg-1.png",
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/jqrisj/article67358837.ece/alternates/LANDSCAPE_1200/Russia_Ukraine_War_NATO_45569.jpg",
					"https://a57.foxnews.com/static.foxnews.com/foxnews.com/content/uploads/2023/09/931/523/North-Korea-Russia_03.jpg?ve=1&tl=1",
					"https://th-i.thgim.com/public/incoming/ua8x70/article67350341.ece/alternates/LANDSCAPE_1200/Russia_Ukraine_War_99768.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 12,
				"title": " Pakistan: At least 58 killed in suicide blasts",
				"updated_at": "2023-10-02T07:19:02.58389+00:00",
				"logo_urls": [
					"https://i.postimg.cc/26x7kWCp/Fox-News-Channel-logo-svg-1.png",
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/nf5zji/article67360841.ece/alternates/LANDSCAPE_1200/Pakistan_Bombing_06368.jpg",
					"https://a57.foxnews.com/static.foxnews.com/foxnews.com/content/uploads/2023/09/931/523/pakistan-bombing-victim.jpg?ve=1&tl=1"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 15,
				"title": " Meitei students' bodies surface on social media",
				"updated_at": "2023-10-02T07:19:00.523803+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/tqx07l/article67346384.ece/alternates/LANDSCAPE_1200/PTI06_18_2023_000014B.jpg",
					"https://th-i.thgim.com/public/incoming/vnztjv/article67350576.ece/alternates/LANDSCAPE_1200/IMG_Armed_Forces_2_1_869BP2IN.jpg",
					"https://th-i.thgim.com/public/incoming/dhint8/article67363523.ece/alternates/LANDSCAPE_1200/20230929261L.jpg",
					"https://th-i.thgim.com/public/incoming/lx06q9/article67358868.ece/alternates/LANDSCAPE_1200/2023-09-28T193011Z_1900883782_RC2QH3AOJME4_RTRMADP_3_USA-INDIA.JPG"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 27,
				"title": " Sri Lanka may delay second tranche of IMF bailout",
				"updated_at": "2023-10-02T07:18:57.749199+00:00",
				"logo_urls": [
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/c5k24c/article67326763.ece/alternates/LANDSCAPE_1200/IMG_ADB_2_1_6EBLUFVG.jpg",
					"https://th-i.thgim.com/public/incoming/7ymyi7/article67354514.ece/alternates/LANDSCAPE_1200/AFP_33WR3JU.jpg"
				],
				"article_groups_l1_to_comments": null,
				"article_groups_l1_to_likes": null,
				"article_groups_l1_to_views": null,
				"t_v1_articals_groups_l1_views_likes": []
			},
			{
				"article_group_id": 54,
				"title": " Niger military wants ‘negotiated framework’ for French army pullout",
				"updated_at": "2023-10-02T07:18:55.844349+00:00",
				"logo_urls": [
					"https://i.postimg.cc/26x7kWCp/Fox-News-Channel-logo-svg-1.png",
					"https://i.postimg.cc/bwQ1SXQh/h-circle-black-white-new.png"
				],
				"image_urls": [
					"https://th-i.thgim.com/public/incoming/8i5fbc/article67350417.ece/alternates/LANDSCAPE_1200/AFP_33WH3PN.jpg",
					"https://a57.foxnews.com/static.foxnews.com/foxnews.com/content/uploads/2023/01/931/523/DOTCOM_STATE_COUNTRY_NEWS_AFRICA.png?ve=1&tl=1",
					"https://th-i.thgim.com/public/incoming/ygq1vx/article67354598.ece/alternates/LANDSCAPE_1200/IMG_FILES-NIGER-FRANCE-C_2_1_HNBPUQOA.jpg"
				],
				"article_groups_l1_to_comments": {
					"comment_count": 1
				},
				"article_groups_l1_to_likes": {
					"like_count": 2
				},
				"article_groups_l1_to_views": {
					"view_count": 2
				},
				"t_v1_articals_groups_l1_views_likes": [
					{
						"type": 1
					},
					{
						"type": 0
					}
				]
			}
		]
	}
}*/