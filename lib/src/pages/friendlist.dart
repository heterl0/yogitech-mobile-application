import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/pages/friend_profile.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';

class FriendListPage extends StatefulWidget {
  final int initialTabIndex;
  const FriendListPage({super.key, required this.initialTabIndex});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isNotSearching = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Sample data for the friend list
  List<String> friends = List.generate(20, (index) => 'Friend Name $index');
  List<String> filteredFriends = [];

  // Sample data for search results (new friends)
  List<String> newFriends = List.generate(20, (index) => 'New Friend $index');
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    filteredFriends = friends; // Initially display all friends
  }

  void _filterFriends(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = newFriends
            .where(
                (friend) => friend.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _startSearch() {
    setState(() {
      _isNotSearching = false;
      _isSearching = true;
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

  Future<void> _fetchAccounts() async {
    final List<dynamic> accountsData = await getUserProfiles();
    final List<Account> accounts =
        accountsData.map<Account>((json) => Account.fromJson(json)).toList();
    setState(() {
      accountList = accounts;
    });
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
                  icon:
                      Icon(Icons.group_add, color: theme.colorScheme.onSurface),
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
                onChanged: (value) {
                  _filterFriends(value);
                },
                onTap: () {},
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
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              FriendList(
                friends: filteredFriends,
              ),
              FriendList(
                friends: filteredFriends,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return FriendListItem(
                name: searchResults[index],
                avatarUrl: 'assets/images/gradient.jpg',
                exp: '10000',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendProfile(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  final List<String> friends;

  const FriendList({
    super.key,
    required this.friends,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              return FriendListItem(
                name: friends[index],
                avatarUrl: 'assets/images/gradient.jpg',
                exp: '10000',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FriendProfile(id: accounts[index].id),
                    ),
                  );
                },
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

  const FriendListItem({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.onTap,
    required this.exp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minHeight: 80),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stroke,
              ),
              child: CircleAvatar(
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$exp EXP',
                    style: min_cap.copyWith(color: text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
