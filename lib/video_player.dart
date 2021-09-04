import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class VideoPlayercustom extends StatefulWidget {
  VideoPlayercustom(this.index, this.documents);
  final int index;
  final dynamic documents;

  @override
  _VideoPlayercustomState createState() => _VideoPlayercustomState();
}
//widget.documents[widget.index].data()['Video'],
class _VideoPlayercustomState extends State<VideoPlayercustom> {

  late VideoPlayerController _videoPlayerController1;
  @override
  void initState() {
    _videoPlayerController1 = VideoPlayerController.network(
        widget.documents[widget.index]['link']);
    _videoPlayerController1.setLooping(true);
    _videoPlayerController1.initialize().then((value) =>  setState(() {}));
    super.initState();
  }
  @override
  void dispose() {
    _videoPlayerController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int key = widget.index;
    return VisibilityDetector(
      key: Key(key.toString()),
      onVisibilityChanged: (VisibilityInfo info){
        if(info.visibleFraction==0 || info.visibleFraction <=0.5){
          _videoPlayerController1.pause();
        }else{
          _videoPlayerController1.play();
        }
      },
          child: _videoPlayerController1.value != null && _videoPlayerController1.value.isInitialized
              ? AspectRatio(
                  child: VideoPlayer(_videoPlayerController1),
                  aspectRatio: _videoPlayerController1.value.aspectRatio,
                )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text('Loading'),
                          ],
                        ),
    );
  }
}
