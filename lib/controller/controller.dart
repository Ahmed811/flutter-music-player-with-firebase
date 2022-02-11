import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Controller extends ChangeNotifier {
  late AssetsAudioPlayer assetsAudioPlayer;
  IconData playBtn = Icons.play_arrow;
  Duration position = Duration();
  Duration musicLength = Duration();
  late String url;
  var loopMood = LoopMode.none;
  bool isRepeating = false;

  Controller() {
    assetsAudioPlayer = AssetsAudioPlayer();
    // assetsAudioPlayer.
  }

  loadSong(url) async {
    try {
      await assetsAudioPlayer.open(Audio.network(url),
          showNotification: true,
          autoStart: false,
          playInBackground: PlayInBackground.enabled,
          loopMode: loopMood);
      assetsAudioPlayer.current.listen((song) {
        musicLength = song!.audio.duration;
        notifyListeners();
      });
    } catch (t) {
      //mp3 unreachable
    }
  }

  changeRepeatMood(url) async {
    if (isRepeating) {
      loopMood = LoopMode.single;

      notifyListeners();
    } else {
      loopMood = LoopMode.none;
      notifyListeners();
    }
    assetsAudioPlayer.stop();
    await loadSong(url);
  }

  @override
  void dispose() {
    //  assetsAudioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void seektoSec(double sec) {
    Duration newPos = Duration(seconds: sec.toInt());
    //  _player.seek(newPos);
    assetsAudioPlayer.seek(newPos);
    notifyListeners();
  }
}
