import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/api/event/event_service.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/views/event_detail.dart';
import 'package:YogiTech/widgets/card.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: trans.event,
          showBackButton: false,
        ),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(
                color: (!(widget.account?.is_premium ?? false))
                    ? primary
                    : primary2,
              ))
            : SafeArea(
                child: RefreshIndicator(
                  color: (!(widget.account?.is_premium ?? false))
                      ? primary
                      : primary2,
                  backgroundColor: theme.colorScheme.onSecondary,

                  // Bọc SingleChildScrollView bằng RefreshIndicator
                  onRefresh: () async {
                    // Gọi hàm để refresh dữ liệu ở đây
                    _loadEvents(null);
                    widget.fetchAccount?.call();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: double.infinity,
                      // height: double.infinity,
                      decoration:
                          BoxDecoration(color: theme.colorScheme.surface),
                      child: SingleChildScrollView(
                        child: _buildEventMainContent(),
                      ),
                    ),
                  ),
                ),
              ));
  }

  Future<void> _loadEvents(int? eventId) async {
    print('Loading activities...');
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

  Widget _buildEventMainContent() {
    final trans = AppLocalizations.of(context)!;

    // Filter the events based on the status
    final filteredEvents = _events.where((event) {
      CheckDateResult check =
          checkDateExpired(event.start_date, event.expire_date, trans);
      return check.status == 1 || check.status == 2;
    }).toList();

    filteredEvents.sort((a, b) {
      CheckDateResult checkA =
          checkDateExpired(a.start_date, a.expire_date, trans);
      CheckDateResult checkB =
          checkDateExpired(b.start_date, b.expire_date, trans);

      // Sort by status (1 for remaining, 2 for expiring soon) in ascending order
      return checkA.status.compareTo(checkB.status);
    });

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
          final check =
              checkDateExpired(event.start_date, event.expire_date, trans);

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
