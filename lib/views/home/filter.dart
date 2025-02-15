import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/services/pose/pose_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/models/pose.dart';
import 'package:YogiTech/views/exercise/all_exercise.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/custombar/bottombar.dart';
import 'package:YogiTech/widgets/dropdown_field.dart'; // Import DropdownField
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterPage extends StatefulWidget {
  final Account? account;
  const FilterPage({super.key, this.account});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController category = TextEditingController();
  List<dynamic> _muscles = [];
  String? selectedMuscle;
  Account? _account;

  @override
  void initState() {
    super.initState();
    _account = widget.account;
    _loadMuscles();
  }

  Future<void> _loadMuscles() async {
    try {
      final muscles = await getMuscles();
      setState(() {
        _muscles = muscles;
      });
    } catch (e) {
      // Handle errors, e.g., show a snackbar or error message
      print('Error loading muscles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    print('Có account hay không? ${_account}');
    Map<String, String> muscleMap = {
      'Quadriceps': 'Cơ tứ đầu',
      'Pelvis': 'Khung chậu',
      'Neck': 'Cổ',
      'Knees': 'Đầu gối',
      'Interior Hips': 'Hông trong',
      'Chest': 'Ngực',
      'Feet Ankles': 'Bàn chân và mắt cá chân',
      'Abs': 'Cơ bụng',
      'Biceps': 'Cơ nhị đầu',
      'Shoulder': 'Vai',
      'Exterior Hips': 'Hông ngoài',
      'Hamstrings': 'Cơ gân kheo',
      'Gluteus': 'Cơ mông',
      'Hip': 'Hông',
      'Middle Back': 'Lưng giữa',
      'Triceps': 'Cơ tam đầu',
      'Upper Back': 'Lưng trên',
      'Lower Back': 'Lưng dưới'
    };

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        showBackButton: false,
        title: trans.filter,
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trans.category,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary)),
              SizedBox(height: 8.0),
              CustomDropdownFormField(
                controller: category,
                placeholder: trans.choosecCategory,
                items: ((trans.locale == "en")
                    ? muscleMap.keys.toList()
                    : muscleMap.values.toList()),
                onTap: () {},
                onChanged: (value) {
                  // Handle the selected value
                  setState(() {
                    selectedMuscle = value;
                    if (trans.locale != "en") {
                      selectedMuscle = muscleMap.keys.firstWhere(
                          (key) => muscleMap[key] == selectedMuscle);
                    }
                    // if(value != null){
                    //    Muscle? muscle = _muscles.firstWhere((mus) => mus.name == value, orElse: () => _muscles[0]);
                    // }
                  });
                },
              ),
              SizedBox(height: 8.0),
              if (selectedMuscle != null)
                MuscleInfoWidget(
                  muscleName: selectedMuscle!,
                  muscles: _muscles,
                  muscleMap: muscleMap,
                  account: _account,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        transparentBg: true,
        buttonTitle: trans.apply,
        onPressed: () {
          Navigator.pop(context);
          List<dynamic>? mus =
              _muscles.where((mus) => mus.name == selectedMuscle).toList();
          if (mus.isNotEmpty) {
            setState(() {
              Muscle? muscle = mus[0];
              // pushScreenWithNavBar(
              //     context, AllExercise(selectedMuscle: muscle));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllExercise(
                    selectedMuscle: muscle,
                    category: selectedMuscle!,
                    account: _account,
                  ),
                ),
              );
              // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              //     builder: (context) => AllExercise(selectedMuscle: muscle)));
            });
          }
        },
      ),
    );
  }
}

class MuscleInfoWidget extends StatelessWidget {
  final String muscleName;
  final List<dynamic> muscles;
  final Map<String, String> muscleMap;
  final Account? account;

  const MuscleInfoWidget({
    super.key,
    required this.muscleName,
    required this.muscles,
    required this.muscleMap,
    this.account,
  });

