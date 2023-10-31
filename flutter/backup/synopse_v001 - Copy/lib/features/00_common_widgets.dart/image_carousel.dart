import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:synopse_v001/features/00_common_widgets.dart/image_shimmer.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final double aspectRatio;
  final Duration duration;

  const ImageCarousel({
    Key? key,
    required this.imageUrls,
    this.height = 200,
    this.aspectRatio = 16 / 9,
    this.duration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.duration, (_) {
      if (_currentPage < widget.imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.height * 16 / 9,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return Animate(
            effects: [
              FadeEffect(delay: 200.milliseconds, duration: 1000.milliseconds)
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    placeholder: (context, url) => const ImageShimmer(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
