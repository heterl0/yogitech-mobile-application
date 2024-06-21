import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PerformMeditate extends StatefulWidget {
  final Duration selectedDuration;
  final String audioPath;

  const PerformMeditate({
    Key? key,
    this.selectedDuration = const Duration(seconds: 5),
    this.audioPath = '',
  }) : super(key: key);

  @override
  _PerformMeditateState createState() => _PerformMeditateState();
}

class _PerformMeditateState extends State<PerformMeditate> {
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;

    print(widget.audioPath == ''
        ? 'trong'
        : '${widget.audioPath}Time:${widget.selectedDuration}');

    return Scaffold(
      appBar: CustomAppBar(
        title: trans.meditate,
      ),
    );
  }
}
