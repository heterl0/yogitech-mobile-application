import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/api/blog/blog_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/card.dart';
import 'package:YogiTech/src/pages/blog_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  BlogState createState() => BlogState();
}

class BlogState extends State<Blog> {
  List<dynamic> jsonList = [];
  bool _isNotSearching = true;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBlogs(); // Gọi hàm fetchBlogs khi trạng thái của widget được khởi tạo
  }

  Future<void> _fetchBlogs([String query = '']) async {
    setState(() {
      _isLoading = true;
    });
    final List<dynamic> blogs = await getBlogs();
    setState(() {
      if (query.isNotEmpty) {
        jsonList = blogs.where((blog) => blog.containsQuery(query)).toList();
      } else {
        jsonList = blogs;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _isNotSearching
          ? CustomAppBar(
              showBackButton: false,
              title: trans.blog,
              postActions: [
                IconButton(
                  icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
                  onPressed: () {
                    setState(() {
                      _isNotSearching = false;
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
                });
              },
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: trans.search,
                trailing:
                    Icon(Icons.search, color: theme.colorScheme.onSurface),
                keyboardType: TextInputType.text,
                inputFormatters: const [],
                onChanged: (value) {
                  _fetchBlogs(value);
                },
                onTap: () {},
              ),
              postActions: [
                IconButton(
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  onPressed: () {
                    _searchController.clear();
                    _fetchBlogs(); // Fetch all blogs again
                    setState(() {
                      _isNotSearching = true;
                    });
                  },
                ),
              ],
            ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: theme.colorScheme.surface),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBlogMainContent(),
                ],
              ),
            ),
          );
  }

  Widget _buildBlogMainContent() {
    final trans = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
      child: jsonList.length > 0
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 5,
              ),
              itemCount: jsonList.length,
              itemBuilder: (context, index) {
                final blog = jsonList.reversed.toList()[index];
                return CustomCard(
                  title: blog.title,
                  caption: blog.description,
                  imageUrl: blog.image_url,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetail(
                          id: blog.id,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text(
                trans.noResult,
                style: bd_text.copyWith(color: text),
              ),
            ),
    );
  }
}
