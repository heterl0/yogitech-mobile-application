import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/api/event/event_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/models/event.dart';
import 'package:yogi_application/src/pages/event_detail.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yogi_application/utils/formatting.dart';

class Activities extends StatefulWidget {
  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // Biến trạng thái để lưu trữ nội dung hiện tại

  List<dynamic> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: trans.event,
        showBackButton: false,
      ),
      body: _buildBody(context),
    );
  }

  Future<void> _loadEvents() async {
    try {
      final events = await getEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      // Handle errors, e.g., show a snackbar or error message
      print('Error loading activities: $e');
    }
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildEventMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventMainContent() {
    final trans = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: 4.0), // Add horizontal padding if needed
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(), // Enable scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 4, // Aspect ratio of each card
        ),
        itemCount: _events.length, // Number of cards

        itemBuilder: (context, index) {
          return CustomCard(
            imageUrl: _events[index].image_url,
            title: _events[index].title,
            caption:
                "Number of participants: ${_events[index].event_candidate.length}",
            subtitle: checkDateExpired(
                _events[index].start_date, _events[index].expire_date),
            onTap: () {
              pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetail(
                    event: _events[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
