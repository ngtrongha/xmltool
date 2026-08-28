import 'package:equatable/equatable.dart';
import 'package:xmltool/domain/entities/digital_certificate.dart';

/// Metadata and status of a digital signature on a BHYT XML envelope.
class SignatureInfo extends Equatable {
  final bool isSigned;
  final String? signatureValue;
  final String? digestValue;
  final DateTime? signingTime;
  final DigitalCertificate? certificate;
  final bool isValid;
  final String? validationMessage;

  const SignatureInfo({
    required this.isSigned,
    this.signatureValue,
    this.digestValue,
    this.signingTime,
    this.certificate,
    this.isValid = false,
    this.validationMessage,
  });

  /// Factory for an unsigned state.
  factory SignatureInfo.unsigned() => const SignatureInfo(isSigned: false);

  SignatureInfo copyWith({
    bool? isSigned,
    String? signatureValue,
    String? digestValue,
    DateTime? signingTime,
    DigitalCertificate? certificate,
    bool? isValid,
    String? validationMessage,
  }) {
    return SignatureInfo(
      isSigned: isSigned ?? this.isSigned,
      signatureValue: signatureValue ?? this.signatureValue,
      digestValue: digestValue ?? this.digestValue,
      signingTime: signingTime ?? this.signingTime,
      certificate: certificate ?? this.certificate,
      isValid: isValid ?? this.isValid,
      validationMessage: validationMessage ?? this.validationMessage,
    );
  }

  @override
  List<Object?> get props => [
        isSigned,
        signatureValue,
        digestValue,
        signingTime,
        certificate,
        isValid,
        validationMessage,
      ];
}
