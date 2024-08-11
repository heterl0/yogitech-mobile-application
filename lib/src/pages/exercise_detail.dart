import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/event.dart';
import 'package:YogiTech/src/shared/premium_dialog.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:YogiTech/utils/method_channel_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/models/exercise.dart';
import 'package:YogiTech/src/models/pose.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/utils/formatting.dart';

class ExerciseDetail extends StatefulWidget {
  final Account? account;
  final VoidCallback? fetchAccount;
  final Exercise? exercise;
  final Event? event;
  final VoidCallback? fetchEvent;

  const ExerciseDetail(
      {super.key,
      this.exercise,
      this.account,
      this.fetchAccount,
      this.event,
      this.fetchEvent});

  @override
  _ExerciseDetailState createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  late Exercise? _exercise;
  late Account? _account;

  late bool _isLoading = false;
  late int user_id = -1;
  final TextEditingController commentController = TextEditingController();

  List<ExtendComment> exComments = [];
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: trans.exerciseDetail,
        style: widthStyle.Large,
        postActions: [
          SizedBox(
            width: 48,
            height: 28,
            child: _exercise!.is_premium
                ? (!(_account?.is_premium ?? false))
                    ? Image.asset('assets/images/Crown.png')
                    : Image.asset('assets/images/Crown2.png')
                : null,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? Container(
              color: theme.colorScheme.surface,
              child: Center(
                child: CircularProgressIndicator(
                  color:
                      (!(_account?.is_premium ?? false)) ? primary : primary2,
                ),
              ),
            )
          : _buildBody(context),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.doExercise,
        onPressed: () async {
          bool? isPremium = _account?.is_premium ?? false;

          if (_account != null && (isPremium || !_exercise!.is_premium)) {
            if (widget.event != null) {
              await storeExercise(_exercise!, widget.event!.id);
            } else {
              await storeExercise(_exercise!, null);
            }
            const platform = MethodChannel('com.example.yogitech');
            final methodChannel = MethodChannelHandler(
                account: _account,
                fetchAccount: widget.fetchAccount,
                fetchEvent: widget.fetchEvent ?? () {});
            methodChannel.context = context;
            await platform.invokeMethod('exerciseActivity');

            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //       content: Text(
            //           'You do not have access to this exercise. Upgrade to premium to access.')),
            // );
          } else {
            showPremiumDialog(context, _account!, widget.fetchAccount);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchExercise();
  }

  Future<void> fetchExercise() async {
    setState(() {
      _isLoading = true;
    });

    final exercise = widget.exercise;
    _account = widget.account;
    setState(() {
      _exercise = exercise;
      user_id = _account!.id;
      exComments = makeExtentComment(_exercise!.comments);
      _isLoading = false;
    });
  }

  Widget _buildBody(BuildContext context) {
    print('Bài tập có trả phí hay không? ${_exercise?.is_premium}');
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImage(context),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 90),
        child: AspectRatio(
          aspectRatio:
              (_exercise!.image_url == null || _exercise!.image_url!.isEmpty)
                  ? 16 / 1
                  : 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  _exercise!.image_url ??
                      "", // Thay thế URL mặc định nếu _exercise!.image_url null
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }

  Widget _buildMainContent(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    print('id bài tập ${_exercise!.id}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildRowWithText(trans, context),
          const SizedBox(height: 16),
          _buildDescription(context),
          const SizedBox(height: 16),
          _buildTitle2(context, trans.poses),
          const SizedBox(height: 16),
          _buildPoses(trans, context),
          const SizedBox(height: 16),
          if (_exercise!.image_url != null && _exercise!.image_url!.isNotEmpty)
            _buildTitle2(context, trans.comment),
          const SizedBox(height: 16),
          if (_exercise!.image_url != null && _exercise!.image_url!.isNotEmpty)
            _buildCommentSection(trans),
          const SizedBox(height: 16),
          ...exComments.map(
            (comment) => comment.comment.active_status == 1
                ? _buildComment(context, comment, _account!)
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle2(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: h3.copyWith(color: theme.colorScheme.onPrimary),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      _exercise?.title ?? "Ringo Island",
      style: h2.copyWith(color: theme.colorScheme.onPrimary, height: 1.2),
    );
  }

  Widget _buildRowWithText(AppLocalizations trans, BuildContext context) {
    final durations = _exercise?.durations ?? 0;
    final minute = durations ~/ 60;
    final int level = _exercise?.level ?? 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${trans.duration}: ',
          style: bd_text.copyWith(color: text),
        ),
        Text(
          '$minute ${trans.minutes}',
          style: bd_text.copyWith(
            color: _exercise!.is_premium ? primary2 : primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: Row(
          children: [
            Text(
              '${trans.level}: ',
              style: bd_text.copyWith(color: text),
            ),
            Text(
              level == 1
                  ? trans.beginner
                  : (level == 2 ? trans.intermediate : trans.advanced),
              style: bd_text.copyWith(
                color: _exercise!.is_premium ? primary2 : primary,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return HtmlWidget(
      _exercise?.description ??
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      textStyle: TextStyle(fontFamily: 'ReadexPro', fontSize: 16, height: 1.2),
    );
  }

  Widget _buildPoses(AppLocalizations trans, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 8 / 9,
      ),
      itemCount: _exercise?.poses.length ?? 0,
      itemBuilder: (context, index) {
        final PoseWithTime pose = _exercise!.poses[index];
        final Pose poseDetail = pose.pose;
        final title = poseDetail.name;
        // final title = trans.pose + ' ${index + 1}';
        final subtitle = '${pose.duration} ${trans.seconds}';

        return CustomCard(
          title: title,
          subtitle: subtitle,
          imageUrl: poseDetail.image_url,
          onTap: () {
            showDetailDialog(context, poseDetail);
          },
          premium: _account?.is_premium ?? false,
        );
      },
    );
  }

  void showDetailDialog(BuildContext context, Pose pose) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: appElevation,
          backgroundColor: theme.colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: pose.image_url,
                    height: 240, // Chiều cao cố định của ảnh
                    width: double
                        .infinity, // Đảm bảo ảnh chiếm toàn bộ chiều ngang
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                      color: (!(_account?.is_premium ?? false))
                          ? primary
                          : primary2,
                    )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pose.name,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: [
                    Text(
                      '${trans.duration}: ${pose.duration} ${trans.seconds}.',
                      style: bd_text.copyWith(
                        color: _exercise!.is_premium ? primary2 : primary,
                      ),
                    ),
                    Text(
                      '${trans.burned}: ${pose.calories} ${trans.calorie}.',
                      style: bd_text.copyWith(
                        color: _exercise!.is_premium ? primary2 : primary,
                      ),
                    ),
                    Text(
                      '${trans.level}: ${pose.level == 1 ? trans.beginner : (pose.level == 2 ? trans.intermediate : trans.advanced)}.',
                      style: bd_text.copyWith(
                        color: _exercise!.is_premium ? primary2 : primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(trans.supMuscle, style: bd_text.copyWith(color: text)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: pose.muscles.map((muscle) {
                    return Material(
                      elevation: appElevation,
                      borderRadius: BorderRadius.circular(20.0),
                      color: _exercise!.is_premium ? primary2 : primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          muscle.name,
                          style: min_cap.copyWith(
                            color: active,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180, // height limit for the instruction text
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          pose.instruction,
                          style: bd_text.copyWith(
                              color: theme.colorScheme.onPrimary),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 20, // adjust the height of the fade effect
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                theme.colorScheme.onSecondary.withOpacity(0.0),
                                theme.colorScheme.onSecondary.withOpacity(0.5),
                                theme.colorScheme.onSecondary,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  title: trans.close,
                  style: ButtonStyleType.Tertiary,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentSection(AppLocalizations trans) {
    return Row(
      children: [
        Expanded(
          child: BoxInputField(
              controller: commentController, placeholder: trans.yourComment),
        ),
        IconButton(
          onPressed: () async {
            await postAComment();
          },
          icon: const Icon(
            Icons.send_outlined,
            size: 36,
            color: text,
          ),
        ),
      ],
    );
  }

  Widget _buildComment(
    BuildContext context,
    ExtendComment exComment,
    Account _account,
  ) {
    Comment comment = exComment.comment;
    bool isLike = comment.hasUserVoted(user_id);
    Locale locale = Localizations.localeOf(context);
    final name = comment.user.profile.first_name != null
        ? "${comment.user.profile.last_name} ${comment.user.profile.first_name}"
        : comment.user.username;
    final theme = Theme.of(context);
    List<Comment> repComment = exComment.replies;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: stroke),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(
                          4.0), // Adjust the value as needed
                      child: (comment.user.profile.avatar_url != null &&
                              comment.user.profile.avatar_url != '')
                          ? Container(
                              width: 52,
                              height: 52,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      comment.user.profile.avatar_url ?? ''),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                            )
                          : Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: _exercise!.is_premium
                                      ? primary2
                                      : primary,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  comment.user.username != ''
                                      ? comment.user.username[0].toUpperCase()
                                      : ':)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _exercise!.is_premium
                                        ? primary2
                                        : primary,
                                  ),
                                ),
                              ),
                            )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              textAlign: TextAlign.start,
                              style: min_cap.copyWith(
                                color:
                                    _exercise!.is_premium ? primary2 : primary,
                              ),
                            ),
                            Text(
                              formatDateTime(
                                  comment.created_at, locale.languageCode),
                              textAlign: TextAlign.end,
                              style: min_cap.copyWith(color: text),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0), // Adjust the value as needed
                              child: Text(
                                comment.text,
                                style: bd_text.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (isLike) {
                                      Vote? vote = comment.getUserVote(user_id);
                                      if (vote != null) {
                                        await deleteVote(vote.id);
                                        setState(() {
                                          comment.votes.remove(vote);
                                          isLike = false;
                                        });
                                      }
                                    } else {
                                      Vote? vote = await postVote(comment.id);
                                      setState(() {
                                        isLike = vote != null;
                                        comment.votes.add(vote!);
                                      });
                                    }
                                  },
                                  iconSize: 24,
                                  icon: isLike
                                      ? Icon(
                                          Icons.favorite,
                                          color:
                                              (!(_account.is_premium ?? false))
                                                  ? primary
                                                  : primary2,
                                        )
                                      : const Icon(
                                          Icons.favorite_border_outlined,
                                          color: text,
                                        ),
                                ),
                                Text(
                                  '${comment.votes.length} vote',
                                  textAlign: TextAlign.end,
                                  style: min_cap.copyWith(color: text),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Nếu có parent_comment, hiển thị reply của admin bên dưới
              repComment.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: stroke,
                        ),
                        ...repComment.map((comment) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Admin', // Replace with dynamic data based on repComment[index]
                                        style: min_cap.copyWith(
                                          color: _exercise!.is_premium
                                              ? primary2
                                              : primary,
                                        ),
                                      ),
                                      Text(
                                        formatDateTime(
                                            comment.created_at,
                                            locale
                                                .languageCode), // Replace with dynamic data based on repComment[index]
                                        textAlign: TextAlign.end,
                                        style: min_cap.copyWith(color: text),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    comment
                                        .text, // Replace with dynamic data based on repComment[index]
                                    style: bd_text.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }

  Future<void> postAComment() async {
    final text = commentController.text;
    final exercise = _exercise;
    if (text.isEmpty) {
      return;
    } else if (exercise == null) {
      return;
    }
    final request = PostCommentRequest(text: text, exercise: exercise.id);
    final comment = await postComment(request);
    if (comment != null) {
      commentController.clear();
      setState(() {
        _exercise!.comments.add(comment);
        fetchExercise();
      });
    } else {
      print('Failed to post comment');
    }
    // await postComment(request);
  }

  List<ExtendComment> makeExtentComment(List<Comment> comments) {
    Map<int, ExtendComment> extendMap = {};

    for (var comment in comments) {
      if (comment.parent_comment == null) {
        extendMap[comment.id] =
            ExtendComment(id: comment.id, comment: comment, replies: []);
      } else {
        if (extendMap.containsKey(comment.parent_comment!)) {
          extendMap[comment.parent_comment!]!.addReply(comment);
        }
      }
    }
    return extendMap.values.toList();
  }
}

class ExtendComment {
  int id;
  Comment comment;
  List<Comment> replies;

  ExtendComment({
    required this.id,
    required this.comment,
    List<Comment>? replies,
  }) : replies = replies ?? [];

  void addReply(Comment reply) {
    replies.add(reply);
  }
}
