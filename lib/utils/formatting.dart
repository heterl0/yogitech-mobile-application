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

String cleanApiUrl(String? url) => (url ?? '')
    .trim()
    .replaceFirst(RegExp(r'/api/v1'), '')
    .replaceFirst(RegExp(r'/$'), '');

String checkDateExpired(String startDateStr, String dateStr, AppLocalizations trans) {
  DateTime targetDateUtc = DateTime.parse(dateStr).toUtc();
  DateTime startDateUtc = DateTime.parse(startDateStr).toUtc();
  
  // Calculate the difference
  DateTime nowUtc = DateTime.now().toUtc();
  print('now (UTC) $nowUtc');
  print('start (UTC) $startDateUtc');
  print('end (UTC) $targetDateUtc');

  Duration startDifferent = startDateUtc.difference(nowUtc);
  if (!startDifferent.isNegative) {
    return trans.eventNotStart;
  }
  Duration difference = targetDateUtc.difference(nowUtc);

  print('difference (UTC): ${difference.inDays} days, ${difference.inHours} hours, ${difference.inMinutes} minutes');

  if (difference.isNegative) {
    return trans.eventPassed;
  } else {
    // Convert targetDateUtc to local time for display
    DateTime targetDateLocal = targetDateUtc.toLocal();
    DateTime nowLocal = nowUtc.toLocal();
    Duration localDifference = targetDateLocal.difference(nowLocal);

    print('now (Local) $nowLocal');
    print('end (Local) $targetDateLocal');
    print('localDifference: ${localDifference.inDays} days, ${localDifference.inHours} hours, ${localDifference.inMinutes} minutes');

    int days = localDifference.inDays;
    int hours = localDifference.inHours % 24;
    int minutes = localDifference.inMinutes % 60;

    print('days: $days, hours: $hours, minutes: $minutes');

    if (days == 0) {
      if (hours == 0) {
        return '$minutes ${trans.minutes} ${trans.eventRemain}';
      }
      return '$hours ${trans.hours} $minutes ${trans.minutes} ${trans.eventRemain}';
    } else {
      return '$days ${trans.day} ${trans.eventRemain}';
    }
  }
}

String formatDateTime(String isoString, String locale) {
  DateTime date = DateTime.parse(isoString).toLocal();
  var format = DateFormat.yMMMMd(locale);
  return format.format(date);
}
