import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/file_ho_so.dart';
import 'package:xmltool/domain/entities/xml1_record.dart';

/// Represents a `<HOSO>` containing multiple `<FILEHOSO>` elements for a single treatment episode.
class HoSo extends Equatable {
  final String maLk;
  final List<FileHoSo> fileList;

  const HoSo({
    required this.maLk,
    required this.fileList,
  });

  /// Extract XML1 master record if present
  Xml1Record? get xml1Record {
    for (final f in fileList) {
      if (f.xmlType == XmlType.xml1 && f.records.isNotEmpty) {
        final rec = f.records.first;
        if (rec is Xml1Record) return rec;
        return Xml1Record.fromFields(rec.fields, index: rec.index);
      }
    }
    return null;
  }

  /// Get FileHoSo by XML type
  FileHoSo? getFile(XmlType type) {
    for (final f in fileList) {
      if (f.xmlType == type) return f;
    }
    return null;
  }

  /// Total number of records across all XML tables in this HoSo
  int get totalRecords {
    var count = 0;
    for (final f in fileList) {
      count += f.records.length;
    }
    return count;
  }

  @override
  List<Object?> get props => [maLk, fileList];
}
