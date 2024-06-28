import 'package:YogiTech/src/pages/camera/camera_page.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
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
  final Exercise? exercise;

  const ExerciseDetail({super.key, this.exercise});

  @override
  _ExerciseDetailState createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  late Exercise? _exercise;
  late bool _isLoading = false;
  late int user_id = -1;
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: trans.exerciseDetail,
        style: widthStyle.Large,
      ),
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? Container(
              color: theme.colorScheme.surface,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _buildBody(context),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: trans.doExercise,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                // builder: (context) => Result(),
                builder: (context) => CameraPage()),
          );
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
    final user = await retrieveAccount();
    setState(() {
      _exercise = exercise;
      _isLoading = false;
      user_id = user!.id;
    });
  }

  Widget _buildBody(BuildContext context) {
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
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        width: double.infinity,
        height: 360,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:CachedNetworkImageProvider(_exercise!.image_url), // ! for null safety
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final trans = AppLocalizations.of(context)!;

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
          _buildTitle2(context, trans.comment),
          const SizedBox(height: 16),
          _buildCommentSection(trans),
          const SizedBox(height: 16),
          ..._exercise!.comments.map(
            (comment) => _buildComment(context, comment),
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
          '$minute ${trans.minutes}',
          style: bd_text.copyWith(color: text),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            level == 1
                ? trans.beginner
                : level == 2
                    ? trans.advance
                    : trans.professional,
            style: bd_text.copyWith(color: primary),
          ),
        ),
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
                  child: 
                  CachedNetworkImage(
                    imageUrl: pose.image_url,
                    height: 240, // Chiều cao cố định của ảnh
                    width: double.infinity, // Đảm bảo ảnh chiếm toàn bộ chiều ngang
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pose.name,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${trans.duration}: ${pose.duration}',
                      style: bd_text.copyWith(color: primary),
                    ),
                    Text(
                      '${trans.level}: ${pose.level}',
                      style: bd_text.copyWith(color: primary),
                    ),
                    Text(
                      '${trans.calorie}: ${pose.calories}',
                      style: bd_text.copyWith(color: primary),
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
                      color: primary,
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
            controller: commentController,
            placeholder: trans.yourComment,
            onSubmitted: (value) async {
              await postAComment();
            },
          ),
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

  Widget _buildComment(BuildContext context, Comment comment) {
    bool isLike = comment.hasUserVoted(user_id);
    Locale locale = Localizations.localeOf(context);
    final name = comment.user.profile.first_name != null
        ? "${comment.user.profile.last_name} ${comment.user.profile.first_name}"
        : comment.user.username;
    final theme = Theme.of(context);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image:(comment.user.profile.avatar_url!=null && comment.user.profile.avatar_url!='')? CachedNetworkImageProvider(comment.user.profile.avatar_url.toString()):AssetImage('assets/images/gradient.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  // gradient: gradient,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            textAlign: TextAlign.start,
                            style: min_cap.copyWith(color: primary),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            formatDateTime(
                                comment.created_at, locale.languageCode),
                            textAlign: TextAlign.end,
                            style: min_cap.copyWith(color: text),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      comment.text,
                      style:
                          bd_text.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
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
                icon: isLike
                    ? const Icon(
                        Icons.favorite,
                        color: primary,
                      )
                    : const Icon(
                        Icons.favorite_border_outlined,
                        color: text,
                      ),
              ),
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
      });
    } else {
      print('Failed to post comment');
    }
    // await postComment(request);
  }
}
