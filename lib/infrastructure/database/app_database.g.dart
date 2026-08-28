// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldFileNameMeta = const VerificationMeta(
    'oldFileName',
  );
  @override
  late final GeneratedColumn<String> oldFileName = GeneratedColumn<String>(
    'old_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _newFileNameMeta = const VerificationMeta(
    'newFileName',
  );
  @override
  late final GeneratedColumn<String> newFileName = GeneratedColumn<String>(
    'new_file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _oldFileHashMeta = const VerificationMeta(
    'oldFileHash',
  );
  @override
  late final GeneratedColumn<String> oldFileHash = GeneratedColumn<String>(
    'old_file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _newFileHashMeta = const VerificationMeta(
    'newFileHash',
  );
  @override
  late final GeneratedColumn<String> newFileHash = GeneratedColumn<String>(
    'new_file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _outputFileNameMeta = const VerificationMeta(
    'outputFileName',
  );
  @override
  late final GeneratedColumn<String> outputFileName = GeneratedColumn<String>(
    'output_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outputFileHashMeta = const VerificationMeta(
    'outputFileHash',
  );
  @override
  late final GeneratedColumn<String> outputFileHash = GeneratedColumn<String>(
    'output_file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _standardVersionMeta = const VerificationMeta(
    'standardVersion',
  );
  @override
  late final GeneratedColumn<String> standardVersion = GeneratedColumn<String>(
    'standard_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('QĐ 3176'),
  );
  static const VerificationMeta _totalClaimsMeta = const VerificationMeta(
    'totalClaims',
  );
  @override
  late final GeneratedColumn<int> totalClaims = GeneratedColumn<int>(
    'total_claims',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalChangesMeta = const VerificationMeta(
    'totalChanges',
  );
  @override
  late final GeneratedColumn<int> totalChanges = GeneratedColumn<int>(
    'total_changes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMau09RowsMeta = const VerificationMeta(
    'totalMau09Rows',
  );
  @override
  late final GeneratedColumn<int> totalMau09Rows = GeneratedColumn<int>(
    'total_mau09_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    oldFileName,
    newFileName,
    oldFileHash,
    newFileHash,
    outputFileName,
    outputFileHash,
    standardVersion,
    totalClaims,
    totalChanges,
    totalMau09Rows,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('old_file_name')) {
      context.handle(
        _oldFileNameMeta,
        oldFileName.isAcceptableOrUnknown(
          data['old_file_name']!,
          _oldFileNameMeta,
        ),
      );
    }
    if (data.containsKey('new_file_name')) {
      context.handle(
        _newFileNameMeta,
        newFileName.isAcceptableOrUnknown(
          data['new_file_name']!,
          _newFileNameMeta,
        ),
      );
    }
    if (data.containsKey('old_file_hash')) {
      context.handle(
        _oldFileHashMeta,
        oldFileHash.isAcceptableOrUnknown(
          data['old_file_hash']!,
          _oldFileHashMeta,
        ),
      );
    }
    if (data.containsKey('new_file_hash')) {
      context.handle(
        _newFileHashMeta,
        newFileHash.isAcceptableOrUnknown(
          data['new_file_hash']!,
          _newFileHashMeta,
        ),
      );
    }
    if (data.containsKey('output_file_name')) {
      context.handle(
        _outputFileNameMeta,
        outputFileName.isAcceptableOrUnknown(
          data['output_file_name']!,
          _outputFileNameMeta,
        ),
      );
    }
    if (data.containsKey('output_file_hash')) {
      context.handle(
        _outputFileHashMeta,
        outputFileHash.isAcceptableOrUnknown(
          data['output_file_hash']!,
          _outputFileHashMeta,
        ),
      );
    }
    if (data.containsKey('standard_version')) {
      context.handle(
        _standardVersionMeta,
        standardVersion.isAcceptableOrUnknown(
          data['standard_version']!,
          _standardVersionMeta,
        ),
      );
    }
    if (data.containsKey('total_claims')) {
      context.handle(
        _totalClaimsMeta,
        totalClaims.isAcceptableOrUnknown(
          data['total_claims']!,
          _totalClaimsMeta,
        ),
      );
    }
    if (data.containsKey('total_changes')) {
      context.handle(
        _totalChangesMeta,
        totalChanges.isAcceptableOrUnknown(
          data['total_changes']!,
          _totalChangesMeta,
        ),
      );
    }
    if (data.containsKey('total_mau09_rows')) {
      context.handle(
        _totalMau09RowsMeta,
        totalMau09Rows.isAcceptableOrUnknown(
          data['total_mau09_rows']!,
          _totalMau09RowsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      oldFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_file_name'],
      )!,
      newFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_file_name'],
      )!,
      oldFileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_file_hash'],
      )!,
      newFileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_file_hash'],
      )!,
      outputFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_file_name'],
      ),
      outputFileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_file_hash'],
      ),
      standardVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}standard_version'],
      )!,
      totalClaims: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_claims'],
      )!,
      totalChanges: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_changes'],
      )!,
      totalMau09Rows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_mau09_rows'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final DateTime timestamp;
  final String oldFileName;
  final String newFileName;
  final String oldFileHash;
  final String newFileHash;
  final String? outputFileName;
  final String? outputFileHash;
  final String standardVersion;
  final int totalClaims;
  final int totalChanges;
  final int totalMau09Rows;
  final String? note;
  const AuditLog({
    required this.id,
    required this.timestamp,
    required this.oldFileName,
    required this.newFileName,
    required this.oldFileHash,
    required this.newFileHash,
    this.outputFileName,
    this.outputFileHash,
    required this.standardVersion,
    required this.totalClaims,
    required this.totalChanges,
    required this.totalMau09Rows,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['old_file_name'] = Variable<String>(oldFileName);
    map['new_file_name'] = Variable<String>(newFileName);
    map['old_file_hash'] = Variable<String>(oldFileHash);
    map['new_file_hash'] = Variable<String>(newFileHash);
    if (!nullToAbsent || outputFileName != null) {
      map['output_file_name'] = Variable<String>(outputFileName);
    }
    if (!nullToAbsent || outputFileHash != null) {
      map['output_file_hash'] = Variable<String>(outputFileHash);
    }
    map['standard_version'] = Variable<String>(standardVersion);
    map['total_claims'] = Variable<int>(totalClaims);
    map['total_changes'] = Variable<int>(totalChanges);
    map['total_mau09_rows'] = Variable<int>(totalMau09Rows);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      oldFileName: Value(oldFileName),
      newFileName: Value(newFileName),
      oldFileHash: Value(oldFileHash),
      newFileHash: Value(newFileHash),
      outputFileName: outputFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(outputFileName),
      outputFileHash: outputFileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(outputFileHash),
      standardVersion: Value(standardVersion),
      totalClaims: Value(totalClaims),
      totalChanges: Value(totalChanges),
      totalMau09Rows: Value(totalMau09Rows),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory AuditLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      oldFileName: serializer.fromJson<String>(json['oldFileName']),
      newFileName: serializer.fromJson<String>(json['newFileName']),
      oldFileHash: serializer.fromJson<String>(json['oldFileHash']),
      newFileHash: serializer.fromJson<String>(json['newFileHash']),
      outputFileName: serializer.fromJson<String?>(json['outputFileName']),
      outputFileHash: serializer.fromJson<String?>(json['outputFileHash']),
      standardVersion: serializer.fromJson<String>(json['standardVersion']),
      totalClaims: serializer.fromJson<int>(json['totalClaims']),
      totalChanges: serializer.fromJson<int>(json['totalChanges']),
      totalMau09Rows: serializer.fromJson<int>(json['totalMau09Rows']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'oldFileName': serializer.toJson<String>(oldFileName),
      'newFileName': serializer.toJson<String>(newFileName),
      'oldFileHash': serializer.toJson<String>(oldFileHash),
      'newFileHash': serializer.toJson<String>(newFileHash),
      'outputFileName': serializer.toJson<String?>(outputFileName),
      'outputFileHash': serializer.toJson<String?>(outputFileHash),
      'standardVersion': serializer.toJson<String>(standardVersion),
      'totalClaims': serializer.toJson<int>(totalClaims),
      'totalChanges': serializer.toJson<int>(totalChanges),
      'totalMau09Rows': serializer.toJson<int>(totalMau09Rows),
      'note': serializer.toJson<String?>(note),
    };
  }

  AuditLog copyWith({
    int? id,
    DateTime? timestamp,
    String? oldFileName,
    String? newFileName,
    String? oldFileHash,
    String? newFileHash,
    Value<String?> outputFileName = const Value.absent(),
    Value<String?> outputFileHash = const Value.absent(),
    String? standardVersion,
    int? totalClaims,
    int? totalChanges,
    int? totalMau09Rows,
    Value<String?> note = const Value.absent(),
  }) => AuditLog(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    oldFileName: oldFileName ?? this.oldFileName,
    newFileName: newFileName ?? this.newFileName,
    oldFileHash: oldFileHash ?? this.oldFileHash,
    newFileHash: newFileHash ?? this.newFileHash,
    outputFileName: outputFileName.present
        ? outputFileName.value
        : this.outputFileName,
    outputFileHash: outputFileHash.present
        ? outputFileHash.value
        : this.outputFileHash,
    standardVersion: standardVersion ?? this.standardVersion,
    totalClaims: totalClaims ?? this.totalClaims,
    totalChanges: totalChanges ?? this.totalChanges,
    totalMau09Rows: totalMau09Rows ?? this.totalMau09Rows,
    note: note.present ? note.value : this.note,
  );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      oldFileName: data.oldFileName.present
          ? data.oldFileName.value
          : this.oldFileName,
      newFileName: data.newFileName.present
          ? data.newFileName.value
          : this.newFileName,
      oldFileHash: data.oldFileHash.present
          ? data.oldFileHash.value
          : this.oldFileHash,
      newFileHash: data.newFileHash.present
          ? data.newFileHash.value
          : this.newFileHash,
      outputFileName: data.outputFileName.present
          ? data.outputFileName.value
          : this.outputFileName,
      outputFileHash: data.outputFileHash.present
          ? data.outputFileHash.value
          : this.outputFileHash,
      standardVersion: data.standardVersion.present
          ? data.standardVersion.value
          : this.standardVersion,
      totalClaims: data.totalClaims.present
          ? data.totalClaims.value
          : this.totalClaims,
      totalChanges: data.totalChanges.present
          ? data.totalChanges.value
          : this.totalChanges,
      totalMau09Rows: data.totalMau09Rows.present
          ? data.totalMau09Rows.value
          : this.totalMau09Rows,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('oldFileName: $oldFileName, ')
          ..write('newFileName: $newFileName, ')
          ..write('oldFileHash: $oldFileHash, ')
          ..write('newFileHash: $newFileHash, ')
          ..write('outputFileName: $outputFileName, ')
          ..write('outputFileHash: $outputFileHash, ')
          ..write('standardVersion: $standardVersion, ')
          ..write('totalClaims: $totalClaims, ')
          ..write('totalChanges: $totalChanges, ')
          ..write('totalMau09Rows: $totalMau09Rows, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    oldFileName,
    newFileName,
    oldFileHash,
    newFileHash,
    outputFileName,
    outputFileHash,
    standardVersion,
    totalClaims,
    totalChanges,
    totalMau09Rows,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.oldFileName == this.oldFileName &&
          other.newFileName == this.newFileName &&
          other.oldFileHash == this.oldFileHash &&
          other.newFileHash == this.newFileHash &&
          other.outputFileName == this.outputFileName &&
          other.outputFileHash == this.outputFileHash &&
          other.standardVersion == this.standardVersion &&
          other.totalClaims == this.totalClaims &&
          other.totalChanges == this.totalChanges &&
          other.totalMau09Rows == this.totalMau09Rows &&
          other.note == this.note);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> oldFileName;
  final Value<String> newFileName;
  final Value<String> oldFileHash;
  final Value<String> newFileHash;
  final Value<String?> outputFileName;
  final Value<String?> outputFileHash;
  final Value<String> standardVersion;
  final Value<int> totalClaims;
  final Value<int> totalChanges;
  final Value<int> totalMau09Rows;
  final Value<String?> note;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.oldFileName = const Value.absent(),
    this.newFileName = const Value.absent(),
    this.oldFileHash = const Value.absent(),
    this.newFileHash = const Value.absent(),
    this.outputFileName = const Value.absent(),
    this.outputFileHash = const Value.absent(),
    this.standardVersion = const Value.absent(),
    this.totalClaims = const Value.absent(),
    this.totalChanges = const Value.absent(),
    this.totalMau09Rows = const Value.absent(),
    this.note = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    this.oldFileName = const Value.absent(),
    this.newFileName = const Value.absent(),
    this.oldFileHash = const Value.absent(),
    this.newFileHash = const Value.absent(),
    this.outputFileName = const Value.absent(),
    this.outputFileHash = const Value.absent(),
    this.standardVersion = const Value.absent(),
    this.totalClaims = const Value.absent(),
    this.totalChanges = const Value.absent(),
    this.totalMau09Rows = const Value.absent(),
    this.note = const Value.absent(),
  }) : timestamp = Value(timestamp);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? oldFileName,
    Expression<String>? newFileName,
    Expression<String>? oldFileHash,
    Expression<String>? newFileHash,
    Expression<String>? outputFileName,
    Expression<String>? outputFileHash,
    Expression<String>? standardVersion,
    Expression<int>? totalClaims,
    Expression<int>? totalChanges,
    Expression<int>? totalMau09Rows,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (oldFileName != null) 'old_file_name': oldFileName,
      if (newFileName != null) 'new_file_name': newFileName,
      if (oldFileHash != null) 'old_file_hash': oldFileHash,
      if (newFileHash != null) 'new_file_hash': newFileHash,
      if (outputFileName != null) 'output_file_name': outputFileName,
      if (outputFileHash != null) 'output_file_hash': outputFileHash,
      if (standardVersion != null) 'standard_version': standardVersion,
      if (totalClaims != null) 'total_claims': totalClaims,
      if (totalChanges != null) 'total_changes': totalChanges,
      if (totalMau09Rows != null) 'total_mau09_rows': totalMau09Rows,
      if (note != null) 'note': note,
    });
  }

  AuditLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? oldFileName,
    Value<String>? newFileName,
    Value<String>? oldFileHash,
    Value<String>? newFileHash,
    Value<String?>? outputFileName,
    Value<String?>? outputFileHash,
    Value<String>? standardVersion,
    Value<int>? totalClaims,
    Value<int>? totalChanges,
    Value<int>? totalMau09Rows,
    Value<String?>? note,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      oldFileName: oldFileName ?? this.oldFileName,
      newFileName: newFileName ?? this.newFileName,
      oldFileHash: oldFileHash ?? this.oldFileHash,
      newFileHash: newFileHash ?? this.newFileHash,
      outputFileName: outputFileName ?? this.outputFileName,
      outputFileHash: outputFileHash ?? this.outputFileHash,
      standardVersion: standardVersion ?? this.standardVersion,
      totalClaims: totalClaims ?? this.totalClaims,
      totalChanges: totalChanges ?? this.totalChanges,
      totalMau09Rows: totalMau09Rows ?? this.totalMau09Rows,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (oldFileName.present) {
      map['old_file_name'] = Variable<String>(oldFileName.value);
    }
    if (newFileName.present) {
      map['new_file_name'] = Variable<String>(newFileName.value);
    }
    if (oldFileHash.present) {
      map['old_file_hash'] = Variable<String>(oldFileHash.value);
    }
    if (newFileHash.present) {
      map['new_file_hash'] = Variable<String>(newFileHash.value);
    }
    if (outputFileName.present) {
      map['output_file_name'] = Variable<String>(outputFileName.value);
    }
    if (outputFileHash.present) {
      map['output_file_hash'] = Variable<String>(outputFileHash.value);
    }
    if (standardVersion.present) {
      map['standard_version'] = Variable<String>(standardVersion.value);
    }
    if (totalClaims.present) {
      map['total_claims'] = Variable<int>(totalClaims.value);
    }
    if (totalChanges.present) {
      map['total_changes'] = Variable<int>(totalChanges.value);
    }
    if (totalMau09Rows.present) {
      map['total_mau09_rows'] = Variable<int>(totalMau09Rows.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('oldFileName: $oldFileName, ')
          ..write('newFileName: $newFileName, ')
          ..write('oldFileHash: $oldFileHash, ')
          ..write('newFileHash: $newFileHash, ')
          ..write('outputFileName: $outputFileName, ')
          ..write('outputFileHash: $outputFileHash, ')
          ..write('standardVersion: $standardVersion, ')
          ..write('totalClaims: $totalClaims, ')
          ..write('totalChanges: $totalChanges, ')
          ..write('totalMau09Rows: $totalMau09Rows, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _standardVersionMeta = const VerificationMeta(
    'standardVersion',
  );
  @override
  late final GeneratedColumn<String> standardVersion = GeneratedColumn<String>(
    'standard_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    standardVersion,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('standard_version')) {
      context.handle(
        _standardVersionMeta,
        standardVersion.isAcceptableOrUnknown(
          data['standard_version']!,
          _standardVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_standardVersionMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      standardVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}standard_version'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final DateTime createdAt;
  final String standardVersion;
  final String? description;
  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.standardVersion,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['standard_version'] = Variable<String>(standardVersion);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      standardVersion: Value(standardVersion),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      standardVersion: serializer.fromJson<String>(json['standardVersion']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'standardVersion': serializer.toJson<String>(standardVersion),
      'description': serializer.toJson<String?>(description),
    };
  }

  Project copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    String? standardVersion,
    Value<String?> description = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    standardVersion: standardVersion ?? this.standardVersion,
    description: description.present ? description.value : this.description,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      standardVersion: data.standardVersion.present
          ? data.standardVersion.value
          : this.standardVersion,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('standardVersion: $standardVersion, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, createdAt, standardVersion, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.standardVersion == this.standardVersion &&
          other.description == this.description);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<String> standardVersion;
  final Value<String?> description;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.standardVersion = const Value.absent(),
    this.description = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    required String standardVersion,
    this.description = const Value.absent(),
  }) : name = Value(name),
       createdAt = Value(createdAt),
       standardVersion = Value(standardVersion);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<String>? standardVersion,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (standardVersion != null) 'standard_version': standardVersion,
      if (description != null) 'description': description,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<String>? standardVersion,
    Value<String?>? description,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      standardVersion: standardVersion ?? this.standardVersion,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (standardVersion.present) {
      map['standard_version'] = Variable<String>(standardVersion.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('standardVersion: $standardVersion, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [auditLogs, projects];
}

typedef $$AuditLogsTableCreateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      Value<String> oldFileName,
      Value<String> newFileName,
      Value<String> oldFileHash,
      Value<String> newFileHash,
      Value<String?> outputFileName,
      Value<String?> outputFileHash,
      Value<String> standardVersion,
      Value<int> totalClaims,
      Value<int> totalChanges,
      Value<int> totalMau09Rows,
      Value<String?> note,
    });
typedef $$AuditLogsTableUpdateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> oldFileName,
      Value<String> newFileName,
      Value<String> oldFileHash,
      Value<String> newFileHash,
      Value<String?> outputFileName,
      Value<String?> outputFileHash,
      Value<String> standardVersion,
      Value<int> totalClaims,
      Value<int> totalChanges,
      Value<int> totalMau09Rows,
      Value<String?> note,
    });

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldFileName => $composableBuilder(
    column: $table.oldFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newFileName => $composableBuilder(
    column: $table.newFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldFileHash => $composableBuilder(
    column: $table.oldFileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newFileHash => $composableBuilder(
    column: $table.newFileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputFileName => $composableBuilder(
    column: $table.outputFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputFileHash => $composableBuilder(
    column: $table.outputFileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get standardVersion => $composableBuilder(
    column: $table.standardVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalClaims => $composableBuilder(
    column: $table.totalClaims,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalChanges => $composableBuilder(
    column: $table.totalChanges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMau09Rows => $composableBuilder(
    column: $table.totalMau09Rows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldFileName => $composableBuilder(
    column: $table.oldFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newFileName => $composableBuilder(
    column: $table.newFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldFileHash => $composableBuilder(
    column: $table.oldFileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newFileHash => $composableBuilder(
    column: $table.newFileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputFileName => $composableBuilder(
    column: $table.outputFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputFileHash => $composableBuilder(
    column: $table.outputFileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get standardVersion => $composableBuilder(
    column: $table.standardVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalClaims => $composableBuilder(
    column: $table.totalClaims,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalChanges => $composableBuilder(
    column: $table.totalChanges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMau09Rows => $composableBuilder(
    column: $table.totalMau09Rows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get oldFileName => $composableBuilder(
    column: $table.oldFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newFileName => $composableBuilder(
    column: $table.newFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oldFileHash => $composableBuilder(
    column: $table.oldFileHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newFileHash => $composableBuilder(
    column: $table.newFileHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputFileName => $composableBuilder(
    column: $table.outputFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputFileHash => $composableBuilder(
    column: $table.outputFileHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get standardVersion => $composableBuilder(
    column: $table.standardVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalClaims => $composableBuilder(
    column: $table.totalClaims,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalChanges => $composableBuilder(
    column: $table.totalChanges,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMau09Rows => $composableBuilder(
    column: $table.totalMau09Rows,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$AuditLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogsTable,
          AuditLog,
          $$AuditLogsTableFilterComposer,
          $$AuditLogsTableOrderingComposer,
          $$AuditLogsTableAnnotationComposer,
          $$AuditLogsTableCreateCompanionBuilder,
          $$AuditLogsTableUpdateCompanionBuilder,
          (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
          AuditLog,
          PrefetchHooks Function()
        > {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> oldFileName = const Value.absent(),
                Value<String> newFileName = const Value.absent(),
                Value<String> oldFileHash = const Value.absent(),
                Value<String> newFileHash = const Value.absent(),
                Value<String?> outputFileName = const Value.absent(),
                Value<String?> outputFileHash = const Value.absent(),
                Value<String> standardVersion = const Value.absent(),
                Value<int> totalClaims = const Value.absent(),
                Value<int> totalChanges = const Value.absent(),
                Value<int> totalMau09Rows = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => AuditLogsCompanion(
                id: id,
                timestamp: timestamp,
                oldFileName: oldFileName,
                newFileName: newFileName,
                oldFileHash: oldFileHash,
                newFileHash: newFileHash,
                outputFileName: outputFileName,
                outputFileHash: outputFileHash,
                standardVersion: standardVersion,
                totalClaims: totalClaims,
                totalChanges: totalChanges,
                totalMau09Rows: totalMau09Rows,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                Value<String> oldFileName = const Value.absent(),
                Value<String> newFileName = const Value.absent(),
                Value<String> oldFileHash = const Value.absent(),
                Value<String> newFileHash = const Value.absent(),
                Value<String?> outputFileName = const Value.absent(),
                Value<String?> outputFileHash = const Value.absent(),
                Value<String> standardVersion = const Value.absent(),
                Value<int> totalClaims = const Value.absent(),
                Value<int> totalChanges = const Value.absent(),
                Value<int> totalMau09Rows = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => AuditLogsCompanion.insert(
                id: id,
                timestamp: timestamp,
                oldFileName: oldFileName,
                newFileName: newFileName,
                oldFileHash: oldFileHash,
                newFileHash: newFileHash,
                outputFileName: outputFileName,
                outputFileHash: outputFileHash,
                standardVersion: standardVersion,
                totalClaims: totalClaims,
                totalChanges: totalChanges,
                totalMau09Rows: totalMau09Rows,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogsTable,
      AuditLog,
      $$AuditLogsTableFilterComposer,
      $$AuditLogsTableOrderingComposer,
      $$AuditLogsTableAnnotationComposer,
      $$AuditLogsTableCreateCompanionBuilder,
      $$AuditLogsTableUpdateCompanionBuilder,
      (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
      AuditLog,
      PrefetchHooks Function()
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
      required String standardVersion,
      Value<String?> description,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<String> standardVersion,
      Value<String?> description,
    });

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get standardVersion => $composableBuilder(
    column: $table.standardVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get standardVersion => $composableBuilder(
    column: $table.standardVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get standardVersion => $composableBuilder(
    column: $table.standardVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
          Project,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> standardVersion = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                standardVersion: standardVersion,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
                required String standardVersion,
                Value<String?> description = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                standardVersion: standardVersion,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
      Project,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
}
