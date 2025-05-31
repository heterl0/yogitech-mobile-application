import 'dart:async';

import 'package:ZenAiYoga/services/auth/auth_service.dart';
import 'package:ZenAiYoga/services/blog/blog_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ZenAiYoga/models/account.dart';
import 'package:ZenAiYoga/models/blog.dart';
import 'package:ZenAiYoga/shared/app_colors.dart';
import "package:ZenAiYoga/shared/styles.dart";
import 'package:ZenAiYoga/custombar/appbar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BlogDetail extends StatefulWidget {
  final int id;

  const BlogDetail({
    super.key,
    required this.id,
  });

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  late Blog? blog; // 0: không có ý kiến, 1: like, 2: dislike
  late int? userId;
  late bool isLoading = false;
  late BlogVote? blogVote = null;

  late int _like = 0;
  late int _disLike = 0;

  @override
  void initState() {
    super.initState();
    fetchBlog();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        style: WidthStyle.small,
        postActions: [_buildDislikeButton(_disLike), _buildLikeButton(_like)],
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
      userId = account?.id;
      isLoading = false;

      if (blog != null) {
        _like = 0;
        _disLike = 0;
        for (var i = 0; i < blog.votes.length; i++) {
          BlogVote vote = blog.votes[i];
          if (vote.vote_value == 1) {
            _like++;
          } else {
            _disLike++;
          }
        }
        blogVote = blog.getUserVote(account?.id ?? -1);
      }
    });
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImage(),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildLikeButton(int likeCount) {
    final theme = Theme.of(context);

    if (blogVote == null) {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_up_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              // Khi người dùng nhấn like, cập nhật userFeedback và gọi setState để rebuild UI
              final BlogVote? blogVote = await voteBlog(widget.id, 1);
              setState(() {
                checkBlogVote(blogVote);
                this.blogVote = blogVote;

                print(blogVote);
              });
            },
          ),
          Text(
            '$_like',
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      );
    }

    if (blogVote?.vote_value == -1) {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_up_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              final BlogVote? blogVote =
                  await updateVoteBlog(this.blogVote!.id, 1);
              setState(() {
                checkBlogVote(blogVote);
                this.blogVote = blogVote;
              });
            },
          ),
          Text(
            '$likeCount',
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_up_rounded,
              color: primary,
            ),
            onPressed: () async {
              final bool? result = await removeVoteBlog(blogVote!.id);
              if (result == true) {
                setState(() {
                  checkBlogVote(blogVote);
                  blogVote = null;
                });
              }
            },
          ),
          Text(
            '$likeCount',
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      );
    }
  }

  Widget _buildDislikeButton(int dislikeCount) {
    final theme = Theme.of(context);

    if (blogVote == null) {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_down_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              // Khi người dùng nhấn dislike, cập nhật userFeedback và gọi setState để rebuild UI
              final BlogVote? blogVote = await voteBlog(widget.id, -1);
              setState(() {
                checkBlogVote(blogVote);
                this.blogVote = blogVote;
              });
            },
          ),
          Text(
            '$dislikeCount',
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      );
    }
    if (blogVote?.vote_value == 1) {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_down_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () async {
              final BlogVote? blogVote =
                  await updateVoteBlog(this.blogVote!.id, -1);
              setState(() {
                checkBlogVote(blogVote);
                this.blogVote = blogVote;
              });
            },
          ),
          Text(
            '$dislikeCount',
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.thumb_down_alt_rounded,
              color: error,
            ),
            onPressed: () async {
              final bool? result = await removeVoteBlog(blogVote!.id);
              if (result == true) {
                setState(() {
                  checkBlogVote(blogVote);
                  blogVote = null;
                });
              }
            },
          ),
          Text(
            '$dislikeCount',
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      );
    }
  }

  Widget _buildImage() {
    print('id bài blog ${blog?.id}');
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(blog?.image_url ?? ''),
              fit: BoxFit.cover,
            ),
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
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
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
    return HtmlWidget(
      blog?.description ?? '',
      textStyle: TextStyle(
        fontFamily: 'ReadexPro',
        fontSize: 18,
        height: 1.2,
      ),
    );
  }

  int checkBlogVote(BlogVote? myVote) {
    if (blogVote != null && myVote!.vote_value != 0) {
      _like = _like + myVote.vote_value;
      _disLike = _disLike - myVote.vote_value;
    } else {
      myVote!.vote_value == 1 ? _like++ : _disLike++;
    }
    return 0;
  }
}
