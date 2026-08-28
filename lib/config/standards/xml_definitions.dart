/// Catalog of XML types used in BHYT KCB claims data.
enum XmlType {
  xml1(
    code: 'XML1',
    title: 'Tổng hợp khám bệnh, chữa bệnh',
    containerElement: 'TONG_HOP',
    recordElement: 'TONG_HOP',
    isSingle: true,
  ),
  xml2(
    code: 'XML2',
    title: 'Chi tiết thuốc và sinh phẩm',
    containerElement: 'DSACH_CHI_TIET_THUOC',
    recordElement: 'CHI_TIET_THUOC',
    isSingle: false,
  ),
  xml3(
    code: 'XML3',
    title: 'Chi tiết dịch vụ kỹ thuật và vật tư y tế',
    containerElement: 'DSACH_CHI_TIET_DVKT',
    recordElement: 'CHI_TIET_DVKT',
    isSingle: false,
  ),
  xml4(
    code: 'XML4',
    title: 'Chi tiết kết quả cận lâm sàng',
    containerElement: 'DSACH_CHI_TIET_CLS',
    recordElement: 'CHI_TIET_CLS',
    isSingle: false,
  ),
  xml5(
    code: 'XML5',
    title: 'Theo dõi diễn biến lâm sàng',
    containerElement: 'DSACH_CHI_TIET_DIEN_BIEN_BENH',
    recordElement: 'CHI_TIET_DIEN_BIEN_BENH',
    isSingle: false,
  ),
  xml6(
    code: 'XML6',
    title: 'Hồ sơ điều trị HIV/AIDS',
    containerElement: 'HO_SO_HIV',
    recordElement: 'HO_SO_HIV',
    isSingle: true,
  ),
  xml7(
    code: 'XML7',
    title: 'Dữ liệu giấy ra viện',
    containerElement: 'CHI_TIEU_DU_LIEU_GIAY_RA_VIEN',
    recordElement: 'CHI_TIEU_DU_LIEU_GIAY_RA_VIEN',
    isSingle: true,
  ),
  xml8(
    code: 'XML8',
    title: 'Tóm tắt hồ sơ bệnh án',
    containerElement: 'CHI_TIEU_DU_LIEU_TOM_TAT_HO_SO_BENH_AN',
    recordElement: 'CHI_TIEU_DU_LIEU_TOM_TAT_HO_SO_BENH_AN',
    isSingle: true,
  ),
  xml9(
    code: 'XML9',
    title: 'Dữ liệu giấy chứng sinh',
    containerElement: 'GIAY_CHUNG_SINH',
    recordElement: 'GIAY_CHUNG_SINH',
    isSingle: true,
  ),
  xml10(
    code: 'XML10',
    title: 'Giấy chứng nhận nghỉ dưỡng thai',
    containerElement: 'GIAY_NGHI_DUONG_THAI',
    recordElement: 'GIAY_NGHI_DUONG_THAI',
    isSingle: true,
  ),
  xml11(
    code: 'XML11',
    title: 'Giấy chứng nhận nghỉ việc hưởng BHXH',
    containerElement: 'GIAY_NGHI_VIEC_BHXH',
    recordElement: 'GIAY_NGHI_VIEC_BHXH',
    isSingle: true,
  ),
  xml12(
    code: 'XML12',
    title: 'Biên bản giám định y khoa',
    containerElement: 'BIEN_BAN_GIAM_DINH_YK',
    recordElement: 'BIEN_BAN_GIAM_DINH_YK',
    isSingle: true,
  ),
  xml13(
    code: 'XML13',
    title: 'Giấy chuyển tuyến điện tử',
    containerElement: 'GIAY_CHUYEN_TUYEN',
    recordElement: 'GIAY_CHUYEN_TUYEN',
    isSingle: true,
  ),
  xml14(
    code: 'XML14',
    title: 'Giấy hẹn khám lại điện tử',
    containerElement: 'GIAY_HEN_KHAM_LAI',
    recordElement: 'GIAY_HEN_KHAM_LAI',
    isSingle: true,
  ),
  xml15(
    code: 'XML15',
    title: 'Hồ sơ điều trị bệnh Lao',
    containerElement: 'HO_SO_LAO',
    recordElement: 'HO_SO_LAO',
    isSingle: true,
  );

  final String code;
  final String title;
  final String containerElement;
  final String recordElement;
  final bool isSingle;

  const XmlType({
    required this.code,
    required this.title,
    required this.containerElement,
    required this.recordElement,
    required this.isSingle,
  });

  /// Parse from XML code string (e.g., 'XML1', 'XML2')
  static XmlType? fromCode(String? code) {
    if (code == null) return null;
    final normalized = code.trim().toUpperCase();
    for (final type in XmlType.values) {
      if (type.code == normalized) return type;
    }
    return null;
  }
}
