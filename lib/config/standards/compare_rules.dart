import 'package:xmltool/config/standards/xml_definitions.dart';

/// Registry of comparable fields per XML type.
class CompareRules {
  /// Fields in XML1 to compare for changes.
  static const List<String> xml1ComparableFields = [
    'LY_DO_VV',
    'LY_DO_VNT',
    'MA_LY_DO_VNT',
    'CHAN_DOAN_VAO',
    'CHAN_DOAN_RV',
    'MA_BENH_CHINH',
    'MA_BENH_KT',
    'MA_BENH_YHCT',
    'MA_PTTT_QT',
    'MA_DOITUONG_KCB',
    'MA_NOI_DI',
    'MA_NOI_DEN',
    'MA_TAI_NAN',
    'NGAY_VAO',
    'NGAY_VAO_NOI_TRU',
    'NGAY_RA',
    'GIAY_CHUYEN_TUYEN',
    'SO_NGAY_DTRI',
    'PP_DIEU_TRI',
    'KET_QUA_DTRI',
    'MA_LOAI_RV',
    'GHI_CHU',
    'NGAY_TTOAN',
    'T_THUOC',
    'T_VTYT',
    'T_TONGCHI_BV',
    'T_TONGCHI_BH',
    'T_BNTT',
    'T_BNCCT',
    'T_BHTT',
    'T_NGUONKHAC',
    'T_BHTT_GDV',
    'MA_LOAI_KCB',
    'MA_KHOA',
    'MA_KHUVUC',
    'CAN_NANG',
    'CAN_NANG_CON',
    'NGAY_TAI_KHAM',
    'NHOM_MAU',
  ];

  /// Fields in XML2 to compare for changes.
  static const List<String> xml2ComparableFields = [
    'MA_THUOC',
    'MA_PP_CHEBIEN',
    'MA_NHOM',
    'TEN_THUOC',
    'DON_VI_TINH',
    'HAM_LUONG',
    'DUONG_DUNG',
    'DANG_BAO_CHE',
    'LIEU_DUNG',
    'CACH_DUNG',
    'SO_DANG_KY',
    'TT_THAU',
    'PHAM_VI',
    'TYLE_TT_BH',
    'SO_LUONG',
    'DON_GIA',
    'THANH_TIEN_BV',
    'THANH_TIEN_BH',
    'T_NGUONKHAC_NSNN',
    'T_NGUONKHAC_VTNN',
    'T_NGUONKHAC_VTTN',
    'T_NGUONKHAC_CL',
    'T_NGUONKHAC',
    'MUC_HUONG',
    'T_BNTT',
    'T_BNCCT',
    'T_BHTT',
    'MA_KHOA',
    'MA_BAC_SI',
    'MA_DICH_VU',
    'NGAY_YL',
    'NGAY_TH_YL',
    'MA_PTTT',
    'NGUON_CTRA',
    'VET_THUONG_TP',
  ];

  /// Fields in XML3 to compare for changes.
  static const List<String> xml3ComparableFields = [
    'MA_DICH_VU',
    'MA_PTTT_QT',
    'MA_VAT_TU',
    'MA_NHOM',
    'GOI_VTYT',
    'TEN_VAT_TU',
    'TEN_DICH_VU',
    'MA_XANG_DAU',
    'DON_VI_TINH',
    'PHAM_VI',
    'SO_LUONG',
    'DON_GIA_BV',
    'DON_GIA_BH',
    'TT_THAU',
    'TYLE_TT_DV',
    'TYLE_TT_BH',
    'THANH_TIEN_BV',
    'THANH_TIEN_BH',
    'T_TRANTT',
    'MUC_HUONG',
    'T_NGUONKHAC_NSNN',
    'T_NGUONKHAC_VTNN',
    'T_NGUONKHAC_VTTN',
    'T_NGUONKHAC_CL',
    'T_NGUONKHAC',
    'T_BNTT',
    'T_BNCCT',
    'T_BHTT',
    'MA_KHOA',
    'MA_GIUONG',
    'MA_BAC_SI',
    'NGUOI_THUC_HIEN',
    'MA_BENH',
    'MA_BENH_YHCT',
    'NGAY_YL',
    'NGAY_TH_YL',
    'NGAY_KQ',
    'MA_PTTT',
    'VET_THUONG_TP',
    'PP_VO_CAM',
    'VI_TRI_TH_DVKT',
    'MA_MAY',
    'MA_HIEU_SP',
    'TAI_SU_DUNG',
  ];

  /// Fields in XML4 to compare.
  static const List<String> xml4ComparableFields = [
    'TEN_CHI_SO',
    'GIA_TRI',
    'DON_VI_DO',
    'MO_TA',
    'KET_LUAN',
    'NGAY_KQ',
    'MA_BS_DOC_KQ',
  ];

  /// Fields in XML5 to compare.
  static const List<String> xml5ComparableFields = [
    'DIEN_BIEN_LS',
    'GIAI_DOAN_BENH',
    'HOI_CHAN',
    'PHAU_THUAT',
    'THOI_DIEM_DBLS',
    'NGUOI_THUC_HIEN',
  ];

  /// Fields in XML7 to compare.
  static const List<String> xml7ComparableFields = [
    'SO_LUU_TRU',
    'MA_KHOA_RV',
    'NGAY_VAO',
    'NGAY_RA',
    'MA_DINH_CHI_THAI',
    'NGUYENNHAN_DINHCHI',
    'THOIGIAN_DINHCHI',
    'TUOI_THAI',
    'CHAN_DOAN_RV',
    'PP_DIEUTRI',
    'GHI_CHU',
    'MA_BS',
    'TEN_BS',
    'NGAY_CT',
    'MA_CHA',
    'MA_ME',
    'MA_THE_TAM',
    'HO_TEN_CHA',
    'HO_TEN_ME',
    'SO_NGAY_NGHI',
    'NGOAITRU_TUNGAY',
    'NGOAITRU_DENNGAY',
  ];

  /// Fields in XML8 to compare.
  static const List<String> xml8ComparableFields = [
    'MA_LOAI_KCB',
    'HO_TEN_CHA',
    'HO_TEN_ME',
    'NGUOI_GIAM_HO',
    'DON_VI',
    'NGAY_VAO',
    'NGAY_RA',
    'CHAN_DOAN_VAO',
    'CHAN_DOAN_RV',
    'QT_BENHLY',
    'TOMTAT_KQ',
    'PP_DIEUTRI',
    'NGAY_SINHCON',
    'NGAY_CONCHET',
    'SO_CONCHET',
    'KET_QUA_DTRI',
    'GHI_CHU',
    'NGAY_CT',
    'MA_THE_TAM',
  ];

  /// Returns list of comparable field names for a given XML type.
  static List<String> getComparableFields(XmlType type) {
    switch (type) {
      case XmlType.xml1:
        return xml1ComparableFields;
      case XmlType.xml2:
        return xml2ComparableFields;
      case XmlType.xml3:
        return xml3ComparableFields;
      case XmlType.xml4:
        return xml4ComparableFields;
      case XmlType.xml5:
        return xml5ComparableFields;
      case XmlType.xml7:
        return xml7ComparableFields;
      case XmlType.xml8:
        return xml8ComparableFields;
      default:
        return const [];
    }
  }
}
