import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageCaresole extends StatefulWidget {
  final double width;
  final List<String> images;
  final int type;

  const ImageCaresole(
      {super.key,
      required this.width,
      required this.images,
      required this.type});

  @override
  State<ImageCaresole> createState() => _ImageCaresoleState();
}

class _ImageCaresoleState extends State<ImageCaresole> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _totalPages = widget.images.length;
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _totalPages) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.type == 1 ? widget.width * 9 / 16 : widget.width,
      width: widget.width,
      child: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Builder(
              builder: (BuildContext context) {
                try {
                  return CachedNetworkImage(
                    imageUrl: widget.images[index],
                    placeholder: (context, url) => Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: widget.type == 1
                              ? widget.width * 9 / 16
                              : widget.width,
                          width: widget.width,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    fit: BoxFit.cover,
                  );
                } catch (e) {
                  return Container();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
