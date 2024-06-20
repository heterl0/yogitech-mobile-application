import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:yogi_application/api/exercise/exercise_service.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/models/exercise.dart';
import 'package:yogi_application/src/pages/result.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExerciseDetail extends StatefulWidget {
  final int? id;

  ExerciseDetail({Key? key, this.id}) : super(key: key);

  @override
  _ExerciseDetailState createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail> {
  late Exercise? _exercise;
  late bool _isLoading = false;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: trans.exerciseDetail,
        style: widthStyle.Large,
      ),
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Container(
              color: Colors.black54,
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
              builder: (context) => Result(),
            ),
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

    final exercise = await getExercise(widget.id ?? 0);
    setState(() {
      _exercise = exercise;
      _isLoading = false;
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
            image: NetworkImage(_exercise!.image_url), // ! for null safety
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
          _buildPoses(trans),
          const SizedBox(height: 16),
          _buildTitle2(context, trans.comment),
          const SizedBox(height: 16),
          _buildCommentSection(trans),
          const SizedBox(height: 16),
          _buildComment(context),
          const SizedBox(height: 36),
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
          '$minute ' + trans.minutes,
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

  Widget _buildPoses(AppLocalizations trans) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 5 / 4,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        final title = trans.pose + ' ${index + 1}';
        final subtitle = '${5 - index} ' + trans.minutes;

        return CustomCard(
          title: title,
          subtitle: subtitle,
          onTap: () {},
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
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.send_outlined,
            size: 36,
            color: text,
          ),
        ),
      ],
    );
  }

  Widget _buildComment(BuildContext context) {
    bool like = false; // Define a variable to keep track of like state
    final theme = Theme.of(context);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
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
                  gradient: gradient,
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
                            'Chinhphu',
                            textAlign: TextAlign.start,
                            style: min_cap.copyWith(color: primary),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Feb 30 2024',
                            textAlign: TextAlign.end,
                            style: min_cap.copyWith(color: text),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'This exercise is too hard to doooooooooooo!!!!!',
                      style:
                          bd_text.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    like = !like; // Toggle the like state
                  });
                },
                icon: like
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
}
