import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:synopse/core/utils/image_constant.dart';

class AudioPlayer111 extends StatelessWidget {
  const AudioPlayer111({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioPlayer11();
  }
}

class AudioPlayer11 extends StatefulWidget {
  const AudioPlayer11({super.key});

  @override
  State<AudioPlayer11> createState() => _AudioPlayer11State();
}

class _AudioPlayer11State extends State<AudioPlayer11> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _play() async {
    await _audioPlayer
        .setUrl('https://play.synopseai.com/trending_2024022609.wav');
    _audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.bg),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 10,
              blurRadius: 15,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (!(playing ?? false)) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  color: Colors.white,
                  onPressed: _audioPlayer.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  color: Colors.white,
                  onPressed: _audioPlayer.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  color: Colors.white,
                  onPressed: () {
                    _play();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
