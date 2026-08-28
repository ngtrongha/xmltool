import 'package:equatable/equatable.dart';

/// Represents an X.509 Digital Certificate used for BHYT XML signing.
/// Complies with Decree 130/2018/ND-CP and Circular 18/2022/TT-BTTTT.
class DigitalCertificate extends Equatable {
  final String subjectName;
  final String issuerName;
  final String serialNumber;
  final DateTime validFrom;
  final DateTime validTo;
  final String thumbprintSha256;
  final String rawCertificateBase64;

  const DigitalCertificate({
    required this.subjectName,
    required this.issuerName,
    required this.serialNumber,
    required this.validFrom,
    required this.validTo,
    required this.thumbprintSha256,
    required this.rawCertificateBase64,
  });

  /// Checks if the certificate is currently valid (within date range).
  bool get isValidNow {
    final now = DateTime.now();
    return now.isAfter(validFrom) && now.isBefore(validTo);
  }

  /// True if certificate has expired.
  bool get isExpired => DateTime.now().isAfter(validTo);

  /// Friendly short organization / doctor name extracted from Subject.
  String get displayName {
    for (final part in subjectName.split(',')) {
      final trimmed = part.trim();
      if (trimmed.startsWith('CN=') || trimmed.startsWith('O=')) {
        return trimmed.substring(3).trim();
      }
    }
    return subjectName;
  }

  /// Friendly CA provider name extracted from Issuer.
  String get caProvider {
    for (final part in issuerName.split(',')) {
      final trimmed = part.trim();
      if (trimmed.startsWith('CN=') || trimmed.startsWith('O=')) {
        return trimmed.substring(3).trim();
      }
    }
    return issuerName;
  }

  @override
  List<Object?> get props => [
        subjectName,
        issuerName,
        serialNumber,
        validFrom,
        validTo,
        thumbprintSha256,
        rawCertificateBase64,
      ];
}
