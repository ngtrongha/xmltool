import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:xmltool/domain/entities/validation_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';

abstract class ImportEvent extends Equatable {
  const ImportEvent();

  @override
  List<Object?> get props => [];
}

class ImportOldXmlSelected extends ImportEvent {
  final File file;
  const ImportOldXmlSelected(this.file);

  @override
  List<Object?> get props => [file];
}

class ImportNewXmlSelected extends ImportEvent {
  final File file;
  const ImportNewXmlSelected(this.file);

  @override
  List<Object?> get props => [file];
}

class ImportResetRequested extends ImportEvent {}

enum ImportStatus { initial, loading, success, failure }

class ImportState extends Equatable {
  final ImportStatus status;
  final XmlEnvelope? oldEnvelope;
  final XmlEnvelope? newEnvelope;
  final ValidationResult? oldValidation;
  final ValidationResult? newValidation;
  final String? errorMessage;

  const ImportState({
    this.status = ImportStatus.initial,
    this.oldEnvelope,
    this.newEnvelope,
    this.oldValidation,
    this.newValidation,
    this.errorMessage,
  });

  bool get canCompare => oldEnvelope != null && newEnvelope != null;

  ImportState copyWith({
    ImportStatus? status,
    XmlEnvelope? oldEnvelope,
    XmlEnvelope? newEnvelope,
    ValidationResult? oldValidation,
    ValidationResult? newValidation,
    String? errorMessage,
  }) {
    return ImportState(
      status: status ?? this.status,
      oldEnvelope: oldEnvelope ?? this.oldEnvelope,
      newEnvelope: newEnvelope ?? this.newEnvelope,
      oldValidation: oldValidation ?? this.oldValidation,
      newValidation: newValidation ?? this.newValidation,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        oldEnvelope,
        newEnvelope,
        oldValidation,
        newValidation,
        errorMessage,
      ];
}
