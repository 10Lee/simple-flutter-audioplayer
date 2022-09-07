import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  String path =
      'https://docs.google.com/uc?export=download&id=1M9Xo8osVctpAnpDaMG95JOEw2ZILVpeK';

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isPlaying = false;
  bool isForward = false;
  bool isBackward = false;
  bool isRepeat = false;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged
        .listen((event) => setState(() => duration = event));
    player.onPositionChanged
        .listen((event) => setState(() => position = event));

    player.setSourceUrl(path);
    player.onPlayerComplete.listen((event) {
      position = Duration.zero;
      if (isRepeat) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
          isRepeat = false;
          isForward = false;
          isBackward = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player Dbestech"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(position.toString().split('.')[0]),
              Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  setState(() => position = Duration(seconds: value.toInt()));
                  player.seek(position);
                },
              ),
              Text(duration.toString().split('.')[0]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isPlaying ? 1 : .25,
                child: IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        if (isBackward) {
                          await player.setPlaybackRate(1);
                          setState(() {
                            isBackward = false;
                            isPlaying = true;
                          });
                        } else {
                          await player.setPlaybackRate(0.5);
                          setState(() {
                            isBackward = true;
                            isPlaying = true;
                            isForward = false;
                          });
                        }
                      }
                    },
                    iconSize: 44,
                    icon: isBackward
                        ? const Icon(Icons.fast_rewind_rounded)
                        : const Icon(Icons.fast_rewind_outlined)),
              ),
              IconButton(
                iconSize: 55,
                onPressed: () async {
                  if (isPlaying) {
                    await player.pause();
                    setState(() => isPlaying = false);
                  } else {
                    await player.setPlaybackRate(1);
                    await player.resume();
                    setState(() {
                      isPlaying = true;
                      isForward = false;
                      isBackward = false;
                    });
                  }
                },
                icon: isPlaying
                    ? const Icon(
                        Icons.pause_circle_filled,
                      )
                    : const Icon(
                        Icons.play_circle_fill,
                      ),
              ),
              Opacity(
                opacity: isPlaying ? 1 : .25,
                child: IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        if (isForward) {
                          await player.setPlaybackRate(1);
                          setState(() {
                            isForward = false;
                            isPlaying = true;
                          });
                        } else {
                          await player.setPlaybackRate(1.5);
                          setState(() {
                            isForward = true;
                            isPlaying = true;
                            isBackward = false;
                          });
                        }
                      }
                    },
                    iconSize: 44,
                    icon: isForward
                        ? const Icon(Icons.fast_forward_rounded)
                        : const Icon(Icons.fast_forward_outlined)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
