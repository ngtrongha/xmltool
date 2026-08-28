import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:xmltool/domain/entities/xml_record.dart';

/// Adapter bridging diffutil_dart Myers diff with XmlRecord lists.
class RecordDiffAdapter {
  /// Calculate diff updates between old and new record lists
  static List<diffutil.DataDiffUpdate<XmlRecord>> calculateDiff(
    List<XmlRecord> oldList,
    List<XmlRecord> newList,
  ) {
    return diffutil.calculateListDiff<XmlRecord>(
      oldList,
      newList,
      equalityChecker: (a, b) => a.key == b.key,
    ).getUpdatesWithData().toList();
  }
}
