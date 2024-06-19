import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



String formatApiUrl(String? url) {
  final base = cleanApiUrl(dotenv.get("API_BASE_URL"));

  if (url!.isEmpty) {
    return base;
  }

  return '$base$url';
}

String cleanApiUrl(String? url) => (url ?? '')
    .trim()
    .replaceFirst(RegExp(r'/api/v1'), '')
    .replaceFirst(RegExp(r'/$'), '');

String checkDateExpired(String startDateStr, String dateStr,AppLocalizations trans) {
  DateTime targetDate = DateTime.parse(dateStr);
  DateTime startDate = DateTime.parse(startDateStr);
  // // Format the date
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(targetDate);
  // print('Formatted date: $formattedDate');

  // Calculate the difference
  DateTime now = DateTime.now();
  Duration startDifferent = startDate.difference(now);
  if (!startDifferent.isNegative) {
    return trans.eventNotStart;
  }
  Duration difference = targetDate.difference(now);

  if (difference.isNegative) {
    return trans.eventPassed;
  } else {
    return '${difference.inDays} ${trans.eventRemain}';
  }
}
