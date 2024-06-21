import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/pages/friend_profile.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yogi_application/api/account/account_service.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';

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
  List<Account> accountList = [];
  List<Account> searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _fetchAccounts(); // Gọi hàm fetchAccounts khi trạng thái của widget được khởi tạo
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
              title: trans.friends,
              postActions: [
                IconButton(
                  icon: Icon(Icons.group_add,
                      color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = false;
                      _isSearching = true;
                    });
                  },
                ),
              ],
            )
          : CustomAppBar(
              showBackButton: false,
              onBackPressed: () {
                setState(() {
                  _isNotSearching = true;
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: trans.search,
                trailing:
                    Icon(Icons.search, color: theme.colorScheme.onBackground),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onChanged: (value) {
                  _fetchAccounts();
                },
                onTap: () {},
              ),
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.close, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    _searchController.clear();
                    _fetchAccounts(); // Fetch all friends again
                    setState(() {
                      _isNotSearching = true;
                      _isSearching = false;
                    });
                  },
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
                color: primary, // Màu sắc của đường gạch chân tab được chọn
                width: 2.0, // Độ dày của đường gạch chân tab được chọn
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
                accounts: accountList,
              ),
              FriendList(
                accounts: accountList,
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
                name: searchResults[index].username,
                avatarUrl: searchResults[index].profile.avatar_url ?? '',
                exp: searchResults[index].profile.exp.toString(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FriendProfile(id: searchResults[index].id),
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
  final List<Account> accounts;

  const FriendList({
    Key? key,
    required this.accounts,
  }) : super(key: key);

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
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return FriendListItem(
                name: accounts[index].username,
                avatarUrl: accounts[index].profile.avatar_url ?? '',
                exp: accounts[index].profile.exp.toString(),
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
        margin: EdgeInsets.only(bottom: 12), // Thay đổi từ 8 thành 12
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minHeight: 80),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Canh chỉnh theo trục chính của Row
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stroke, // Màu nền của Avatar placeholder
              ),
              child: CircleAvatar(
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              ),
            ),
            SizedBox(width: 12), // Thêm khoảng cách giữa Avatar và nội dung

            // Sử dụng một Column để hiển thị tên và EXP
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: h3.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                  SizedBox(height: 4), // Thêm khoảng cách giữa tên và EXP
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
