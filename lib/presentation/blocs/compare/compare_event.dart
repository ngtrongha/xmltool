import 'package:equatable/equatable.dart';
import 'package:xmltool/config/standards/xml_definitions.dart';
import 'package:xmltool/domain/entities/compare_result.dart';
import 'package:xmltool/domain/entities/xml_envelope.dart';
import 'package:xmltool/domain/value_objects/change_type.dart';

abstract class CompareEvent extends Equatable {
  const CompareEvent();

  @override
  List<Object?> get props => [];
}

class CompareStarted extends CompareEvent {
  final XmlEnvelope oldEnvelope;
  final XmlEnvelope newEnvelope;

  const CompareStarted({
    required this.oldEnvelope,
    required this.newEnvelope,
  });

  @override
  List<Object?> get props => [oldEnvelope, newEnvelope];
}

class CompareFilterChanged extends CompareEvent {
  final XmlType? selectedXmlType;
  final ChangeType? selectedChangeType;
  final bool? onlyMau09Eligible;
  final String? searchQuery;

  const CompareFilterChanged({
    this.selectedXmlType,
    this.selectedChangeType,
    this.onlyMau09Eligible,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        selectedXmlType,
        selectedChangeType,
        onlyMau09Eligible,
        searchQuery,
      ];
}

enum CompareStatus { initial, loading, success, failure }

class CompareState extends Equatable {
  final CompareStatus status;
  final CompareResult? result;
  final XmlType? selectedXmlType;
  final ChangeType? selectedChangeType;
  final bool onlyMau09Eligible;
  final String searchQuery;
  final String? errorMessage;

  const CompareState({
    this.status = CompareStatus.initial,
    this.result,
    this.selectedXmlType,
    this.selectedChangeType,
    this.onlyMau09Eligible = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  CompareState copyWith({
    CompareStatus? status,
    CompareResult? result,
    XmlType? selectedXmlType,
    ChangeType? selectedChangeType,
    bool? onlyMau09Eligible,
    String? searchQuery,
    String? errorMessage,
  }) {
    return CompareState(
      status: status ?? this.status,
      result: result ?? this.result,
      selectedXmlType: selectedXmlType ?? this.selectedXmlType,
      selectedChangeType: selectedChangeType ?? this.selectedChangeType,
      onlyMau09Eligible: onlyMau09Eligible ?? this.onlyMau09Eligible,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        result,
        selectedXmlType,
        selectedChangeType,
        onlyMau09Eligible,
        searchQuery,
        errorMessage,
      ];
}
