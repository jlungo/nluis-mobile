// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mobileModulesJsonMeta = const VerificationMeta(
    'mobileModulesJson',
  );
  @override
  late final GeneratedColumn<String> mobileModulesJson =
      GeneratedColumn<String>(
        'mobile_modules_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    firstName,
    lastName,
    mobileModulesJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('mobile_modules_json')) {
      context.handle(
        _mobileModulesJsonMeta,
        mobileModulesJson.isAcceptableOrUnknown(
          data['mobile_modules_json']!,
          _mobileModulesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mobileModulesJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      email:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}email'],
          )!,
      firstName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}first_name'],
          )!,
      lastName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_name'],
          )!,
      mobileModulesJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mobile_modules_json'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobileModulesJson;
  final int updatedAt;
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobileModulesJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['mobile_modules_json'] = Variable<String>(mobileModulesJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      firstName: Value(firstName),
      lastName: Value(lastName),
      mobileModulesJson: Value(mobileModulesJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      mobileModulesJson: serializer.fromJson<String>(json['mobileModulesJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'mobileModulesJson': serializer.toJson<String>(mobileModulesJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? mobileModulesJson,
    int? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    mobileModulesJson: mobileModulesJson ?? this.mobileModulesJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      mobileModulesJson:
          data.mobileModulesJson.present
              ? data.mobileModulesJson.value
              : this.mobileModulesJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobileModulesJson: $mobileModulesJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, email, firstName, lastName, mobileModulesJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.mobileModulesJson == this.mobileModulesJson &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> mobileModulesJson;
  final Value<int> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.mobileModulesJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String firstName,
    required String lastName,
    required String mobileModulesJson,
    required int updatedAt,
  }) : email = Value(email),
       firstName = Value(firstName),
       lastName = Value(lastName),
       mobileModulesJson = Value(mobileModulesJson),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? mobileModulesJson,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (mobileModulesJson != null) 'mobile_modules_json': mobileModulesJson,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? mobileModulesJson,
    Value<int>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileModulesJson: mobileModulesJson ?? this.mobileModulesJson,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (mobileModulesJson.present) {
      map['mobile_modules_json'] = Variable<String>(mobileModulesJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('mobileModulesJson: $mobileModulesJson, ')
          ..write('updatedAt: $updatedAt')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<int> localityId = GeneratedColumn<int>(
    'locality_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignedOnMeta = const VerificationMeta(
    'assignedOn',
  );
  @override
  late final GeneratedColumn<int> assignedOn = GeneratedColumn<int>(
    'assigned_on',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasSurveyMeta = const VerificationMeta(
    'hasSurvey',
  );
  @override
  late final GeneratedColumn<bool> hasSurvey = GeneratedColumn<bool>(
    'has_survey',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_survey" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasZoningMeta = const VerificationMeta(
    'hasZoning',
  );
  @override
  late final GeneratedColumn<bool> hasZoning = GeneratedColumn<bool>(
    'has_zoning',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_zoning" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDownloadedMeta = const VerificationMeta(
    'isDownloaded',
  );
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
    'is_downloaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_downloaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    localityId,
    status,
    assignedOn,
    hasSurvey,
    hasZoning,
    isDownloaded,
    downloadedAt,
    updatedAt,
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('assigned_on')) {
      context.handle(
        _assignedOnMeta,
        assignedOn.isAcceptableOrUnknown(data['assigned_on']!, _assignedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_assignedOnMeta);
    }
    if (data.containsKey('has_survey')) {
      context.handle(
        _hasSurveyMeta,
        hasSurvey.isAcceptableOrUnknown(data['has_survey']!, _hasSurveyMeta),
      );
    }
    if (data.containsKey('has_zoning')) {
      context.handle(
        _hasZoningMeta,
        hasZoning.isAcceptableOrUnknown(data['has_zoning']!, _hasZoningMeta),
      );
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
        _isDownloadedMeta,
        isDownloaded.isAcceptableOrUnknown(
          data['is_downloaded']!,
          _isDownloadedMeta,
        ),
      );
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      assignedOn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}assigned_on'],
          )!,
      hasSurvey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}has_survey'],
          )!,
      hasZoning:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}has_zoning'],
          )!,
      isDownloaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_downloaded'],
          )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final int localityId;
  final String status;
  final int assignedOn;
  final bool hasSurvey;
  final bool hasZoning;
  final bool isDownloaded;
  final int? downloadedAt;
  final int updatedAt;
  const Project({
    required this.id,
    required this.name,
    required this.localityId,
    required this.status,
    required this.assignedOn,
    required this.hasSurvey,
    required this.hasZoning,
    required this.isDownloaded,
    this.downloadedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['locality_id'] = Variable<int>(localityId);
    map['status'] = Variable<String>(status);
    map['assigned_on'] = Variable<int>(assignedOn);
    map['has_survey'] = Variable<bool>(hasSurvey);
    map['has_zoning'] = Variable<bool>(hasZoning);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    if (!nullToAbsent || downloadedAt != null) {
      map['downloaded_at'] = Variable<int>(downloadedAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      localityId: Value(localityId),
      status: Value(status),
      assignedOn: Value(assignedOn),
      hasSurvey: Value(hasSurvey),
      hasZoning: Value(hasZoning),
      isDownloaded: Value(isDownloaded),
      downloadedAt:
          downloadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(downloadedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      localityId: serializer.fromJson<int>(json['localityId']),
      status: serializer.fromJson<String>(json['status']),
      assignedOn: serializer.fromJson<int>(json['assignedOn']),
      hasSurvey: serializer.fromJson<bool>(json['hasSurvey']),
      hasZoning: serializer.fromJson<bool>(json['hasZoning']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      downloadedAt: serializer.fromJson<int?>(json['downloadedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'localityId': serializer.toJson<int>(localityId),
      'status': serializer.toJson<String>(status),
      'assignedOn': serializer.toJson<int>(assignedOn),
      'hasSurvey': serializer.toJson<bool>(hasSurvey),
      'hasZoning': serializer.toJson<bool>(hasZoning),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'downloadedAt': serializer.toJson<int?>(downloadedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    int? localityId,
    String? status,
    int? assignedOn,
    bool? hasSurvey,
    bool? hasZoning,
    bool? isDownloaded,
    Value<int?> downloadedAt = const Value.absent(),
    int? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    localityId: localityId ?? this.localityId,
    status: status ?? this.status,
    assignedOn: assignedOn ?? this.assignedOn,
    hasSurvey: hasSurvey ?? this.hasSurvey,
    hasZoning: hasZoning ?? this.hasZoning,
    isDownloaded: isDownloaded ?? this.isDownloaded,
    downloadedAt: downloadedAt.present ? downloadedAt.value : this.downloadedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      status: data.status.present ? data.status.value : this.status,
      assignedOn:
          data.assignedOn.present ? data.assignedOn.value : this.assignedOn,
      hasSurvey: data.hasSurvey.present ? data.hasSurvey.value : this.hasSurvey,
      hasZoning: data.hasZoning.present ? data.hasZoning.value : this.hasZoning,
      isDownloaded:
          data.isDownloaded.present
              ? data.isDownloaded.value
              : this.isDownloaded,
      downloadedAt:
          data.downloadedAt.present
              ? data.downloadedAt.value
              : this.downloadedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localityId: $localityId, ')
          ..write('status: $status, ')
          ..write('assignedOn: $assignedOn, ')
          ..write('hasSurvey: $hasSurvey, ')
          ..write('hasZoning: $hasZoning, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    localityId,
    status,
    assignedOn,
    hasSurvey,
    hasZoning,
    isDownloaded,
    downloadedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.localityId == this.localityId &&
          other.status == this.status &&
          other.assignedOn == this.assignedOn &&
          other.hasSurvey == this.hasSurvey &&
          other.hasZoning == this.hasZoning &&
          other.isDownloaded == this.isDownloaded &&
          other.downloadedAt == this.downloadedAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> localityId;
  final Value<String> status;
  final Value<int> assignedOn;
  final Value<bool> hasSurvey;
  final Value<bool> hasZoning;
  final Value<bool> isDownloaded;
  final Value<int?> downloadedAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.localityId = const Value.absent(),
    this.status = const Value.absent(),
    this.assignedOn = const Value.absent(),
    this.hasSurvey = const Value.absent(),
    this.hasZoning = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required int localityId,
    required String status,
    required int assignedOn,
    this.hasSurvey = const Value.absent(),
    this.hasZoning = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       localityId = Value(localityId),
       status = Value(status),
       assignedOn = Value(assignedOn),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? localityId,
    Expression<String>? status,
    Expression<int>? assignedOn,
    Expression<bool>? hasSurvey,
    Expression<bool>? hasZoning,
    Expression<bool>? isDownloaded,
    Expression<int>? downloadedAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (localityId != null) 'locality_id': localityId,
      if (status != null) 'status': status,
      if (assignedOn != null) 'assigned_on': assignedOn,
      if (hasSurvey != null) 'has_survey': hasSurvey,
      if (hasZoning != null) 'has_zoning': hasZoning,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? localityId,
    Value<String>? status,
    Value<int>? assignedOn,
    Value<bool>? hasSurvey,
    Value<bool>? hasZoning,
    Value<bool>? isDownloaded,
    Value<int?>? downloadedAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      localityId: localityId ?? this.localityId,
      status: status ?? this.status,
      assignedOn: assignedOn ?? this.assignedOn,
      hasSurvey: hasSurvey ?? this.hasSurvey,
      hasZoning: hasZoning ?? this.hasZoning,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assignedOn.present) {
      map['assigned_on'] = Variable<int>(assignedOn.value);
    }
    if (hasSurvey.present) {
      map['has_survey'] = Variable<bool>(hasSurvey.value);
    }
    if (hasZoning.present) {
      map['has_zoning'] = Variable<bool>(hasZoning.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('localityId: $localityId, ')
          ..write('status: $status, ')
          ..write('assignedOn: $assignedOn, ')
          ..write('hasSurvey: $hasSurvey, ')
          ..write('hasZoning: $hasZoning, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectPacksTable extends ProjectPacks
    with TableInfo<$ProjectPacksTable, ProjectPack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    projectId,
    status,
    downloadedAt,
    updatedAt,
    sizeBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectPack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {projectId};
  @override
  ProjectPack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectPack(
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}downloaded_at'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      ),
    );
  }

  @override
  $ProjectPacksTable createAlias(String alias) {
    return $ProjectPacksTable(attachedDatabase, alias);
  }
}

class ProjectPack extends DataClass implements Insertable<ProjectPack> {
  final String projectId;
  final String status;
  final int? downloadedAt;
  final int updatedAt;
  final int? sizeBytes;
  const ProjectPack({
    required this.projectId,
    required this.status,
    this.downloadedAt,
    required this.updatedAt,
    this.sizeBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['project_id'] = Variable<String>(projectId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || downloadedAt != null) {
      map['downloaded_at'] = Variable<int>(downloadedAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    return map;
  }

  ProjectPacksCompanion toCompanion(bool nullToAbsent) {
    return ProjectPacksCompanion(
      projectId: Value(projectId),
      status: Value(status),
      downloadedAt:
          downloadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(downloadedAt),
      updatedAt: Value(updatedAt),
      sizeBytes:
          sizeBytes == null && nullToAbsent
              ? const Value.absent()
              : Value(sizeBytes),
    );
  }

  factory ProjectPack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectPack(
      projectId: serializer.fromJson<String>(json['projectId']),
      status: serializer.fromJson<String>(json['status']),
      downloadedAt: serializer.fromJson<int?>(json['downloadedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'projectId': serializer.toJson<String>(projectId),
      'status': serializer.toJson<String>(status),
      'downloadedAt': serializer.toJson<int?>(downloadedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
    };
  }

  ProjectPack copyWith({
    String? projectId,
    String? status,
    Value<int?> downloadedAt = const Value.absent(),
    int? updatedAt,
    Value<int?> sizeBytes = const Value.absent(),
  }) => ProjectPack(
    projectId: projectId ?? this.projectId,
    status: status ?? this.status,
    downloadedAt: downloadedAt.present ? downloadedAt.value : this.downloadedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
  );
  ProjectPack copyWithCompanion(ProjectPacksCompanion data) {
    return ProjectPack(
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      status: data.status.present ? data.status.value : this.status,
      downloadedAt:
          data.downloadedAt.present
              ? data.downloadedAt.value
              : this.downloadedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectPack(')
          ..write('projectId: $projectId, ')
          ..write('status: $status, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sizeBytes: $sizeBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(projectId, status, downloadedAt, updatedAt, sizeBytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectPack &&
          other.projectId == this.projectId &&
          other.status == this.status &&
          other.downloadedAt == this.downloadedAt &&
          other.updatedAt == this.updatedAt &&
          other.sizeBytes == this.sizeBytes);
}

class ProjectPacksCompanion extends UpdateCompanion<ProjectPack> {
  final Value<String> projectId;
  final Value<String> status;
  final Value<int?> downloadedAt;
  final Value<int> updatedAt;
  final Value<int?> sizeBytes;
  final Value<int> rowid;
  const ProjectPacksCompanion({
    this.projectId = const Value.absent(),
    this.status = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectPacksCompanion.insert({
    required String projectId,
    required String status,
    this.downloadedAt = const Value.absent(),
    required int updatedAt,
    this.sizeBytes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : projectId = Value(projectId),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<ProjectPack> custom({
    Expression<String>? projectId,
    Expression<String>? status,
    Expression<int>? downloadedAt,
    Expression<int>? updatedAt,
    Expression<int>? sizeBytes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (projectId != null) 'project_id': projectId,
      if (status != null) 'status': status,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectPacksCompanion copyWith({
    Value<String>? projectId,
    Value<String>? status,
    Value<int?>? downloadedAt,
    Value<int>? updatedAt,
    Value<int?>? sizeBytes,
    Value<int>? rowid,
  }) {
    return ProjectPacksCompanion(
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectPacksCompanion(')
          ..write('projectId: $projectId, ')
          ..write('status: $status, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionnaireTypesTable extends QuestionnaireTypes
    with TableInfo<$QuestionnaireTypesTable, QuestionnaireType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionnaireTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<int> localityId = GeneratedColumn<int>(
    'locality_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, slug, localityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questionnaire_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionnaireType> instance, {
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
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionnaireType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionnaireType(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      slug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}slug'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
    );
  }

  @override
  $QuestionnaireTypesTable createAlias(String alias) {
    return $QuestionnaireTypesTable(attachedDatabase, alias);
  }
}

class QuestionnaireType extends DataClass
    implements Insertable<QuestionnaireType> {
  final int id;
  final String name;
  final String slug;
  final int localityId;
  const QuestionnaireType({
    required this.id,
    required this.name,
    required this.slug,
    required this.localityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['locality_id'] = Variable<int>(localityId);
    return map;
  }

  QuestionnaireTypesCompanion toCompanion(bool nullToAbsent) {
    return QuestionnaireTypesCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      localityId: Value(localityId),
    );
  }

  factory QuestionnaireType.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionnaireType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      localityId: serializer.fromJson<int>(json['localityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'localityId': serializer.toJson<int>(localityId),
    };
  }

  QuestionnaireType copyWith({
    int? id,
    String? name,
    String? slug,
    int? localityId,
  }) => QuestionnaireType(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    localityId: localityId ?? this.localityId,
  );
  QuestionnaireType copyWithCompanion(QuestionnaireTypesCompanion data) {
    return QuestionnaireType(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionnaireType(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('localityId: $localityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, slug, localityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionnaireType &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.localityId == this.localityId);
}

class QuestionnaireTypesCompanion extends UpdateCompanion<QuestionnaireType> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<int> localityId;
  const QuestionnaireTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.localityId = const Value.absent(),
  });
  QuestionnaireTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String slug,
    required int localityId,
  }) : name = Value(name),
       slug = Value(slug),
       localityId = Value(localityId);
  static Insertable<QuestionnaireType> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<int>? localityId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (localityId != null) 'locality_id': localityId,
    });
  }

  QuestionnaireTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? slug,
    Value<int>? localityId,
  }) {
    return QuestionnaireTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      localityId: localityId ?? this.localityId,
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
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionnaireTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('localityId: $localityId')
          ..write(')'))
        .toString();
  }
}

class $QuestionnairesTable extends Questionnaires
    with TableInfo<$QuestionnairesTable, Questionnaire> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionnairesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<int> typeId = GeneratedColumn<int>(
    'type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<int> localityId = GeneratedColumn<int>(
    'locality_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _moduleSlugMeta = const VerificationMeta(
    'moduleSlug',
  );
  @override
  late final GeneratedColumn<String> moduleSlug = GeneratedColumn<String>(
    'module_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _moduleNameMeta = const VerificationMeta(
    'moduleName',
  );
  @override
  late final GeneratedColumn<String> moduleName = GeneratedColumn<String>(
    'module_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    slug,
    typeId,
    version,
    updatedAt,
    localityId,
    description,
    moduleSlug,
    moduleName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questionnaires';
  @override
  VerificationContext validateIntegrity(
    Insertable<Questionnaire> instance, {
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
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(
        _typeIdMeta,
        typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
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
    if (data.containsKey('module_slug')) {
      context.handle(
        _moduleSlugMeta,
        moduleSlug.isAcceptableOrUnknown(data['module_slug']!, _moduleSlugMeta),
      );
    }
    if (data.containsKey('module_name')) {
      context.handle(
        _moduleNameMeta,
        moduleName.isAcceptableOrUnknown(data['module_name']!, _moduleNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Questionnaire map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Questionnaire(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      slug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}slug'],
          )!,
      typeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}type_id'],
          )!,
      version:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}version'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      moduleSlug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}module_slug'],
          )!,
      moduleName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}module_name'],
          )!,
    );
  }

  @override
  $QuestionnairesTable createAlias(String alias) {
    return $QuestionnairesTable(attachedDatabase, alias);
  }
}

class Questionnaire extends DataClass implements Insertable<Questionnaire> {
  final int id;
  final String name;
  final String slug;
  final int typeId;
  final String version;
  final int updatedAt;
  final int localityId;
  final String description;
  final String moduleSlug;
  final String moduleName;
  const Questionnaire({
    required this.id,
    required this.name,
    required this.slug,
    required this.typeId,
    required this.version,
    required this.updatedAt,
    required this.localityId,
    required this.description,
    required this.moduleSlug,
    required this.moduleName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['type_id'] = Variable<int>(typeId);
    map['version'] = Variable<String>(version);
    map['updated_at'] = Variable<int>(updatedAt);
    map['locality_id'] = Variable<int>(localityId);
    map['description'] = Variable<String>(description);
    map['module_slug'] = Variable<String>(moduleSlug);
    map['module_name'] = Variable<String>(moduleName);
    return map;
  }

  QuestionnairesCompanion toCompanion(bool nullToAbsent) {
    return QuestionnairesCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      typeId: Value(typeId),
      version: Value(version),
      updatedAt: Value(updatedAt),
      localityId: Value(localityId),
      description: Value(description),
      moduleSlug: Value(moduleSlug),
      moduleName: Value(moduleName),
    );
  }

  factory Questionnaire.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Questionnaire(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      typeId: serializer.fromJson<int>(json['typeId']),
      version: serializer.fromJson<String>(json['version']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      localityId: serializer.fromJson<int>(json['localityId']),
      description: serializer.fromJson<String>(json['description']),
      moduleSlug: serializer.fromJson<String>(json['moduleSlug']),
      moduleName: serializer.fromJson<String>(json['moduleName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'typeId': serializer.toJson<int>(typeId),
      'version': serializer.toJson<String>(version),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'localityId': serializer.toJson<int>(localityId),
      'description': serializer.toJson<String>(description),
      'moduleSlug': serializer.toJson<String>(moduleSlug),
      'moduleName': serializer.toJson<String>(moduleName),
    };
  }

  Questionnaire copyWith({
    int? id,
    String? name,
    String? slug,
    int? typeId,
    String? version,
    int? updatedAt,
    int? localityId,
    String? description,
    String? moduleSlug,
    String? moduleName,
  }) => Questionnaire(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    typeId: typeId ?? this.typeId,
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
    localityId: localityId ?? this.localityId,
    description: description ?? this.description,
    moduleSlug: moduleSlug ?? this.moduleSlug,
    moduleName: moduleName ?? this.moduleName,
  );
  Questionnaire copyWithCompanion(QuestionnairesCompanion data) {
    return Questionnaire(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      description:
          data.description.present ? data.description.value : this.description,
      moduleSlug:
          data.moduleSlug.present ? data.moduleSlug.value : this.moduleSlug,
      moduleName:
          data.moduleName.present ? data.moduleName.value : this.moduleName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Questionnaire(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('typeId: $typeId, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localityId: $localityId, ')
          ..write('description: $description, ')
          ..write('moduleSlug: $moduleSlug, ')
          ..write('moduleName: $moduleName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    slug,
    typeId,
    version,
    updatedAt,
    localityId,
    description,
    moduleSlug,
    moduleName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Questionnaire &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.typeId == this.typeId &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt &&
          other.localityId == this.localityId &&
          other.description == this.description &&
          other.moduleSlug == this.moduleSlug &&
          other.moduleName == this.moduleName);
}

class QuestionnairesCompanion extends UpdateCompanion<Questionnaire> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<int> typeId;
  final Value<String> version;
  final Value<int> updatedAt;
  final Value<int> localityId;
  final Value<String> description;
  final Value<String> moduleSlug;
  final Value<String> moduleName;
  const QuestionnairesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.typeId = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.localityId = const Value.absent(),
    this.description = const Value.absent(),
    this.moduleSlug = const Value.absent(),
    this.moduleName = const Value.absent(),
  });
  QuestionnairesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String slug,
    required int typeId,
    required String version,
    required int updatedAt,
    required int localityId,
    this.description = const Value.absent(),
    this.moduleSlug = const Value.absent(),
    this.moduleName = const Value.absent(),
  }) : name = Value(name),
       slug = Value(slug),
       typeId = Value(typeId),
       version = Value(version),
       updatedAt = Value(updatedAt),
       localityId = Value(localityId);
  static Insertable<Questionnaire> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<int>? typeId,
    Expression<String>? version,
    Expression<int>? updatedAt,
    Expression<int>? localityId,
    Expression<String>? description,
    Expression<String>? moduleSlug,
    Expression<String>? moduleName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (typeId != null) 'type_id': typeId,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (localityId != null) 'locality_id': localityId,
      if (description != null) 'description': description,
      if (moduleSlug != null) 'module_slug': moduleSlug,
      if (moduleName != null) 'module_name': moduleName,
    });
  }

  QuestionnairesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? slug,
    Value<int>? typeId,
    Value<String>? version,
    Value<int>? updatedAt,
    Value<int>? localityId,
    Value<String>? description,
    Value<String>? moduleSlug,
    Value<String>? moduleName,
  }) {
    return QuestionnairesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      typeId: typeId ?? this.typeId,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      localityId: localityId ?? this.localityId,
      description: description ?? this.description,
      moduleSlug: moduleSlug ?? this.moduleSlug,
      moduleName: moduleName ?? this.moduleName,
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
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<int>(typeId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (moduleSlug.present) {
      map['module_slug'] = Variable<String>(moduleSlug.value);
    }
    if (moduleName.present) {
      map['module_name'] = Variable<String>(moduleName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionnairesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('typeId: $typeId, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('localityId: $localityId, ')
          ..write('description: $description, ')
          ..write('moduleSlug: $moduleSlug, ')
          ..write('moduleName: $moduleName')
          ..write(')'))
        .toString();
  }
}

class $FormsTable extends Forms with TableInfo<$FormsTable, Form> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionnaireIdMeta = const VerificationMeta(
    'questionnaireId',
  );
  @override
  late final GeneratedColumn<int> questionnaireId = GeneratedColumn<int>(
    'questionnaire_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleSlugMeta = const VerificationMeta(
    'moduleSlug',
  );
  @override
  late final GeneratedColumn<String> moduleSlug = GeneratedColumn<String>(
    'module_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workflowSlugMeta = const VerificationMeta(
    'workflowSlug',
  );
  @override
  late final GeneratedColumn<String> workflowSlug = GeneratedColumn<String>(
    'workflow_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionSlugMeta = const VerificationMeta(
    'sectionSlug',
  );
  @override
  late final GeneratedColumn<String> sectionSlug = GeneratedColumn<String>(
    'section_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sectionNameMeta = const VerificationMeta(
    'sectionName',
  );
  @override
  late final GeneratedColumn<String> sectionName = GeneratedColumn<String>(
    'section_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sectionPositionMeta = const VerificationMeta(
    'sectionPosition',
  );
  @override
  late final GeneratedColumn<int> sectionPosition = GeneratedColumn<int>(
    'section_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sectionDescriptionMeta =
      const VerificationMeta('sectionDescription');
  @override
  late final GeneratedColumn<String> sectionDescription =
      GeneratedColumn<String>(
        'section_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    slug,
    questionnaireId,
    name,
    description,
    moduleSlug,
    workflowSlug,
    position,
    updatedAt,
    sectionSlug,
    sectionName,
    sectionPosition,
    sectionDescription,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Form> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('questionnaire_id')) {
      context.handle(
        _questionnaireIdMeta,
        questionnaireId.isAcceptableOrUnknown(
          data['questionnaire_id']!,
          _questionnaireIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('module_slug')) {
      context.handle(
        _moduleSlugMeta,
        moduleSlug.isAcceptableOrUnknown(data['module_slug']!, _moduleSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleSlugMeta);
    }
    if (data.containsKey('workflow_slug')) {
      context.handle(
        _workflowSlugMeta,
        workflowSlug.isAcceptableOrUnknown(
          data['workflow_slug']!,
          _workflowSlugMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workflowSlugMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('section_slug')) {
      context.handle(
        _sectionSlugMeta,
        sectionSlug.isAcceptableOrUnknown(
          data['section_slug']!,
          _sectionSlugMeta,
        ),
      );
    }
    if (data.containsKey('section_name')) {
      context.handle(
        _sectionNameMeta,
        sectionName.isAcceptableOrUnknown(
          data['section_name']!,
          _sectionNameMeta,
        ),
      );
    }
    if (data.containsKey('section_position')) {
      context.handle(
        _sectionPositionMeta,
        sectionPosition.isAcceptableOrUnknown(
          data['section_position']!,
          _sectionPositionMeta,
        ),
      );
    }
    if (data.containsKey('section_description')) {
      context.handle(
        _sectionDescriptionMeta,
        sectionDescription.isAcceptableOrUnknown(
          data['section_description']!,
          _sectionDescriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug};
  @override
  Form map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Form(
      slug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}slug'],
          )!,
      questionnaireId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}questionnaire_id'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      moduleSlug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}module_slug'],
          )!,
      workflowSlug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}workflow_slug'],
          )!,
      position:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}position'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      sectionSlug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}section_slug'],
          )!,
      sectionName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}section_name'],
          )!,
      sectionPosition:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}section_position'],
          )!,
      sectionDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_description'],
      ),
    );
  }

  @override
  $FormsTable createAlias(String alias) {
    return $FormsTable(attachedDatabase, alias);
  }
}

class Form extends DataClass implements Insertable<Form> {
  final String slug;
  final int? questionnaireId;
  final String name;
  final String description;
  final String moduleSlug;
  final String workflowSlug;
  final int position;
  final int updatedAt;
  final String sectionSlug;
  final String sectionName;
  final int sectionPosition;
  final String? sectionDescription;
  const Form({
    required this.slug,
    this.questionnaireId,
    required this.name,
    required this.description,
    required this.moduleSlug,
    required this.workflowSlug,
    required this.position,
    required this.updatedAt,
    required this.sectionSlug,
    required this.sectionName,
    required this.sectionPosition,
    this.sectionDescription,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || questionnaireId != null) {
      map['questionnaire_id'] = Variable<int>(questionnaireId);
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['module_slug'] = Variable<String>(moduleSlug);
    map['workflow_slug'] = Variable<String>(workflowSlug);
    map['position'] = Variable<int>(position);
    map['updated_at'] = Variable<int>(updatedAt);
    map['section_slug'] = Variable<String>(sectionSlug);
    map['section_name'] = Variable<String>(sectionName);
    map['section_position'] = Variable<int>(sectionPosition);
    if (!nullToAbsent || sectionDescription != null) {
      map['section_description'] = Variable<String>(sectionDescription);
    }
    return map;
  }

  FormsCompanion toCompanion(bool nullToAbsent) {
    return FormsCompanion(
      slug: Value(slug),
      questionnaireId:
          questionnaireId == null && nullToAbsent
              ? const Value.absent()
              : Value(questionnaireId),
      name: Value(name),
      description: Value(description),
      moduleSlug: Value(moduleSlug),
      workflowSlug: Value(workflowSlug),
      position: Value(position),
      updatedAt: Value(updatedAt),
      sectionSlug: Value(sectionSlug),
      sectionName: Value(sectionName),
      sectionPosition: Value(sectionPosition),
      sectionDescription:
          sectionDescription == null && nullToAbsent
              ? const Value.absent()
              : Value(sectionDescription),
    );
  }

  factory Form.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Form(
      slug: serializer.fromJson<String>(json['slug']),
      questionnaireId: serializer.fromJson<int?>(json['questionnaireId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      moduleSlug: serializer.fromJson<String>(json['moduleSlug']),
      workflowSlug: serializer.fromJson<String>(json['workflowSlug']),
      position: serializer.fromJson<int>(json['position']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      sectionSlug: serializer.fromJson<String>(json['sectionSlug']),
      sectionName: serializer.fromJson<String>(json['sectionName']),
      sectionPosition: serializer.fromJson<int>(json['sectionPosition']),
      sectionDescription: serializer.fromJson<String?>(
        json['sectionDescription'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slug': serializer.toJson<String>(slug),
      'questionnaireId': serializer.toJson<int?>(questionnaireId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'moduleSlug': serializer.toJson<String>(moduleSlug),
      'workflowSlug': serializer.toJson<String>(workflowSlug),
      'position': serializer.toJson<int>(position),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'sectionSlug': serializer.toJson<String>(sectionSlug),
      'sectionName': serializer.toJson<String>(sectionName),
      'sectionPosition': serializer.toJson<int>(sectionPosition),
      'sectionDescription': serializer.toJson<String?>(sectionDescription),
    };
  }

  Form copyWith({
    String? slug,
    Value<int?> questionnaireId = const Value.absent(),
    String? name,
    String? description,
    String? moduleSlug,
    String? workflowSlug,
    int? position,
    int? updatedAt,
    String? sectionSlug,
    String? sectionName,
    int? sectionPosition,
    Value<String?> sectionDescription = const Value.absent(),
  }) => Form(
    slug: slug ?? this.slug,
    questionnaireId:
        questionnaireId.present ? questionnaireId.value : this.questionnaireId,
    name: name ?? this.name,
    description: description ?? this.description,
    moduleSlug: moduleSlug ?? this.moduleSlug,
    workflowSlug: workflowSlug ?? this.workflowSlug,
    position: position ?? this.position,
    updatedAt: updatedAt ?? this.updatedAt,
    sectionSlug: sectionSlug ?? this.sectionSlug,
    sectionName: sectionName ?? this.sectionName,
    sectionPosition: sectionPosition ?? this.sectionPosition,
    sectionDescription:
        sectionDescription.present
            ? sectionDescription.value
            : this.sectionDescription,
  );
  Form copyWithCompanion(FormsCompanion data) {
    return Form(
      slug: data.slug.present ? data.slug.value : this.slug,
      questionnaireId:
          data.questionnaireId.present
              ? data.questionnaireId.value
              : this.questionnaireId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      moduleSlug:
          data.moduleSlug.present ? data.moduleSlug.value : this.moduleSlug,
      workflowSlug:
          data.workflowSlug.present
              ? data.workflowSlug.value
              : this.workflowSlug,
      position: data.position.present ? data.position.value : this.position,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sectionSlug:
          data.sectionSlug.present ? data.sectionSlug.value : this.sectionSlug,
      sectionName:
          data.sectionName.present ? data.sectionName.value : this.sectionName,
      sectionPosition:
          data.sectionPosition.present
              ? data.sectionPosition.value
              : this.sectionPosition,
      sectionDescription:
          data.sectionDescription.present
              ? data.sectionDescription.value
              : this.sectionDescription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Form(')
          ..write('slug: $slug, ')
          ..write('questionnaireId: $questionnaireId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('moduleSlug: $moduleSlug, ')
          ..write('workflowSlug: $workflowSlug, ')
          ..write('position: $position, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sectionSlug: $sectionSlug, ')
          ..write('sectionName: $sectionName, ')
          ..write('sectionPosition: $sectionPosition, ')
          ..write('sectionDescription: $sectionDescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    slug,
    questionnaireId,
    name,
    description,
    moduleSlug,
    workflowSlug,
    position,
    updatedAt,
    sectionSlug,
    sectionName,
    sectionPosition,
    sectionDescription,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Form &&
          other.slug == this.slug &&
          other.questionnaireId == this.questionnaireId &&
          other.name == this.name &&
          other.description == this.description &&
          other.moduleSlug == this.moduleSlug &&
          other.workflowSlug == this.workflowSlug &&
          other.position == this.position &&
          other.updatedAt == this.updatedAt &&
          other.sectionSlug == this.sectionSlug &&
          other.sectionName == this.sectionName &&
          other.sectionPosition == this.sectionPosition &&
          other.sectionDescription == this.sectionDescription);
}

class FormsCompanion extends UpdateCompanion<Form> {
  final Value<String> slug;
  final Value<int?> questionnaireId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> moduleSlug;
  final Value<String> workflowSlug;
  final Value<int> position;
  final Value<int> updatedAt;
  final Value<String> sectionSlug;
  final Value<String> sectionName;
  final Value<int> sectionPosition;
  final Value<String?> sectionDescription;
  final Value<int> rowid;
  const FormsCompanion({
    this.slug = const Value.absent(),
    this.questionnaireId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.moduleSlug = const Value.absent(),
    this.workflowSlug = const Value.absent(),
    this.position = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sectionSlug = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.sectionPosition = const Value.absent(),
    this.sectionDescription = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormsCompanion.insert({
    required String slug,
    this.questionnaireId = const Value.absent(),
    required String name,
    required String description,
    required String moduleSlug,
    required String workflowSlug,
    required int position,
    required int updatedAt,
    this.sectionSlug = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.sectionPosition = const Value.absent(),
    this.sectionDescription = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : slug = Value(slug),
       name = Value(name),
       description = Value(description),
       moduleSlug = Value(moduleSlug),
       workflowSlug = Value(workflowSlug),
       position = Value(position),
       updatedAt = Value(updatedAt);
  static Insertable<Form> custom({
    Expression<String>? slug,
    Expression<int>? questionnaireId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? moduleSlug,
    Expression<String>? workflowSlug,
    Expression<int>? position,
    Expression<int>? updatedAt,
    Expression<String>? sectionSlug,
    Expression<String>? sectionName,
    Expression<int>? sectionPosition,
    Expression<String>? sectionDescription,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slug != null) 'slug': slug,
      if (questionnaireId != null) 'questionnaire_id': questionnaireId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (moduleSlug != null) 'module_slug': moduleSlug,
      if (workflowSlug != null) 'workflow_slug': workflowSlug,
      if (position != null) 'position': position,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sectionSlug != null) 'section_slug': sectionSlug,
      if (sectionName != null) 'section_name': sectionName,
      if (sectionPosition != null) 'section_position': sectionPosition,
      if (sectionDescription != null) 'section_description': sectionDescription,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormsCompanion copyWith({
    Value<String>? slug,
    Value<int?>? questionnaireId,
    Value<String>? name,
    Value<String>? description,
    Value<String>? moduleSlug,
    Value<String>? workflowSlug,
    Value<int>? position,
    Value<int>? updatedAt,
    Value<String>? sectionSlug,
    Value<String>? sectionName,
    Value<int>? sectionPosition,
    Value<String?>? sectionDescription,
    Value<int>? rowid,
  }) {
    return FormsCompanion(
      slug: slug ?? this.slug,
      questionnaireId: questionnaireId ?? this.questionnaireId,
      name: name ?? this.name,
      description: description ?? this.description,
      moduleSlug: moduleSlug ?? this.moduleSlug,
      workflowSlug: workflowSlug ?? this.workflowSlug,
      position: position ?? this.position,
      updatedAt: updatedAt ?? this.updatedAt,
      sectionSlug: sectionSlug ?? this.sectionSlug,
      sectionName: sectionName ?? this.sectionName,
      sectionPosition: sectionPosition ?? this.sectionPosition,
      sectionDescription: sectionDescription ?? this.sectionDescription,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (questionnaireId.present) {
      map['questionnaire_id'] = Variable<int>(questionnaireId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (moduleSlug.present) {
      map['module_slug'] = Variable<String>(moduleSlug.value);
    }
    if (workflowSlug.present) {
      map['workflow_slug'] = Variable<String>(workflowSlug.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (sectionSlug.present) {
      map['section_slug'] = Variable<String>(sectionSlug.value);
    }
    if (sectionName.present) {
      map['section_name'] = Variable<String>(sectionName.value);
    }
    if (sectionPosition.present) {
      map['section_position'] = Variable<int>(sectionPosition.value);
    }
    if (sectionDescription.present) {
      map['section_description'] = Variable<String>(sectionDescription.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormsCompanion(')
          ..write('slug: $slug, ')
          ..write('questionnaireId: $questionnaireId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('moduleSlug: $moduleSlug, ')
          ..write('workflowSlug: $workflowSlug, ')
          ..write('position: $position, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sectionSlug: $sectionSlug, ')
          ..write('sectionName: $sectionName, ')
          ..write('sectionPosition: $sectionPosition, ')
          ..write('sectionDescription: $sectionDescription, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormFieldsTable extends FormFields
    with TableInfo<$FormFieldsTable, FormField> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formSlugMeta = const VerificationMeta(
    'formSlug',
  );
  @override
  late final GeneratedColumn<String> formSlug = GeneratedColumn<String>(
    'form_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _requiredMeta = const VerificationMeta(
    'required',
  );
  @override
  late final GeneratedColumn<bool> required = GeneratedColumn<bool>(
    'required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    formSlug,
    label,
    type,
    name,
    required,
    position,
    optionsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'form_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormField> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('form_slug')) {
      context.handle(
        _formSlugMeta,
        formSlug.isAcceptableOrUnknown(data['form_slug']!, _formSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_formSlugMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('required')) {
      context.handle(
        _requiredMeta,
        required.isAcceptableOrUnknown(data['required']!, _requiredMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormField map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormField(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      formSlug:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}form_slug'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      required:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}required'],
          )!,
      position:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}position'],
          )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      ),
    );
  }

  @override
  $FormFieldsTable createAlias(String alias) {
    return $FormFieldsTable(attachedDatabase, alias);
  }
}

class FormField extends DataClass implements Insertable<FormField> {
  final int id;
  final String formSlug;
  final String label;
  final String type;
  final String name;
  final bool required;
  final int position;
  final String? optionsJson;
  const FormField({
    required this.id,
    required this.formSlug,
    required this.label,
    required this.type,
    required this.name,
    required this.required,
    required this.position,
    this.optionsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['form_slug'] = Variable<String>(formSlug);
    map['label'] = Variable<String>(label);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['required'] = Variable<bool>(required);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || optionsJson != null) {
      map['options_json'] = Variable<String>(optionsJson);
    }
    return map;
  }

  FormFieldsCompanion toCompanion(bool nullToAbsent) {
    return FormFieldsCompanion(
      id: Value(id),
      formSlug: Value(formSlug),
      label: Value(label),
      type: Value(type),
      name: Value(name),
      required: Value(required),
      position: Value(position),
      optionsJson:
          optionsJson == null && nullToAbsent
              ? const Value.absent()
              : Value(optionsJson),
    );
  }

  factory FormField.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormField(
      id: serializer.fromJson<int>(json['id']),
      formSlug: serializer.fromJson<String>(json['formSlug']),
      label: serializer.fromJson<String>(json['label']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      required: serializer.fromJson<bool>(json['required']),
      position: serializer.fromJson<int>(json['position']),
      optionsJson: serializer.fromJson<String?>(json['optionsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'formSlug': serializer.toJson<String>(formSlug),
      'label': serializer.toJson<String>(label),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'required': serializer.toJson<bool>(required),
      'position': serializer.toJson<int>(position),
      'optionsJson': serializer.toJson<String?>(optionsJson),
    };
  }

  FormField copyWith({
    int? id,
    String? formSlug,
    String? label,
    String? type,
    String? name,
    bool? required,
    int? position,
    Value<String?> optionsJson = const Value.absent(),
  }) => FormField(
    id: id ?? this.id,
    formSlug: formSlug ?? this.formSlug,
    label: label ?? this.label,
    type: type ?? this.type,
    name: name ?? this.name,
    required: required ?? this.required,
    position: position ?? this.position,
    optionsJson: optionsJson.present ? optionsJson.value : this.optionsJson,
  );
  FormField copyWithCompanion(FormFieldsCompanion data) {
    return FormField(
      id: data.id.present ? data.id.value : this.id,
      formSlug: data.formSlug.present ? data.formSlug.value : this.formSlug,
      label: data.label.present ? data.label.value : this.label,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      required: data.required.present ? data.required.value : this.required,
      position: data.position.present ? data.position.value : this.position,
      optionsJson:
          data.optionsJson.present ? data.optionsJson.value : this.optionsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormField(')
          ..write('id: $id, ')
          ..write('formSlug: $formSlug, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('required: $required, ')
          ..write('position: $position, ')
          ..write('optionsJson: $optionsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    formSlug,
    label,
    type,
    name,
    required,
    position,
    optionsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormField &&
          other.id == this.id &&
          other.formSlug == this.formSlug &&
          other.label == this.label &&
          other.type == this.type &&
          other.name == this.name &&
          other.required == this.required &&
          other.position == this.position &&
          other.optionsJson == this.optionsJson);
}

class FormFieldsCompanion extends UpdateCompanion<FormField> {
  final Value<int> id;
  final Value<String> formSlug;
  final Value<String> label;
  final Value<String> type;
  final Value<String> name;
  final Value<bool> required;
  final Value<int> position;
  final Value<String?> optionsJson;
  const FormFieldsCompanion({
    this.id = const Value.absent(),
    this.formSlug = const Value.absent(),
    this.label = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.required = const Value.absent(),
    this.position = const Value.absent(),
    this.optionsJson = const Value.absent(),
  });
  FormFieldsCompanion.insert({
    this.id = const Value.absent(),
    required String formSlug,
    required String label,
    required String type,
    required String name,
    this.required = const Value.absent(),
    required int position,
    this.optionsJson = const Value.absent(),
  }) : formSlug = Value(formSlug),
       label = Value(label),
       type = Value(type),
       name = Value(name),
       position = Value(position);
  static Insertable<FormField> custom({
    Expression<int>? id,
    Expression<String>? formSlug,
    Expression<String>? label,
    Expression<String>? type,
    Expression<String>? name,
    Expression<bool>? required,
    Expression<int>? position,
    Expression<String>? optionsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formSlug != null) 'form_slug': formSlug,
      if (label != null) 'label': label,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (required != null) 'required': required,
      if (position != null) 'position': position,
      if (optionsJson != null) 'options_json': optionsJson,
    });
  }

  FormFieldsCompanion copyWith({
    Value<int>? id,
    Value<String>? formSlug,
    Value<String>? label,
    Value<String>? type,
    Value<String>? name,
    Value<bool>? required,
    Value<int>? position,
    Value<String?>? optionsJson,
  }) {
    return FormFieldsCompanion(
      id: id ?? this.id,
      formSlug: formSlug ?? this.formSlug,
      label: label ?? this.label,
      type: type ?? this.type,
      name: name ?? this.name,
      required: required ?? this.required,
      position: position ?? this.position,
      optionsJson: optionsJson ?? this.optionsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (formSlug.present) {
      map['form_slug'] = Variable<String>(formSlug.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (required.present) {
      map['required'] = Variable<bool>(required.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormFieldsCompanion(')
          ..write('id: $id, ')
          ..write('formSlug: $formSlug, ')
          ..write('label: $label, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('required: $required, ')
          ..write('position: $position, ')
          ..write('optionsJson: $optionsJson')
          ..write(')'))
        .toString();
  }
}

class $SurveyResponsesTable extends SurveyResponses
    with TableInfo<$SurveyResponsesTable, SurveyResponse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurveyResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surveyIdMeta = const VerificationMeta(
    'surveyId',
  );
  @override
  late final GeneratedColumn<String> surveyId = GeneratedColumn<String>(
    'survey_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionnaireIdMeta = const VerificationMeta(
    'questionnaireId',
  );
  @override
  late final GeneratedColumn<int> questionnaireId = GeneratedColumn<int>(
    'questionnaire_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionnaireSlugMeta = const VerificationMeta(
    'questionnaireSlug',
  );
  @override
  late final GeneratedColumn<String> questionnaireSlug =
      GeneratedColumn<String>(
        'questionnaire_slug',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _formSlugMeta = const VerificationMeta(
    'formSlug',
  );
  @override
  late final GeneratedColumn<String> formSlug = GeneratedColumn<String>(
    'form_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDraftMeta = const VerificationMeta(
    'isDraft',
  );
  @override
  late final GeneratedColumn<bool> isDraft = GeneratedColumn<bool>(
    'is_draft',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_draft" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _schemaSnapshotJsonMeta =
      const VerificationMeta('schemaSnapshotJson');
  @override
  late final GeneratedColumn<String> schemaSnapshotJson =
      GeneratedColumn<String>(
        'schema_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surveyId,
    projectId,
    questionnaireId,
    questionnaireSlug,
    formSlug,
    answersJson,
    isDraft,
    updatedAt,
    dirty,
    schemaSnapshotJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'survey_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurveyResponse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('survey_id')) {
      context.handle(
        _surveyIdMeta,
        surveyId.isAcceptableOrUnknown(data['survey_id']!, _surveyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surveyIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('questionnaire_id')) {
      context.handle(
        _questionnaireIdMeta,
        questionnaireId.isAcceptableOrUnknown(
          data['questionnaire_id']!,
          _questionnaireIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionnaireIdMeta);
    }
    if (data.containsKey('questionnaire_slug')) {
      context.handle(
        _questionnaireSlugMeta,
        questionnaireSlug.isAcceptableOrUnknown(
          data['questionnaire_slug']!,
          _questionnaireSlugMeta,
        ),
      );
    }
    if (data.containsKey('form_slug')) {
      context.handle(
        _formSlugMeta,
        formSlug.isAcceptableOrUnknown(data['form_slug']!, _formSlugMeta),
      );
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    if (data.containsKey('is_draft')) {
      context.handle(
        _isDraftMeta,
        isDraft.isAcceptableOrUnknown(data['is_draft']!, _isDraftMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('schema_snapshot_json')) {
      context.handle(
        _schemaSnapshotJsonMeta,
        schemaSnapshotJson.isAcceptableOrUnknown(
          data['schema_snapshot_json']!,
          _schemaSnapshotJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurveyResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurveyResponse(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      surveyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}survey_id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      questionnaireId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}questionnaire_id'],
          )!,
      questionnaireSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questionnaire_slug'],
      ),
      formSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_slug'],
      ),
      answersJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}answers_json'],
          )!,
      isDraft:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_draft'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      dirty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}dirty'],
          )!,
      schemaSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_snapshot_json'],
      ),
    );
  }

  @override
  $SurveyResponsesTable createAlias(String alias) {
    return $SurveyResponsesTable(attachedDatabase, alias);
  }
}

class SurveyResponse extends DataClass implements Insertable<SurveyResponse> {
  final String id;
  final String surveyId;
  final String projectId;
  final int questionnaireId;
  final String? questionnaireSlug;
  final String? formSlug;
  final String answersJson;
  final bool isDraft;
  final int updatedAt;
  final bool dirty;
  final String? schemaSnapshotJson;
  const SurveyResponse({
    required this.id,
    required this.surveyId,
    required this.projectId,
    required this.questionnaireId,
    this.questionnaireSlug,
    this.formSlug,
    required this.answersJson,
    required this.isDraft,
    required this.updatedAt,
    required this.dirty,
    this.schemaSnapshotJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['survey_id'] = Variable<String>(surveyId);
    map['project_id'] = Variable<String>(projectId);
    map['questionnaire_id'] = Variable<int>(questionnaireId);
    if (!nullToAbsent || questionnaireSlug != null) {
      map['questionnaire_slug'] = Variable<String>(questionnaireSlug);
    }
    if (!nullToAbsent || formSlug != null) {
      map['form_slug'] = Variable<String>(formSlug);
    }
    map['answers_json'] = Variable<String>(answersJson);
    map['is_draft'] = Variable<bool>(isDraft);
    map['updated_at'] = Variable<int>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    if (!nullToAbsent || schemaSnapshotJson != null) {
      map['schema_snapshot_json'] = Variable<String>(schemaSnapshotJson);
    }
    return map;
  }

  SurveyResponsesCompanion toCompanion(bool nullToAbsent) {
    return SurveyResponsesCompanion(
      id: Value(id),
      surveyId: Value(surveyId),
      projectId: Value(projectId),
      questionnaireId: Value(questionnaireId),
      questionnaireSlug:
          questionnaireSlug == null && nullToAbsent
              ? const Value.absent()
              : Value(questionnaireSlug),
      formSlug:
          formSlug == null && nullToAbsent
              ? const Value.absent()
              : Value(formSlug),
      answersJson: Value(answersJson),
      isDraft: Value(isDraft),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
      schemaSnapshotJson:
          schemaSnapshotJson == null && nullToAbsent
              ? const Value.absent()
              : Value(schemaSnapshotJson),
    );
  }

  factory SurveyResponse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurveyResponse(
      id: serializer.fromJson<String>(json['id']),
      surveyId: serializer.fromJson<String>(json['surveyId']),
      projectId: serializer.fromJson<String>(json['projectId']),
      questionnaireId: serializer.fromJson<int>(json['questionnaireId']),
      questionnaireSlug: serializer.fromJson<String?>(
        json['questionnaireSlug'],
      ),
      formSlug: serializer.fromJson<String?>(json['formSlug']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      schemaSnapshotJson: serializer.fromJson<String?>(
        json['schemaSnapshotJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surveyId': serializer.toJson<String>(surveyId),
      'projectId': serializer.toJson<String>(projectId),
      'questionnaireId': serializer.toJson<int>(questionnaireId),
      'questionnaireSlug': serializer.toJson<String?>(questionnaireSlug),
      'formSlug': serializer.toJson<String?>(formSlug),
      'answersJson': serializer.toJson<String>(answersJson),
      'isDraft': serializer.toJson<bool>(isDraft),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
      'schemaSnapshotJson': serializer.toJson<String?>(schemaSnapshotJson),
    };
  }

  SurveyResponse copyWith({
    String? id,
    String? surveyId,
    String? projectId,
    int? questionnaireId,
    Value<String?> questionnaireSlug = const Value.absent(),
    Value<String?> formSlug = const Value.absent(),
    String? answersJson,
    bool? isDraft,
    int? updatedAt,
    bool? dirty,
    Value<String?> schemaSnapshotJson = const Value.absent(),
  }) => SurveyResponse(
    id: id ?? this.id,
    surveyId: surveyId ?? this.surveyId,
    projectId: projectId ?? this.projectId,
    questionnaireId: questionnaireId ?? this.questionnaireId,
    questionnaireSlug:
        questionnaireSlug.present
            ? questionnaireSlug.value
            : this.questionnaireSlug,
    formSlug: formSlug.present ? formSlug.value : this.formSlug,
    answersJson: answersJson ?? this.answersJson,
    isDraft: isDraft ?? this.isDraft,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
    schemaSnapshotJson:
        schemaSnapshotJson.present
            ? schemaSnapshotJson.value
            : this.schemaSnapshotJson,
  );
  SurveyResponse copyWithCompanion(SurveyResponsesCompanion data) {
    return SurveyResponse(
      id: data.id.present ? data.id.value : this.id,
      surveyId: data.surveyId.present ? data.surveyId.value : this.surveyId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      questionnaireId:
          data.questionnaireId.present
              ? data.questionnaireId.value
              : this.questionnaireId,
      questionnaireSlug:
          data.questionnaireSlug.present
              ? data.questionnaireSlug.value
              : this.questionnaireSlug,
      formSlug: data.formSlug.present ? data.formSlug.value : this.formSlug,
      answersJson:
          data.answersJson.present ? data.answersJson.value : this.answersJson,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      schemaSnapshotJson:
          data.schemaSnapshotJson.present
              ? data.schemaSnapshotJson.value
              : this.schemaSnapshotJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurveyResponse(')
          ..write('id: $id, ')
          ..write('surveyId: $surveyId, ')
          ..write('projectId: $projectId, ')
          ..write('questionnaireId: $questionnaireId, ')
          ..write('questionnaireSlug: $questionnaireSlug, ')
          ..write('formSlug: $formSlug, ')
          ..write('answersJson: $answersJson, ')
          ..write('isDraft: $isDraft, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('schemaSnapshotJson: $schemaSnapshotJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surveyId,
    projectId,
    questionnaireId,
    questionnaireSlug,
    formSlug,
    answersJson,
    isDraft,
    updatedAt,
    dirty,
    schemaSnapshotJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurveyResponse &&
          other.id == this.id &&
          other.surveyId == this.surveyId &&
          other.projectId == this.projectId &&
          other.questionnaireId == this.questionnaireId &&
          other.questionnaireSlug == this.questionnaireSlug &&
          other.formSlug == this.formSlug &&
          other.answersJson == this.answersJson &&
          other.isDraft == this.isDraft &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty &&
          other.schemaSnapshotJson == this.schemaSnapshotJson);
}

class SurveyResponsesCompanion extends UpdateCompanion<SurveyResponse> {
  final Value<String> id;
  final Value<String> surveyId;
  final Value<String> projectId;
  final Value<int> questionnaireId;
  final Value<String?> questionnaireSlug;
  final Value<String?> formSlug;
  final Value<String> answersJson;
  final Value<bool> isDraft;
  final Value<int> updatedAt;
  final Value<bool> dirty;
  final Value<String?> schemaSnapshotJson;
  final Value<int> rowid;
  const SurveyResponsesCompanion({
    this.id = const Value.absent(),
    this.surveyId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.questionnaireId = const Value.absent(),
    this.questionnaireSlug = const Value.absent(),
    this.formSlug = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.schemaSnapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurveyResponsesCompanion.insert({
    required String id,
    required String surveyId,
    required String projectId,
    required int questionnaireId,
    this.questionnaireSlug = const Value.absent(),
    this.formSlug = const Value.absent(),
    required String answersJson,
    this.isDraft = const Value.absent(),
    required int updatedAt,
    this.dirty = const Value.absent(),
    this.schemaSnapshotJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       surveyId = Value(surveyId),
       projectId = Value(projectId),
       questionnaireId = Value(questionnaireId),
       answersJson = Value(answersJson),
       updatedAt = Value(updatedAt);
  static Insertable<SurveyResponse> custom({
    Expression<String>? id,
    Expression<String>? surveyId,
    Expression<String>? projectId,
    Expression<int>? questionnaireId,
    Expression<String>? questionnaireSlug,
    Expression<String>? formSlug,
    Expression<String>? answersJson,
    Expression<bool>? isDraft,
    Expression<int>? updatedAt,
    Expression<bool>? dirty,
    Expression<String>? schemaSnapshotJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surveyId != null) 'survey_id': surveyId,
      if (projectId != null) 'project_id': projectId,
      if (questionnaireId != null) 'questionnaire_id': questionnaireId,
      if (questionnaireSlug != null) 'questionnaire_slug': questionnaireSlug,
      if (formSlug != null) 'form_slug': formSlug,
      if (answersJson != null) 'answers_json': answersJson,
      if (isDraft != null) 'is_draft': isDraft,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (schemaSnapshotJson != null)
        'schema_snapshot_json': schemaSnapshotJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurveyResponsesCompanion copyWith({
    Value<String>? id,
    Value<String>? surveyId,
    Value<String>? projectId,
    Value<int>? questionnaireId,
    Value<String?>? questionnaireSlug,
    Value<String?>? formSlug,
    Value<String>? answersJson,
    Value<bool>? isDraft,
    Value<int>? updatedAt,
    Value<bool>? dirty,
    Value<String?>? schemaSnapshotJson,
    Value<int>? rowid,
  }) {
    return SurveyResponsesCompanion(
      id: id ?? this.id,
      surveyId: surveyId ?? this.surveyId,
      projectId: projectId ?? this.projectId,
      questionnaireId: questionnaireId ?? this.questionnaireId,
      questionnaireSlug: questionnaireSlug ?? this.questionnaireSlug,
      formSlug: formSlug ?? this.formSlug,
      answersJson: answersJson ?? this.answersJson,
      isDraft: isDraft ?? this.isDraft,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      schemaSnapshotJson: schemaSnapshotJson ?? this.schemaSnapshotJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surveyId.present) {
      map['survey_id'] = Variable<String>(surveyId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (questionnaireId.present) {
      map['questionnaire_id'] = Variable<int>(questionnaireId.value);
    }
    if (questionnaireSlug.present) {
      map['questionnaire_slug'] = Variable<String>(questionnaireSlug.value);
    }
    if (formSlug.present) {
      map['form_slug'] = Variable<String>(formSlug.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (schemaSnapshotJson.present) {
      map['schema_snapshot_json'] = Variable<String>(schemaSnapshotJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurveyResponsesCompanion(')
          ..write('id: $id, ')
          ..write('surveyId: $surveyId, ')
          ..write('projectId: $projectId, ')
          ..write('questionnaireId: $questionnaireId, ')
          ..write('questionnaireSlug: $questionnaireSlug, ')
          ..write('formSlug: $formSlug, ')
          ..write('answersJson: $answersJson, ')
          ..write('isDraft: $isDraft, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('schemaSnapshotJson: $schemaSnapshotJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BaseMapsTable extends BaseMaps with TableInfo<$BaseMapsTable, BaseMap> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BaseMapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _geoJsonMeta = const VerificationMeta(
    'geoJson',
  );
  @override
  late final GeneratedColumn<String> geoJson = GeneratedColumn<String>(
    'geo_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [projectId, geoJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'base_maps';
  @override
  VerificationContext validateIntegrity(
    Insertable<BaseMap> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('geo_json')) {
      context.handle(
        _geoJsonMeta,
        geoJson.isAcceptableOrUnknown(data['geo_json']!, _geoJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_geoJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {projectId};
  @override
  BaseMap map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaseMap(
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      geoJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}geo_json'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $BaseMapsTable createAlias(String alias) {
    return $BaseMapsTable(attachedDatabase, alias);
  }
}

class BaseMap extends DataClass implements Insertable<BaseMap> {
  final String projectId;
  final String geoJson;
  final int updatedAt;
  const BaseMap({
    required this.projectId,
    required this.geoJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['project_id'] = Variable<String>(projectId);
    map['geo_json'] = Variable<String>(geoJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BaseMapsCompanion toCompanion(bool nullToAbsent) {
    return BaseMapsCompanion(
      projectId: Value(projectId),
      geoJson: Value(geoJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory BaseMap.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaseMap(
      projectId: serializer.fromJson<String>(json['projectId']),
      geoJson: serializer.fromJson<String>(json['geoJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'projectId': serializer.toJson<String>(projectId),
      'geoJson': serializer.toJson<String>(geoJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BaseMap copyWith({String? projectId, String? geoJson, int? updatedAt}) =>
      BaseMap(
        projectId: projectId ?? this.projectId,
        geoJson: geoJson ?? this.geoJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BaseMap copyWithCompanion(BaseMapsCompanion data) {
    return BaseMap(
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      geoJson: data.geoJson.present ? data.geoJson.value : this.geoJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaseMap(')
          ..write('projectId: $projectId, ')
          ..write('geoJson: $geoJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(projectId, geoJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseMap &&
          other.projectId == this.projectId &&
          other.geoJson == this.geoJson &&
          other.updatedAt == this.updatedAt);
}

class BaseMapsCompanion extends UpdateCompanion<BaseMap> {
  final Value<String> projectId;
  final Value<String> geoJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BaseMapsCompanion({
    this.projectId = const Value.absent(),
    this.geoJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BaseMapsCompanion.insert({
    required String projectId,
    required String geoJson,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : projectId = Value(projectId),
       geoJson = Value(geoJson),
       updatedAt = Value(updatedAt);
  static Insertable<BaseMap> custom({
    Expression<String>? projectId,
    Expression<String>? geoJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (projectId != null) 'project_id': projectId,
      if (geoJson != null) 'geo_json': geoJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BaseMapsCompanion copyWith({
    Value<String>? projectId,
    Value<String>? geoJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BaseMapsCompanion(
      projectId: projectId ?? this.projectId,
      geoJson: geoJson ?? this.geoJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (geoJson.present) {
      map['geo_json'] = Variable<String>(geoJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaseMapsCompanion(')
          ..write('projectId: $projectId, ')
          ..write('geoJson: $geoJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZoningFeaturesTable extends ZoningFeatures
    with TableInfo<$ZoningFeaturesTable, ZoningFeature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZoningFeaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _geomTypeMeta = const VerificationMeta(
    'geomType',
  );
  @override
  late final GeneratedColumn<String> geomType = GeneratedColumn<String>(
    'geom_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coordsJsonMeta = const VerificationMeta(
    'coordsJson',
  );
  @override
  late final GeneratedColumn<String> coordsJson = GeneratedColumn<String>(
    'coords_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertiesJsonMeta = const VerificationMeta(
    'propertiesJson',
  );
  @override
  late final GeneratedColumn<String> propertiesJson = GeneratedColumn<String>(
    'properties_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDraftMeta = const VerificationMeta(
    'isDraft',
  );
  @override
  late final GeneratedColumn<bool> isDraft = GeneratedColumn<bool>(
    'is_draft',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_draft" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    geomType,
    coordsJson,
    propertiesJson,
    isDraft,
    updatedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zoning_features';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZoningFeature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('geom_type')) {
      context.handle(
        _geomTypeMeta,
        geomType.isAcceptableOrUnknown(data['geom_type']!, _geomTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_geomTypeMeta);
    }
    if (data.containsKey('coords_json')) {
      context.handle(
        _coordsJsonMeta,
        coordsJson.isAcceptableOrUnknown(data['coords_json']!, _coordsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_coordsJsonMeta);
    }
    if (data.containsKey('properties_json')) {
      context.handle(
        _propertiesJsonMeta,
        propertiesJson.isAcceptableOrUnknown(
          data['properties_json']!,
          _propertiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_draft')) {
      context.handle(
        _isDraftMeta,
        isDraft.isAcceptableOrUnknown(data['is_draft']!, _isDraftMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZoningFeature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZoningFeature(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      geomType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}geom_type'],
          )!,
      coordsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}coords_json'],
          )!,
      propertiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}properties_json'],
      ),
      isDraft:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_draft'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      dirty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}dirty'],
          )!,
    );
  }

  @override
  $ZoningFeaturesTable createAlias(String alias) {
    return $ZoningFeaturesTable(attachedDatabase, alias);
  }
}

class ZoningFeature extends DataClass implements Insertable<ZoningFeature> {
  final String id;
  final String projectId;
  final String geomType;
  final String coordsJson;
  final String? propertiesJson;
  final bool isDraft;
  final int updatedAt;
  final bool dirty;
  const ZoningFeature({
    required this.id,
    required this.projectId,
    required this.geomType,
    required this.coordsJson,
    this.propertiesJson,
    required this.isDraft,
    required this.updatedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['geom_type'] = Variable<String>(geomType);
    map['coords_json'] = Variable<String>(coordsJson);
    if (!nullToAbsent || propertiesJson != null) {
      map['properties_json'] = Variable<String>(propertiesJson);
    }
    map['is_draft'] = Variable<bool>(isDraft);
    map['updated_at'] = Variable<int>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  ZoningFeaturesCompanion toCompanion(bool nullToAbsent) {
    return ZoningFeaturesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      geomType: Value(geomType),
      coordsJson: Value(coordsJson),
      propertiesJson:
          propertiesJson == null && nullToAbsent
              ? const Value.absent()
              : Value(propertiesJson),
      isDraft: Value(isDraft),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
    );
  }

  factory ZoningFeature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZoningFeature(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      geomType: serializer.fromJson<String>(json['geomType']),
      coordsJson: serializer.fromJson<String>(json['coordsJson']),
      propertiesJson: serializer.fromJson<String?>(json['propertiesJson']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'geomType': serializer.toJson<String>(geomType),
      'coordsJson': serializer.toJson<String>(coordsJson),
      'propertiesJson': serializer.toJson<String?>(propertiesJson),
      'isDraft': serializer.toJson<bool>(isDraft),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  ZoningFeature copyWith({
    String? id,
    String? projectId,
    String? geomType,
    String? coordsJson,
    Value<String?> propertiesJson = const Value.absent(),
    bool? isDraft,
    int? updatedAt,
    bool? dirty,
  }) => ZoningFeature(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    geomType: geomType ?? this.geomType,
    coordsJson: coordsJson ?? this.coordsJson,
    propertiesJson:
        propertiesJson.present ? propertiesJson.value : this.propertiesJson,
    isDraft: isDraft ?? this.isDraft,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
  );
  ZoningFeature copyWithCompanion(ZoningFeaturesCompanion data) {
    return ZoningFeature(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      geomType: data.geomType.present ? data.geomType.value : this.geomType,
      coordsJson:
          data.coordsJson.present ? data.coordsJson.value : this.coordsJson,
      propertiesJson:
          data.propertiesJson.present
              ? data.propertiesJson.value
              : this.propertiesJson,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZoningFeature(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('geomType: $geomType, ')
          ..write('coordsJson: $coordsJson, ')
          ..write('propertiesJson: $propertiesJson, ')
          ..write('isDraft: $isDraft, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    geomType,
    coordsJson,
    propertiesJson,
    isDraft,
    updatedAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZoningFeature &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.geomType == this.geomType &&
          other.coordsJson == this.coordsJson &&
          other.propertiesJson == this.propertiesJson &&
          other.isDraft == this.isDraft &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty);
}

class ZoningFeaturesCompanion extends UpdateCompanion<ZoningFeature> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> geomType;
  final Value<String> coordsJson;
  final Value<String?> propertiesJson;
  final Value<bool> isDraft;
  final Value<int> updatedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const ZoningFeaturesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.geomType = const Value.absent(),
    this.coordsJson = const Value.absent(),
    this.propertiesJson = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZoningFeaturesCompanion.insert({
    required String id,
    required String projectId,
    required String geomType,
    required String coordsJson,
    this.propertiesJson = const Value.absent(),
    this.isDraft = const Value.absent(),
    required int updatedAt,
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       geomType = Value(geomType),
       coordsJson = Value(coordsJson),
       updatedAt = Value(updatedAt);
  static Insertable<ZoningFeature> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? geomType,
    Expression<String>? coordsJson,
    Expression<String>? propertiesJson,
    Expression<bool>? isDraft,
    Expression<int>? updatedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (geomType != null) 'geom_type': geomType,
      if (coordsJson != null) 'coords_json': coordsJson,
      if (propertiesJson != null) 'properties_json': propertiesJson,
      if (isDraft != null) 'is_draft': isDraft,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZoningFeaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? geomType,
    Value<String>? coordsJson,
    Value<String?>? propertiesJson,
    Value<bool>? isDraft,
    Value<int>? updatedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return ZoningFeaturesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      geomType: geomType ?? this.geomType,
      coordsJson: coordsJson ?? this.coordsJson,
      propertiesJson: propertiesJson ?? this.propertiesJson,
      isDraft: isDraft ?? this.isDraft,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (geomType.present) {
      map['geom_type'] = Variable<String>(geomType.value);
    }
    if (coordsJson.present) {
      map['coords_json'] = Variable<String>(coordsJson.value);
    }
    if (propertiesJson.present) {
      map['properties_json'] = Variable<String>(propertiesJson.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZoningFeaturesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('geomType: $geomType, ')
          ..write('coordsJson: $coordsJson, ')
          ..write('propertiesJson: $propertiesJson, ')
          ..write('isDraft: $isDraft, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLogsTable extends SyncLogs with TableInfo<$SyncLogsTable, SyncLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refTypeMeta = const VerificationMeta(
    'refType',
  );
  @override
  late final GeneratedColumn<String> refType = GeneratedColumn<String>(
    'ref_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    refType,
    refId,
    op,
    status,
    lastError,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ref_type')) {
      context.handle(
        _refTypeMeta,
        refType.isAcceptableOrUnknown(data['ref_type']!, _refTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_refTypeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLog(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      refType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ref_type'],
          )!,
      refId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ref_id'],
          )!,
      op:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}op'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $SyncLogsTable createAlias(String alias) {
    return $SyncLogsTable(attachedDatabase, alias);
  }
}

class SyncLog extends DataClass implements Insertable<SyncLog> {
  final String id;
  final String refType;
  final String refId;
  final String op;
  final String status;
  final String? lastError;
  final int updatedAt;
  const SyncLog({
    required this.id,
    required this.refType,
    required this.refId,
    required this.op,
    required this.status,
    this.lastError,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ref_type'] = Variable<String>(refType);
    map['ref_id'] = Variable<String>(refId);
    map['op'] = Variable<String>(op);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SyncLogsCompanion toCompanion(bool nullToAbsent) {
    return SyncLogsCompanion(
      id: Value(id),
      refType: Value(refType),
      refId: Value(refId),
      op: Value(op),
      status: Value(status),
      lastError:
          lastError == null && nullToAbsent
              ? const Value.absent()
              : Value(lastError),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLog(
      id: serializer.fromJson<String>(json['id']),
      refType: serializer.fromJson<String>(json['refType']),
      refId: serializer.fromJson<String>(json['refId']),
      op: serializer.fromJson<String>(json['op']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'refType': serializer.toJson<String>(refType),
      'refId': serializer.toJson<String>(refId),
      'op': serializer.toJson<String>(op),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SyncLog copyWith({
    String? id,
    String? refType,
    String? refId,
    String? op,
    String? status,
    Value<String?> lastError = const Value.absent(),
    int? updatedAt,
  }) => SyncLog(
    id: id ?? this.id,
    refType: refType ?? this.refType,
    refId: refId ?? this.refId,
    op: op ?? this.op,
    status: status ?? this.status,
    lastError: lastError.present ? lastError.value : this.lastError,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncLog copyWithCompanion(SyncLogsCompanion data) {
    return SyncLog(
      id: data.id.present ? data.id.value : this.id,
      refType: data.refType.present ? data.refType.value : this.refType,
      refId: data.refId.present ? data.refId.value : this.refId,
      op: data.op.present ? data.op.value : this.op,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLog(')
          ..write('id: $id, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('op: $op, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, refType, refId, op, status, lastError, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLog &&
          other.id == this.id &&
          other.refType == this.refType &&
          other.refId == this.refId &&
          other.op == this.op &&
          other.status == this.status &&
          other.lastError == this.lastError &&
          other.updatedAt == this.updatedAt);
}

class SyncLogsCompanion extends UpdateCompanion<SyncLog> {
  final Value<String> id;
  final Value<String> refType;
  final Value<String> refId;
  final Value<String> op;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SyncLogsCompanion({
    this.id = const Value.absent(),
    this.refType = const Value.absent(),
    this.refId = const Value.absent(),
    this.op = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncLogsCompanion.insert({
    required String id,
    required String refType,
    required String refId,
    required String op,
    required String status,
    this.lastError = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       refType = Value(refType),
       refId = Value(refId),
       op = Value(op),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<SyncLog> custom({
    Expression<String>? id,
    Expression<String>? refType,
    Expression<String>? refId,
    Expression<String>? op,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (refType != null) 'ref_type': refType,
      if (refId != null) 'ref_id': refId,
      if (op != null) 'op': op,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? refType,
    Value<String>? refId,
    Value<String>? op,
    Value<String>? status,
    Value<String?>? lastError,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncLogsCompanion(
      id: id ?? this.id,
      refType: refType ?? this.refType,
      refId: refId ?? this.refId,
      op: op ?? this.op,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (refType.present) {
      map['ref_type'] = Variable<String>(refType.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogsCompanion(')
          ..write('id: $id, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('op: $op, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $ProjectPacksTable projectPacks = $ProjectPacksTable(this);
  late final $QuestionnaireTypesTable questionnaireTypes =
      $QuestionnaireTypesTable(this);
  late final $QuestionnairesTable questionnaires = $QuestionnairesTable(this);
  late final $FormsTable forms = $FormsTable(this);
  late final $FormFieldsTable formFields = $FormFieldsTable(this);
  late final $SurveyResponsesTable surveyResponses = $SurveyResponsesTable(
    this,
  );
  late final $BaseMapsTable baseMaps = $BaseMapsTable(this);
  late final $ZoningFeaturesTable zoningFeatures = $ZoningFeaturesTable(this);
  late final $SyncLogsTable syncLogs = $SyncLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    projects,
    projectPacks,
    questionnaireTypes,
    questionnaires,
    forms,
    formFields,
    surveyResponses,
    baseMaps,
    zoningFeatures,
    syncLogs,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String email,
      required String firstName,
      required String lastName,
      required String mobileModulesJson,
      required int updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> mobileModulesJson,
      Value<int> updatedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobileModulesJson => $composableBuilder(
    column: $table.mobileModulesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobileModulesJson => $composableBuilder(
    column: $table.mobileModulesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get mobileModulesJson => $composableBuilder(
    column: $table.mobileModulesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> mobileModulesJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                firstName: firstName,
                lastName: lastName,
                mobileModulesJson: mobileModulesJson,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                required String firstName,
                required String lastName,
                required String mobileModulesJson,
                required int updatedAt,
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                firstName: firstName,
                lastName: lastName,
                mobileModulesJson: mobileModulesJson,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      required int localityId,
      required String status,
      required int assignedOn,
      Value<bool> hasSurvey,
      Value<bool> hasZoning,
      Value<bool> isDownloaded,
      Value<int?> downloadedAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> localityId,
      Value<String> status,
      Value<int> assignedOn,
      Value<bool> hasSurvey,
      Value<bool> hasZoning,
      Value<bool> isDownloaded,
      Value<int?> downloadedAt,
      Value<int> updatedAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignedOn => $composableBuilder(
    column: $table.assignedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSurvey => $composableBuilder(
    column: $table.hasSurvey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasZoning => $composableBuilder(
    column: $table.hasZoning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignedOn => $composableBuilder(
    column: $table.assignedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSurvey => $composableBuilder(
    column: $table.hasSurvey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasZoning => $composableBuilder(
    column: $table.hasZoning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get assignedOn => $composableBuilder(
    column: $table.assignedOn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSurvey =>
      $composableBuilder(column: $table.hasSurvey, builder: (column) => column);

  GeneratedColumn<bool> get hasZoning =>
      $composableBuilder(column: $table.hasZoning, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
    column: $table.isDownloaded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
          createFilteringComposer:
              () => $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> assignedOn = const Value.absent(),
                Value<bool> hasSurvey = const Value.absent(),
                Value<bool> hasZoning = const Value.absent(),
                Value<bool> isDownloaded = const Value.absent(),
                Value<int?> downloadedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                localityId: localityId,
                status: status,
                assignedOn: assignedOn,
                hasSurvey: hasSurvey,
                hasZoning: hasZoning,
                isDownloaded: isDownloaded,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int localityId,
                required String status,
                required int assignedOn,
                Value<bool> hasSurvey = const Value.absent(),
                Value<bool> hasZoning = const Value.absent(),
                Value<bool> isDownloaded = const Value.absent(),
                Value<int?> downloadedAt = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                localityId: localityId,
                status: status,
                assignedOn: assignedOn,
                hasSurvey: hasSurvey,
                hasZoning: hasZoning,
                isDownloaded: isDownloaded,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
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
typedef $$ProjectPacksTableCreateCompanionBuilder =
    ProjectPacksCompanion Function({
      required String projectId,
      required String status,
      Value<int?> downloadedAt,
      required int updatedAt,
      Value<int?> sizeBytes,
      Value<int> rowid,
    });
typedef $$ProjectPacksTableUpdateCompanionBuilder =
    ProjectPacksCompanion Function({
      Value<String> projectId,
      Value<String> status,
      Value<int?> downloadedAt,
      Value<int> updatedAt,
      Value<int?> sizeBytes,
      Value<int> rowid,
    });

class $$ProjectPacksTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectPacksTable> {
  $$ProjectPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectPacksTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectPacksTable> {
  $$ProjectPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectPacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectPacksTable> {
  $$ProjectPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);
}

class $$ProjectPacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectPacksTable,
          ProjectPack,
          $$ProjectPacksTableFilterComposer,
          $$ProjectPacksTableOrderingComposer,
          $$ProjectPacksTableAnnotationComposer,
          $$ProjectPacksTableCreateCompanionBuilder,
          $$ProjectPacksTableUpdateCompanionBuilder,
          (
            ProjectPack,
            BaseReferences<_$AppDatabase, $ProjectPacksTable, ProjectPack>,
          ),
          ProjectPack,
          PrefetchHooks Function()
        > {
  $$ProjectPacksTableTableManager(_$AppDatabase db, $ProjectPacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProjectPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ProjectPacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ProjectPacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> projectId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> downloadedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> sizeBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectPacksCompanion(
                projectId: projectId,
                status: status,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
                sizeBytes: sizeBytes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String projectId,
                required String status,
                Value<int?> downloadedAt = const Value.absent(),
                required int updatedAt,
                Value<int?> sizeBytes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectPacksCompanion.insert(
                projectId: projectId,
                status: status,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
                sizeBytes: sizeBytes,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectPacksTable,
      ProjectPack,
      $$ProjectPacksTableFilterComposer,
      $$ProjectPacksTableOrderingComposer,
      $$ProjectPacksTableAnnotationComposer,
      $$ProjectPacksTableCreateCompanionBuilder,
      $$ProjectPacksTableUpdateCompanionBuilder,
      (
        ProjectPack,
        BaseReferences<_$AppDatabase, $ProjectPacksTable, ProjectPack>,
      ),
      ProjectPack,
      PrefetchHooks Function()
    >;
typedef $$QuestionnaireTypesTableCreateCompanionBuilder =
    QuestionnaireTypesCompanion Function({
      Value<int> id,
      required String name,
      required String slug,
      required int localityId,
    });
typedef $$QuestionnaireTypesTableUpdateCompanionBuilder =
    QuestionnaireTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> slug,
      Value<int> localityId,
    });

class $$QuestionnaireTypesTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionnaireTypesTable> {
  $$QuestionnaireTypesTableFilterComposer({
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

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionnaireTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionnaireTypesTable> {
  $$QuestionnaireTypesTableOrderingComposer({
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

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionnaireTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionnaireTypesTable> {
  $$QuestionnaireTypesTableAnnotationComposer({
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

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );
}

class $$QuestionnaireTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionnaireTypesTable,
          QuestionnaireType,
          $$QuestionnaireTypesTableFilterComposer,
          $$QuestionnaireTypesTableOrderingComposer,
          $$QuestionnaireTypesTableAnnotationComposer,
          $$QuestionnaireTypesTableCreateCompanionBuilder,
          $$QuestionnaireTypesTableUpdateCompanionBuilder,
          (
            QuestionnaireType,
            BaseReferences<
              _$AppDatabase,
              $QuestionnaireTypesTable,
              QuestionnaireType
            >,
          ),
          QuestionnaireType,
          PrefetchHooks Function()
        > {
  $$QuestionnaireTypesTableTableManager(
    _$AppDatabase db,
    $QuestionnaireTypesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$QuestionnaireTypesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$QuestionnaireTypesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$QuestionnaireTypesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<int> localityId = const Value.absent(),
              }) => QuestionnaireTypesCompanion(
                id: id,
                name: name,
                slug: slug,
                localityId: localityId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String slug,
                required int localityId,
              }) => QuestionnaireTypesCompanion.insert(
                id: id,
                name: name,
                slug: slug,
                localityId: localityId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionnaireTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionnaireTypesTable,
      QuestionnaireType,
      $$QuestionnaireTypesTableFilterComposer,
      $$QuestionnaireTypesTableOrderingComposer,
      $$QuestionnaireTypesTableAnnotationComposer,
      $$QuestionnaireTypesTableCreateCompanionBuilder,
      $$QuestionnaireTypesTableUpdateCompanionBuilder,
      (
        QuestionnaireType,
        BaseReferences<
          _$AppDatabase,
          $QuestionnaireTypesTable,
          QuestionnaireType
        >,
      ),
      QuestionnaireType,
      PrefetchHooks Function()
    >;
typedef $$QuestionnairesTableCreateCompanionBuilder =
    QuestionnairesCompanion Function({
      Value<int> id,
      required String name,
      required String slug,
      required int typeId,
      required String version,
      required int updatedAt,
      required int localityId,
      Value<String> description,
      Value<String> moduleSlug,
      Value<String> moduleName,
    });
typedef $$QuestionnairesTableUpdateCompanionBuilder =
    QuestionnairesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> slug,
      Value<int> typeId,
      Value<String> version,
      Value<int> updatedAt,
      Value<int> localityId,
      Value<String> description,
      Value<String> moduleSlug,
      Value<String> moduleName,
    });

class $$QuestionnairesTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionnairesTable> {
  $$QuestionnairesTableFilterComposer({
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

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typeId => $composableBuilder(
    column: $table.typeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleSlug => $composableBuilder(
    column: $table.moduleSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionnairesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionnairesTable> {
  $$QuestionnairesTableOrderingComposer({
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

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typeId => $composableBuilder(
    column: $table.typeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleSlug => $composableBuilder(
    column: $table.moduleSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionnairesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionnairesTable> {
  $$QuestionnairesTableAnnotationComposer({
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

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<int> get typeId =>
      $composableBuilder(column: $table.typeId, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleSlug => $composableBuilder(
    column: $table.moduleSlug,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleName => $composableBuilder(
    column: $table.moduleName,
    builder: (column) => column,
  );
}

class $$QuestionnairesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionnairesTable,
          Questionnaire,
          $$QuestionnairesTableFilterComposer,
          $$QuestionnairesTableOrderingComposer,
          $$QuestionnairesTableAnnotationComposer,
          $$QuestionnairesTableCreateCompanionBuilder,
          $$QuestionnairesTableUpdateCompanionBuilder,
          (
            Questionnaire,
            BaseReferences<_$AppDatabase, $QuestionnairesTable, Questionnaire>,
          ),
          Questionnaire,
          PrefetchHooks Function()
        > {
  $$QuestionnairesTableTableManager(
    _$AppDatabase db,
    $QuestionnairesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$QuestionnairesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$QuestionnairesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$QuestionnairesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<int> typeId = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> moduleSlug = const Value.absent(),
                Value<String> moduleName = const Value.absent(),
              }) => QuestionnairesCompanion(
                id: id,
                name: name,
                slug: slug,
                typeId: typeId,
                version: version,
                updatedAt: updatedAt,
                localityId: localityId,
                description: description,
                moduleSlug: moduleSlug,
                moduleName: moduleName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String slug,
                required int typeId,
                required String version,
                required int updatedAt,
                required int localityId,
                Value<String> description = const Value.absent(),
                Value<String> moduleSlug = const Value.absent(),
                Value<String> moduleName = const Value.absent(),
              }) => QuestionnairesCompanion.insert(
                id: id,
                name: name,
                slug: slug,
                typeId: typeId,
                version: version,
                updatedAt: updatedAt,
                localityId: localityId,
                description: description,
                moduleSlug: moduleSlug,
                moduleName: moduleName,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionnairesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionnairesTable,
      Questionnaire,
      $$QuestionnairesTableFilterComposer,
      $$QuestionnairesTableOrderingComposer,
      $$QuestionnairesTableAnnotationComposer,
      $$QuestionnairesTableCreateCompanionBuilder,
      $$QuestionnairesTableUpdateCompanionBuilder,
      (
        Questionnaire,
        BaseReferences<_$AppDatabase, $QuestionnairesTable, Questionnaire>,
      ),
      Questionnaire,
      PrefetchHooks Function()
    >;
typedef $$FormsTableCreateCompanionBuilder =
    FormsCompanion Function({
      required String slug,
      Value<int?> questionnaireId,
      required String name,
      required String description,
      required String moduleSlug,
      required String workflowSlug,
      required int position,
      required int updatedAt,
      Value<String> sectionSlug,
      Value<String> sectionName,
      Value<int> sectionPosition,
      Value<String?> sectionDescription,
      Value<int> rowid,
    });
typedef $$FormsTableUpdateCompanionBuilder =
    FormsCompanion Function({
      Value<String> slug,
      Value<int?> questionnaireId,
      Value<String> name,
      Value<String> description,
      Value<String> moduleSlug,
      Value<String> workflowSlug,
      Value<int> position,
      Value<int> updatedAt,
      Value<String> sectionSlug,
      Value<String> sectionName,
      Value<int> sectionPosition,
      Value<String?> sectionDescription,
      Value<int> rowid,
    });

class $$FormsTableFilterComposer extends Composer<_$AppDatabase, $FormsTable> {
  $$FormsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionnaireId => $composableBuilder(
    column: $table.questionnaireId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleSlug => $composableBuilder(
    column: $table.moduleSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workflowSlug => $composableBuilder(
    column: $table.workflowSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionSlug => $composableBuilder(
    column: $table.sectionSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sectionPosition => $composableBuilder(
    column: $table.sectionPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionDescription => $composableBuilder(
    column: $table.sectionDescription,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FormsTableOrderingComposer
    extends Composer<_$AppDatabase, $FormsTable> {
  $$FormsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionnaireId => $composableBuilder(
    column: $table.questionnaireId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleSlug => $composableBuilder(
    column: $table.moduleSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workflowSlug => $composableBuilder(
    column: $table.workflowSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionSlug => $composableBuilder(
    column: $table.sectionSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sectionPosition => $composableBuilder(
    column: $table.sectionPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionDescription => $composableBuilder(
    column: $table.sectionDescription,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FormsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormsTable> {
  $$FormsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<int> get questionnaireId => $composableBuilder(
    column: $table.questionnaireId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleSlug => $composableBuilder(
    column: $table.moduleSlug,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workflowSlug => $composableBuilder(
    column: $table.workflowSlug,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get sectionSlug => $composableBuilder(
    column: $table.sectionSlug,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sectionPosition => $composableBuilder(
    column: $table.sectionPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sectionDescription => $composableBuilder(
    column: $table.sectionDescription,
    builder: (column) => column,
  );
}

class $$FormsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormsTable,
          Form,
          $$FormsTableFilterComposer,
          $$FormsTableOrderingComposer,
          $$FormsTableAnnotationComposer,
          $$FormsTableCreateCompanionBuilder,
          $$FormsTableUpdateCompanionBuilder,
          (Form, BaseReferences<_$AppDatabase, $FormsTable, Form>),
          Form,
          PrefetchHooks Function()
        > {
  $$FormsTableTableManager(_$AppDatabase db, $FormsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FormsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FormsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FormsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> slug = const Value.absent(),
                Value<int?> questionnaireId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> moduleSlug = const Value.absent(),
                Value<String> workflowSlug = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> sectionSlug = const Value.absent(),
                Value<String> sectionName = const Value.absent(),
                Value<int> sectionPosition = const Value.absent(),
                Value<String?> sectionDescription = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormsCompanion(
                slug: slug,
                questionnaireId: questionnaireId,
                name: name,
                description: description,
                moduleSlug: moduleSlug,
                workflowSlug: workflowSlug,
                position: position,
                updatedAt: updatedAt,
                sectionSlug: sectionSlug,
                sectionName: sectionName,
                sectionPosition: sectionPosition,
                sectionDescription: sectionDescription,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String slug,
                Value<int?> questionnaireId = const Value.absent(),
                required String name,
                required String description,
                required String moduleSlug,
                required String workflowSlug,
                required int position,
                required int updatedAt,
                Value<String> sectionSlug = const Value.absent(),
                Value<String> sectionName = const Value.absent(),
                Value<int> sectionPosition = const Value.absent(),
                Value<String?> sectionDescription = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormsCompanion.insert(
                slug: slug,
                questionnaireId: questionnaireId,
                name: name,
                description: description,
                moduleSlug: moduleSlug,
                workflowSlug: workflowSlug,
                position: position,
                updatedAt: updatedAt,
                sectionSlug: sectionSlug,
                sectionName: sectionName,
                sectionPosition: sectionPosition,
                sectionDescription: sectionDescription,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FormsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormsTable,
      Form,
      $$FormsTableFilterComposer,
      $$FormsTableOrderingComposer,
      $$FormsTableAnnotationComposer,
      $$FormsTableCreateCompanionBuilder,
      $$FormsTableUpdateCompanionBuilder,
      (Form, BaseReferences<_$AppDatabase, $FormsTable, Form>),
      Form,
      PrefetchHooks Function()
    >;
typedef $$FormFieldsTableCreateCompanionBuilder =
    FormFieldsCompanion Function({
      Value<int> id,
      required String formSlug,
      required String label,
      required String type,
      required String name,
      Value<bool> required,
      required int position,
      Value<String?> optionsJson,
    });
typedef $$FormFieldsTableUpdateCompanionBuilder =
    FormFieldsCompanion Function({
      Value<int> id,
      Value<String> formSlug,
      Value<String> label,
      Value<String> type,
      Value<String> name,
      Value<bool> required,
      Value<int> position,
      Value<String?> optionsJson,
    });

class $$FormFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $FormFieldsTable> {
  $$FormFieldsTableFilterComposer({
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

  ColumnFilters<String> get formSlug => $composableBuilder(
    column: $table.formSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FormFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $FormFieldsTable> {
  $$FormFieldsTableOrderingComposer({
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

  ColumnOrderings<String> get formSlug => $composableBuilder(
    column: $table.formSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FormFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FormFieldsTable> {
  $$FormFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get formSlug =>
      $composableBuilder(column: $table.formSlug, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get required =>
      $composableBuilder(column: $table.required, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );
}

class $$FormFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FormFieldsTable,
          FormField,
          $$FormFieldsTableFilterComposer,
          $$FormFieldsTableOrderingComposer,
          $$FormFieldsTableAnnotationComposer,
          $$FormFieldsTableCreateCompanionBuilder,
          $$FormFieldsTableUpdateCompanionBuilder,
          (
            FormField,
            BaseReferences<_$AppDatabase, $FormFieldsTable, FormField>,
          ),
          FormField,
          PrefetchHooks Function()
        > {
  $$FormFieldsTableTableManager(_$AppDatabase db, $FormFieldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FormFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FormFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FormFieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> formSlug = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> required = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> optionsJson = const Value.absent(),
              }) => FormFieldsCompanion(
                id: id,
                formSlug: formSlug,
                label: label,
                type: type,
                name: name,
                required: required,
                position: position,
                optionsJson: optionsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String formSlug,
                required String label,
                required String type,
                required String name,
                Value<bool> required = const Value.absent(),
                required int position,
                Value<String?> optionsJson = const Value.absent(),
              }) => FormFieldsCompanion.insert(
                id: id,
                formSlug: formSlug,
                label: label,
                type: type,
                name: name,
                required: required,
                position: position,
                optionsJson: optionsJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FormFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FormFieldsTable,
      FormField,
      $$FormFieldsTableFilterComposer,
      $$FormFieldsTableOrderingComposer,
      $$FormFieldsTableAnnotationComposer,
      $$FormFieldsTableCreateCompanionBuilder,
      $$FormFieldsTableUpdateCompanionBuilder,
      (FormField, BaseReferences<_$AppDatabase, $FormFieldsTable, FormField>),
      FormField,
      PrefetchHooks Function()
    >;
typedef $$SurveyResponsesTableCreateCompanionBuilder =
    SurveyResponsesCompanion Function({
      required String id,
      required String surveyId,
      required String projectId,
      required int questionnaireId,
      Value<String?> questionnaireSlug,
      Value<String?> formSlug,
      required String answersJson,
      Value<bool> isDraft,
      required int updatedAt,
      Value<bool> dirty,
      Value<String?> schemaSnapshotJson,
      Value<int> rowid,
    });
typedef $$SurveyResponsesTableUpdateCompanionBuilder =
    SurveyResponsesCompanion Function({
      Value<String> id,
      Value<String> surveyId,
      Value<String> projectId,
      Value<int> questionnaireId,
      Value<String?> questionnaireSlug,
      Value<String?> formSlug,
      Value<String> answersJson,
      Value<bool> isDraft,
      Value<int> updatedAt,
      Value<bool> dirty,
      Value<String?> schemaSnapshotJson,
      Value<int> rowid,
    });

class $$SurveyResponsesTableFilterComposer
    extends Composer<_$AppDatabase, $SurveyResponsesTable> {
  $$SurveyResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surveyId => $composableBuilder(
    column: $table.surveyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionnaireId => $composableBuilder(
    column: $table.questionnaireId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionnaireSlug => $composableBuilder(
    column: $table.questionnaireSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formSlug => $composableBuilder(
    column: $table.formSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaSnapshotJson => $composableBuilder(
    column: $table.schemaSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SurveyResponsesTableOrderingComposer
    extends Composer<_$AppDatabase, $SurveyResponsesTable> {
  $$SurveyResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surveyId => $composableBuilder(
    column: $table.surveyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionnaireId => $composableBuilder(
    column: $table.questionnaireId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionnaireSlug => $composableBuilder(
    column: $table.questionnaireSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formSlug => $composableBuilder(
    column: $table.formSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaSnapshotJson => $composableBuilder(
    column: $table.schemaSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurveyResponsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurveyResponsesTable> {
  $$SurveyResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get surveyId =>
      $composableBuilder(column: $table.surveyId, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get questionnaireId => $composableBuilder(
    column: $table.questionnaireId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionnaireSlug => $composableBuilder(
    column: $table.questionnaireSlug,
    builder: (column) => column,
  );

  GeneratedColumn<String> get formSlug =>
      $composableBuilder(column: $table.formSlug, builder: (column) => column);

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<String> get schemaSnapshotJson => $composableBuilder(
    column: $table.schemaSnapshotJson,
    builder: (column) => column,
  );
}

class $$SurveyResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurveyResponsesTable,
          SurveyResponse,
          $$SurveyResponsesTableFilterComposer,
          $$SurveyResponsesTableOrderingComposer,
          $$SurveyResponsesTableAnnotationComposer,
          $$SurveyResponsesTableCreateCompanionBuilder,
          $$SurveyResponsesTableUpdateCompanionBuilder,
          (
            SurveyResponse,
            BaseReferences<
              _$AppDatabase,
              $SurveyResponsesTable,
              SurveyResponse
            >,
          ),
          SurveyResponse,
          PrefetchHooks Function()
        > {
  $$SurveyResponsesTableTableManager(
    _$AppDatabase db,
    $SurveyResponsesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SurveyResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SurveyResponsesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SurveyResponsesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> surveyId = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<int> questionnaireId = const Value.absent(),
                Value<String?> questionnaireSlug = const Value.absent(),
                Value<String?> formSlug = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<String?> schemaSnapshotJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SurveyResponsesCompanion(
                id: id,
                surveyId: surveyId,
                projectId: projectId,
                questionnaireId: questionnaireId,
                questionnaireSlug: questionnaireSlug,
                formSlug: formSlug,
                answersJson: answersJson,
                isDraft: isDraft,
                updatedAt: updatedAt,
                dirty: dirty,
                schemaSnapshotJson: schemaSnapshotJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String surveyId,
                required String projectId,
                required int questionnaireId,
                Value<String?> questionnaireSlug = const Value.absent(),
                Value<String?> formSlug = const Value.absent(),
                required String answersJson,
                Value<bool> isDraft = const Value.absent(),
                required int updatedAt,
                Value<bool> dirty = const Value.absent(),
                Value<String?> schemaSnapshotJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SurveyResponsesCompanion.insert(
                id: id,
                surveyId: surveyId,
                projectId: projectId,
                questionnaireId: questionnaireId,
                questionnaireSlug: questionnaireSlug,
                formSlug: formSlug,
                answersJson: answersJson,
                isDraft: isDraft,
                updatedAt: updatedAt,
                dirty: dirty,
                schemaSnapshotJson: schemaSnapshotJson,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SurveyResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurveyResponsesTable,
      SurveyResponse,
      $$SurveyResponsesTableFilterComposer,
      $$SurveyResponsesTableOrderingComposer,
      $$SurveyResponsesTableAnnotationComposer,
      $$SurveyResponsesTableCreateCompanionBuilder,
      $$SurveyResponsesTableUpdateCompanionBuilder,
      (
        SurveyResponse,
        BaseReferences<_$AppDatabase, $SurveyResponsesTable, SurveyResponse>,
      ),
      SurveyResponse,
      PrefetchHooks Function()
    >;
typedef $$BaseMapsTableCreateCompanionBuilder =
    BaseMapsCompanion Function({
      required String projectId,
      required String geoJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$BaseMapsTableUpdateCompanionBuilder =
    BaseMapsCompanion Function({
      Value<String> projectId,
      Value<String> geoJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$BaseMapsTableFilterComposer
    extends Composer<_$AppDatabase, $BaseMapsTable> {
  $$BaseMapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geoJson => $composableBuilder(
    column: $table.geoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BaseMapsTableOrderingComposer
    extends Composer<_$AppDatabase, $BaseMapsTable> {
  $$BaseMapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geoJson => $composableBuilder(
    column: $table.geoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BaseMapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BaseMapsTable> {
  $$BaseMapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get geoJson =>
      $composableBuilder(column: $table.geoJson, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BaseMapsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BaseMapsTable,
          BaseMap,
          $$BaseMapsTableFilterComposer,
          $$BaseMapsTableOrderingComposer,
          $$BaseMapsTableAnnotationComposer,
          $$BaseMapsTableCreateCompanionBuilder,
          $$BaseMapsTableUpdateCompanionBuilder,
          (BaseMap, BaseReferences<_$AppDatabase, $BaseMapsTable, BaseMap>),
          BaseMap,
          PrefetchHooks Function()
        > {
  $$BaseMapsTableTableManager(_$AppDatabase db, $BaseMapsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BaseMapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$BaseMapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BaseMapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> projectId = const Value.absent(),
                Value<String> geoJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BaseMapsCompanion(
                projectId: projectId,
                geoJson: geoJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String projectId,
                required String geoJson,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BaseMapsCompanion.insert(
                projectId: projectId,
                geoJson: geoJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BaseMapsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BaseMapsTable,
      BaseMap,
      $$BaseMapsTableFilterComposer,
      $$BaseMapsTableOrderingComposer,
      $$BaseMapsTableAnnotationComposer,
      $$BaseMapsTableCreateCompanionBuilder,
      $$BaseMapsTableUpdateCompanionBuilder,
      (BaseMap, BaseReferences<_$AppDatabase, $BaseMapsTable, BaseMap>),
      BaseMap,
      PrefetchHooks Function()
    >;
typedef $$ZoningFeaturesTableCreateCompanionBuilder =
    ZoningFeaturesCompanion Function({
      required String id,
      required String projectId,
      required String geomType,
      required String coordsJson,
      Value<String?> propertiesJson,
      Value<bool> isDraft,
      required int updatedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$ZoningFeaturesTableUpdateCompanionBuilder =
    ZoningFeaturesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> geomType,
      Value<String> coordsJson,
      Value<String?> propertiesJson,
      Value<bool> isDraft,
      Value<int> updatedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$ZoningFeaturesTableFilterComposer
    extends Composer<_$AppDatabase, $ZoningFeaturesTable> {
  $$ZoningFeaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geomType => $composableBuilder(
    column: $table.geomType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ZoningFeaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZoningFeaturesTable> {
  $$ZoningFeaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geomType => $composableBuilder(
    column: $table.geomType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZoningFeaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZoningFeaturesTable> {
  $$ZoningFeaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get geomType =>
      $composableBuilder(column: $table.geomType, builder: (column) => column);

  GeneratedColumn<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$ZoningFeaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZoningFeaturesTable,
          ZoningFeature,
          $$ZoningFeaturesTableFilterComposer,
          $$ZoningFeaturesTableOrderingComposer,
          $$ZoningFeaturesTableAnnotationComposer,
          $$ZoningFeaturesTableCreateCompanionBuilder,
          $$ZoningFeaturesTableUpdateCompanionBuilder,
          (
            ZoningFeature,
            BaseReferences<_$AppDatabase, $ZoningFeaturesTable, ZoningFeature>,
          ),
          ZoningFeature,
          PrefetchHooks Function()
        > {
  $$ZoningFeaturesTableTableManager(
    _$AppDatabase db,
    $ZoningFeaturesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ZoningFeaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ZoningFeaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ZoningFeaturesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> geomType = const Value.absent(),
                Value<String> coordsJson = const Value.absent(),
                Value<String?> propertiesJson = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZoningFeaturesCompanion(
                id: id,
                projectId: projectId,
                geomType: geomType,
                coordsJson: coordsJson,
                propertiesJson: propertiesJson,
                isDraft: isDraft,
                updatedAt: updatedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String geomType,
                required String coordsJson,
                Value<String?> propertiesJson = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                required int updatedAt,
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZoningFeaturesCompanion.insert(
                id: id,
                projectId: projectId,
                geomType: geomType,
                coordsJson: coordsJson,
                propertiesJson: propertiesJson,
                isDraft: isDraft,
                updatedAt: updatedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ZoningFeaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZoningFeaturesTable,
      ZoningFeature,
      $$ZoningFeaturesTableFilterComposer,
      $$ZoningFeaturesTableOrderingComposer,
      $$ZoningFeaturesTableAnnotationComposer,
      $$ZoningFeaturesTableCreateCompanionBuilder,
      $$ZoningFeaturesTableUpdateCompanionBuilder,
      (
        ZoningFeature,
        BaseReferences<_$AppDatabase, $ZoningFeaturesTable, ZoningFeature>,
      ),
      ZoningFeature,
      PrefetchHooks Function()
    >;
typedef $$SyncLogsTableCreateCompanionBuilder =
    SyncLogsCompanion Function({
      required String id,
      required String refType,
      required String refId,
      required String op,
      required String status,
      Value<String?> lastError,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$SyncLogsTableUpdateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<String> id,
      Value<String> refType,
      Value<String> refId,
      Value<String> op,
      Value<String> status,
      Value<String?> lastError,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$SyncLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get refType =>
      $composableBuilder(column: $table.refType, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLogsTable,
          SyncLog,
          $$SyncLogsTableFilterComposer,
          $$SyncLogsTableOrderingComposer,
          $$SyncLogsTableAnnotationComposer,
          $$SyncLogsTableCreateCompanionBuilder,
          $$SyncLogsTableUpdateCompanionBuilder,
          (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
          SyncLog,
          PrefetchHooks Function()
        > {
  $$SyncLogsTableTableManager(_$AppDatabase db, $SyncLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SyncLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SyncLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SyncLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> refType = const Value.absent(),
                Value<String> refId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLogsCompanion(
                id: id,
                refType: refType,
                refId: refId,
                op: op,
                status: status,
                lastError: lastError,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String refType,
                required String refId,
                required String op,
                required String status,
                Value<String?> lastError = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncLogsCompanion.insert(
                id: id,
                refType: refType,
                refId: refId,
                op: op,
                status: status,
                lastError: lastError,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLogsTable,
      SyncLog,
      $$SyncLogsTableFilterComposer,
      $$SyncLogsTableOrderingComposer,
      $$SyncLogsTableAnnotationComposer,
      $$SyncLogsTableCreateCompanionBuilder,
      $$SyncLogsTableUpdateCompanionBuilder,
      (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
      SyncLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$ProjectPacksTableTableManager get projectPacks =>
      $$ProjectPacksTableTableManager(_db, _db.projectPacks);
  $$QuestionnaireTypesTableTableManager get questionnaireTypes =>
      $$QuestionnaireTypesTableTableManager(_db, _db.questionnaireTypes);
  $$QuestionnairesTableTableManager get questionnaires =>
      $$QuestionnairesTableTableManager(_db, _db.questionnaires);
  $$FormsTableTableManager get forms =>
      $$FormsTableTableManager(_db, _db.forms);
  $$FormFieldsTableTableManager get formFields =>
      $$FormFieldsTableTableManager(_db, _db.formFields);
  $$SurveyResponsesTableTableManager get surveyResponses =>
      $$SurveyResponsesTableTableManager(_db, _db.surveyResponses);
  $$BaseMapsTableTableManager get baseMaps =>
      $$BaseMapsTableTableManager(_db, _db.baseMaps);
  $$ZoningFeaturesTableTableManager get zoningFeatures =>
      $$ZoningFeaturesTableTableManager(_db, _db.zoningFeatures);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db, _db.syncLogs);
}
