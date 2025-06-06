import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String formatApiUrl(String? url) {
  final base = cleanApiUrl(dotenv.get("API_BASE_URL"));

  if (url!.isEmpty) {
    return base;
  }

  return '$base$url';
}

String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date).toUtc().toLocal();
  return DateFormat('dd-MM-yyyy').format(parsedDate);
}

String cleanApiUrl(String? url) => (url ?? '')
    .trim()
    .replaceFirst(RegExp(r'/api/v1'), '')
    .replaceFirst(RegExp(r'/$'), '');

class CheckDateResult {
  final String message;
  final int status;

  CheckDateResult({required this.message, required this.status});
}

CheckDateResult checkDateExpired(
    String startDateStr, String dateStr, AppLocalizations trans) {
  DateTime targetDateUtc = DateTime.parse(dateStr).toUtc();
  DateTime startDateUtc =
      DateTime.parse(startDateStr).toUtc().subtract(Duration(minutes: 1));

  // Calculate the difference
  DateTime nowUtc = DateTime.now().toUtc();

  Duration startDifferent = startDateUtc.difference(nowUtc);

  if (!startDifferent.isNegative) {
    return CheckDateResult(message: trans.eventNotStart, status: 0);
  }

  Duration difference = targetDateUtc.difference(nowUtc);

  if (difference.isNegative) {
    int daysPassed = -difference.inDays;
    String message = '${trans.eventPassed}';
    if (daysPassed >= 1) {
      message += ' $daysPassed ${trans.days}';
    }

    if (daysPassed > 7) {
      return CheckDateResult(message: message, status: 3);
    }
    return CheckDateResult(message: message, status: 2);
  } else {
    // Convert targetDateUtc to local time for display
    DateTime targetDateLocal = targetDateUtc.toLocal();
    DateTime nowLocal = nowUtc.toLocal();
    Duration localDifference = targetDateLocal.difference(nowLocal);

    int days = localDifference.inDays;
    int hours = localDifference.inHours % 24;
    int minutes = localDifference.inMinutes % 60;

    String message;
    if (days == 0) {
      if (hours == 0) {
        message = '$minutes ${trans.minutes} ${trans.eventRemain}';
      } else {
        message =
            '$hours ${trans.hours} $minutes ${trans.minutes} ${trans.eventRemain}';
      }
    } else {
      message = '$days ${trans.day} ${trans.eventRemain}';
    }

    return CheckDateResult(message: message, status: 1);
  }
}

String formatDateTime(String isoString, String locale) {
  DateTime date = DateTime.parse(isoString).toLocal();
  var format = DateFormat.yMMMMd(locale);
  return format.format(date);
}
