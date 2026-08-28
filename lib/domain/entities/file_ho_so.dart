import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/xml_record.dart';

/// Represents a `<FILEHOSO>` segment containing one type of XML and its records.
class FileHoSo extends Equatable {
  final XmlType xmlType;
  final List<XmlRecord> records;
  final String? rawContent;
  final bool isBase64Encoded;

  const FileHoSo({
    required this.xmlType,
    required this.records,
    this.rawContent,
    this.isBase64Encoded = false,
  });

  @override
  List<Object?> get props => [xmlType, records, isBase64Encoded];
}
