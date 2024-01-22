import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoPlaybackControls {
  VideoPlaybackControls({required this.position, required this.mute});

  final double position;
  final bool mute;
}

final videoPlayerControlsProvider =
    StateNotifierProvider<VideoPlayerControls, VideoPlaybackControls>((ref) {
  return VideoPlayerControls(ref);
});

class VideoPlayerControls extends StateNotifier<VideoPlaybackControls> {
  VideoPlayerControls(this.ref)
      : super(
          VideoPlaybackControls(
            position: 0,
            mute: false,
          ),
        );

  final Ref ref;

  VideoPlaybackControls get value => state;

  set value(VideoPlaybackControls value) {
    state = value;
  }

  double get position => state.position;
  bool get mute => state.mute;

  set position(double value) {
    state = VideoPlaybackControls(position: value, mute: state.mute);
  }

  set mute(bool value) {
    state = VideoPlaybackControls(position: state.position, mute: value);
  }

  void toggleMute() {
    state = VideoPlaybackControls(position: state.position, mute: !state.mute);
  }
}
