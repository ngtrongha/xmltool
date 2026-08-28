import 'package:equatable/equatable.dart';
import 'package:xmltool/domain/entities/audit_entry.dart';

abstract class AuditEvent extends Equatable {
  const AuditEvent();

  @override
  List<Object?> get props => [];
}

class AuditLoadRequested extends AuditEvent {
  const AuditLoadRequested();
}

class AuditEntryAdded extends AuditEvent {
  final AuditEntry entry;
  const AuditEntryAdded(this.entry);

  @override
  List<Object?> get props => [entry];
}

class AuditClearRequested extends AuditEvent {
  const AuditClearRequested();
}

enum AuditStatus { initial, loading, success, failure }

class AuditState extends Equatable {
  final AuditStatus status;
  final List<AuditEntry> entries;
  final String? errorMessage;

  const AuditState({
    this.status = AuditStatus.initial,
    this.entries = const [],
    this.errorMessage,
  });

  AuditState copyWith({
    AuditStatus? status,
    List<AuditEntry>? entries,
    String? errorMessage,
  }) {
    return AuditState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, entries, errorMessage];
}
