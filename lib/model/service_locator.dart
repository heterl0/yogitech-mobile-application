import 'package:YogiTech/model/pose/pose_service.dart';
import 'package:get_it/get_it.dart';

import 'model_inference_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Pose>(Pose());

  locator.registerLazySingleton<ModelInferenceService>(
      () => ModelInferenceService());
}
