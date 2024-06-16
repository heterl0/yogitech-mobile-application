import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/services/api_service.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:yogi_application/src/pages/blog_detail.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  BlogState createState() => BlogState();

  static fromJson(item) {}

  static fromMap(x) {}

  toMap() {}
}

class BlogState extends State<Blog> {
  late Future<Blog> blogs;
  bool _isNotSearching = true;
  TextEditingController _searchController = TextEditingController();
  List<Blog> _blogs = [];

  @override
  void initState() {
    super.initState();
    _fetchBlogs(); // Gọi hàm fetchBlogs khi trạng thái của widget được khởi tạo
  }

  Future<void> _fetchBlogs() async {
    ApiService apiService = ApiService();
    try {
      // List<Blog> blogs =
      //     await apiService.fetchBlogs(); // Gọi hàm fetchBlogs từ service
      setState(() {
        // _blogs = blogs;
      });
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _isNotSearching
          ? CustomAppBar(
              showBackButton: false,
              title: 'Blog',
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.search, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = false;
                    });
                  },
                ),
              ],
            )
          : CustomAppBar(
              onBackPressed: () {
                // Xử lý khi nút back được nhấn

                setState(() {
                  _isNotSearching = true;
                });
              },
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: 'Search...',
                trailing: Icon(Icons.search),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onTap: () {
                  // Xử lý khi input field được nhấn
                },
              ),
              postActions: [
                IconButton(
                  icon:
                      Icon(Icons.close, color: theme.colorScheme.onBackground),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = true;
                    });
                  },
                ),
              ],
            ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildDefaultAppBar() {
    return const Text('');
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        right: 24.0,
        left: 24.0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () {
              setState(() {
                _isNotSearching = false;
                _searchController.clear();
              });
            },
          ),
          Expanded(
            child: BoxInputField(
              controller: _searchController,
              placeholder: 'Search...',
              leading: null,
              trailing: Icon(
                Icons.search,
              ),

              // Handle the send button press

              keyboardType: TextInputType.text,
              inputFormatters: [],
              onTap: () {
                // Handle tap on input field
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () {
              setState(() {
                _isNotSearching = false;
                _searchController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: _buildBlogMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogMainContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: _blogs.length,
        itemBuilder: (context, index) {
          final title = 'title';
          final caption = 'Caption ${index + 1}';
          final subtitle = '${5 - index} days left';

          return CustomCard(
            title: title,
            caption: caption,
            subtitle: subtitle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetail(
                    title: title,
                    caption: caption,
                    subtitle: subtitle,
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
