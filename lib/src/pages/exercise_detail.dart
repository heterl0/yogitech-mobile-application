import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/result.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';

class ExerciseDetail extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Exercise Detail',
        style: widthStyle.Large,
      ),
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(
        defaultStyle: false,
        buttonTitle: 'Do exercise',
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

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        width: double.infinity,
        height: 360,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/yoga.jpeg'),
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
          _buildRowWithText(),
          const SizedBox(height: 16),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildTitle2(context, 'Poses'),
          const SizedBox(height: 16),
          _buildPoses(),
          const SizedBox(height: 16),
          _buildTitle2(context, 'Comment'),
          const SizedBox(height: 16),
          _buildCommentSection(),
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
      'Ringo Island',
      style: h2.copyWith(color: theme.colorScheme.onPrimary),
    );
  }

  Widget _buildRowWithText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '10 mins',
          style: bd_text.copyWith(color: text),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Beginner',
            style: bd_text.copyWith(color: primary),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncusLorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt sollicitudin nisl, vel ornare dolor tincidunt ut. Fusce consectetur turpis feugiat tellus efficitur, id egestas dui rhoncus',
      style: bd_text.copyWith(color: text),
    );
  }

  Widget _buildPoses() {
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
        final title = 'Pose ${index + 1}';
        final subtitle = '${5 - index} minutes';

        return CustomCard(
          title: title,
          subtitle: subtitle,
          onTap: () {},
        );
      },
    );
  }

  Widget _buildCommentSection() {
    return Row(
      children: [
        Expanded(
          child: BoxInputField(
            controller: commentController,
            placeholder: 'Your comment',
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
