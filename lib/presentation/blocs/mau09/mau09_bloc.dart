import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmltool/application/services/xml_generation_service.dart';
import 'package:xmltool/application/usecases/export_usecase.dart';
import 'package:xmltool/application/usecases/generate_mau09_usecase.dart';
import 'package:xmltool/core/logging/app_talker.dart';
import 'package:xmltool/domain/entities/mau09_document.dart';
import 'package:xmltool/domain/entities/mau09_row.dart';
import 'package:xmltool/domain/entities/signature_info.dart';
import 'package:xmltool/infrastructure/security/bhyt_digital_signer.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_event.dart';

export 'package:xmltool/presentation/blocs/mau09/mau09_event.dart';

class Mau09Bloc extends Bloc<Mau09Event, Mau09State> {
  final GenerateMau09UseCase generateMau09UseCase;
  final ExportUseCase exportUseCase;
  final BHYTDigitalSigner digitalSigner;
  final XmlGenerationService xmlGenerationService;

  Mau09Bloc({
    required this.generateMau09UseCase,
    required this.exportUseCase,
    required this.digitalSigner,
    required this.xmlGenerationService,
  }) : super(const Mau09State()) {
    on<Mau09GenerateRequested>(_onGenerateRequested);
    on<Mau09RowReasonUpdated>(_onReasonUpdated);
    on<Mau09BulkReasonUpdated>(_onBulkReasonUpdated);
    on<Mau09DigitalSignatureApplied>(_onDigitalSignatureApplied);
    on<Mau09SignatureVerified>(_onSignatureVerified);
    on<Mau09SignatureCleared>(_onSignatureCleared);
    on<Mau09ExportXmlRequested>(_onExportXmlRequested);
    on<Mau09ExportExcelRequested>(_onExportExcelRequested);
  }

