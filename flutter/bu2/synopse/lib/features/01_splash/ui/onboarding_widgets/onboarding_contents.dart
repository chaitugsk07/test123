import 'package:synopse/core/asset_gen/assets.gen.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to Synopse! \n Stay informed with AI-curated news.",
    image: Assets.images.img1.path,
    desc:
        "Experience the world unfiltered. Your news, unbiased and personalized, only with our app.",
  ),
  OnboardingContents(
    title: "Navigate the News Stream",
    image: Assets.images.img2.path,
    desc:
        "Dive into detailed breakdowns of complex issues, presented in a clear and concise way. We'll learn your interests to build your personalized news feed. Like articles to tune your recommendations.",
  ),
  OnboardingContents(
    title: "Join the Conversation",
    image: Assets.images.img3.path,
    desc:
        "Discuss the news, share insights, and challenge perspectives in a respectful and open forum. Earn points and levels by reading and commenting. Check the leaderboard and improve your news IQ!. ",
  ),
];
