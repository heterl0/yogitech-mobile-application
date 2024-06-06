import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:yogi_application/src/pages/blog_detail.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  BlogState createState() => BlogState();
}

class BlogState extends State<Blog> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isSearching ? 100 : 100),
        // Increase height when searching
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            title: _isSearching ? _buildSearchBar() : _buildDefaultAppBar(),
            bottom: _isSearching
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        right: 24.0,
                        left: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Blog',
                              style: h2.copyWith(
                                  color: theme.colorScheme.onBackground),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search,
                                color: theme.colorScheme.onBackground),
                            onPressed: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildDefaultAppBar() {
    return const Text('');
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: Image.asset('assets/icons/tune.png'),
            onPressed: () {
              // Handle filter button press
            },
          ),
          Expanded(
            child: Container(
              height: 44,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(44.0),
                    borderSide: const BorderSide(color: Color(0xFF8D8E99)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: IconButton(
                    icon: Image.asset('assets/icons/search.png'),
                    onPressed: () {
                      // Handle the send button press
                    },
                  ),
                ),
                cursorColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Image.asset('assets/icons/close.png'),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0A141C)),
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final title = 'Event ${index + 1}';
          final caption = 'Caption ${index + 1}';
          final subtitle = '${5 - index} days left';

          return GestureDetector(
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
            child: CustomCard(
              title: title,
              caption: caption,
              subtitle: subtitle,
            ),
          );
        },
      ),
    );
  }
}
