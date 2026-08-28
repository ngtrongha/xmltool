/// Standard version definition for BHYT KCB XML data format.
enum StandardVersion {
  qd3176(
    code: '2026.1_QD3176',
    title: 'QĐ 3176/QĐ-BYT (Hiện hành từ 01/02/2026)',
    decisionNumber: '3176/QĐ-BYT',
    releaseDate: '2024-10-29',
    effectiveDate: '2026-02-01',
    description: 'Chuẩn 15 bảng XML, chuẩn hóa mã CCHN/GPHN và định dạng trường số/ngày.',
  ),
  qd4750(
    code: '2024.1_QD4750',
    title: 'QĐ 4750/QĐ-BYT (Giai đoạn 2024 - 2025)',
    decisionNumber: '4750/QĐ-BYT',
    releaseDate: '2023-12-29',
    effectiveDate: '2024-04-01',
    description: 'Bổ sung XML13, XML14, Checkin tiếp đón và chuẩn hóa cấu trúc 12 bảng XML.',
  ),
  qd130(
    code: '2023.1_QD130',
    title: 'QĐ 130/QĐ-BYT (Nền tảng)',
    decisionNumber: '130/QĐ-BYT',
    releaseDate: '2023-01-18',
    effectiveDate: '2023-09-01',
    description: 'Quy định định dạng dữ liệu đầu ra phục vụ quản lý giám định KCB BHYT.',
  );

  final String code;
  final String title;
  final String decisionNumber;
  final String releaseDate;
  final String effectiveDate;
  final String description;

  const StandardVersion({
    required this.code,
    required this.title,
    required this.decisionNumber,
    required this.releaseDate,
    required this.effectiveDate,
    required this.description,
  });

  /// Default active standard for the system.
  static const StandardVersion defaultVersion = StandardVersion.qd3176;
}
