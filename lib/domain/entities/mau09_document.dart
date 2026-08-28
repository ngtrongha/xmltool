import 'package:equatable/equatable.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';

/// Represents a single `<HOSO>` containing multiple `<MAU_09>` rows.
class Mau09HoSo extends Equatable {
  final String maLk;
  final List<Mau09Row> rows;

  const Mau09HoSo({
    required this.maLk,
    required this.rows,
  });

  @override
  List<Object?> get props => [maLk, rows];
}

/// Represents the complete Mẫu 09/BH adjustment document inside the GIAMDINHHS envelope.
class Mau09Document extends Equatable {
  final String maCskcb;
  final String? maTinh;
  final String? tenTinh;
  final String ngayLap;
  final List<Mau09HoSo> hoSoList;
  final String? chuKySo;

  const Mau09Document({
    required this.maCskcb,
    this.maTinh,
    this.tenTinh,
    required this.ngayLap,
    required this.hoSoList,
    this.chuKySo,
  });

  /// Flattened list of all adjustment rows
  List<Mau09Row> get allRows =>
      hoSoList.expand((hs) => hs.rows).toList();

  /// Total number of adjustment rows
  int get totalRows => allRows.length;

  /// Total number of claims affected
  int get totalClaims => hoSoList.length;

  @override
  List<Object?> get props => [
        maCskcb,
        maTinh,
        tenTinh,
        ngayLap,
        hoSoList,
        chuKySo,
      ];
}
