import 'package:flutter/material.dart';
import 'package:yogi_application/api/blog/blog_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:yogi_application/src/pages/blog_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  BlogState createState() => BlogState();

  static fromJson(item) {}

  static fromMap(x) {}

  toMap() {}
}

class BlogState extends State<Blog> {
  List<dynamic> jsonList = [];
  bool _isNotSearching = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBlogs(); // Gọi hàm fetchBlogs khi trạng thái của widget được khởi tạo
  }

  Future<void> _fetchBlogs() async {
    // Gọi API để lấy danh sách bài tập
    // Đảm bảo rằng phương thức getListExercises đã được định nghĩa trong lớp ApiService
    final List<dynamic> blog = await getBlogs();
    print(blog);
    // Cập nhật trạng thái với danh sách bài tập mới nhận được từ API
    setState(() {
      jsonList = blog;
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
                setState(() {
                  _isNotSearching = true;
                });
              },
              style: widthStyle.Large,
              titleWidget: BoxInputField(
                controller: _searchController,
                placeholder: trans.search,
                trailing: const Icon(Icons.search),
                keyboardType: TextInputType.text,
                inputFormatters: [],
                onTap: () {},
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
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
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
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 4 / 5,
        ),
        itemCount: jsonList!.length,
        itemBuilder: (context, index) {
          return CustomCard(
            title: jsonList!.elementAt(index).title,
            caption: jsonList!.elementAt(index).description,
            imageUrl: jsonList!.elementAt(index).image_url,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetail(
                    title: jsonList!.elementAt(index).title,
                    caption: jsonList!.elementAt(index).description,
                    subtitle: jsonList!.elementAt(index).content,
                    imageUrl: jsonList!.elementAt(index).image_url,
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
