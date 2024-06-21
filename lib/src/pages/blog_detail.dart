import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/api/blog/blog_service.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/src/models/blog.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import "package:yogi_application/src/shared/styles.dart";
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BlogDetail extends StatefulWidget {
  final int id;

  const BlogDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  late Blog? blog; // 0: không có ý kiến, 1: like, 2: dislike
  late int? userId;
  late bool isLoading = false;
  late BlogVote? blogVote = null;

  @override
  void initState() {
    super.initState();
    fetchBlog();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        postActions: [_buildDislikeButton(), _buildLikeButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBody(context),
    );
  }

  Future fetchBlog() async {
    setState(() {
      isLoading = true;
    });
    final Blog? blog = await getBlog(widget.id);
    final Account? account = await retrieveAccount();
    setState(() {
      this.blog = blog;
      this.userId = account?.id;
      isLoading = false;
    });

    if (blog != null) {
      setState(() {
        blogVote = blog.getUserVote(account?.id ?? -1);
      });
    }
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildImage(),
            _buildMainContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    final theme = Theme.of(context);

    if (blogVote == null) {
      return IconButton(
        icon: Icon(
          Icons.thumb_up_outlined,
          color: theme.colorScheme.onBackground,
        ),
        onPressed: () async {
          // Khi người dùng nhấn like, cập nhật userFeedback và gọi setState để rebuild UI
          final BlogVote? blogVote = await voteBlog(widget.id, 1);
          setState(() {
            this.blogVote = blogVote;
          });
        },
      );
    }
    if (blogVote?.vote_value == -1) {
      return IconButton(
        icon: Icon(
          Icons.thumb_up_outlined,
          color: theme.colorScheme.onBackground,
        ),
        onPressed: () async {
          final BlogVote? blogVote = await updateVoteBlog(this.blogVote!.id, 1);
          setState(() {
            this.blogVote = blogVote;
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.thumb_up_rounded,
          color: primary,
        ),
        onPressed: () async {
          final bool? result = await removeVoteBlog(this.blogVote!.id);
          if (result == true) {
            setState(() {
              this.blogVote = null;
            });
          }
        },
      );
    }
  }

  Widget _buildDislikeButton() {
    final theme = Theme.of(context);
    if (blogVote == null) {
      return IconButton(
        icon: Icon(
          Icons.thumb_down_outlined,
          color: theme.colorScheme.onBackground,
        ),
        onPressed: () async {
          // Khi người dùng nhấn dislike, cập nhật userFeedback và gọi setState để rebuild UI
          final BlogVote? blogVote = await voteBlog(widget.id, -1);
          setState(() {
            this.blogVote = blogVote;
          });
        },
      );
    }
    if (blogVote?.vote_value == 1) {
      return IconButton(
        icon: Icon(
          Icons.thumb_down_outlined,
          color: theme.colorScheme.onBackground,
        ),
        onPressed: () async {
          final BlogVote? blogVote =
              await updateVoteBlog(this.blogVote!.id, -1);
          setState(() {
            this.blogVote = blogVote;
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.thumb_down_alt_rounded,
          color: error,
        ),
        onPressed: () async {
          final bool? result = await removeVoteBlog(this.blogVote!.id);
          if (result == true) {
            setState(() {
              this.blogVote = null;
            });
          }
        },
      );
    }
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: double.infinity,
        height: 360,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(blog?.image_url ?? ''),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildSubtitle(),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    // return Text(
    //   widget.subtitle,
    //   style: min_cap.copyWith(color: text),
    //   textAlign: TextAlign.left,
    // );
    return HtmlWidget(
      blog?.content ?? '',
      textStyle: TextStyle(fontFamily: 'ReadexPro', fontSize: 16, height: 1.2),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        child: Column(
          children: [
            Text(
              blog?.title ?? '',
              style:
                  h2.copyWith(color: theme.colorScheme.onPrimary, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    // return Text(
    //   widget.caption,
    //   style: min_cap.copyWith(color: text),
    //   textAlign: TextAlign.left,
    // );
    return HtmlWidget(
      blog?.description ?? '',
      textStyle: TextStyle(fontFamily: 'ReadexPro', fontSize: 20, height: 1.2),
    );
  }
}
