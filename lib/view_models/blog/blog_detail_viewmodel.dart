import 'dart:async';
import 'package:flutter/material.dart';
import 'package:YogiTech/models/blog.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/services/blog/blog_service.dart';
import 'package:YogiTech/services/auth/auth_service.dart';

class BlogDetailViewModel extends ChangeNotifier {
  Blog? blog;
  BlogVote? blogVote;
  int? userId;
  bool isLoading = false;
  int likeCount = 0;
  int dislikeCount = 0;

  Future<void> fetchBlog(int blogId) async {
    isLoading = true;
    notifyListeners();

    final Blog? fetchedBlog = await getBlog(blogId);
    final Account? account = await retrieveAccount();

    if (fetchedBlog != null) {
      userId = account?.id;
      blog = fetchedBlog;
      likeCount = fetchedBlog.votes.where((v) => v.vote_value == 1).length;
      dislikeCount = fetchedBlog.votes.where((v) => v.vote_value == -1).length;
      blogVote = blog?.getUserVote(account?.id ?? -1);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> vote(int blogId, int voteValue) async {
    if (blogVote == null) {
      blogVote = await voteBlog(blogId, voteValue);
    } else {
      blogVote = await updateVoteBlog(blogVote!.id, voteValue);
    }
    _updateVoteCount();
  }

  Future<void> removeVote() async {
    if (blogVote != null) {
      final bool? result = await removeVoteBlog(blogVote!.id);
      if (result == true) {
        blogVote = null;
        _updateVoteCount();
      }
    }
  }

  void _updateVoteCount() {
    likeCount = blog!.votes.where((v) => v.vote_value == 1).length;
    dislikeCount = blog!.votes.where((v) => v.vote_value == -1).length;
    notifyListeners();
  }
}
