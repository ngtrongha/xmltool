import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/application/usecases/import_xml_usecase.dart';
import 'package:xmltool/core/logging/app_talker.dart';
import 'package:xmltool/presentation/blocs/import/import_event.dart';

export 'package:xmltool/presentation/blocs/import/import_event.dart';

class ImportBloc extends Bloc<ImportEvent, ImportState> {
  final ImportXmlUseCase importXmlUseCase;

  ImportBloc({required this.importXmlUseCase}) : super(const ImportState()) {
    on<ImportOldXmlSelected>(_onOldXmlSelected);
    on<ImportNewXmlSelected>(_onNewXmlSelected);
    on<ImportResetRequested>(_onResetRequested);
  }

  Future<void> _onOldXmlSelected(
    ImportOldXmlSelected event,
    Emitter<ImportState> emit,
  ) async {
    emit(state.copyWith(status: ImportStatus.loading));
    try {
      final result = await importXmlUseCase.execute(event.file);
      appTalker.info('Imported Old XML: ${event.file.path} (${result.envelope.totalRecords} records)');
      emit(state.copyWith(
        status: ImportStatus.success,
        oldEnvelope: result.envelope,
        oldValidation: result.validationResult,
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Failed to import Old XML');
      emit(state.copyWith(
        status: ImportStatus.failure,
        errorMessage: 'Lỗi đọc file XML cũ: $e',
      ));
    }
  }

  Future<void> _onNewXmlSelected(
    ImportNewXmlSelected event,
    Emitter<ImportState> emit,
  ) async {
    emit(state.copyWith(status: ImportStatus.loading));
    try {
      final result = await importXmlUseCase.execute(event.file);
      appTalker.info('Imported New XML: ${event.file.path} (${result.envelope.totalRecords} records)');
      emit(state.copyWith(
        status: ImportStatus.success,
        newEnvelope: result.envelope,
        newValidation: result.validationResult,
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Failed to import New XML');
      emit(state.copyWith(
        status: ImportStatus.failure,
        errorMessage: 'Lỗi đọc file XML mới: $e',
      ));
    }
  }

  void _onResetRequested(
    ImportResetRequested event,
    Emitter<ImportState> emit,
  ) {
    emit(const ImportState());
  }
}
