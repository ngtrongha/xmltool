import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/core/logging/app_talker.dart';
import 'package:xmltool/domain/repositories/audit_repository.dart';
import 'package:xmltool/presentation/blocs/audit/audit_event.dart';

class AuditBloc extends Bloc<AuditEvent, AuditState> {
  final AuditRepository auditRepository;

  AuditBloc({required this.auditRepository}) : super(const AuditState()) {
    on<AuditLoadRequested>(_onLoadRequested);
    on<AuditEntryAdded>(_onEntryAdded);
    on<AuditClearRequested>(_onClearRequested);
  }

  Future<void> _onLoadRequested(
    AuditLoadRequested event,
    Emitter<AuditState> emit,
  ) async {
    emit(state.copyWith(status: AuditStatus.loading));
    try {
      final entries = await auditRepository.getEntries();
      emit(state.copyWith(status: AuditStatus.success, entries: entries));
    } catch (e, st) {
      appTalker.handle(e, st, 'Failed to load audit logs');
      emit(state.copyWith(
        status: AuditStatus.failure,
        errorMessage: 'Lỗi tải lịch sử đối soát: $e',
      ));
    }
  }

  Future<void> _onEntryAdded(
    AuditEntryAdded event,
    Emitter<AuditState> emit,
  ) async {
    try {
      await auditRepository.logEntry(event.entry);
      add(const AuditLoadRequested());
    } catch (e, st) {
      appTalker.handle(e, st, 'Failed to save audit log');
    }
  }

  Future<void> _onClearRequested(
    AuditClearRequested event,
    Emitter<AuditState> emit,
  ) async {
    emit(state.copyWith(status: AuditStatus.loading));
    try {
      await auditRepository.clearAll();
      emit(state.copyWith(status: AuditStatus.success, entries: []));
    } catch (e, st) {
      appTalker.handle(e, st, 'Failed to clear audit logs');
      emit(state.copyWith(
        status: AuditStatus.failure,
        errorMessage: 'Lỗi xóa lịch sử: $e',
      ));
    }
  }
}