  @override
  Widget build(BuildContext context) {
    Muscle mus = muscles.firstWhere((mus) => mus.name == muscleName,
        orElse: () => muscles[0]);
    Map<String, String> detail = createDetail();

    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Container(
              height: 540,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trans.muscles,
                              textAlign: TextAlign.left,
                              style: bd_text.copyWith(
                                  color: theme.colorScheme.onPrimary),
                            ),
                            Text(
                              (trans.locale != "en"
                                  ? muscleMap[muscleName]!
                                  : muscleName),
                              textAlign: TextAlign.left,
                              style: h3.copyWith(
                                  color: theme.colorScheme.onPrimary),
                            ),
                            Text(
                              (trans.locale != "en"
                                  ? detail[muscleName]!
                                  : mus.description),
                              textAlign: TextAlign.left,
                              style: bd_text.copyWith(
                                  color: (!(account?.is_premium ?? false))
                                      ? primary
                                      : primary2),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: mus.image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                    color: (!(account?.is_premium ?? false))
                                        ? primary
                                        : primary2,
                                  )),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> createDetail() {
    return {
      "Quadriceps":
          "Cơ lớn ở phía trước đùi, được chia thành bốn phần riêng biệt và có chức năng duỗi chân.",
      "Pelvis":
          "Khung chậu được định nghĩa là phần giữa của cơ thể con người giữa vùng bụng trên và đùi dưới.",
      "Neck":
          "Cơ cổ là các mô cơ tạo ra chuyển động ở cổ khi được kích thích. Các cơ cổ kéo dài từ đáy sọ đến lưng trên và cùng hoạt động để cúi đầu và hỗ trợ trong việc thở.",
      "Knees":
          "Đầu gối là một khớp phức tạp nối xương đùi (femur) với xương ống chân (tibia). Nó liên quan đến nhiều cơ, gân, và dây chằng để tạo ra sự di chuyển và ổn định.",
      "Interior Hips":
          "Hông trong đề cập đến các cơ nằm bên trong khớp hông. Những cơ này đóng vai trò quan trọng trong việc gấp, xoay, và ổn định hông.",
      "Chest":
          "Cơ ngực, còn được gọi là cơ pectoral, nằm ở phía trước trên của thân. Chúng chịu trách nhiệm cho các động tác như đẩy, kéo, và ôm.",
      "Feet Ankles":
          "Bàn chân và mắt cá chân chứa nhiều cơ tham gia vào việc duy trì thăng bằng, hỗ trợ trọng lượng cơ thể, và cho phép các động tác như đi bộ, chạy, và nhảy.",
      "Abs":
          "Cơ bụng, thường được gọi là cơ abs, nằm ở phía trước của bụng. Chúng cung cấp sự hỗ trợ cho cột sống, giúp duy trì tư thế và tham gia vào các động tác như cúi và xoay.",
      "Biceps":
          "Cơ nhị đầu nằm ở phần trên của cánh tay và chịu trách nhiệm cho việc gập khớp khuỷu tay và xoay cẳng tay. Chúng tham gia vào nhiều động tác nâng và kéo.",
      "Shoulder":
          "Cơ vai, bao gồm cơ deltoids, cơ rotator cuff và cơ trapezius, cung cấp sự ổn định và tạo điều kiện cho nhiều động tác ở khớp vai, như nâng, vươn và ném.",
      "Exterior Hips":
          "Hông ngoài đề cập đến các cơ nằm bên ngoài khớp hông. Những cơ này đóng vai trò quan trọng trong việc dạng hông, xoay và ổn định hông.",
      "Hamstrings":
          "Cơ gân kheo là nhóm cơ nằm ở phía sau đùi. Chúng tham gia vào việc gập gối và duỗi hông, và đóng vai trò quan trọng trong các hoạt động như chạy, nhảy và cúi.",
      "Gluteus":
          "Cơ mông, bao gồm cơ mông lớn, cơ mông giữa và cơ mông nhỏ, nằm ở mông. Chúng chịu trách nhiệm cho việc duỗi hông, dạng hông và xoay hông, cũng như cung cấp sự ổn định cho khung chậu và lưng dưới.",
      "Hip":
          "Các cơ hông bao gồm nhiều cơ bao quanh và hỗ trợ khớp hông. Chúng tham gia vào các động tác như gấp hông, duỗi hông, dạng hông, khép hông và xoay hông.",
      "Middle Back":
          "Các cơ lưng giữa, bao gồm cơ erector spinae và cơ rhomboids, nằm ở khu vực giữa hai bả vai. Chúng cung cấp sự hỗ trợ và ổn định cho cột sống, cũng như tham gia vào các động tác như cúi và xoay.",
      "Triceps":
          "Cơ tam đầu nằm ở phía sau cánh tay trên và chịu trách nhiệm cho việc duỗi khớp khuỷu tay. Chúng tham gia vào các động tác như đẩy, ném và duỗi thẳng cánh tay.",
      "Upper Back":
          "Các cơ lưng trên, bao gồm cơ trapezius, cơ latissimus dorsi và cơ rhomboids, nằm ở khu vực trên và giữa của lưng. Chúng cung cấp sự hỗ trợ cho cột sống, hỗ trợ trong các động tác vai và góp phần duy trì tư thế.",
      "Lower Back":
          "Các cơ lưng dưới, bao gồm cơ erector spinae, cơ quadratus lumborum và cơ multifidus, nằm ở vùng thắt lưng của cột sống. Chúng cung cấp sự ổn định cho cột sống, hỗ trợ trong các động tác cúi và xoay, và hỗ trợ cơ thể trong nhiều hoạt động khác nhau."
    };
  }
}
