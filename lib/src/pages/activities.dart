import 'package:YogiTech/main.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/event.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/api/event/event_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/pages/event_detail.dart';
import 'package:YogiTech/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/utils/formatting.dart';

class Activities extends StatefulWidget {
  final Account? account;
  final VoidCallback? fetchAccount;
  const Activities({super.key, this.account, this.fetchAccount});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  List<dynamic> _events = [];
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _loadEvents(null);
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

  Future<void> _loadEvents(int? eventId) async {
    setState(() {
        _isloading = true;
      });
    try {
      final events = await getEvents();
      setState(() {
        _events = events;
        _isloading = false;
      });
    } catch (e) {
      print('Error loading activities: $e');
    }
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return  _isloading
      ? Center(child: CircularProgressIndicator()):
     Container(
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

    // Filter the events based on the status
    final filteredEvents = _events.where((event) {
      CheckDateResult check = checkDateExpired(event.start_date, event.expire_date, trans);
      return check.status == 1 || check.status == 2;
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 5 / 6,
        ),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          final check = checkDateExpired(event.start_date, event.expire_date, trans);

          return CustomCard(
            imageUrl: event.image_url,
            title: event.title,
            caption: "${trans.participants}: ${event.event_candidate.length}",
            subtitle: check.message,
            onTap: () {
              pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetail(
                    key: UniqueKey(), // Ensure EventDetail is keyed
                    event: event,
                    account: widget.account,
                    fetchAccount: widget.fetchAccount,
                    fetchEvent: _loadEvents,
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