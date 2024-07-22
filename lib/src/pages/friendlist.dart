import 'package:YogiTech/api/social/social_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/social.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/pages/friend_profile.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FriendListPage extends StatefulWidget {
  final int initialTabIndex;
  final VoidCallback? onProfileUpdated;
  late Account? account;
  FriendListPage(
      {super.key,
      required this.initialTabIndex,
      this.onProfileUpdated,
      this.account});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isNotSearching = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late List<dynamic> _following;
  late List<dynamic> _followers;
  late bool _isLoading;

  // Sample data for the friend list
  List<String> friends = List.generate(20, (index) => 'Friend Name $index');
  List<String> filteredFriends = [];

  // Sample data for search results (new friends)
  List<String> newFriends = List.generate(20, (index) => 'New Friend $index');
  late List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    filteredFriends = friends; // Initially display all friends
    _fetchFollower();
  }

  Future<void> _fetchFollower() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedFollowing = await getFollowing();
      final fetchedFollowers = await getFollowers();
      setState(() {
        _following = fetchedFollowing;
        _followers = fetchedFollowers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching friends: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> unFollow(int id) async {
    try {
      final account = await unfollowUser(id);

      _following.removeWhere((element) => element.id == id);
      setState(() {
        _following = _following;
      });
      if (widget.onProfileUpdated != null) {
        widget.onProfileUpdated!();
      }
      if (account != null) {
        setState(() {
          widget.account = account;
        });
      }
    } catch (e) {
      print('Error unfollowing: $e');
    }
  }

  Future<void> followUserByUserId(int id) async {
    try {
      final account = await followUser(id);
      if (widget.onProfileUpdated != null) {
        widget.onProfileUpdated!();
      }
      _fetchFollower();
      if (account != null) {
        setState(() {
          widget.account = account;
        });
      }
    } catch (e) {
      print('Error following: $e');
    }
  }

  // void _filterFriends(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       searchResults = [];
  //     } else {
  //       searchResults = newFriends
  //           .where(
  //               (friend) => friend.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //     }
  //   });
  // }

  void _startSearch() {
    setState(() {
      _isNotSearching = false;
      _isSearching = true;
    });
  }

  Future<void> _searchFriend() async {
    final result = await searchSocialProfile(_searchController.text);
    print(result);
    setState(() {
      searchResults = result;
    });
  }

  void _stopSearch() {
    setState(() {
      _isNotSearching = true;
      _isSearching = false;
      _searchController.clear();
      searchResults = [];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _isNotSearching
          ? CustomAppBar(
              style: widthStyle.Large,
              title: trans.friends,
              postActions: [
                IconButton(
                  icon: Icon(Icons.group_add_outlined,
                      color: theme.colorScheme.onSurface),
                  onPressed: _startSearch,
                ),
              ],
            )
          : CustomAppBar(
              showBackButton: false,
              onBackPressed: _stopSearch,
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: trans.search,
                trailing:
                    Icon(Icons.search, color: theme.colorScheme.onSurface),
                keyboardType: TextInputType.text,
                inputFormatters: const [],
                // onChanged: (value) {
                //   _filterFriends(value);
                // },
                // onTap: () {},
                onSubmitted: (value) async {
                  await _searchFriend();
                },
              ),
              postActions: [
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  onPressed: _stopSearch,
                ),
              ],
            ),
      body: _isSearching
          ? _buildSearchResults(context)
          : _buildFriendTabs(context, trans),
    );
  }

  Widget _buildFriendTabs(BuildContext context, AppLocalizations trans) {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: primary,
                width: 2.0,
              ),
            ),
          ),
          unselectedLabelColor: text,
          padding: EdgeInsets.only(left: 24, right: 24, top: 16),
          tabs: [
            Tab(
              child: Text(
                trans.following,
                style: h3,
              ),
            ),
            Tab(
              child: Text(
                trans.follower,
                style: h3,
              ),
            ),
          ],
        ),
        _isLoading
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FriendList(
                      friends: _following,
                      unFollow: unFollow,
                      followUserByUserId: followUserByUserId,
                      account: widget.account,
                      tab: 0,
                    ),
                    FriendList(
                      friends: _followers,
                      unFollow: unFollow,
                      followUserByUserId: followUserByUserId,
                      tab: 1,
                      account: widget.account,
                      // following: _following,
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: searchResults.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final SocialProfile friend = searchResults[index];
                      var isFollowing =
                          widget.account!.isFollowing(friend.user_id ?? -1);

                      final name = friend.first_name != null
                          ? '${friend.first_name} ${friend.last_name}'
                          : friend.username ?? 'N/A';
                      return FriendListItem(
                        name: name,
                        avatarUrl: friend.avatar ?? '',
                        exp: friend.exp.toString(),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendProfile(
                                profile: friend,
                                account: widget.account,
                                unFollow: unFollow,
                                followUserByUserId: followUserByUserId,
                              ),
                            ),
                          );
                        },
                        postIcon: isFollowing
                            ? IconButton(
                                icon: Icon(
                                  Icons.group_remove_outlined,
                                  color: error,
                                ),
                                onPressed: () async {
                                  await unFollow(friend.user_id ?? -1);
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.group_add_outlined,
                                  color: primary,
                                ),
                                onPressed: () async {
                                  await followUserByUserId(
                                      friend.user_id ?? -1);
                                  if (widget.onProfileUpdated != null) {
                                    widget.onProfileUpdated!();
                                  }
                                },
                              ),
                        // isFollowing: isFollowing,
                      );
                    },
                  ),
                ],
              )
            : searchResults.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                      trans.noResult,
                      style: bd_text.copyWith(color: text),
                    ),
                  )
                : Center(
                    child: Text(
                      trans.inputName,
                      style: bd_text.copyWith(color: text),
                    ),
                  ));
  }
}

