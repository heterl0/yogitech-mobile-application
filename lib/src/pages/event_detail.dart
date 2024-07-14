import 'package:YogiTech/api/social/social_service.dart';
import 'package:YogiTech/src/pages/exercise_detail.dart';
import 'package:YogiTech/src/pages/friend_profile.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
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
  final void Function(int)? fetchEvent;

  const EventDetail({
    Key? key, // Add a key here
    required this.event,
    this.account,
    this.fetchAccount,
    this.fetchEvent,
  }) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail>
    with TickerProviderStateMixin {
  Event? _event;
  Account? _account;
  late TabController _tabController;
  bool isLoading = false;
  bool _isJoin = false;
  CandidateEvent? _candidateEvent;
  CheckDateResult? _expired;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _account = widget.account;
    _tabController = TabController(length: 2, vsync: this);
    _fetchEventDetails(null);
    _fetchUsers();

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  

  Future<void> _fetchUsers() async {
    if (_event == null || _account == null) return;
    setState(() {
      isLoading = true; // Start loading
    });
    JoinEvent join = getCandidateByUser();
    setState(() {
      _isJoin = join.isJoin;
      _candidateEvent = join.candidate;
      isLoading = false;
    });
  }

  Future<void> handleJoinEvent() async {
    if (_event == null) return;
    setState(() {
      isLoading = true; // Start loading
    });
    CandidateEvent? updateResult;
    if (!_isJoin && _candidateEvent == null) {
      updateResult = await joinEvent(_event!.id);
    } else if (!_isJoin && _candidateEvent != null) {
      updateResult = await updateStatusCandidateEvent(_candidateEvent!.id, 1);
    } else {
      updateResult = null;
    }
    if (updateResult is CandidateEvent) {
      print('nowfetch');
      // await _fetchUsers();
      setState(() {
        widget.fetchEvent!.call(_event!.id);
        _fetchEventDetails(_event!.id);
      });
    } else {
      print('Error joining event: $updateResult');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> handleGiveUpEvent() async {
    if (_isJoin && _candidateEvent != null) {
      setState(() {
        isLoading = true; // Start loading
      });
      final CandidateEvent? giveUpResult =
          await updateStatusCandidateEvent(_candidateEvent!.id, 0);
      if (giveUpResult != null) {
        // await _fetchUsers();
        setState(() {
          widget.fetchEvent!.call(_event!.id);
          _fetchEventDetails(_event!.id);
        });
      } else {
        print('Error giving up event: $giveUpResult');
        setState(() {
          isLoading = false; // Stop loading on error
        });
      }
    }
  }

  Future<void> _fetchEventDetails(int? event) async {
    if (event != null) {
      Event? updatedEvent = await getEvent(event);
      setState(() {
        _event = updatedEvent;
        final join = getCandidateByUser();
        _isJoin = join.isJoin;
        _candidateEvent = join.candidate;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        _event = widget.event;
        _account = widget.account;
        if (_event != null && _account != null) {
          final join = getCandidateByUser();
          _isJoin = join.isJoin;
          _candidateEvent = join.candidate;
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    _expired = checkDateExpired(_event!.start_date, _event!.expire_date, trans);

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: theme.colorScheme.surface,
            body: CustomScrollView(
              slivers: [
                if (_event != null) _buildCustomTopBar(context),
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
            bottomNavigationBar: (!(_expired!.status == 1))
                ? CustomBottomBar(
                    buttonTitle: _expired!.message,
                    style: ButtonStyleType.Tertiary,
                  )
                : _isJoin
                    ? CustomBottomBar(
                        buttonTitle: trans.giveUp,
                        style: ButtonStyleType.Quaternary,
                        onPressed: handleGiveUpEvent,
                      )
                    : CustomBottomBar(
                        buttonTitle: trans.joinIn,
                        onPressed: handleJoinEvent,
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
      title: Text(_expired!.message,
          style: h2.copyWith(color: theme.colorScheme.onSurface)),
      expandedHeight: 320,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: _event!.image_url,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
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
          if (_event != null) _buildTitle(context),
          const SizedBox(height: 16),
          if (_event != null) _buildRowWithText(context, trans),
          const SizedBox(height: 16),
          if (_event != null) _buildDescription(),
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
        .format(DateTime.parse(_event!.start_date).toUtc().toLocal());
    String endDay = DateFormat.yMMMd(local.languageCode)
        .add_Hm()
        .format(DateTime.parse(_event!.expire_date).toUtc().toLocal());

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

    List<dynamic> candidates = _event!.event_candidate
        .where((candidate) => candidate.active_status != 0)
        .toList();
    candidates
        .sort((a, b) => (b.event_point ?? 0).compareTo(a.event_point ?? 0));

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Đảm bảo column không mở rộng vượt qua khung nhìn
        children: candidates.asMap().entries.map((entry) {
          int index = entry.key;
          CandidateEvent item = entry.value as CandidateEvent;
          return ((item.active_status == 1) &&
                  (item.profile.active_status == 1))
              ? GestureDetector(
                  onTap: () {
                    if (item.user != _account!.id) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendProfile(
                            profile: item.profile,
                            account: _account,
                            unFollow: unFollow,
                            followUserByUserId: followUserByUserId,
                          ),
                        ),
                      );
                    }
                  },
                  child: Padding(
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
                            child: (item.profile.avatar != null &&
                                    item.profile.avatar != '')
                                ? Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: stroke,
                                    ),
                                    child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(item
                                                .profile.avatar
                                                .toString())),
                                  )
                                : Container(
                                    width:
                                        60, // 2 * radius + 8 (border width) * 2
                                    height:
                                        60, // Matching the ratio as per Figma
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 78,
                                      backgroundImage: AssetImage(
                                          'assets/images/gradient.jpg'),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.profile.first_name != ''
                                              ? item.profile.first_name![0]
                                                  .toUpperCase()
                                              : ':)',
                                          style: TextStyle(
                                            fontSize:
                                                28, // Adjust the size as needed
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${item.profile.first_name} ${item.profile.last_name}',
                              style: h3.copyWith(
                                  color: theme.colorScheme.onSurface),
                              maxLines:
                                  1, // Đảm bảo tên người dùng không quá dài
                              overflow: TextOverflow
                                  .ellipsis, // Xử lý trường hợp tràn bản
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
                  ))
              : SizedBox();
        }).toList(),
      ),
    );
  }

  Widget _buildListExerciseContent(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return
      _isJoin?
     GridView.builder(
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetail(
                  exercise: exercise,
                  account: _account,
                  fetchAccount: widget.fetchAccount,
                  event: _event,
                  fetchEvent: ()=>{_fetchEventDetails(_event!.id)},
                ),
              ),
            );
          },
        );
      },
    ): Padding(padding:  const EdgeInsets.all(20),
      child: Text(trans.needToJoin),
    );
  }

  JoinEvent getCandidateByUser() {
    CandidateEvent? candi;
    bool isjoin = false;
    try {
      candi = _event!.event_candidate.firstWhere(
        (candidate) => candidate.user == _account!.id,
      );
    } catch (e) {
      candi = null;
    }
    // print(candi);
    if (candi != null && candi.active_status == 1) {
      isjoin = true;
    }
    JoinEvent join = JoinEvent(isJoin: isjoin, candidate: candi);
    return join;
  }

  Future<void> unFollow(int id) async {
    try {
      final account = await unfollowUser(id);

      if (widget.fetchAccount != null) {
        widget.fetchAccount!();
      }
      if (account != null) {
        setState(() {
          _account = account;
        });
      }
    } catch (e) {
      print('Error unfollowing: $e');
    }
  }

  Future<void> followUserByUserId(int id) async {
    try {
      final account = await followUser(id);
      if (widget.fetchAccount != null) {
        widget.fetchAccount!();
      }
      if (account != null) {
        setState(() {
          _account = account;
        });
      }
    } catch (e) {
      print('Error following: $e');
    }
  }
}

class JoinEvent {
  bool isJoin;
  CandidateEvent? candidate;
  JoinEvent({required this.isJoin, this.candidate});
}
