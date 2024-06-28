import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/widgets/switch.dart'; // Assuming this is CustomSwitch
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  final bool streakSaverOn;
  final bool friendAactivitiesOn;
  final bool newEventOn;
  // final ValueChanged<bool> areRemindersEnabled;

  const NotificationsPage({
    super.key,
    this.streakSaverOn = true,
    this.friendAactivitiesOn = true,
    this.newEventOn = true,
    // this.areRemindersEnabled,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.notifications,
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              CustomSwitch(
                title: trans.streakSaver,
                value: widget.streakSaverOn,
                onChanged: null,
              ),
              CustomSwitch(
                title: trans.friendsActivities,
                value: widget.friendAactivitiesOn,
                onChanged: null,
              ),
              CustomSwitch(
                title: trans.newEvent,
                value: widget.newEventOn,
                onChanged: null,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
