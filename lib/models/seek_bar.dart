import 'dart:math';

import 'package:flutter/material.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    super.key,
    required this.position,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<StatefulWidget> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  Widget build(BuildContext context) {
    double? _dragValue;

    String _formatDuration(Duration duration) {
      if (duration == null) {
        return '--:--';
      } else {
        String minutes = duration.inMinutes.toString().padLeft(2, '0');
        String seconds =
            duration.inSeconds.remainder(60).toString().padLeft(2, '0');
        return '$minutes:$seconds';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Row(
        children: [
          Text(_formatDuration(widget.position)),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(
                  disabledThumbRadius: 2,
                  enabledThumbRadius: 2,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 10,
                ),
                activeTrackColor: Colors.red,
                inactiveTrackColor: Colors.grey.withOpacity(.5),
                thumbColor: Colors.white,
                overlayColor: Colors.white,
              ),
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });

                  if (widget.onChanged != null) {
                    widget.onChanged!(
                      Duration(
                        milliseconds: value.round(),
                      ),
                    );
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(
                      Duration(
                        milliseconds: value.round(),
                      ),
                    );
                  }

                  _dragValue = null;
                },
              ),
            ),
          ),
          Text(_formatDuration(widget.duration)),
        ],
      ),
    );
  }
}

class SeekBarMin extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBarMin({
    super.key,
    required this.position,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<StatefulWidget> createState() => _SeekBarMinState();
}

class _SeekBarMinState extends State<SeekBarMin> {
  @override
  Widget build(BuildContext context) {
    double? _dragValue;

    String _formatDuration(Duration duration) {
      if (duration == null) {
        return '--:--';
      } else {
        String minutes = duration.inMinutes.toString().padLeft(2, '0');
        String seconds =
            duration.inSeconds.remainder(60).toString().padLeft(2, '0');
        return '$minutes:$seconds';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          // Text(_formatDuration(widget.position)),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(
                  disabledThumbRadius: 1,
                  enabledThumbRadius: 1,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 1,
                ),
                activeTrackColor: Colors.red,
                inactiveTrackColor: Colors.grey.withOpacity(.5),
                thumbColor: Colors.white,
                overlayColor: Colors.white,
              ),
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });

                  if (widget.onChanged != null) {
                    widget.onChanged!(
                      Duration(
                        milliseconds: value.round(),
                      ),
                    );
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(
                      Duration(
                        milliseconds: value.round(),
                      ),
                    );
                  }

                  _dragValue = null;
                },
              ),
            ),
          ),
          // Text(_formatDuration(widget.duration)),
        ],
      ),
    );
  }
}
