import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class UtilsFunctions {
  Future<void> launchUrls(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
