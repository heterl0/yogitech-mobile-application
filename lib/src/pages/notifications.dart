import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/widgets/switch.dart'; // Assuming this is CustomSwitch

class NotificationsPage extends StatefulWidget {
  final bool streakSaverOn;
  final bool friendAactivitiesOn;
  final bool newEventOn;
  // final ValueChanged<bool> areRemindersEnabled;

  const NotificationsPage({
    Key? key,
    this.streakSaverOn = true,
    this.friendAactivitiesOn = true,
    this.newEventOn = true,
    // this.areRemindersEnabled,
  }) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: "Notifications",
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              CustomSwitch(
                title: 'Streak saver',
                value: widget.streakSaverOn,
                onChanged: null,
              ),
              CustomSwitch(
                title: 'Friends activities',
                value: widget.friendAactivitiesOn,
                onChanged: null,
              ),
              CustomSwitch(
                title: 'New event',
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
