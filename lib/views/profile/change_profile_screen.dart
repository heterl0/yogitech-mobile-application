import 'dart:io';
import 'package:YogiTech/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/dropdown_field.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:YogiTech/views/profile/change_BMI_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../../services/account/account_service.dart';
import '../../viewmodels/profile/change_password_viewmodel.dart';
import '../../widgets/build_avatart_widget.dart';
import 'view_avatar_screen.dart';

class ChangeProfilePage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;
  final Account? account;

  const ChangeProfilePage({
    super.key,
    this.onProfileUpdated,
    this.account,
  });

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController lastName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController gender = TextEditingController();
  File? _image;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // Regular expression for Vietnamese phone numbers
  final RegExp phoneRegExp =
      RegExp(r'^(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$');

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _fetchUserProfile();
    }
  }

  void _fetchUserProfile() {
    if (widget.account?.profile != null) {
      lastName.text = widget.account?.profile.last_name ?? '';
      firstName.text = widget.account?.profile.first_name ?? '';
      phone.text = widget.account?.phone ?? '';
      birthday.text = widget.account?.profile.birthdate != null
          ? formatDate(widget.account!.profile.birthdate!)
          : '';
    }
  }

  Future<Uint8List> getImageBytesFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageBytes = _image!.readAsBytesSync();
      });
    }
  }

  void _viewAvatar() {
    if (_imageBytes != null || widget.account?.profile.avatar_url != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarViewPage(
            avatarUrl: widget.account?.profile.avatar_url ?? '',
            imageBytes: _imageBytes,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    final Map<int, String> genderMap = {
      0: trans.female,
      1: trans.male,
      2: trans.other,
    };

    gender.text = genderMap[widget.account?.profile.gender] ?? '';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.editProfile,
        style: WidthStyle.large,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AvatarWidget(
                          avatarUrl: widget.account?.profile.avatar_url,
                          imageBytes: _imageBytes,
                          username: widget.account?.username,
                          onTap: _viewAvatar),
                    ),
                    SizedBox(height: 8),
                    CustomButton(
                      title: trans.changeAvatar,
                      style: ButtonStyleType.Tertiary,
                      onPressed: _pickImage,
                    ),
                    SizedBox(height: 16),
                    Text(
                      trans.lastName,
                      style: h3.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(height: 8.0),
                    BoxInputField(
                      controller: lastName,
                      placeholder: trans.yourLastName,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      trans.firstName,
                      style: h3.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(height: 8.0),
                    BoxInputField(
                      controller: firstName,
                      placeholder: trans.firstName,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      trans.phoneNumber,
                      style: h3.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(height: 8.0),
                    BoxInputField(
                      controller: phone,
                      placeholder: widget.account?.phone ?? '',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      regExp: phoneRegExp,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                trans.birthday,
                                style: h3.copyWith(
                                    color: theme.colorScheme.onPrimary),
                              ),
                              SizedBox(height: 8.0),
                              BoxInputField(
                                controller: birthday,
                                placeholder: trans.birthday,
                                trailing: Icon(Icons.calendar_today),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    if (pickedDate.isAfter(DateTime.now())) {
                                      setState(() {
                                        //'${trans.birthday} ${trans.mustInput}';
                                      });
                                    } else {
                                      setState(() {
                                        birthday.text = DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                      });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                trans.gender,
                                style: h3.copyWith(
                                    color: theme.colorScheme.onPrimary),
                              ),
                              SizedBox(height: 8.0),
                              CustomDropdownFormField(
                                controller: gender,
                                items: [trans.male, trans.female, trans.other],
                                placeholder: gender.text.isEmpty
                                    ? trans.sellectGender
                                    : gender.text,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    CustomButton(
                      title: trans.save,
                      style: ButtonStyleType.Primary,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                          _changeProfile(context);
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    CustomButton(
                      title: trans.changePassword,
                      style: ButtonStyleType.Tertiary,
                      onPressed: () {
                        changePasswordBottomSheet(context);
                      },
                    ),
                    CustomButton(
                      title: trans.changeBMI,
                      style: ButtonStyleType.Tertiary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeBMIPage(
                              onBMIUpdated: widget.onProfileUpdated ?? () {},
                              profile: widget.account!.profile,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _changeProfile(BuildContext context) async {
    final trans = AppLocalizations.of(context)!;
    if (lastName.text.isEmpty || firstName.text.isEmpty) {
      _showSnackBar(false, message: trans.firstAndLastName);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<int, String> genderMap = {
      0: trans.female,
      1: trans.male,
      2: trans.other,
    };

    if (!phoneRegExp.hasMatch(phone.text) || phone.text.length != 10) {
      _showSnackBar(false, message: trans.formatPhone);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    DateTime? birthdate = birthday.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').parse(birthday.text)
        : null;

    int? genderValue = genderMap.entries
        .firstWhere((entry) => entry.value == gender.text,
            orElse: () => MapEntry(2, 'Other'))
        .key;

    print(
        "Giới tánh được sửa? ${genderValue}, giá trị của text: ${gender.text}");

    print("${gender.text} $lastName: ${gender}");

    print("$firstName $lastName $genderValue $genderMap $birthday");
    PatchProfileRequest request = PatchProfileRequest(
      lastName: lastName.text,
      firstName: firstName.text,
      phone: phone.text,
      birthdate: birthdate,
      gender: genderValue,
    );

    final Profile? profile = await patchProfile(request, _imageBytes);
    setState(() {
      _isLoading = false;
      widget.onProfileUpdated?.call();
    });

    if (profile != null) {
      _showSnackBar(true);
    } else {
      _showSnackBar(false);
    }
  }

  void _showSnackBar(bool success, {String? message}) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.onSecondary,
        content: Text(
          message ?? (success ? trans.updateSuccess : trans.updateFail),
          style: bd_text.copyWith(color: theme.colorScheme.onSurface),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
