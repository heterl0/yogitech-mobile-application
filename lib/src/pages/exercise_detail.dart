import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/card.dart';

class ExerciseDetail extends StatelessWidget {
  final TextEditingController commmentController = TextEditingController();

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

  Widget _buildOldBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0A141C)),
      child: Stack(
        children: [
          _buildImage(),
          _buildTopRoundedContainer(),
          _buildTitleText(context),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildTopRoundedContainer() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xFF0D1F29),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: 110,
          child: Text(
            'Exercise detail',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          left: 15,
          top: 92,
          child: _buildBackButton(context),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/arrow_back.png',
        color: Colors.white.withOpacity(1),
        width: 30,
        height: 30,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
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

  // Widget _buildMainContent() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 350),
  //     child: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 24),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 16),
  //             _buildTitle(context),
  //             const SizedBox(height: 16),
  //             _buildRowWithText(),
  //             const SizedBox(height: 16),
  //             _buildDescription(),
  //             const SizedBox(height: 16),
  //             _buildTitle('Poses', 16, FontWeight.w600, Colors.white),
  //             const SizedBox(height: 16),
  //             _buildPoses(),
  //             const SizedBox(height: 16),
  //             _buildTitle('Comment', 16, FontWeight.w600, Colors.white),
  //             const SizedBox(height: 16),
  //             _buildCommentSection(),
  //             const SizedBox(height: 16),
  //             _buildUserComment(),
  //             const SizedBox(
  //                 height: 100), // Provide space for the navigation bar
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTitle2(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.centerLeft, // Aligns the ch // Add padding if needed
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns the children to the start
        children: [
          Text(
            title,
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ],
      ),
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
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
          // child: Container(
          //   height: 44,
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   decoration: ShapeDecoration(
          //     color: Color(0xFF09141C),
          //     shape: RoundedRectangleBorder(
          //       side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
          //       borderRadius: BorderRadius.circular(44),
          //     ),
          //   ),
          //   child: TextField(
          //     style: TextStyle(
          //       color: Color(0xFF8D8E99),
          //       fontSize: 16,
          //       fontFamily: 'Readex Pro',
          //       fontWeight: FontWeight.w400,
          //       height: 1.5,
          //     ),
          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       hintText: 'Your comment',
          //       hintStyle: TextStyle(color: Color(0xFF8D8E99)),
          //     ),
          //   ),
          // ),
          child: BoxInputField(
            controller: commmentController,
            placeholder: 'Your comment',
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send_outlined,
              size: 36,
              color: text,
            ))
        // Container(
        //   width: 36,
        //   height: 36,
        //   child: Image.asset('assets/icons/send.png'),
        // ),
      ],
    );
  }

  Widget _buildComment(context) {
    final theme = Theme.of(context);
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
                  style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border_outlined,
                color: text,
              )),
        ],
      ),
    );
  }
}
  // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           Expanded(
          //             child: Text(
          //               'Chinhphu',
          //               style: min_cap.copyWith(color: primary),
          //             ),
          //           ),
          //           Expanded(
          //             child: Padding(
          //               padding: EdgeInsets.only(left: 52),
          //               child: Row(
          //                 children: [
          //                   const SizedBox(width: 12),
          //                   Padding(
          //                     padding: EdgeInsets.only(top: 2),
          //                     child: Container(
          //                       width: 24,
          //                       height: 24,
          //                       child: Image.asset(
          //                         'assets/icons/favorite.png',
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(bottom: 10),
          //         child: Text(
          //           'This exercise is too hard to do!',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 12,
          //             fontFamily: 'Readex Pro',
          //             fontWeight: FontWeight.w400,
          //             height: 1.5,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),