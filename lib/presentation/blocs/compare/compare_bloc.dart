import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/application/usecases/compare_xml_usecase.dart';
import 'package:xmltool/core/logging/app_talker.dart';
import 'package:xmltool/domain/entities/audit_entry.dart';
import 'package:xmltool/domain/repositories/audit_repository.dart';
import 'package:xmltool/presentation/blocs/compare/compare_event.dart';

export 'package:xmltool/presentation/blocs/compare/compare_event.dart';

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final CompareXmlUseCase compareXmlUseCase;
  final AuditRepository? auditRepository;

  CompareBloc({
    required this.compareXmlUseCase,
    this.auditRepository,
  }) : super(const CompareState()) {
    on<CompareStarted>(_onCompareStarted);
    on<CompareFilterChanged>(_onFilterChanged);
  }

  Future<void> _onCompareStarted(
    CompareStarted event,
    Emitter<CompareState> emit,
  ) async {
    emit(state.copyWith(status: CompareStatus.loading));
    try {
      final result = await compareXmlUseCase.execute(
        oldEnvelope: event.oldEnvelope,
        newEnvelope: event.newEnvelope,
      );

      appTalker.info(
        'Comparison finished: ${result.totalRecords} records '
        '(${result.unchangedCount} unchanged, ${result.changedCount} changed, '
        '${result.addedCount} added, ${result.removedCount} removed)',
      );

      if (auditRepository != null) {
        await auditRepository!.logEntry(
          AuditEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            timestamp: DateTime.now(),
            oldFileName: event.oldEnvelope.filePath?.split(Platform.pathSeparator).last ?? 'XML Cũ',
            newFileName: event.newEnvelope.filePath?.split(Platform.pathSeparator).last ?? 'XML Mới',
            oldFileHash: event.oldEnvelope.fileHash ?? '',
            newFileHash: event.newEnvelope.fileHash ?? '',
            standardVersion: 'QĐ 3176',
            totalClaims: event.oldEnvelope.soLuongHoSo,
            totalChanges: result.changedCount,
            totalMau09Rows: result.mau09EligibleCount,
          ),
        );
      }

      emit(state.copyWith(
        status: CompareStatus.success,
        result: result,
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Error running compare');
      emit(state.copyWith(
        status: CompareStatus.failure,
        errorMessage: 'Lỗi đối soát XML: $e',
      ));
    }
  }

  void _onFilterChanged(
    CompareFilterChanged event,
    Emitter<CompareState> emit,
  ) {
    emit(state.copyWith(
      selectedXmlType: event.selectedXmlType,
      selectedChangeType: event.selectedChangeType,
      onlyMau09Eligible: event.onlyMau09Eligible,
      searchQuery: event.searchQuery,
    ));
  }
}
