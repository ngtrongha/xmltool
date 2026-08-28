import 'package:xmltool/config/standards/xml_definitions.dart';

/// Classification of field changes regarding Mẫu 09/BH eligibility.
enum ChangeEligibility {
  /// Directly adjustable via Mẫu 09/BH (e.g., SO_LUONG, DON_GIA, T_BHTT).
  adjustable,

  /// Conditionally adjustable (requires supporting documentation or hospital master records).
  conditional,

  /// Not adjustable via Mẫu 09 (must cancel/resubmit entire claim if incorrect, e.g. MA_LK, CCCD).
  notAdjustable,

  /// Non-financial / clinical info (tracked and logged, but does not generate Mẫu 09 adjustment rows).
  nonFinancial,
}

/// Registry of Mẫu 09 field eligibility.
class Mau09Mappings {
  /// Locked fields that must never be altered via Mẫu 09
  static const Set<String> lockedFields = {
    'MA_LK',
    'MA_BN',
    'SO_CCCD',
    'HO_TEN',
    'NGAY_SINH',
    'GIOI_TINH',
    'MA_CSKCB',
    'NAM_QT',
    'THANG_QT',
  };

  /// Conditional fields requiring original medical records or justification
  static const Set<String> conditionalFields = {
    'MA_BENH_CHINH',
    'MA_THUOC',
    'MA_DICH_VU',
    'MA_VAT_TU',
  };

  /// XML2 fields eligible for Mẫu 09
  static const Set<String> xml2AdjustableFields = {
    'SO_LUONG',
    'DON_GIA',
    'TYLE_TT_BH',
    'MUC_HUONG',
    'THANH_TIEN_BV',
    'THANH_TIEN_BH',
    'T_BHTT',
    'T_BNCCT',
    'T_BNTT',
    'T_NGUONKHAC_NSNN',
    'T_NGUONKHAC_VTNN',
    'T_NGUONKHAC_VTTN',
    'T_NGUONKHAC_CL',
    'T_NGUONKHAC',
    'MA_KHOA',
    'MA_BAC_SI',
  };

  /// XML3 fields eligible for Mẫu 09
  static const Set<String> xml3AdjustableFields = {
    'SO_LUONG',
    'DON_GIA_BV',
    'DON_GIA_BH',
    'TYLE_TT_DV',
    'TYLE_TT_BH',
    'MUC_HUONG',
    'THANH_TIEN_BV',
    'THANH_TIEN_BH',
    'T_BHTT',
    'T_BNCCT',
    'T_BNTT',
    'T_NGUONKHAC_NSNN',
    'T_NGUONKHAC_VTNN',
    'T_NGUONKHAC_VTTN',
    'T_NGUONKHAC_CL',
    'T_NGUONKHAC',
    'MA_KHOA',
    'MA_BAC_SI',
    'NGUOI_THUC_HIEN',
  };

  /// XML1 fields eligible for Mẫu 09
  static const Set<String> xml1AdjustableFields = {
    'T_THUOC',
    'T_VTYT',
    'T_TONGCHI_BV',
    'T_TONGCHI_BH',
    'T_BHTT',
    'T_BNCCT',
    'T_BNTT',
    'T_NGUONKHAC',
    'MA_BENH_KT',
    'MA_KHOA',
  };

  /// Determine eligibility of a field change for Mẫu 09/BH.
  static ChangeEligibility getEligibility(XmlType xmlType, String fieldName) {
    if (lockedFields.contains(fieldName)) {
      return ChangeEligibility.notAdjustable;
    }
    if (conditionalFields.contains(fieldName)) {
      return ChangeEligibility.conditional;
    }

    switch (xmlType) {
      case XmlType.xml1:
        if (xml1AdjustableFields.contains(fieldName)) {
          return ChangeEligibility.adjustable;
        }
        break;
      case XmlType.xml2:
        if (xml2AdjustableFields.contains(fieldName)) {
          return ChangeEligibility.adjustable;
        }
        break;
      case XmlType.xml3:
        if (xml3AdjustableFields.contains(fieldName)) {
          return ChangeEligibility.adjustable;
        }
        break;
      default:
        break;
    }

    return ChangeEligibility.nonFinancial;
  }
}