  Future<void> _onGenerateRequested(
    Mau09GenerateRequested event,
    Emitter<Mau09State> emit,
  ) async {
    emit(state.copyWith(status: Mau09Status.loading));
    try {
      final result = await generateMau09UseCase.execute(
        compareResult: event.compareResult,
        newEnvelope: event.newEnvelope,
        oldEnvelope: event.oldEnvelope,
        defaultReason: event.defaultReason,
      );

      appTalker.info(
        'Generated Mẫu 09: ${result.document.totalRows} rows across ${result.document.totalClaims} claims. '
        'Valid: ${result.validationResult.isValid}',
      );

      emit(state.copyWith(
        status: Mau09Status.generated,
        document: result.document,
        validationResult: result.validationResult,
        signatureInfo: SignatureInfo.unsigned(),
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Error generating Mẫu 09');
      emit(state.copyWith(
        status: Mau09Status.failure,
        errorMessage: 'Lỗi sinh Mẫu 09: $e',
      ));
    }
  }

  void _onReasonUpdated(
    Mau09RowReasonUpdated event,
    Emitter<Mau09State> emit,
  ) {
    if (state.document == null) return;

    final updatedHoSoList = <Mau09HoSo>[];
    for (final hs in state.document!.hoSoList) {
      final updatedRows = <Mau09Row>[];
      for (final row in hs.rows) {
        if (row.stt == event.stt) {
          updatedRows.add(row.copyWith(lyDoDc: event.newReason));
        } else {
          updatedRows.add(row);
        }
      }
      updatedHoSoList.add(Mau09HoSo(maLk: hs.maLk, rows: updatedRows));
    }

    final updatedDoc = Mau09Document(
      maCskcb: state.document!.maCskcb,
      maTinh: state.document!.maTinh,
      tenTinh: state.document!.tenTinh,
      ngayLap: state.document!.ngayLap,
      hoSoList: updatedHoSoList,
      chuKySo: null, // Reset signature upon modifying payload
    );

    emit(state.copyWith(
      document: updatedDoc,
      signatureInfo: SignatureInfo.unsigned(),
    ));
  }

  void _onBulkReasonUpdated(
    Mau09BulkReasonUpdated event,
    Emitter<Mau09State> emit,
  ) {
    if (state.document == null) return;

    final updatedHoSoList = <Mau09HoSo>[];
    for (final hs in state.document!.hoSoList) {
      final updatedRows = hs.rows.map((row) => row.copyWith(lyDoDc: event.newReason)).toList();
      updatedHoSoList.add(Mau09HoSo(maLk: hs.maLk, rows: updatedRows));
    }

    final updatedDoc = Mau09Document(
      maCskcb: state.document!.maCskcb,
      maTinh: state.document!.maTinh,
      tenTinh: state.document!.tenTinh,
      ngayLap: state.document!.ngayLap,
      hoSoList: updatedHoSoList,
      chuKySo: null, // Reset signature upon modifying payload
    );

    emit(state.copyWith(
      document: updatedDoc,
      signatureInfo: SignatureInfo.unsigned(),
    ));
  }

  void _onDigitalSignatureApplied(
    Mau09DigitalSignatureApplied event,
    Emitter<Mau09State> emit,
  ) {
    if (state.document == null) return;
    emit(state.copyWith(status: Mau09Status.signing));

    try {
      final unsignedXml = xmlGenerationService.generateMau09XmlString(state.document!);
      final signedXml = digitalSigner.signXmlDocument(
        xmlContent: unsignedXml,
        privateKey: event.privateKey,
        certificate: event.certificate,
      );

      final verification = digitalSigner.verifySignature(xmlContent: signedXml);

      // Extract raw signature block to store in Mau09Document.chuKySo
      final sigMatch = RegExp(r'<CHUKYSO>([\s\S]*?)</CHUKYSO>').firstMatch(signedXml);
      final sigContent = sigMatch?.group(1)?.trim();

      final updatedDoc = Mau09Document(
        maCskcb: state.document!.maCskcb,
        maTinh: state.document!.maTinh,
        tenTinh: state.document!.tenTinh,
        ngayLap: state.document!.ngayLap,
        hoSoList: state.document!.hoSoList,
        chuKySo: sigContent,
      );

      appTalker.info('Digital signature applied successfully: ${event.certificate.displayName}');

      emit(state.copyWith(
        status: Mau09Status.signed,
        document: updatedDoc,
        signatureInfo: verification,
        message: 'Đã ký số điện tử thành công theo chuẩn BHXH (XMLDSig RSA-SHA256)',
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Error signing document');
      emit(state.copyWith(
        status: Mau09Status.failure,
        errorMessage: 'Lỗi ký số XML: $e',
      ));
    }
  }

  void _onSignatureVerified(
    Mau09SignatureVerified event,
    Emitter<Mau09State> emit,
  ) {
    if (state.document == null || state.document!.chuKySo == null) {
      emit(state.copyWith(signatureInfo: SignatureInfo.unsigned()));
      return;
    }

    try {
      final xml = xmlGenerationService.generateMau09XmlString(state.document!);
      final verification = digitalSigner.verifySignature(xmlContent: xml);
      emit(state.copyWith(signatureInfo: verification));
    } catch (e, st) {
      appTalker.handle(e, st, 'Error verifying signature');
    }
  }

  void _onSignatureCleared(
    Mau09SignatureCleared event,
    Emitter<Mau09State> emit,
  ) {
    if (state.document == null) return;

    final updatedDoc = Mau09Document(
      maCskcb: state.document!.maCskcb,
      maTinh: state.document!.maTinh,
      tenTinh: state.document!.tenTinh,
      ngayLap: state.document!.ngayLap,
      hoSoList: state.document!.hoSoList,
      chuKySo: null,
    );

    emit(state.copyWith(
      document: updatedDoc,
      signatureInfo: SignatureInfo.unsigned(),
    ));
  }

  Future<void> _onExportXmlRequested(
    Mau09ExportXmlRequested event,
    Emitter<Mau09State> emit,
  ) async {
    if (state.document == null) return;
    emit(state.copyWith(status: Mau09Status.exporting));
    try {
      final file = await exportUseCase.exportXml(state.document!, event.targetPath);
      appTalker.info('Exported Mẫu 09 XML to ${file.path}');
      emit(state.copyWith(
        status: Mau09Status.exportSuccess,
        exportedFile: file,
        message: 'Đã xuất tệp XML Mẫu 09 thành công tại: ${file.path}',
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Error exporting XML');
      emit(state.copyWith(
        status: Mau09Status.failure,
        errorMessage: 'Lỗi xuất XML: $e',
      ));
    }
  }

  Future<void> _onExportExcelRequested(
    Mau09ExportExcelRequested event,
    Emitter<Mau09State> emit,
  ) async {
    emit(state.copyWith(status: Mau09Status.exporting));
    try {
      final file = await exportUseCase.exportExcel(
        compareResult: event.compareResult,
        mau09Document: state.document,
        targetPath: event.targetPath,
      );
      appTalker.info('Exported Excel report to ${file.path}');
      emit(state.copyWith(
        status: Mau09Status.exportSuccess,
        exportedFile: file,
        message: 'Đã xuất báo cáo Excel thành công tại: ${file.path}',
      ));
    } catch (e, st) {
      appTalker.handle(e, st, 'Error exporting Excel');
      emit(state.copyWith(
        status: Mau09Status.failure,
        errorMessage: 'Lỗi xuất Excel: $e',
      ));
    }
  }
}
