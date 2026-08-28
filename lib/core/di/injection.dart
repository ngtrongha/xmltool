import 'package:get_it/get_it.dart';
import 'package:xmltool/application/services/compare_service.dart';
import 'package:xmltool/application/services/mau09_mapping_service.dart';
import 'package:xmltool/application/services/validation_service.dart';
import 'package:xmltool/application/services/xml_generation_service.dart';
import 'package:xmltool/application/services/xml_parse_service.dart';
import 'package:xmltool/application/usecases/compare_xml_usecase.dart';
import 'package:xmltool/application/usecases/export_usecase.dart';
import 'package:xmltool/application/usecases/generate_mau09_usecase.dart';
import 'package:xmltool/application/usecases/import_xml_usecase.dart';
import 'package:xmltool/domain/repositories/audit_repository.dart';
import 'package:xmltool/domain/repositories/comparison_repository.dart';
import 'package:xmltool/domain/repositories/export_repository.dart';
import 'package:xmltool/domain/repositories/mau09_repository.dart';
import 'package:xmltool/domain/repositories/xml_file_repository.dart';
import 'package:xmltool/infrastructure/database/app_database.dart';
import 'package:xmltool/infrastructure/repositories/drift_audit_repository.dart';
import 'package:xmltool/infrastructure/repositories/export_repository_impl.dart';
import 'package:xmltool/infrastructure/repositories/in_memory_repositories.dart';
import 'package:xmltool/infrastructure/xml/xml_parser.dart';
import 'package:xmltool/presentation/blocs/audit/audit_bloc.dart';
import 'package:xmltool/presentation/blocs/compare/compare_bloc.dart';
import 'package:xmltool/presentation/blocs/import/import_bloc.dart';
import 'package:xmltool/presentation/blocs/mau09/mau09_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Configure global dependencies and usecases
Future<void> configureDependencies() async {
  // 0. Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // 1. Repositories
  getIt.registerLazySingleton<XmlFileRepository>(() => BHYTXmlParser());
  getIt.registerLazySingleton<ComparisonRepository>(() => InMemoryComparisonRepository());
  getIt.registerLazySingleton<Mau09Repository>(() => InMemoryMau09Repository());
  getIt.registerLazySingleton<ExportRepository>(() => ExportRepositoryImpl());
  getIt.registerLazySingleton<AuditRepository>(() => DriftAuditRepository(getIt<AppDatabase>()));

  // 2. Services
  getIt.registerLazySingleton<XmlParseService>(() => XmlParseService(getIt<XmlFileRepository>()));
  getIt.registerLazySingleton<CompareService>(() => CompareService());
  getIt.registerLazySingleton<Mau09MappingService>(() => Mau09MappingService());
  getIt.registerLazySingleton<XmlGenerationService>(() => XmlGenerationService());
  getIt.registerLazySingleton<ValidationService>(() => ValidationService());

  // 3. UseCases
  getIt.registerFactory<ImportXmlUseCase>(() => ImportXmlUseCase(
        parseService: getIt<XmlParseService>(),
        validationService: getIt<ValidationService>(),
      ));

  getIt.registerFactory<CompareXmlUseCase>(() => CompareXmlUseCase(
        compareService: getIt<CompareService>(),
        comparisonRepository: getIt<ComparisonRepository>(),
      ));

  getIt.registerFactory<GenerateMau09UseCase>(() => GenerateMau09UseCase(
        mappingService: getIt<Mau09MappingService>(),
        validationService: getIt<ValidationService>(),
        repository: getIt<Mau09Repository>(),
      ));

  getIt.registerFactory<ExportUseCase>(() => ExportUseCase(getIt<ExportRepository>()));

  // 4. BLoCs
  getIt.registerFactory<ImportBloc>(() => ImportBloc(importXmlUseCase: getIt<ImportXmlUseCase>()));
  getIt.registerFactory<CompareBloc>(() => CompareBloc(
        compareXmlUseCase: getIt<CompareXmlUseCase>(),
        auditRepository: getIt<AuditRepository>(),
      ));
  getIt.registerFactory<Mau09Bloc>(() => Mau09Bloc(
        generateMau09UseCase: getIt<GenerateMau09UseCase>(),
        exportUseCase: getIt<ExportUseCase>(),
      ));
  getIt.registerFactory<AuditBloc>(() => AuditBloc(auditRepository: getIt<AuditRepository>()));
}
