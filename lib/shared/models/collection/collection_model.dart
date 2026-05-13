import 'package:static_touch/shared/enum/live_status_enum.dart';

class CollectionItem {
  final String id;
  final String title;
  final String coverUrl;
  final String duration;
  final String date;
  final LiveStatus status;

  CollectionItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.duration,
    required this.date,
    required this.status,
  });
}
