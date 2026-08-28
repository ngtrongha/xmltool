import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/digital_certificate.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/signature_info.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';

abstract class Mau09Event extends Equatable {
  const Mau09Event();

  @override
  List<Object?> get props => [];
}

class Mau09GenerateRequested extends Mau09Event {
  final CompareResult compareResult;
  final XmlEnvelope newEnvelope;
  final XmlEnvelope? oldEnvelope;
  final String defaultReason;

  const Mau09GenerateRequested({
    required this.compareResult,
    required this.newEnvelope,
    this.oldEnvelope,
    this.defaultReason = 'Điều chỉnh số lượng/đơn giá thuốc đúng theo hồ sơ bệnh án và hóa đơn thầu',
  });

  @override
  List<Object?> get props => [compareResult, newEnvelope, oldEnvelope, defaultReason];
}

class Mau09RowReasonUpdated extends Mau09Event {
  final int stt;
  final String newReason;

  const Mau09RowReasonUpdated({required this.stt, required this.newReason});

  @override
  List<Object?> get props => [stt, newReason];
}

class Mau09BulkReasonUpdated extends Mau09Event {
  final String newReason;

  const Mau09BulkReasonUpdated(this.newReason);

  @override
  List<Object?> get props => [newReason];
}

class Mau09ExportXmlRequested extends Mau09Event {
  final String targetPath;
  const Mau09ExportXmlRequested(this.targetPath);

  @override
  List<Object?> get props => [targetPath];
}

class Mau09ExportExcelRequested extends Mau09Event {
  final CompareResult compareResult;
  final String targetPath;

  const Mau09ExportExcelRequested({
    required this.compareResult,
    required this.targetPath,
  });

  @override
  List<Object?> get props => [compareResult, targetPath];
}

/// Applies a digital signature using an RSA private key and certificate.
class Mau09DigitalSignatureApplied extends Mau09Event {
  final pc.RSAPrivateKey privateKey;
  final DigitalCertificate certificate;

  const Mau09DigitalSignatureApplied({
    required this.privateKey,
    required this.certificate,
  });

  @override
  List<Object?> get props => [privateKey, certificate];
}

/// Verifies current digital signature.
class Mau09SignatureVerified extends Mau09Event {
  const Mau09SignatureVerified();
}

/// Clears digital signature.
class Mau09SignatureCleared extends Mau09Event {
  const Mau09SignatureCleared();
}

enum Mau09Status {
  initial,
  loading,
  generated,
  signing,
  signed,
  exporting,
  exportSuccess,
  failure,
}

class Mau09State extends Equatable {
  final Mau09Status status;
  final Mau09Document? document;
  final ValidationResult? validationResult;
  final SignatureInfo signatureInfo;
  final File? exportedFile;
  final String? message;
  final String? errorMessage;

  const Mau09State({
    this.status = Mau09Status.initial,
    this.document,
    this.validationResult,
    this.signatureInfo = const SignatureInfo(isSigned: false),
    this.exportedFile,
    this.message,
    this.errorMessage,
  });

  Mau09State copyWith({
    Mau09Status? status,
    Mau09Document? document,
    ValidationResult? validationResult,
    SignatureInfo? signatureInfo,
    File? exportedFile,
    String? message,
    String? errorMessage,
  }) {
    return Mau09State(
      status: status ?? this.status,
      document: document ?? this.document,
      validationResult: validationResult ?? this.validationResult,
      signatureInfo: signatureInfo ?? this.signatureInfo,
      exportedFile: exportedFile ?? this.exportedFile,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        document,
        validationResult,
        signatureInfo,
        exportedFile,
        message,
        errorMessage,
      ];
}
