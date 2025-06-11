import 'package:ZenAiYoga/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/account/account_service.dart';
import '../../widgets/box_button.dart';
import '../../widgets/box_input_field.dart';

Future<void> changePasswordBottomSheet(BuildContext context) {
  bool isChangingPassword = false;
  final theme = Theme.of(context);
  final trans = AppLocalizations.of(context)!;
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();
  bool isValid = true;
  String newpasswarn = '';
  String repasswarn = '';
  String currentpasswarn = '';
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.onSecondary,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trans.oldPassword,
                          style:
                              h3.copyWith(color: theme.colorScheme.onSurface)),
                      SizedBox(height: 16.0),
                      BoxInputField(
                          controller: currentPassword, password: true),
                      Text(currentpasswarn,
                          style: bd_text.copyWith(color: Colors.red)),
                      SizedBox(height: 8.0),
                      Text(trans.newPassword,
                          style:
                              h3.copyWith(color: theme.colorScheme.onSurface)),
                      SizedBox(height: 16.0),
                      BoxInputField(controller: newPassword, password: true),
                      Text(newpasswarn,
                          style: bd_text.copyWith(color: Colors.red)),
                      SizedBox(height: 8.0),
                      Text(trans.confirmNewPassword,
                          style:
                              h3.copyWith(color: theme.colorScheme.onSurface)),
                      SizedBox(height: 16.0),
                      BoxInputField(
                          controller: confirmNewPassword, password: true),
                      Text(repasswarn,
                          style: bd_text.copyWith(color: Colors.red)),
                      SizedBox(height: 40.0),
                      CustomButton(
                        title: trans.save,
                        style: ButtonStyleType.Primary,
                        state: ButtonState.Enabled,
                        onPressed: () async {
                          String newPass = newPassword.text;
                          String curentPass = currentPassword.text;
                          String rePass = confirmNewPassword.text;

                          setState(() {
                            if (newPass == '' ||
                                curentPass == '' ||
                                rePass == '') {
                              isValid = false;
                              newPass == ''
                                  ? newpasswarn =
                                      '${trans.newPassword} ${trans.fiedNotEmty}'
                                  : newpasswarn = '';
                              rePass == ''
                                  ? repasswarn =
                                      '${trans.confirmNewPassword} ${trans.fiedNotEmty}'
                                  : repasswarn = '';
                              curentPass == ''
                                  ? currentpasswarn =
                                      '${trans.oldPassword} ${trans.fiedNotEmty}'
                                  : currentpasswarn = '';
                            } else {
                              newpasswarn = '';
                              repasswarn = '';
                              currentpasswarn = '';
                              if (newPass != rePass) {
                                isValid = false;
                                repasswarn = trans.passwordsDoNotMatch;
                              } else {
                                isValid = true;
                              }
                            }
                          });

                          if (!isValid) return;

                          if (isValid) {
                            PasswordChangeRequest request =
                                PasswordChangeRequest(
                              currentPassword: currentPassword.text,
                              newPassword: newPassword.text,
                              reNewPassword: confirmNewPassword.text,
                            );

                            setState(() {
                              isChangingPassword = true;
                            });

                            bool? result = await changePassword(request);

                            setState(() {
                              isChangingPassword = false;
                            });

                            if (result == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      theme.colorScheme.onSecondary,
                                  content: Text(
                                    trans.passwordChangedSuccessfully,
                                    style: bd_text.copyWith(
                                        color: theme.colorScheme.onSurface),
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            } else if (result == null) {
                              setState(() {
                                isValid = false;
                                currentpasswarn =
                                    '${trans.password} ${trans.incorrect}';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      theme.colorScheme.onSecondary,
                                  content: Text(
                                    trans.passwordChangeFailed,
                                    style: bd_text.copyWith(
                                        color: theme.colorScheme.onSurface),
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (isChangingPassword)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