class FriendList extends StatelessWidget {
  final int tab;
  final List<dynamic> friends;
  final Account? account;
  final List<dynamic>? following;
  final Function(int)? unFollow;
  final Function(int)? followUserByUserId;

  const FriendList({
    super.key,
    required this.friends,
    required this.tab,
    this.unFollow,
    this.following,
    this.account,
    this.followUserByUserId,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index] as Account;
              final name = friend.profile.first_name != null
                  ? '${friend.profile.first_name} ${friend.profile.last_name}'
                  : friend.username;

              final SocialProfile friendProfile = SocialProfile(
                avatar: friend.profile.avatar_url,
                exp: friend.profile.exp,
                username: friend.username,
                first_name: friend.profile.first_name,
                last_name: friend.profile.last_name,
                level: friend.profile.level,
                streak: friend.profile.streak,
                user_id: friend.id,
              );

              final bool isFollowing = following != null
                  ? following!.any((element) => element.id == friend.id)
                  : false;

              return FriendListItem(
                name: name,
                avatarUrl: friend.profile.avatar_url ?? '',
                exp: friend.profile.exp.toString(),
                onTap: () {
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendProfile(
                        profile: friendProfile,
                        account: account,
                        unFollow: unFollow,
                        followUserByUserId: followUserByUserId,
                      ),
                    ),
                  );
                },
                postIcon: tab == 0
                    ? IconButton(
                        icon: Icon(
                          Icons.group_remove_outlined,
                          color: error,
                        ),
                        onPressed: () async {
                          if (unFollow != null) {
                            await unFollow!(friend.id);
                          }
                        },
                      )
                    : null,
                isFollowing: isFollowing,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final String name;
  final String exp;
  final String avatarUrl;
  final VoidCallback onTap;
  final Widget? postIcon;
  final VoidCallback? onPressedIcon;
  final bool isFollowing;

  const FriendListItem({
    super.key,
    required this.name,
    required this.exp,
    required this.avatarUrl,
    required this.onTap,
    this.postIcon,
    this.onPressedIcon,
    this.isFollowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: avatarUrl != ''
                ? Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stroke,
                    ),
                    child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(avatarUrl)),
                  )
                : Container(
                    width: 60, // 2 * radius + 8 (border width) * 2
                    height: 60, // Matching the ratio as per Figma
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 78,
                      backgroundImage: AssetImage('assets/images/gradient.jpg'),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          name != '' ? name[0].toUpperCase() : ':)',
                          style: TextStyle(
                            fontSize: 36, // Adjust the size as needed
                            color: active,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$exp EXP',
                    style: min_cap.copyWith(color: text),
                  ),
                ],
              ),
            ),
          ),
          if (postIcon != null)
            IconButton(
              icon: postIcon!,
              onPressed: onPressedIcon,
            ),
          if (isFollowing)
            IconButton(
              icon: Icon(Icons.group_add_outlined, color: primary),
              onPressed: onPressedIcon,
            ),
        ],
      ),
    );
  }
}
