import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/api/event/event_service.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/event.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/card.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatefulWidget {
  final Event? event;
  final Account? account;
  final VoidCallback? fetchAccount;
  const EventDetail({super.key, required this.event, this.account, this.fetchAccount});


  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail>
    with TickerProviderStateMixin {
  late Event? _event;
  late Account? _account;
  late TabController _tabController;
  bool isLoading = false;
  bool _isJoin= false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _account = widget.account;
    _event = widget.event;
    _isJoin = isjoin(_event!,_account!.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true; // Start loading
      widget.fetchAccount!.call();
      _account = widget.account;
      _isJoin = isjoin(_event!,_account!.id);
      isLoading = false;
    });
  }

  Future<void> handleJoinEvent(Event ev, bool isJoin) async {
    if (!isJoin) {
      setState(() {
        isLoading = true; // Start loading
      });
      final joinResult = await joinEvent(ev.id);
      if (joinResult is CandidateEvent) {
        print('st');
        fetchEventDetails(ev.id);
        fetchUsers();
      } else {
        print('Error joining event: $joinResult');
        setState(() {
          isLoading = false; // Stop loading on error
        });
      }
    }
  }

  Future<void> handleGiveUpEvent(Event ev, bool isJoin,int candidateId) async {
    if (candidateId != -1 && isJoin) {
      setState(() {
        isLoading = true; // Start loading
      });
      final bool? giveUpResult = await giveUpEvent(candidateId);
      if (giveUpResult != null && giveUpResult) {
        fetchEventDetails(ev.id);
        fetchUsers();
      } else {
        print('Error giving up event: $giveUpResult');
        setState(() {
          isLoading = false; // Stop loading on error
        });
      }
    }
  }

  Future<void> fetchEventDetails(int eventId) async {
      // Kiểm tra _event trước khi gọi API
      setState(() {
        isLoading = true;
      });
      Event? updatedEvent = await getEvent(eventId);
      setState(() {
        _event = updatedEvent;
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    // Find the candidate ID by matching the user ID in the candidates list
    // int candidateId =
    //     _event!.event_candidate.map((candidate) => candidate.id).firstWhere(
    //           (id) => _event!.event_candidate.any((candidate) =>
    //               candidate.user == _account!.id && candidate.id == id),
    //           orElse: () => -1,
    //         );
    // bool isJoin = (candidateId != -1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildCustomTopBar(context),
          SliverToBoxAdapter(
            child: _buildBody(context),
          ),
          if (isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: _isJoin ? trans.giveUp : trans.joinIn,
        onPressed: () {
          if (!_isJoin) {
            handleJoinEvent(_event!,_isJoin);
          } else {
            handleGiveUpEvent(_event!,_isJoin,_account!.id);
          }
        },
      ),
    );
  }

  Widget _buildCustomTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return SliverAppBar(
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      scrolledUnderElevation: appElevation,
      elevation: appElevation,
      backgroundColor: theme.colorScheme.onSecondary,
      pinned: true,
      centerTitle: true,
      title: Text(
          checkDateExpired(_event!.start_date, _event!.expire_date, trans),
          style: h2.copyWith(color: theme.colorScheme.onSurface)),
      expandedHeight: 320,
      flexibleSpace: FlexibleSpaceBar(
        background: 
        CachedNetworkImage(
        imageUrl: _event!.image_url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final trans = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildRowWithText(context, trans),
          const SizedBox(height: 16),
          _buildDescription(),
          const SizedBox(height: 16),
          TabBar(
            dividerColor: Colors.transparent,
            controller: _tabController,
            tabs: [
              Tab(child: Text(trans.leaderboard, style: h3)),
              Tab(child: Text(trans.listOfExercises, style: h3)),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            height: 480,
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                _buildRankContent(context),
                _buildListExerciseContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        _event!.title,
        style: h2.copyWith(color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildRowWithText(BuildContext context, AppLocalizations trans) {
    final local = Localizations.localeOf(context);
    String startDay = DateFormat.yMMMd(local.languageCode)
        .add_Hm()
        .format(DateTime.parse(_event!.start_date));
    String endDay = DateFormat.yMMMd(local.languageCode)
        .add_Hm()
        .format(DateTime.parse(_event!.expire_date));

    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${trans.start}:",
                    style: bd_text.copyWith(color: Colors.white),
                  ),
                  Text(
                    ' $startDay',
                    style: bd_text.copyWith(color: primary),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${trans.end}:",
                    style: bd_text.copyWith(color: Colors.white),
                  ),
                  Text(
                    ' $endDay',
                    style: bd_text.copyWith(color: primary),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trans.numOfExercise,
                    style: bd_text.copyWith(color: Colors.white),
                  ),
                  Text(
                    ' ${_event!.exercises.length}',
                    style: bd_text.copyWith(color: primary),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trans.numOfCandidate,
                    style: bd_text.copyWith(color: Colors.white),
                  ),
                  Text(
                    ' ${_event!.event_candidate.length}',
                    style: bd_text.copyWith(color: primary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return HtmlWidget(
      _event!.description,
      textStyle: TextStyle(fontFamily: 'ReadexPro'),
    );
  }

  Widget _buildRankContent(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    List<dynamic> candidates = _event!.event_candidate;
    candidates
        .sort((a, b) => (a.event_point ?? 0).compareTo(b.event_point ?? 0));

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Đảm bảo column không mở rộng vượt qua khung nhìn
        children: candidates.asMap().entries.map((entry) {
          int index = entry.key;
          CandidateEvent item = entry.value as CandidateEvent;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SizedBox(
              height: 48, // Điều chỉnh chiều cao cho mỗi hàng
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: index == 0
                        ? Image.asset('assets/icons/Warranty.png',
                            fit: BoxFit.fill)
                        : Center(
                            child: Text(
                              (index + 1).toString(),
                              textAlign: TextAlign.center,
                              style: h3.copyWith(
                                  color: theme.colorScheme.onSurface),
                            ),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const ShapeDecoration(
                      gradient: gradient,
                      shape: CircleBorder(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${item.profile.first_name} ${item.profile.last_name}',
                      style: h3.copyWith(color: theme.colorScheme.onSurface),
                      maxLines: 1, // Đảm bảo tên người dùng không quá dài
                      overflow:
                          TextOverflow.ellipsis, // Xử lý trường hợp tràn bản
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.event_point.toStringAsFixed(1)} ${trans.point}',
                    textAlign: TextAlign.right,
                    style: h3.copyWith(color: primary),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListExerciseContent(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 19 / 20,
      ),
      padding: EdgeInsets.all(0),
      itemCount: _event!.exercises.length,
      itemBuilder: (context, index) {
        final exercise = _event!.exercises[index];
        return CustomCard(
          title: exercise.title,
          subtitle:
              '${exercise.calories} ${trans.calorie} / ${exercise.durations} ${trans.seconds}',
          imageUrl: exercise.image_url,
          onTap: () {},
        );
      },
    );
  }

  bool isjoin(Event event, int accId){
    int candidateId =
        event.event_candidate.map((candidate) => candidate.id).firstWhere(
              (id) => event.event_candidate.any((candidate) =>
                  candidate.user == accId && candidate.id == id),
              orElse: () => -1,
            );
    return (candidateId != -1);
  }
}
