import 'package:equatable/equatable.dart';

/// Represents a single adjustment row in Mẫu 09/BH (per-field, Thông tư 12/2026/TT-BTC).
class Mau09Row extends Equatable {
  final int stt;
  final String hoTen;
  final String maTheBhyt;
  final String ngayVao;
  final String ngayRa;
  final String maLk;
  final String maBn;
  final String? maTheRef;
  final String? ngayVaoRef;
  final String? ngayRaRef;
  final String ngayYl;

  // Group 1: Original rejected/changed field info
  final String truongTtGoc;
  final String giaTriGoc;
  final String lyDoTuChoi;
  final double soTuChoi;

  // Group 2: Proposed adjustment from healthcare facility (CSKCB)
  final String truongTtDc;
  final String giaTriDc;
  final String lyDoDc;
  final String ghiChu;

  const Mau09Row({
    required this.stt,
    required this.hoTen,
    required this.maTheBhyt,
    required this.ngayVao,
    required this.ngayRa,
    required this.maLk,
    required this.maBn,
    this.maTheRef,
    this.ngayVaoRef,
    this.ngayRaRef,
    required this.ngayYl,
    required this.truongTtGoc,
    required this.giaTriGoc,
    this.lyDoTuChoi = '',
    this.soTuChoi = 0.0,
    required this.truongTtDc,
    required this.giaTriDc,
    required this.lyDoDc,
    this.ghiChu = '',
  });

  Mau09Row copyWith({
    int? stt,
    String? hoTen,
    String? maTheBhyt,
    String? ngayVao,
    String? ngayRa,
    String? maLk,
    String? maBn,
    String? maTheRef,
    String? ngayVaoRef,
    String? ngayRaRef,
    String? ngayYl,
    String? truongTtGoc,
    String? giaTriGoc,
    String? lyDoTuChoi,
    double? soTuChoi,
    String? truongTtDc,
    String? giaTriDc,
    String? lyDoDc,
    String? ghiChu,
  }) {
    return Mau09Row(
      stt: stt ?? this.stt,
      hoTen: hoTen ?? this.hoTen,
      maTheBhyt: maTheBhyt ?? this.maTheBhyt,
      ngayVao: ngayVao ?? this.ngayVao,
      ngayRa: ngayRa ?? this.ngayRa,
      maLk: maLk ?? this.maLk,
      maBn: maBn ?? this.maBn,
      maTheRef: maTheRef ?? this.maTheRef,
      ngayVaoRef: ngayVaoRef ?? this.ngayVaoRef,
      ngayRaRef: ngayRaRef ?? this.ngayRaRef,
      ngayYl: ngayYl ?? this.ngayYl,
      truongTtGoc: truongTtGoc ?? this.truongTtGoc,
      giaTriGoc: giaTriGoc ?? this.giaTriGoc,
      lyDoTuChoi: lyDoTuChoi ?? this.lyDoTuChoi,
      soTuChoi: soTuChoi ?? this.soTuChoi,
      truongTtDc: truongTtDc ?? this.truongTtDc,
      giaTriDc: giaTriDc ?? this.giaTriDc,
      lyDoDc: lyDoDc ?? this.lyDoDc,
      ghiChu: ghiChu ?? this.ghiChu,
    );
  }

  @override
  List<Object?> get props => [
        stt,
        hoTen,
        maTheBhyt,
        ngayVao,
        ngayRa,
        maLk,
        maBn,
        maTheRef,
        ngayVaoRef,
        ngayRaRef,
        ngayYl,
        truongTtGoc,
        giaTriGoc,
        lyDoTuChoi,
        soTuChoi,
        truongTtDc,
        giaTriDc,
        lyDoDc,
        ghiChu,
      ];
}
