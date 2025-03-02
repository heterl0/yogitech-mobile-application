import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../viewmodels/profile/change_BMI_viewmodel.dart';

class ChangeBMIPage extends StatefulWidget {
  final VoidCallback onBMIUpdated;
  final Profile profile;

  const ChangeBMIPage(
      {super.key, required this.onBMIUpdated, required this.profile});

  @override
  State<ChangeBMIPage> createState() => _ChangeBMIPageState();
}

class _ChangeBMIPageState extends State<ChangeBMIPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChangeBMIViewModel>().initialize(widget.profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChangeBMIViewModel>();
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.changeBMI,
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBMIDisplay(viewModel),
              const SizedBox(height: 16),
              _buildInputField(
                  trans.weightKg, viewModel.weightController, viewModel),
              const SizedBox(height: 16),
              _buildInputField(
                  trans.heightCm, viewModel.heightController, viewModel),
              const SizedBox(height: 16),
              _buildUpdateButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBMIDisplay(ChangeBMIViewModel viewModel) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: stroke, width: 2),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Center(
                child: Text(
                  viewModel.bmiResult.isNotEmpty ? viewModel.bmiResult : 'BMI',
                  style: h1.copyWith(color: primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(viewModel.bmiComment, style: h3.copyWith(color: text)),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      ChangeBMIViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: h3.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        const SizedBox(height: 8),
        BoxInputField(
          controller: controller,
          placeholder: label,
          keyboardType: TextInputType.number,
          onChanged: (_) => viewModel.calculateBMI(context),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(ChangeBMIViewModel viewModel) {
    return CustomButton(
      title: AppLocalizations.of(context)!.updateBMI,
      onPressed: viewModel.isLoading
          ? null
          : () =>
              viewModel.updateBMI(context, widget.profile, widget.onBMIUpdated),
      style: ButtonStyleType.Primary,
    );
  }
}
