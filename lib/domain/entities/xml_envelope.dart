import 'package:equatable/equatable.dart';
import 'package:xmltool/domain/entities/ho_so.dart';

/// Represents the top-level `<GIAMDINHHS>` envelope.
class XmlEnvelope extends Equatable {
  final String maCskcb;
  final String ngayLap;
  final int soLuongHoSo;
  final List<HoSo> danhSachHoSo;
  final String? filePath;
  final String? fileHash;
  final int fileSizeBytes;

  const XmlEnvelope({
    required this.maCskcb,
    required this.ngayLap,
    required this.soLuongHoSo,
    required this.danhSachHoSo,
    this.filePath,
    this.fileHash,
    this.fileSizeBytes = 0,
  });

  /// Total records in all HoSo
  int get totalRecords {
    var count = 0;
    for (final hs in danhSachHoSo) {
      count += hs.totalRecords;
    }
    return count;
  }

  @override
  List<Object?> get props => [
        maCskcb,
        ngayLap,
        soLuongHoSo,
        danhSachHoSo,
        filePath,
        fileHash,
        fileSizeBytes,
      ];
}
