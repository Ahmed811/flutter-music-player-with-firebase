import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:islamic_ringtoon/controller/controller.dart';
import 'package:provider/provider.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:adcolony_flutter/banner.dart';

import '../constant.dart';

class PlaySong extends StatefulWidget {
  final url, title;
  const PlaySong({Key? key, this.url, this.title}) : super(key: key);

  @override
  _PlaySongState createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  /////////////////////////////
  bool isPlaying = false;

  @override
  void dispose() {
    // TODO: implement dispose
    //  _player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  listener(AdColonyAdListener? event, int? reward) async {
    print(event);
    if (event == AdColonyAdListener.onRequestFilled) {
      if (await AdColony.isLoaded()) {
        AdColony.show();
      }
    }
    if (event == AdColonyAdListener.onClosed) {
      print('ADCOLONY: closed');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<Controller>(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg_song.jpg'), fit: BoxFit.cover)),
          child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 28, color: Colors.white70),
                    ),
                  ),
                  controller.assetsAudioPlayer.builderCurrentPosition(
                      builder: (contex, p) {
                    var p1 = "${p.inMinutes}:${p.inSeconds.remainder(60)}";
                    var p2 =
                        "${controller.musicLength.inMinutes}:${controller.musicLength.inSeconds.remainder(60)}";
                    if (p1 == p2) {
                      print("complete=====================");
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${p.inMinutes}:${p.inSeconds.remainder(60)}",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Expanded(
                            child: Slider.adaptive(
                                activeColor: Colors.blue[800],
                                inactiveColor: Colors.grey[350],
                                min: 0.0,
                                max:
                                    controller.musicLength.inSeconds.toDouble(),
                                value: p.inSeconds.toDouble(),
                                onChanged: (v) {
                                  controller.seektoSec(v);
                                }),
                          ),
                          Text(
                            "${controller.musicLength.inMinutes}:${controller.musicLength.inSeconds.remainder(60)}",
                            style: TextStyle(color: Colors.white70),
                          )
                        ],
                      ),
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return controller.assetsAudioPlayer.builderIsPlaying(
                            builder: (context, isNowPlaying) {
                              return IconButton(
                                onPressed: () async {
                                  controller.assetsAudioPlayer.stop();
                                  if (controller
                                      .assetsAudioPlayer.isPlaying.value) {
                                    await controller.assetsAudioPlayer.pause();
                                  } else {
                                    await controller.assetsAudioPlayer.play();
                                  }
                                  //  controller.changeRepeatMood();
                                },
                                icon: Icon(isNowPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                color: Colors.blue[800],
                                iconSize: 62,
                              );
                            },
                          );
                        },
                        stream: controller.assetsAudioPlayer.onReadyToPlay,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.stop),
                        color: Colors.blue,
                        iconSize: 45,
                      ),
                      controller.assetsAudioPlayer.builderLoopMode(
                          builder: (context, playMood) {
                        print("playmood is $playMood");
                        return IconButton(
                          onPressed: () {
                            controller.isRepeating = !controller.isRepeating;
                            controller.changeRepeatMood(widget.url);
                          },
                          icon: Icon(Icons.repeat),
                          color: playMood == LoopMode.single
                              ? Colors.green
                              : Colors.blue,
                          iconSize: 45,
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    child: BannerView(listener, BannerSizes.banner, zones[1]),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
//Ilovesex1988_&
//app62b533408b014de1ab
// banner vzfa52c86b0594480fa7
