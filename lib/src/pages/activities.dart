import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/api/event/event_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/pages/event_detail.dart';
import 'package:YogiTech/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/utils/formatting.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

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
      decoration: BoxDecoration(color: theme.colorScheme.surface),
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
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(), // Enable scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns

          childAspectRatio: 5 / 6, // Aspect ratio of each card
        ),
        itemCount: _events.length, // Number of cards

        itemBuilder: (context, index) {
          return CustomCard(
            imageUrl: _events[index].image_url,
            title: _events[index].title,
            caption:
                "${trans.participants}: ${_events[index].event_candidate.length}",
            subtitle: checkDateExpired(
                _events[index].start_date, _events[index].expire_date, trans),
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
