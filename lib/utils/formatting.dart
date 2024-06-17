import 'package:flutter_dotenv/flutter_dotenv.dart';

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

String checkDateExpired(String startDateStr, String dateStr) {
  DateTime targetDate = DateTime.parse(dateStr);
  DateTime startDate = DateTime.parse(startDateStr);
  // // Format the date
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(targetDate);
  // print('Formatted date: $formattedDate');

  // Calculate the difference
  DateTime now = DateTime.now();
  Duration startDifferent = startDate.difference(now);
  if (!startDifferent.isNegative) {
    return 'The event is not start.';
  }
  Duration difference = targetDate.difference(now);

  if (difference.isNegative) {
    return 'The date has passed.';
  } else {
    return '${difference.inDays} days remaining.';
  }
}
