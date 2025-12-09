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
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<int> localityId = GeneratedColumn<int>(
    'locality_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _centerLatMeta = const VerificationMeta(
    'centerLat',
  );
  @override
  late final GeneratedColumn<double> centerLat = GeneratedColumn<double>(
    'center_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _centerLngMeta = const VerificationMeta(
    'centerLng',
  );
  @override
  late final GeneratedColumn<double> centerLng = GeneratedColumn<double>(
    'center_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoomMeta = const VerificationMeta('zoom');
  @override
  late final GeneratedColumn<double> zoom = GeneratedColumn<double>(
    'zoom',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    localityId,
    geoJson,
    centerLat,
    centerLng,
    zoom,
    downloadedAt,
    updatedAt,
  ];
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
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    }
    if (data.containsKey('geo_json')) {
      context.handle(
        _geoJsonMeta,
        geoJson.isAcceptableOrUnknown(data['geo_json']!, _geoJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_geoJsonMeta);
    }
    if (data.containsKey('center_lat')) {
      context.handle(
        _centerLatMeta,
        centerLat.isAcceptableOrUnknown(data['center_lat']!, _centerLatMeta),
      );
    }
    if (data.containsKey('center_lng')) {
      context.handle(
        _centerLngMeta,
        centerLng.isAcceptableOrUnknown(data['center_lng']!, _centerLngMeta),
      );
    }
    if (data.containsKey('zoom')) {
      context.handle(
        _zoomMeta,
        zoom.isAcceptableOrUnknown(data['zoom']!, _zoomMeta),
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
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {localityId};
  @override
  BaseMap map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BaseMap(
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      geoJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}geo_json'],
          )!,
      centerLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}center_lat'],
      ),
      centerLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}center_lng'],
      ),
      zoom: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}zoom'],
      ),
      downloadedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}downloaded_at'],
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
  final int localityId;
  final String geoJson;
  final double? centerLat;
  final double? centerLng;
  final double? zoom;
  final int downloadedAt;
  final int updatedAt;
  const BaseMap({
    required this.localityId,
    required this.geoJson,
    this.centerLat,
    this.centerLng,
    this.zoom,
    required this.downloadedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['locality_id'] = Variable<int>(localityId);
    map['geo_json'] = Variable<String>(geoJson);
    if (!nullToAbsent || centerLat != null) {
      map['center_lat'] = Variable<double>(centerLat);
    }
    if (!nullToAbsent || centerLng != null) {
      map['center_lng'] = Variable<double>(centerLng);
    }
    if (!nullToAbsent || zoom != null) {
      map['zoom'] = Variable<double>(zoom);
    }
    map['downloaded_at'] = Variable<int>(downloadedAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BaseMapsCompanion toCompanion(bool nullToAbsent) {
    return BaseMapsCompanion(
      localityId: Value(localityId),
      geoJson: Value(geoJson),
      centerLat:
          centerLat == null && nullToAbsent
              ? const Value.absent()
              : Value(centerLat),
      centerLng:
          centerLng == null && nullToAbsent
              ? const Value.absent()
              : Value(centerLng),
      zoom: zoom == null && nullToAbsent ? const Value.absent() : Value(zoom),
      downloadedAt: Value(downloadedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BaseMap.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BaseMap(
      localityId: serializer.fromJson<int>(json['localityId']),
      geoJson: serializer.fromJson<String>(json['geoJson']),
      centerLat: serializer.fromJson<double?>(json['centerLat']),
      centerLng: serializer.fromJson<double?>(json['centerLng']),
      zoom: serializer.fromJson<double?>(json['zoom']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localityId': serializer.toJson<int>(localityId),
      'geoJson': serializer.toJson<String>(geoJson),
      'centerLat': serializer.toJson<double?>(centerLat),
      'centerLng': serializer.toJson<double?>(centerLng),
      'zoom': serializer.toJson<double?>(zoom),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BaseMap copyWith({
    int? localityId,
    String? geoJson,
    Value<double?> centerLat = const Value.absent(),
    Value<double?> centerLng = const Value.absent(),
    Value<double?> zoom = const Value.absent(),
    int? downloadedAt,
    int? updatedAt,
  }) => BaseMap(
    localityId: localityId ?? this.localityId,
    geoJson: geoJson ?? this.geoJson,
    centerLat: centerLat.present ? centerLat.value : this.centerLat,
    centerLng: centerLng.present ? centerLng.value : this.centerLng,
    zoom: zoom.present ? zoom.value : this.zoom,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BaseMap copyWithCompanion(BaseMapsCompanion data) {
    return BaseMap(
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      geoJson: data.geoJson.present ? data.geoJson.value : this.geoJson,
      centerLat: data.centerLat.present ? data.centerLat.value : this.centerLat,
      centerLng: data.centerLng.present ? data.centerLng.value : this.centerLng,
      zoom: data.zoom.present ? data.zoom.value : this.zoom,
      downloadedAt:
          data.downloadedAt.present
              ? data.downloadedAt.value
              : this.downloadedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BaseMap(')
          ..write('localityId: $localityId, ')
          ..write('geoJson: $geoJson, ')
          ..write('centerLat: $centerLat, ')
          ..write('centerLng: $centerLng, ')
          ..write('zoom: $zoom, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localityId,
    geoJson,
    centerLat,
    centerLng,
    zoom,
    downloadedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseMap &&
          other.localityId == this.localityId &&
          other.geoJson == this.geoJson &&
          other.centerLat == this.centerLat &&
          other.centerLng == this.centerLng &&
          other.zoom == this.zoom &&
          other.downloadedAt == this.downloadedAt &&
          other.updatedAt == this.updatedAt);
}

class BaseMapsCompanion extends UpdateCompanion<BaseMap> {
  final Value<int> localityId;
  final Value<String> geoJson;
  final Value<double?> centerLat;
  final Value<double?> centerLng;
  final Value<double?> zoom;
  final Value<int> downloadedAt;
  final Value<int> updatedAt;
  const BaseMapsCompanion({
    this.localityId = const Value.absent(),
    this.geoJson = const Value.absent(),
    this.centerLat = const Value.absent(),
    this.centerLng = const Value.absent(),
    this.zoom = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BaseMapsCompanion.insert({
    this.localityId = const Value.absent(),
    required String geoJson,
    this.centerLat = const Value.absent(),
    this.centerLng = const Value.absent(),
    this.zoom = const Value.absent(),
    required int downloadedAt,
    required int updatedAt,
  }) : geoJson = Value(geoJson),
       downloadedAt = Value(downloadedAt),
       updatedAt = Value(updatedAt);
  static Insertable<BaseMap> custom({
    Expression<int>? localityId,
    Expression<String>? geoJson,
    Expression<double>? centerLat,
    Expression<double>? centerLng,
    Expression<double>? zoom,
    Expression<int>? downloadedAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (localityId != null) 'locality_id': localityId,
      if (geoJson != null) 'geo_json': geoJson,
      if (centerLat != null) 'center_lat': centerLat,
      if (centerLng != null) 'center_lng': centerLng,
      if (zoom != null) 'zoom': zoom,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BaseMapsCompanion copyWith({
    Value<int>? localityId,
    Value<String>? geoJson,
    Value<double?>? centerLat,
    Value<double?>? centerLng,
    Value<double?>? zoom,
    Value<int>? downloadedAt,
    Value<int>? updatedAt,
  }) {
    return BaseMapsCompanion(
      localityId: localityId ?? this.localityId,
      geoJson: geoJson ?? this.geoJson,
      centerLat: centerLat ?? this.centerLat,
      centerLng: centerLng ?? this.centerLng,
      zoom: zoom ?? this.zoom,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (geoJson.present) {
      map['geo_json'] = Variable<String>(geoJson.value);
    }
    if (centerLat.present) {
      map['center_lat'] = Variable<double>(centerLat.value);
    }
    if (centerLng.present) {
      map['center_lng'] = Variable<double>(centerLng.value);
    }
    if (zoom.present) {
      map['zoom'] = Variable<double>(zoom.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BaseMapsCompanion(')
          ..write('localityId: $localityId, ')
          ..write('geoJson: $geoJson, ')
          ..write('centerLat: $centerLat, ')
          ..write('centerLng: $centerLng, ')
          ..write('zoom: $zoom, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
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
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _landUseIdMeta = const VerificationMeta(
    'landUseId',
  );
  @override
  late final GeneratedColumn<int> landUseId = GeneratedColumn<int>(
    'land_use_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _sridMeta = const VerificationMeta('srid');
  @override
  late final GeneratedColumn<int> srid = GeneratedColumn<int>(
    'srid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4326),
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
  static const VerificationMeta _areaSqmMeta = const VerificationMeta(
    'areaSqm',
  );
  @override
  late final GeneratedColumn<double> areaSqm = GeneratedColumn<double>(
    'area_sqm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lengthMMeta = const VerificationMeta(
    'lengthM',
  );
  @override
  late final GeneratedColumn<double> lengthM = GeneratedColumn<double>(
    'length_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bufferMeta = const VerificationMeta('buffer');
  @override
  late final GeneratedColumn<double> buffer = GeneratedColumn<double>(
    'buffer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
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
  static const VerificationMeta _isProposedMeta = const VerificationMeta(
    'isProposed',
  );
  @override
  late final GeneratedColumn<bool> isProposed = GeneratedColumn<bool>(
    'is_proposed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_proposed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Draft'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('field_survey'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    clientUuid,
    serverId,
    projectId,
    localityId,
    landUseId,
    geomType,
    srid,
    coordsJson,
    areaSqm,
    lengthM,
    buffer,
    propertiesJson,
    isDraft,
    isProposed,
    status,
    source,
    version,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
    metadataJson,
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
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('land_use_id')) {
      context.handle(
        _landUseIdMeta,
        landUseId.isAcceptableOrUnknown(data['land_use_id']!, _landUseIdMeta),
      );
    }
    if (data.containsKey('geom_type')) {
      context.handle(
        _geomTypeMeta,
        geomType.isAcceptableOrUnknown(data['geom_type']!, _geomTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_geomTypeMeta);
    }
    if (data.containsKey('srid')) {
      context.handle(
        _sridMeta,
        srid.isAcceptableOrUnknown(data['srid']!, _sridMeta),
      );
    }
    if (data.containsKey('coords_json')) {
      context.handle(
        _coordsJsonMeta,
        coordsJson.isAcceptableOrUnknown(data['coords_json']!, _coordsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_coordsJsonMeta);
    }
    if (data.containsKey('area_sqm')) {
      context.handle(
        _areaSqmMeta,
        areaSqm.isAcceptableOrUnknown(data['area_sqm']!, _areaSqmMeta),
      );
    }
    if (data.containsKey('length_m')) {
      context.handle(
        _lengthMMeta,
        lengthM.isAcceptableOrUnknown(data['length_m']!, _lengthMMeta),
      );
    }
    if (data.containsKey('buffer')) {
      context.handle(
        _bufferMeta,
        buffer.isAcceptableOrUnknown(data['buffer']!, _bufferMeta),
      );
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
    if (data.containsKey('is_proposed')) {
      context.handle(
        _isProposedMeta,
        isProposed.isAcceptableOrUnknown(data['is_proposed']!, _isProposedMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {clientUuid};
  @override
  ZoningFeature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZoningFeature(
      clientUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_uuid'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      landUseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}land_use_id'],
      ),
      geomType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}geom_type'],
          )!,
      srid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}srid'],
          )!,
      coordsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}coords_json'],
          )!,
      areaSqm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_sqm'],
      ),
      lengthM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}length_m'],
      ),
      buffer:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}buffer'],
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
      isProposed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_proposed'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      version:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}version'],
          )!,
      uploaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}uploaded'],
          )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
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
  final String clientUuid;
  final String? serverId;
  final String projectId;
  final int localityId;
  final int? landUseId;
  final String geomType;
  final int srid;
  final String coordsJson;
  final double? areaSqm;
  final double? lengthM;
  final double buffer;
  final String? propertiesJson;
  final bool isDraft;
  final bool isProposed;
  final String status;
  final String source;
  final int version;
  final bool uploaded;
  final int? uploadedAt;
  final int createdAt;
  final int updatedAt;
  final String? metadataJson;
  final bool dirty;
  const ZoningFeature({
    required this.clientUuid,
    this.serverId,
    required this.projectId,
    required this.localityId,
    this.landUseId,
    required this.geomType,
    required this.srid,
    required this.coordsJson,
    this.areaSqm,
    this.lengthM,
    required this.buffer,
    this.propertiesJson,
    required this.isDraft,
    required this.isProposed,
    required this.status,
    required this.source,
    required this.version,
    required this.uploaded,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
    this.metadataJson,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['project_id'] = Variable<String>(projectId);
    map['locality_id'] = Variable<int>(localityId);
    if (!nullToAbsent || landUseId != null) {
      map['land_use_id'] = Variable<int>(landUseId);
    }
    map['geom_type'] = Variable<String>(geomType);
    map['srid'] = Variable<int>(srid);
    map['coords_json'] = Variable<String>(coordsJson);
    if (!nullToAbsent || areaSqm != null) {
      map['area_sqm'] = Variable<double>(areaSqm);
    }
    if (!nullToAbsent || lengthM != null) {
      map['length_m'] = Variable<double>(lengthM);
    }
    map['buffer'] = Variable<double>(buffer);
    if (!nullToAbsent || propertiesJson != null) {
      map['properties_json'] = Variable<String>(propertiesJson);
    }
    map['is_draft'] = Variable<bool>(isDraft);
    map['is_proposed'] = Variable<bool>(isProposed);
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    map['version'] = Variable<int>(version);
    map['uploaded'] = Variable<bool>(uploaded);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<int>(uploadedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  ZoningFeaturesCompanion toCompanion(bool nullToAbsent) {
    return ZoningFeaturesCompanion(
      clientUuid: Value(clientUuid),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      projectId: Value(projectId),
      localityId: Value(localityId),
      landUseId:
          landUseId == null && nullToAbsent
              ? const Value.absent()
              : Value(landUseId),
      geomType: Value(geomType),
      srid: Value(srid),
      coordsJson: Value(coordsJson),
      areaSqm:
          areaSqm == null && nullToAbsent
              ? const Value.absent()
              : Value(areaSqm),
      lengthM:
          lengthM == null && nullToAbsent
              ? const Value.absent()
              : Value(lengthM),
      buffer: Value(buffer),
      propertiesJson:
          propertiesJson == null && nullToAbsent
              ? const Value.absent()
              : Value(propertiesJson),
      isDraft: Value(isDraft),
      isProposed: Value(isProposed),
      status: Value(status),
      source: Value(source),
      version: Value(version),
      uploaded: Value(uploaded),
      uploadedAt:
          uploadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      metadataJson:
          metadataJson == null && nullToAbsent
              ? const Value.absent()
              : Value(metadataJson),
      dirty: Value(dirty),
    );
  }

  factory ZoningFeature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZoningFeature(
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      projectId: serializer.fromJson<String>(json['projectId']),
      localityId: serializer.fromJson<int>(json['localityId']),
      landUseId: serializer.fromJson<int?>(json['landUseId']),
      geomType: serializer.fromJson<String>(json['geomType']),
      srid: serializer.fromJson<int>(json['srid']),
      coordsJson: serializer.fromJson<String>(json['coordsJson']),
      areaSqm: serializer.fromJson<double?>(json['areaSqm']),
      lengthM: serializer.fromJson<double?>(json['lengthM']),
      buffer: serializer.fromJson<double>(json['buffer']),
      propertiesJson: serializer.fromJson<String?>(json['propertiesJson']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      isProposed: serializer.fromJson<bool>(json['isProposed']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      version: serializer.fromJson<int>(json['version']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      uploadedAt: serializer.fromJson<int?>(json['uploadedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientUuid': serializer.toJson<String>(clientUuid),
      'serverId': serializer.toJson<String?>(serverId),
      'projectId': serializer.toJson<String>(projectId),
      'localityId': serializer.toJson<int>(localityId),
      'landUseId': serializer.toJson<int?>(landUseId),
      'geomType': serializer.toJson<String>(geomType),
      'srid': serializer.toJson<int>(srid),
      'coordsJson': serializer.toJson<String>(coordsJson),
      'areaSqm': serializer.toJson<double?>(areaSqm),
      'lengthM': serializer.toJson<double?>(lengthM),
      'buffer': serializer.toJson<double>(buffer),
      'propertiesJson': serializer.toJson<String?>(propertiesJson),
      'isDraft': serializer.toJson<bool>(isDraft),
      'isProposed': serializer.toJson<bool>(isProposed),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'version': serializer.toJson<int>(version),
      'uploaded': serializer.toJson<bool>(uploaded),
      'uploadedAt': serializer.toJson<int?>(uploadedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  ZoningFeature copyWith({
    String? clientUuid,
    Value<String?> serverId = const Value.absent(),
    String? projectId,
    int? localityId,
    Value<int?> landUseId = const Value.absent(),
    String? geomType,
    int? srid,
    String? coordsJson,
    Value<double?> areaSqm = const Value.absent(),
    Value<double?> lengthM = const Value.absent(),
    double? buffer,
    Value<String?> propertiesJson = const Value.absent(),
    bool? isDraft,
    bool? isProposed,
    String? status,
    String? source,
    int? version,
    bool? uploaded,
    Value<int?> uploadedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<String?> metadataJson = const Value.absent(),
    bool? dirty,
  }) => ZoningFeature(
    clientUuid: clientUuid ?? this.clientUuid,
    serverId: serverId.present ? serverId.value : this.serverId,
    projectId: projectId ?? this.projectId,
    localityId: localityId ?? this.localityId,
    landUseId: landUseId.present ? landUseId.value : this.landUseId,
    geomType: geomType ?? this.geomType,
    srid: srid ?? this.srid,
    coordsJson: coordsJson ?? this.coordsJson,
    areaSqm: areaSqm.present ? areaSqm.value : this.areaSqm,
    lengthM: lengthM.present ? lengthM.value : this.lengthM,
    buffer: buffer ?? this.buffer,
    propertiesJson:
        propertiesJson.present ? propertiesJson.value : this.propertiesJson,
    isDraft: isDraft ?? this.isDraft,
    isProposed: isProposed ?? this.isProposed,
    status: status ?? this.status,
    source: source ?? this.source,
    version: version ?? this.version,
    uploaded: uploaded ?? this.uploaded,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
    dirty: dirty ?? this.dirty,
  );
  ZoningFeature copyWithCompanion(ZoningFeaturesCompanion data) {
    return ZoningFeature(
      clientUuid:
          data.clientUuid.present ? data.clientUuid.value : this.clientUuid,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      landUseId: data.landUseId.present ? data.landUseId.value : this.landUseId,
      geomType: data.geomType.present ? data.geomType.value : this.geomType,
      srid: data.srid.present ? data.srid.value : this.srid,
      coordsJson:
          data.coordsJson.present ? data.coordsJson.value : this.coordsJson,
      areaSqm: data.areaSqm.present ? data.areaSqm.value : this.areaSqm,
      lengthM: data.lengthM.present ? data.lengthM.value : this.lengthM,
      buffer: data.buffer.present ? data.buffer.value : this.buffer,
      propertiesJson:
          data.propertiesJson.present
              ? data.propertiesJson.value
              : this.propertiesJson,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      isProposed:
          data.isProposed.present ? data.isProposed.value : this.isProposed,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      version: data.version.present ? data.version.value : this.version,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      metadataJson:
          data.metadataJson.present
              ? data.metadataJson.value
              : this.metadataJson,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZoningFeature(')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('projectId: $projectId, ')
          ..write('localityId: $localityId, ')
          ..write('landUseId: $landUseId, ')
          ..write('geomType: $geomType, ')
          ..write('srid: $srid, ')
          ..write('coordsJson: $coordsJson, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('lengthM: $lengthM, ')
          ..write('buffer: $buffer, ')
          ..write('propertiesJson: $propertiesJson, ')
          ..write('isDraft: $isDraft, ')
          ..write('isProposed: $isProposed, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('version: $version, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    clientUuid,
    serverId,
    projectId,
    localityId,
    landUseId,
    geomType,
    srid,
    coordsJson,
    areaSqm,
    lengthM,
    buffer,
    propertiesJson,
    isDraft,
    isProposed,
    status,
    source,
    version,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
    metadataJson,
    dirty,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZoningFeature &&
          other.clientUuid == this.clientUuid &&
          other.serverId == this.serverId &&
          other.projectId == this.projectId &&
          other.localityId == this.localityId &&
          other.landUseId == this.landUseId &&
          other.geomType == this.geomType &&
          other.srid == this.srid &&
          other.coordsJson == this.coordsJson &&
          other.areaSqm == this.areaSqm &&
          other.lengthM == this.lengthM &&
          other.buffer == this.buffer &&
          other.propertiesJson == this.propertiesJson &&
          other.isDraft == this.isDraft &&
          other.isProposed == this.isProposed &&
          other.status == this.status &&
          other.source == this.source &&
          other.version == this.version &&
          other.uploaded == this.uploaded &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.metadataJson == this.metadataJson &&
          other.dirty == this.dirty);
}

class ZoningFeaturesCompanion extends UpdateCompanion<ZoningFeature> {
  final Value<String> clientUuid;
  final Value<String?> serverId;
  final Value<String> projectId;
  final Value<int> localityId;
  final Value<int?> landUseId;
  final Value<String> geomType;
  final Value<int> srid;
  final Value<String> coordsJson;
  final Value<double?> areaSqm;
  final Value<double?> lengthM;
  final Value<double> buffer;
  final Value<String?> propertiesJson;
  final Value<bool> isDraft;
  final Value<bool> isProposed;
  final Value<String> status;
  final Value<String> source;
  final Value<int> version;
  final Value<bool> uploaded;
  final Value<int?> uploadedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> metadataJson;
  final Value<bool> dirty;
  final Value<int> rowid;
  const ZoningFeaturesCompanion({
    this.clientUuid = const Value.absent(),
    this.serverId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.landUseId = const Value.absent(),
    this.geomType = const Value.absent(),
    this.srid = const Value.absent(),
    this.coordsJson = const Value.absent(),
    this.areaSqm = const Value.absent(),
    this.lengthM = const Value.absent(),
    this.buffer = const Value.absent(),
    this.propertiesJson = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.isProposed = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.version = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZoningFeaturesCompanion.insert({
    required String clientUuid,
    this.serverId = const Value.absent(),
    required String projectId,
    required int localityId,
    this.landUseId = const Value.absent(),
    required String geomType,
    this.srid = const Value.absent(),
    required String coordsJson,
    this.areaSqm = const Value.absent(),
    this.lengthM = const Value.absent(),
    this.buffer = const Value.absent(),
    this.propertiesJson = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.isProposed = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.version = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.metadataJson = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientUuid = Value(clientUuid),
       projectId = Value(projectId),
       localityId = Value(localityId),
       geomType = Value(geomType),
       coordsJson = Value(coordsJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ZoningFeature> custom({
    Expression<String>? clientUuid,
    Expression<String>? serverId,
    Expression<String>? projectId,
    Expression<int>? localityId,
    Expression<int>? landUseId,
    Expression<String>? geomType,
    Expression<int>? srid,
    Expression<String>? coordsJson,
    Expression<double>? areaSqm,
    Expression<double>? lengthM,
    Expression<double>? buffer,
    Expression<String>? propertiesJson,
    Expression<bool>? isDraft,
    Expression<bool>? isProposed,
    Expression<String>? status,
    Expression<String>? source,
    Expression<int>? version,
    Expression<bool>? uploaded,
    Expression<int>? uploadedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? metadataJson,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (serverId != null) 'server_id': serverId,
      if (projectId != null) 'project_id': projectId,
      if (localityId != null) 'locality_id': localityId,
      if (landUseId != null) 'land_use_id': landUseId,
      if (geomType != null) 'geom_type': geomType,
      if (srid != null) 'srid': srid,
      if (coordsJson != null) 'coords_json': coordsJson,
      if (areaSqm != null) 'area_sqm': areaSqm,
      if (lengthM != null) 'length_m': lengthM,
      if (buffer != null) 'buffer': buffer,
      if (propertiesJson != null) 'properties_json': propertiesJson,
      if (isDraft != null) 'is_draft': isDraft,
      if (isProposed != null) 'is_proposed': isProposed,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (version != null) 'version': version,
      if (uploaded != null) 'uploaded': uploaded,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZoningFeaturesCompanion copyWith({
    Value<String>? clientUuid,
    Value<String?>? serverId,
    Value<String>? projectId,
    Value<int>? localityId,
    Value<int?>? landUseId,
    Value<String>? geomType,
    Value<int>? srid,
    Value<String>? coordsJson,
    Value<double?>? areaSqm,
    Value<double?>? lengthM,
    Value<double>? buffer,
    Value<String?>? propertiesJson,
    Value<bool>? isDraft,
    Value<bool>? isProposed,
    Value<String>? status,
    Value<String>? source,
    Value<int>? version,
    Value<bool>? uploaded,
    Value<int?>? uploadedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<String?>? metadataJson,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return ZoningFeaturesCompanion(
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      projectId: projectId ?? this.projectId,
      localityId: localityId ?? this.localityId,
      landUseId: landUseId ?? this.landUseId,
      geomType: geomType ?? this.geomType,
      srid: srid ?? this.srid,
      coordsJson: coordsJson ?? this.coordsJson,
      areaSqm: areaSqm ?? this.areaSqm,
      lengthM: lengthM ?? this.lengthM,
      buffer: buffer ?? this.buffer,
      propertiesJson: propertiesJson ?? this.propertiesJson,
      isDraft: isDraft ?? this.isDraft,
      isProposed: isProposed ?? this.isProposed,
      status: status ?? this.status,
      source: source ?? this.source,
      version: version ?? this.version,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadataJson: metadataJson ?? this.metadataJson,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (landUseId.present) {
      map['land_use_id'] = Variable<int>(landUseId.value);
    }
    if (geomType.present) {
      map['geom_type'] = Variable<String>(geomType.value);
    }
    if (srid.present) {
      map['srid'] = Variable<int>(srid.value);
    }
    if (coordsJson.present) {
      map['coords_json'] = Variable<String>(coordsJson.value);
    }
    if (areaSqm.present) {
      map['area_sqm'] = Variable<double>(areaSqm.value);
    }
    if (lengthM.present) {
      map['length_m'] = Variable<double>(lengthM.value);
    }
    if (buffer.present) {
      map['buffer'] = Variable<double>(buffer.value);
    }
    if (propertiesJson.present) {
      map['properties_json'] = Variable<String>(propertiesJson.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (isProposed.present) {
      map['is_proposed'] = Variable<bool>(isProposed.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
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
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('projectId: $projectId, ')
          ..write('localityId: $localityId, ')
          ..write('landUseId: $landUseId, ')
          ..write('geomType: $geomType, ')
          ..write('srid: $srid, ')
          ..write('coordsJson: $coordsJson, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('lengthM: $lengthM, ')
          ..write('buffer: $buffer, ')
          ..write('propertiesJson: $propertiesJson, ')
          ..write('isDraft: $isDraft, ')
          ..write('isProposed: $isProposed, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('version: $version, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('metadataJson: $metadataJson, ')
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

class $ZoningFeatureHistoryTable extends ZoningFeatureHistory
    with TableInfo<$ZoningFeatureHistoryTable, ZoningFeatureHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZoningFeatureHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureIdMeta = const VerificationMeta(
    'featureId',
  );
  @override
  late final GeneratedColumn<String> featureId = GeneratedColumn<String>(
    'feature_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oldDataJsonMeta = const VerificationMeta(
    'oldDataJson',
  );
  @override
  late final GeneratedColumn<String> oldDataJson = GeneratedColumn<String>(
    'old_data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newDataJsonMeta = const VerificationMeta(
    'newDataJson',
  );
  @override
  late final GeneratedColumn<String> newDataJson = GeneratedColumn<String>(
    'new_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changesJsonMeta = const VerificationMeta(
    'changesJson',
  );
  @override
  late final GeneratedColumn<String> changesJson = GeneratedColumn<String>(
    'changes_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    featureId,
    action,
    userId,
    oldDataJson,
    newDataJson,
    changesJson,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zoning_feature_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZoningFeatureHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feature_id')) {
      context.handle(
        _featureIdMeta,
        featureId.isAcceptableOrUnknown(data['feature_id']!, _featureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_featureIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('old_data_json')) {
      context.handle(
        _oldDataJsonMeta,
        oldDataJson.isAcceptableOrUnknown(
          data['old_data_json']!,
          _oldDataJsonMeta,
        ),
      );
    }
    if (data.containsKey('new_data_json')) {
      context.handle(
        _newDataJsonMeta,
        newDataJson.isAcceptableOrUnknown(
          data['new_data_json']!,
          _newDataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newDataJsonMeta);
    }
    if (data.containsKey('changes_json')) {
      context.handle(
        _changesJsonMeta,
        changesJson.isAcceptableOrUnknown(
          data['changes_json']!,
          _changesJsonMeta,
        ),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZoningFeatureHistoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZoningFeatureHistoryData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      featureId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}feature_id'],
          )!,
      action:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}action'],
          )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      oldDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_data_json'],
      ),
      newDataJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}new_data_json'],
          )!,
      changesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changes_json'],
      ),
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}timestamp'],
          )!,
    );
  }

  @override
  $ZoningFeatureHistoryTable createAlias(String alias) {
    return $ZoningFeatureHistoryTable(attachedDatabase, alias);
  }
}

class ZoningFeatureHistoryData extends DataClass
    implements Insertable<ZoningFeatureHistoryData> {
  final String id;
  final String featureId;
  final String action;
  final String? userId;
  final String? oldDataJson;
  final String newDataJson;
  final String? changesJson;
  final int timestamp;
  const ZoningFeatureHistoryData({
    required this.id,
    required this.featureId,
    required this.action,
    this.userId,
    this.oldDataJson,
    required this.newDataJson,
    this.changesJson,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['feature_id'] = Variable<String>(featureId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || oldDataJson != null) {
      map['old_data_json'] = Variable<String>(oldDataJson);
    }
    map['new_data_json'] = Variable<String>(newDataJson);
    if (!nullToAbsent || changesJson != null) {
      map['changes_json'] = Variable<String>(changesJson);
    }
    map['timestamp'] = Variable<int>(timestamp);
    return map;
  }

  ZoningFeatureHistoryCompanion toCompanion(bool nullToAbsent) {
    return ZoningFeatureHistoryCompanion(
      id: Value(id),
      featureId: Value(featureId),
      action: Value(action),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      oldDataJson:
          oldDataJson == null && nullToAbsent
              ? const Value.absent()
              : Value(oldDataJson),
      newDataJson: Value(newDataJson),
      changesJson:
          changesJson == null && nullToAbsent
              ? const Value.absent()
              : Value(changesJson),
      timestamp: Value(timestamp),
    );
  }

  factory ZoningFeatureHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZoningFeatureHistoryData(
      id: serializer.fromJson<String>(json['id']),
      featureId: serializer.fromJson<String>(json['featureId']),
      action: serializer.fromJson<String>(json['action']),
      userId: serializer.fromJson<String?>(json['userId']),
      oldDataJson: serializer.fromJson<String?>(json['oldDataJson']),
      newDataJson: serializer.fromJson<String>(json['newDataJson']),
      changesJson: serializer.fromJson<String?>(json['changesJson']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'featureId': serializer.toJson<String>(featureId),
      'action': serializer.toJson<String>(action),
      'userId': serializer.toJson<String?>(userId),
      'oldDataJson': serializer.toJson<String?>(oldDataJson),
      'newDataJson': serializer.toJson<String>(newDataJson),
      'changesJson': serializer.toJson<String?>(changesJson),
      'timestamp': serializer.toJson<int>(timestamp),
    };
  }

  ZoningFeatureHistoryData copyWith({
    String? id,
    String? featureId,
    String? action,
    Value<String?> userId = const Value.absent(),
    Value<String?> oldDataJson = const Value.absent(),
    String? newDataJson,
    Value<String?> changesJson = const Value.absent(),
    int? timestamp,
  }) => ZoningFeatureHistoryData(
    id: id ?? this.id,
    featureId: featureId ?? this.featureId,
    action: action ?? this.action,
    userId: userId.present ? userId.value : this.userId,
    oldDataJson: oldDataJson.present ? oldDataJson.value : this.oldDataJson,
    newDataJson: newDataJson ?? this.newDataJson,
    changesJson: changesJson.present ? changesJson.value : this.changesJson,
    timestamp: timestamp ?? this.timestamp,
  );
  ZoningFeatureHistoryData copyWithCompanion(
    ZoningFeatureHistoryCompanion data,
  ) {
    return ZoningFeatureHistoryData(
      id: data.id.present ? data.id.value : this.id,
      featureId: data.featureId.present ? data.featureId.value : this.featureId,
      action: data.action.present ? data.action.value : this.action,
      userId: data.userId.present ? data.userId.value : this.userId,
      oldDataJson:
          data.oldDataJson.present ? data.oldDataJson.value : this.oldDataJson,
      newDataJson:
          data.newDataJson.present ? data.newDataJson.value : this.newDataJson,
      changesJson:
          data.changesJson.present ? data.changesJson.value : this.changesJson,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZoningFeatureHistoryData(')
          ..write('id: $id, ')
          ..write('featureId: $featureId, ')
          ..write('action: $action, ')
          ..write('userId: $userId, ')
          ..write('oldDataJson: $oldDataJson, ')
          ..write('newDataJson: $newDataJson, ')
          ..write('changesJson: $changesJson, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureId,
    action,
    userId,
    oldDataJson,
    newDataJson,
    changesJson,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZoningFeatureHistoryData &&
          other.id == this.id &&
          other.featureId == this.featureId &&
          other.action == this.action &&
          other.userId == this.userId &&
          other.oldDataJson == this.oldDataJson &&
          other.newDataJson == this.newDataJson &&
          other.changesJson == this.changesJson &&
          other.timestamp == this.timestamp);
}

class ZoningFeatureHistoryCompanion
    extends UpdateCompanion<ZoningFeatureHistoryData> {
  final Value<String> id;
  final Value<String> featureId;
  final Value<String> action;
  final Value<String?> userId;
  final Value<String?> oldDataJson;
  final Value<String> newDataJson;
  final Value<String?> changesJson;
  final Value<int> timestamp;
  final Value<int> rowid;
  const ZoningFeatureHistoryCompanion({
    this.id = const Value.absent(),
    this.featureId = const Value.absent(),
    this.action = const Value.absent(),
    this.userId = const Value.absent(),
    this.oldDataJson = const Value.absent(),
    this.newDataJson = const Value.absent(),
    this.changesJson = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZoningFeatureHistoryCompanion.insert({
    required String id,
    required String featureId,
    required String action,
    this.userId = const Value.absent(),
    this.oldDataJson = const Value.absent(),
    required String newDataJson,
    this.changesJson = const Value.absent(),
    required int timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       featureId = Value(featureId),
       action = Value(action),
       newDataJson = Value(newDataJson),
       timestamp = Value(timestamp);
  static Insertable<ZoningFeatureHistoryData> custom({
    Expression<String>? id,
    Expression<String>? featureId,
    Expression<String>? action,
    Expression<String>? userId,
    Expression<String>? oldDataJson,
    Expression<String>? newDataJson,
    Expression<String>? changesJson,
    Expression<int>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureId != null) 'feature_id': featureId,
      if (action != null) 'action': action,
      if (userId != null) 'user_id': userId,
      if (oldDataJson != null) 'old_data_json': oldDataJson,
      if (newDataJson != null) 'new_data_json': newDataJson,
      if (changesJson != null) 'changes_json': changesJson,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZoningFeatureHistoryCompanion copyWith({
    Value<String>? id,
    Value<String>? featureId,
    Value<String>? action,
    Value<String?>? userId,
    Value<String?>? oldDataJson,
    Value<String>? newDataJson,
    Value<String?>? changesJson,
    Value<int>? timestamp,
    Value<int>? rowid,
  }) {
    return ZoningFeatureHistoryCompanion(
      id: id ?? this.id,
      featureId: featureId ?? this.featureId,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      oldDataJson: oldDataJson ?? this.oldDataJson,
      newDataJson: newDataJson ?? this.newDataJson,
      changesJson: changesJson ?? this.changesJson,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (featureId.present) {
      map['feature_id'] = Variable<String>(featureId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (oldDataJson.present) {
      map['old_data_json'] = Variable<String>(oldDataJson.value);
    }
    if (newDataJson.present) {
      map['new_data_json'] = Variable<String>(newDataJson.value);
    }
    if (changesJson.present) {
      map['changes_json'] = Variable<String>(changesJson.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZoningFeatureHistoryCompanion(')
          ..write('id: $id, ')
          ..write('featureId: $featureId, ')
          ..write('action: $action, ')
          ..write('userId: $userId, ')
          ..write('oldDataJson: $oldDataJson, ')
          ..write('newDataJson: $newDataJson, ')
          ..write('changesJson: $changesJson, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeatureUploadQueueTable extends FeatureUploadQueue
    with TableInfo<$FeatureUploadQueueTable, FeatureUploadQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureUploadQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureIdMeta = const VerificationMeta(
    'featureId',
  );
  @override
  late final GeneratedColumn<String> featureId = GeneratedColumn<String>(
    'feature_id',
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
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxRetriesMeta = const VerificationMeta(
    'maxRetries',
  );
  @override
  late final GeneratedColumn<int> maxRetries = GeneratedColumn<int>(
    'max_retries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<int> nextRetryAt = GeneratedColumn<int>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    featureId,
    projectId,
    retryCount,
    maxRetries,
    nextRetryAt,
    lastError,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_upload_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureUploadQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feature_id')) {
      context.handle(
        _featureIdMeta,
        featureId.isAcceptableOrUnknown(data['feature_id']!, _featureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_featureIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('max_retries')) {
      context.handle(
        _maxRetriesMeta,
        maxRetries.isAcceptableOrUnknown(data['max_retries']!, _maxRetriesMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  FeatureUploadQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureUploadQueueData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      featureId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}feature_id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      retryCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}retry_count'],
          )!,
      maxRetries:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}max_retries'],
          )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_retry_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $FeatureUploadQueueTable createAlias(String alias) {
    return $FeatureUploadQueueTable(attachedDatabase, alias);
  }
}

class FeatureUploadQueueData extends DataClass
    implements Insertable<FeatureUploadQueueData> {
  final String id;
  final String featureId;
  final String projectId;
  final int retryCount;
  final int maxRetries;
  final int? nextRetryAt;
  final String? lastError;
  final String status;
  final int createdAt;
  final int updatedAt;
  const FeatureUploadQueueData({
    required this.id,
    required this.featureId,
    required this.projectId,
    required this.retryCount,
    required this.maxRetries,
    this.nextRetryAt,
    this.lastError,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['feature_id'] = Variable<String>(featureId);
    map['project_id'] = Variable<String>(projectId);
    map['retry_count'] = Variable<int>(retryCount);
    map['max_retries'] = Variable<int>(maxRetries);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<int>(nextRetryAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  FeatureUploadQueueCompanion toCompanion(bool nullToAbsent) {
    return FeatureUploadQueueCompanion(
      id: Value(id),
      featureId: Value(featureId),
      projectId: Value(projectId),
      retryCount: Value(retryCount),
      maxRetries: Value(maxRetries),
      nextRetryAt:
          nextRetryAt == null && nullToAbsent
              ? const Value.absent()
              : Value(nextRetryAt),
      lastError:
          lastError == null && nullToAbsent
              ? const Value.absent()
              : Value(lastError),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FeatureUploadQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureUploadQueueData(
      id: serializer.fromJson<String>(json['id']),
      featureId: serializer.fromJson<String>(json['featureId']),
      projectId: serializer.fromJson<String>(json['projectId']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      maxRetries: serializer.fromJson<int>(json['maxRetries']),
      nextRetryAt: serializer.fromJson<int?>(json['nextRetryAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'featureId': serializer.toJson<String>(featureId),
      'projectId': serializer.toJson<String>(projectId),
      'retryCount': serializer.toJson<int>(retryCount),
      'maxRetries': serializer.toJson<int>(maxRetries),
      'nextRetryAt': serializer.toJson<int?>(nextRetryAt),
      'lastError': serializer.toJson<String?>(lastError),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  FeatureUploadQueueData copyWith({
    String? id,
    String? featureId,
    String? projectId,
    int? retryCount,
    int? maxRetries,
    Value<int?> nextRetryAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    String? status,
    int? createdAt,
    int? updatedAt,
  }) => FeatureUploadQueueData(
    id: id ?? this.id,
    featureId: featureId ?? this.featureId,
    projectId: projectId ?? this.projectId,
    retryCount: retryCount ?? this.retryCount,
    maxRetries: maxRetries ?? this.maxRetries,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FeatureUploadQueueData copyWithCompanion(FeatureUploadQueueCompanion data) {
    return FeatureUploadQueueData(
      id: data.id.present ? data.id.value : this.id,
      featureId: data.featureId.present ? data.featureId.value : this.featureId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      maxRetries:
          data.maxRetries.present ? data.maxRetries.value : this.maxRetries,
      nextRetryAt:
          data.nextRetryAt.present ? data.nextRetryAt.value : this.nextRetryAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureUploadQueueData(')
          ..write('id: $id, ')
          ..write('featureId: $featureId, ')
          ..write('projectId: $projectId, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureId,
    projectId,
    retryCount,
    maxRetries,
    nextRetryAt,
    lastError,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureUploadQueueData &&
          other.id == this.id &&
          other.featureId == this.featureId &&
          other.projectId == this.projectId &&
          other.retryCount == this.retryCount &&
          other.maxRetries == this.maxRetries &&
          other.nextRetryAt == this.nextRetryAt &&
          other.lastError == this.lastError &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FeatureUploadQueueCompanion
    extends UpdateCompanion<FeatureUploadQueueData> {
  final Value<String> id;
  final Value<String> featureId;
  final Value<String> projectId;
  final Value<int> retryCount;
  final Value<int> maxRetries;
  final Value<int?> nextRetryAt;
  final Value<String?> lastError;
  final Value<String> status;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const FeatureUploadQueueCompanion({
    this.id = const Value.absent(),
    this.featureId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeatureUploadQueueCompanion.insert({
    required String id,
    required String featureId,
    required String projectId,
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.status = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       featureId = Value(featureId),
       projectId = Value(projectId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FeatureUploadQueueData> custom({
    Expression<String>? id,
    Expression<String>? featureId,
    Expression<String>? projectId,
    Expression<int>? retryCount,
    Expression<int>? maxRetries,
    Expression<int>? nextRetryAt,
    Expression<String>? lastError,
    Expression<String>? status,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureId != null) 'feature_id': featureId,
      if (projectId != null) 'project_id': projectId,
      if (retryCount != null) 'retry_count': retryCount,
      if (maxRetries != null) 'max_retries': maxRetries,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (lastError != null) 'last_error': lastError,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeatureUploadQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? featureId,
    Value<String>? projectId,
    Value<int>? retryCount,
    Value<int>? maxRetries,
    Value<int?>? nextRetryAt,
    Value<String?>? lastError,
    Value<String>? status,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return FeatureUploadQueueCompanion(
      id: id ?? this.id,
      featureId: featureId ?? this.featureId,
      projectId: projectId ?? this.projectId,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      lastError: lastError ?? this.lastError,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
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
    if (featureId.present) {
      map['feature_id'] = Variable<String>(featureId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (maxRetries.present) {
      map['max_retries'] = Variable<int>(maxRetries.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<int>(nextRetryAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('FeatureUploadQueueCompanion(')
          ..write('id: $id, ')
          ..write('featureId: $featureId, ')
          ..write('projectId: $projectId, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastError: $lastError, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ManualZoneDraftsTable extends ManualZoneDrafts
    with TableInfo<$ManualZoneDraftsTable, ManualZoneDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManualZoneDraftsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _zoneNameMeta = const VerificationMeta(
    'zoneName',
  );
  @override
  late final GeneratedColumn<String> zoneName = GeneratedColumn<String>(
    'zone_name',
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
  static const VerificationMeta _sridMeta = const VerificationMeta('srid');
  @override
  late final GeneratedColumn<int> srid = GeneratedColumn<int>(
    'srid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureTypeMeta = const VerificationMeta(
    'featureType',
  );
  @override
  late final GeneratedColumn<String> featureType = GeneratedColumn<String>(
    'feature_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsJsonMeta = const VerificationMeta(
    'pointsJson',
  );
  @override
  late final GeneratedColumn<String> pointsJson = GeneratedColumn<String>(
    'points_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointCountMeta = const VerificationMeta(
    'pointCount',
  );
  @override
  late final GeneratedColumn<int> pointCount = GeneratedColumn<int>(
    'point_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    zoneName,
    description,
    srid,
    featureType,
    pointsJson,
    pointCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manual_zone_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManualZoneDraft> instance, {
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
    if (data.containsKey('zone_name')) {
      context.handle(
        _zoneNameMeta,
        zoneName.isAcceptableOrUnknown(data['zone_name']!, _zoneNameMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneNameMeta);
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
    if (data.containsKey('srid')) {
      context.handle(
        _sridMeta,
        srid.isAcceptableOrUnknown(data['srid']!, _sridMeta),
      );
    } else if (isInserting) {
      context.missing(_sridMeta);
    }
    if (data.containsKey('feature_type')) {
      context.handle(
        _featureTypeMeta,
        featureType.isAcceptableOrUnknown(
          data['feature_type']!,
          _featureTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureTypeMeta);
    }
    if (data.containsKey('points_json')) {
      context.handle(
        _pointsJsonMeta,
        pointsJson.isAcceptableOrUnknown(data['points_json']!, _pointsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsJsonMeta);
    }
    if (data.containsKey('point_count')) {
      context.handle(
        _pointCountMeta,
        pointCount.isAcceptableOrUnknown(data['point_count']!, _pointCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  ManualZoneDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManualZoneDraft(
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
      zoneName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}zone_name'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      srid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}srid'],
          )!,
      featureType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}feature_type'],
          )!,
      pointsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}points_json'],
          )!,
      pointCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}point_count'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ManualZoneDraftsTable createAlias(String alias) {
    return $ManualZoneDraftsTable(attachedDatabase, alias);
  }
}

class ManualZoneDraft extends DataClass implements Insertable<ManualZoneDraft> {
  final String id;
  final String projectId;
  final String zoneName;
  final String? description;
  final int srid;
  final String featureType;
  final String pointsJson;
  final int pointCount;
  final int createdAt;
  final int updatedAt;
  const ManualZoneDraft({
    required this.id,
    required this.projectId,
    required this.zoneName,
    this.description,
    required this.srid,
    required this.featureType,
    required this.pointsJson,
    required this.pointCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['zone_name'] = Variable<String>(zoneName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['srid'] = Variable<int>(srid);
    map['feature_type'] = Variable<String>(featureType);
    map['points_json'] = Variable<String>(pointsJson);
    map['point_count'] = Variable<int>(pointCount);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ManualZoneDraftsCompanion toCompanion(bool nullToAbsent) {
    return ManualZoneDraftsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      zoneName: Value(zoneName),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      srid: Value(srid),
      featureType: Value(featureType),
      pointsJson: Value(pointsJson),
      pointCount: Value(pointCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ManualZoneDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManualZoneDraft(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      zoneName: serializer.fromJson<String>(json['zoneName']),
      description: serializer.fromJson<String?>(json['description']),
      srid: serializer.fromJson<int>(json['srid']),
      featureType: serializer.fromJson<String>(json['featureType']),
      pointsJson: serializer.fromJson<String>(json['pointsJson']),
      pointCount: serializer.fromJson<int>(json['pointCount']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'zoneName': serializer.toJson<String>(zoneName),
      'description': serializer.toJson<String?>(description),
      'srid': serializer.toJson<int>(srid),
      'featureType': serializer.toJson<String>(featureType),
      'pointsJson': serializer.toJson<String>(pointsJson),
      'pointCount': serializer.toJson<int>(pointCount),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ManualZoneDraft copyWith({
    String? id,
    String? projectId,
    String? zoneName,
    Value<String?> description = const Value.absent(),
    int? srid,
    String? featureType,
    String? pointsJson,
    int? pointCount,
    int? createdAt,
    int? updatedAt,
  }) => ManualZoneDraft(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    zoneName: zoneName ?? this.zoneName,
    description: description.present ? description.value : this.description,
    srid: srid ?? this.srid,
    featureType: featureType ?? this.featureType,
    pointsJson: pointsJson ?? this.pointsJson,
    pointCount: pointCount ?? this.pointCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ManualZoneDraft copyWithCompanion(ManualZoneDraftsCompanion data) {
    return ManualZoneDraft(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      zoneName: data.zoneName.present ? data.zoneName.value : this.zoneName,
      description:
          data.description.present ? data.description.value : this.description,
      srid: data.srid.present ? data.srid.value : this.srid,
      featureType:
          data.featureType.present ? data.featureType.value : this.featureType,
      pointsJson:
          data.pointsJson.present ? data.pointsJson.value : this.pointsJson,
      pointCount:
          data.pointCount.present ? data.pointCount.value : this.pointCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManualZoneDraft(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('zoneName: $zoneName, ')
          ..write('description: $description, ')
          ..write('srid: $srid, ')
          ..write('featureType: $featureType, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('pointCount: $pointCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    zoneName,
    description,
    srid,
    featureType,
    pointsJson,
    pointCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManualZoneDraft &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.zoneName == this.zoneName &&
          other.description == this.description &&
          other.srid == this.srid &&
          other.featureType == this.featureType &&
          other.pointsJson == this.pointsJson &&
          other.pointCount == this.pointCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ManualZoneDraftsCompanion extends UpdateCompanion<ManualZoneDraft> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> zoneName;
  final Value<String?> description;
  final Value<int> srid;
  final Value<String> featureType;
  final Value<String> pointsJson;
  final Value<int> pointCount;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ManualZoneDraftsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.description = const Value.absent(),
    this.srid = const Value.absent(),
    this.featureType = const Value.absent(),
    this.pointsJson = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ManualZoneDraftsCompanion.insert({
    required String id,
    required String projectId,
    required String zoneName,
    this.description = const Value.absent(),
    required int srid,
    required String featureType,
    required String pointsJson,
    this.pointCount = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       zoneName = Value(zoneName),
       srid = Value(srid),
       featureType = Value(featureType),
       pointsJson = Value(pointsJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ManualZoneDraft> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? zoneName,
    Expression<String>? description,
    Expression<int>? srid,
    Expression<String>? featureType,
    Expression<String>? pointsJson,
    Expression<int>? pointCount,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (zoneName != null) 'zone_name': zoneName,
      if (description != null) 'description': description,
      if (srid != null) 'srid': srid,
      if (featureType != null) 'feature_type': featureType,
      if (pointsJson != null) 'points_json': pointsJson,
      if (pointCount != null) 'point_count': pointCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ManualZoneDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? zoneName,
    Value<String?>? description,
    Value<int>? srid,
    Value<String>? featureType,
    Value<String>? pointsJson,
    Value<int>? pointCount,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ManualZoneDraftsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      zoneName: zoneName ?? this.zoneName,
      description: description ?? this.description,
      srid: srid ?? this.srid,
      featureType: featureType ?? this.featureType,
      pointsJson: pointsJson ?? this.pointsJson,
      pointCount: pointCount ?? this.pointCount,
      createdAt: createdAt ?? this.createdAt,
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
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (zoneName.present) {
      map['zone_name'] = Variable<String>(zoneName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (srid.present) {
      map['srid'] = Variable<int>(srid.value);
    }
    if (featureType.present) {
      map['feature_type'] = Variable<String>(featureType.value);
    }
    if (pointsJson.present) {
      map['points_json'] = Variable<String>(pointsJson.value);
    }
    if (pointCount.present) {
      map['point_count'] = Variable<int>(pointCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ManualZoneDraftsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('zoneName: $zoneName, ')
          ..write('description: $description, ')
          ..write('srid: $srid, ')
          ..write('featureType: $featureType, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('pointCount: $pointCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LandUsesTable extends LandUses with TableInfo<$LandUsesTable, LandUse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LandUsesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _styleJsonMeta = const VerificationMeta(
    'styleJson',
  );
  @override
  late final GeneratedColumn<String> styleJson = GeneratedColumn<String>(
    'style_json',
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
    name,
    description,
    color,
    styleJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'land_uses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LandUse> instance, {
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
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('style_json')) {
      context.handle(
        _styleJsonMeta,
        styleJson.isAcceptableOrUnknown(data['style_json']!, _styleJsonMeta),
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
  LandUse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LandUse(
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
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      color:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color'],
          )!,
      styleJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style_json'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $LandUsesTable createAlias(String alias) {
    return $LandUsesTable(attachedDatabase, alias);
  }
}

class LandUse extends DataClass implements Insertable<LandUse> {
  final int id;
  final String name;
  final String description;
  final String color;
  final String? styleJson;
  final int updatedAt;
  const LandUse({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.styleJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || styleJson != null) {
      map['style_json'] = Variable<String>(styleJson);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  LandUsesCompanion toCompanion(bool nullToAbsent) {
    return LandUsesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      color: Value(color),
      styleJson:
          styleJson == null && nullToAbsent
              ? const Value.absent()
              : Value(styleJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory LandUse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LandUse(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      color: serializer.fromJson<String>(json['color']),
      styleJson: serializer.fromJson<String?>(json['styleJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'color': serializer.toJson<String>(color),
      'styleJson': serializer.toJson<String?>(styleJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  LandUse copyWith({
    int? id,
    String? name,
    String? description,
    String? color,
    Value<String?> styleJson = const Value.absent(),
    int? updatedAt,
  }) => LandUse(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    color: color ?? this.color,
    styleJson: styleJson.present ? styleJson.value : this.styleJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LandUse copyWithCompanion(LandUsesCompanion data) {
    return LandUse(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      color: data.color.present ? data.color.value : this.color,
      styleJson: data.styleJson.present ? data.styleJson.value : this.styleJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LandUse(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('styleJson: $styleJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, color, styleJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LandUse &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.color == this.color &&
          other.styleJson == this.styleJson &&
          other.updatedAt == this.updatedAt);
}

class LandUsesCompanion extends UpdateCompanion<LandUse> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> color;
  final Value<String?> styleJson;
  final Value<int> updatedAt;
  const LandUsesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.styleJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LandUsesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required String color,
    this.styleJson = const Value.absent(),
    required int updatedAt,
  }) : name = Value(name),
       description = Value(description),
       color = Value(color),
       updatedAt = Value(updatedAt);
  static Insertable<LandUse> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? color,
    Expression<String>? styleJson,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (styleJson != null) 'style_json': styleJson,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LandUsesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? color,
    Value<String?>? styleJson,
    Value<int>? updatedAt,
  }) {
    return LandUsesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      styleJson: styleJson ?? this.styleJson,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (styleJson.present) {
      map['style_json'] = Variable<String>(styleJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LandUsesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('styleJson: $styleJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
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
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final int updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, int? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
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
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubdivisionZonesTable extends SubdivisionZones
    with TableInfo<$SubdivisionZonesTable, SubdivisionZone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubdivisionZonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoneNameMeta = const VerificationMeta(
    'zoneName',
  );
  @override
  late final GeneratedColumn<String> zoneName = GeneratedColumn<String>(
    'zone_name',
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
  static const VerificationMeta _localityNameMeta = const VerificationMeta(
    'localityName',
  );
  @override
  late final GeneratedColumn<String> localityName = GeneratedColumn<String>(
    'locality_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _landUseNameMeta = const VerificationMeta(
    'landUseName',
  );
  @override
  late final GeneratedColumn<String> landUseName = GeneratedColumn<String>(
    'land_use_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canBeSubdividedMeta = const VerificationMeta(
    'canBeSubdivided',
  );
  @override
  late final GeneratedColumn<bool> canBeSubdivided = GeneratedColumn<bool>(
    'can_be_subdivided',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_be_subdivided" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _areaSqmMeta = const VerificationMeta(
    'areaSqm',
  );
  @override
  late final GeneratedColumn<double> areaSqm = GeneratedColumn<double>(
    'area_sqm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geomJsonMeta = const VerificationMeta(
    'geomJson',
  );
  @override
  late final GeneratedColumn<String> geomJson = GeneratedColumn<String>(
    'geom_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    zoneName,
    localityId,
    localityName,
    landUseName,
    canBeSubdivided,
    areaSqm,
    geomJson,
    downloadedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subdivision_zones';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubdivisionZone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_name')) {
      context.handle(
        _zoneNameMeta,
        zoneName.isAcceptableOrUnknown(data['zone_name']!, _zoneNameMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneNameMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('locality_name')) {
      context.handle(
        _localityNameMeta,
        localityName.isAcceptableOrUnknown(
          data['locality_name']!,
          _localityNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localityNameMeta);
    }
    if (data.containsKey('land_use_name')) {
      context.handle(
        _landUseNameMeta,
        landUseName.isAcceptableOrUnknown(
          data['land_use_name']!,
          _landUseNameMeta,
        ),
      );
    }
    if (data.containsKey('can_be_subdivided')) {
      context.handle(
        _canBeSubdividedMeta,
        canBeSubdivided.isAcceptableOrUnknown(
          data['can_be_subdivided']!,
          _canBeSubdividedMeta,
        ),
      );
    }
    if (data.containsKey('area_sqm')) {
      context.handle(
        _areaSqmMeta,
        areaSqm.isAcceptableOrUnknown(data['area_sqm']!, _areaSqmMeta),
      );
    }
    if (data.containsKey('geom_json')) {
      context.handle(
        _geomJsonMeta,
        geomJson.isAcceptableOrUnknown(data['geom_json']!, _geomJsonMeta),
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
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
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
  SubdivisionZone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubdivisionZone(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      zoneName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}zone_name'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      localityName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}locality_name'],
          )!,
      landUseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}land_use_name'],
      ),
      canBeSubdivided:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}can_be_subdivided'],
          )!,
      areaSqm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_sqm'],
      ),
      geomJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geom_json'],
      ),
      downloadedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}downloaded_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $SubdivisionZonesTable createAlias(String alias) {
    return $SubdivisionZonesTable(attachedDatabase, alias);
  }
}

class SubdivisionZone extends DataClass implements Insertable<SubdivisionZone> {
  final int id;
  final String zoneName;
  final int localityId;
  final String localityName;
  final String? landUseName;
  final bool canBeSubdivided;
  final double? areaSqm;
  final String? geomJson;
  final int downloadedAt;
  final int updatedAt;
  const SubdivisionZone({
    required this.id,
    required this.zoneName,
    required this.localityId,
    required this.localityName,
    this.landUseName,
    required this.canBeSubdivided,
    this.areaSqm,
    this.geomJson,
    required this.downloadedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone_name'] = Variable<String>(zoneName);
    map['locality_id'] = Variable<int>(localityId);
    map['locality_name'] = Variable<String>(localityName);
    if (!nullToAbsent || landUseName != null) {
      map['land_use_name'] = Variable<String>(landUseName);
    }
    map['can_be_subdivided'] = Variable<bool>(canBeSubdivided);
    if (!nullToAbsent || areaSqm != null) {
      map['area_sqm'] = Variable<double>(areaSqm);
    }
    if (!nullToAbsent || geomJson != null) {
      map['geom_json'] = Variable<String>(geomJson);
    }
    map['downloaded_at'] = Variable<int>(downloadedAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SubdivisionZonesCompanion toCompanion(bool nullToAbsent) {
    return SubdivisionZonesCompanion(
      id: Value(id),
      zoneName: Value(zoneName),
      localityId: Value(localityId),
      localityName: Value(localityName),
      landUseName:
          landUseName == null && nullToAbsent
              ? const Value.absent()
              : Value(landUseName),
      canBeSubdivided: Value(canBeSubdivided),
      areaSqm:
          areaSqm == null && nullToAbsent
              ? const Value.absent()
              : Value(areaSqm),
      geomJson:
          geomJson == null && nullToAbsent
              ? const Value.absent()
              : Value(geomJson),
      downloadedAt: Value(downloadedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubdivisionZone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubdivisionZone(
      id: serializer.fromJson<int>(json['id']),
      zoneName: serializer.fromJson<String>(json['zoneName']),
      localityId: serializer.fromJson<int>(json['localityId']),
      localityName: serializer.fromJson<String>(json['localityName']),
      landUseName: serializer.fromJson<String?>(json['landUseName']),
      canBeSubdivided: serializer.fromJson<bool>(json['canBeSubdivided']),
      areaSqm: serializer.fromJson<double?>(json['areaSqm']),
      geomJson: serializer.fromJson<String?>(json['geomJson']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zoneName': serializer.toJson<String>(zoneName),
      'localityId': serializer.toJson<int>(localityId),
      'localityName': serializer.toJson<String>(localityName),
      'landUseName': serializer.toJson<String?>(landUseName),
      'canBeSubdivided': serializer.toJson<bool>(canBeSubdivided),
      'areaSqm': serializer.toJson<double?>(areaSqm),
      'geomJson': serializer.toJson<String?>(geomJson),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SubdivisionZone copyWith({
    int? id,
    String? zoneName,
    int? localityId,
    String? localityName,
    Value<String?> landUseName = const Value.absent(),
    bool? canBeSubdivided,
    Value<double?> areaSqm = const Value.absent(),
    Value<String?> geomJson = const Value.absent(),
    int? downloadedAt,
    int? updatedAt,
  }) => SubdivisionZone(
    id: id ?? this.id,
    zoneName: zoneName ?? this.zoneName,
    localityId: localityId ?? this.localityId,
    localityName: localityName ?? this.localityName,
    landUseName: landUseName.present ? landUseName.value : this.landUseName,
    canBeSubdivided: canBeSubdivided ?? this.canBeSubdivided,
    areaSqm: areaSqm.present ? areaSqm.value : this.areaSqm,
    geomJson: geomJson.present ? geomJson.value : this.geomJson,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubdivisionZone copyWithCompanion(SubdivisionZonesCompanion data) {
    return SubdivisionZone(
      id: data.id.present ? data.id.value : this.id,
      zoneName: data.zoneName.present ? data.zoneName.value : this.zoneName,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      localityName:
          data.localityName.present
              ? data.localityName.value
              : this.localityName,
      landUseName:
          data.landUseName.present ? data.landUseName.value : this.landUseName,
      canBeSubdivided:
          data.canBeSubdivided.present
              ? data.canBeSubdivided.value
              : this.canBeSubdivided,
      areaSqm: data.areaSqm.present ? data.areaSqm.value : this.areaSqm,
      geomJson: data.geomJson.present ? data.geomJson.value : this.geomJson,
      downloadedAt:
          data.downloadedAt.present
              ? data.downloadedAt.value
              : this.downloadedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubdivisionZone(')
          ..write('id: $id, ')
          ..write('zoneName: $zoneName, ')
          ..write('localityId: $localityId, ')
          ..write('localityName: $localityName, ')
          ..write('landUseName: $landUseName, ')
          ..write('canBeSubdivided: $canBeSubdivided, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('geomJson: $geomJson, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    zoneName,
    localityId,
    localityName,
    landUseName,
    canBeSubdivided,
    areaSqm,
    geomJson,
    downloadedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubdivisionZone &&
          other.id == this.id &&
          other.zoneName == this.zoneName &&
          other.localityId == this.localityId &&
          other.localityName == this.localityName &&
          other.landUseName == this.landUseName &&
          other.canBeSubdivided == this.canBeSubdivided &&
          other.areaSqm == this.areaSqm &&
          other.geomJson == this.geomJson &&
          other.downloadedAt == this.downloadedAt &&
          other.updatedAt == this.updatedAt);
}

class SubdivisionZonesCompanion extends UpdateCompanion<SubdivisionZone> {
  final Value<int> id;
  final Value<String> zoneName;
  final Value<int> localityId;
  final Value<String> localityName;
  final Value<String?> landUseName;
  final Value<bool> canBeSubdivided;
  final Value<double?> areaSqm;
  final Value<String?> geomJson;
  final Value<int> downloadedAt;
  final Value<int> updatedAt;
  const SubdivisionZonesCompanion({
    this.id = const Value.absent(),
    this.zoneName = const Value.absent(),
    this.localityId = const Value.absent(),
    this.localityName = const Value.absent(),
    this.landUseName = const Value.absent(),
    this.canBeSubdivided = const Value.absent(),
    this.areaSqm = const Value.absent(),
    this.geomJson = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SubdivisionZonesCompanion.insert({
    this.id = const Value.absent(),
    required String zoneName,
    required int localityId,
    required String localityName,
    this.landUseName = const Value.absent(),
    this.canBeSubdivided = const Value.absent(),
    this.areaSqm = const Value.absent(),
    this.geomJson = const Value.absent(),
    required int downloadedAt,
    required int updatedAt,
  }) : zoneName = Value(zoneName),
       localityId = Value(localityId),
       localityName = Value(localityName),
       downloadedAt = Value(downloadedAt),
       updatedAt = Value(updatedAt);
  static Insertable<SubdivisionZone> custom({
    Expression<int>? id,
    Expression<String>? zoneName,
    Expression<int>? localityId,
    Expression<String>? localityName,
    Expression<String>? landUseName,
    Expression<bool>? canBeSubdivided,
    Expression<double>? areaSqm,
    Expression<String>? geomJson,
    Expression<int>? downloadedAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneName != null) 'zone_name': zoneName,
      if (localityId != null) 'locality_id': localityId,
      if (localityName != null) 'locality_name': localityName,
      if (landUseName != null) 'land_use_name': landUseName,
      if (canBeSubdivided != null) 'can_be_subdivided': canBeSubdivided,
      if (areaSqm != null) 'area_sqm': areaSqm,
      if (geomJson != null) 'geom_json': geomJson,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SubdivisionZonesCompanion copyWith({
    Value<int>? id,
    Value<String>? zoneName,
    Value<int>? localityId,
    Value<String>? localityName,
    Value<String?>? landUseName,
    Value<bool>? canBeSubdivided,
    Value<double?>? areaSqm,
    Value<String?>? geomJson,
    Value<int>? downloadedAt,
    Value<int>? updatedAt,
  }) {
    return SubdivisionZonesCompanion(
      id: id ?? this.id,
      zoneName: zoneName ?? this.zoneName,
      localityId: localityId ?? this.localityId,
      localityName: localityName ?? this.localityName,
      landUseName: landUseName ?? this.landUseName,
      canBeSubdivided: canBeSubdivided ?? this.canBeSubdivided,
      areaSqm: areaSqm ?? this.areaSqm,
      geomJson: geomJson ?? this.geomJson,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zoneName.present) {
      map['zone_name'] = Variable<String>(zoneName.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (localityName.present) {
      map['locality_name'] = Variable<String>(localityName.value);
    }
    if (landUseName.present) {
      map['land_use_name'] = Variable<String>(landUseName.value);
    }
    if (canBeSubdivided.present) {
      map['can_be_subdivided'] = Variable<bool>(canBeSubdivided.value);
    }
    if (areaSqm.present) {
      map['area_sqm'] = Variable<double>(areaSqm.value);
    }
    if (geomJson.present) {
      map['geom_json'] = Variable<String>(geomJson.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubdivisionZonesCompanion(')
          ..write('id: $id, ')
          ..write('zoneName: $zoneName, ')
          ..write('localityId: $localityId, ')
          ..write('localityName: $localityName, ')
          ..write('landUseName: $landUseName, ')
          ..write('canBeSubdivided: $canBeSubdivided, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('geomJson: $geomJson, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SubdivisionApplicationsTable extends SubdivisionApplications
    with TableInfo<$SubdivisionApplicationsTable, SubdivisionApplication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubdivisionApplicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _applicationNumberMeta = const VerificationMeta(
    'applicationNumber',
  );
  @override
  late final GeneratedColumn<String> applicationNumber =
      GeneratedColumn<String>(
        'application_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<int> zoneId = GeneratedColumn<int>(
    'zone_id',
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
  static const VerificationMeta _applicantIdMeta = const VerificationMeta(
    'applicantId',
  );
  @override
  late final GeneratedColumn<String> applicantId = GeneratedColumn<String>(
    'applicant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStepMeta = const VerificationMeta(
    'currentStep',
  );
  @override
  late final GeneratedColumn<int> currentStep = GeneratedColumn<int>(
    'current_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    serverId,
    applicationNumber,
    zoneId,
    localityId,
    applicantId,
    currentStep,
    status,
    notes,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subdivision_applications';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubdivisionApplication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('application_number')) {
      context.handle(
        _applicationNumberMeta,
        applicationNumber.isAcceptableOrUnknown(
          data['application_number']!,
          _applicationNumberMeta,
        ),
      );
    }
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('applicant_id')) {
      context.handle(
        _applicantIdMeta,
        applicantId.isAcceptableOrUnknown(
          data['applicant_id']!,
          _applicantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicantIdMeta);
    }
    if (data.containsKey('current_step')) {
      context.handle(
        _currentStepMeta,
        currentStep.isAcceptableOrUnknown(
          data['current_step']!,
          _currentStepMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  SubdivisionApplication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubdivisionApplication(
      clientId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      applicationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}application_number'],
      ),
      zoneId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}zone_id'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      applicantId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}applicant_id'],
          )!,
      currentStep:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}current_step'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      uploaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}uploaded'],
          )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $SubdivisionApplicationsTable createAlias(String alias) {
    return $SubdivisionApplicationsTable(attachedDatabase, alias);
  }
}

class SubdivisionApplication extends DataClass
    implements Insertable<SubdivisionApplication> {
  final String clientId;
  final int? serverId;
  final String? applicationNumber;
  final int zoneId;
  final int localityId;
  final String applicantId;
  final int currentStep;
  final String status;
  final String? notes;
  final bool uploaded;
  final int? uploadedAt;
  final int createdAt;
  final int updatedAt;
  const SubdivisionApplication({
    required this.clientId,
    this.serverId,
    this.applicationNumber,
    required this.zoneId,
    required this.localityId,
    required this.applicantId,
    required this.currentStep,
    required this.status,
    this.notes,
    required this.uploaded,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || applicationNumber != null) {
      map['application_number'] = Variable<String>(applicationNumber);
    }
    map['zone_id'] = Variable<int>(zoneId);
    map['locality_id'] = Variable<int>(localityId);
    map['applicant_id'] = Variable<String>(applicantId);
    map['current_step'] = Variable<int>(currentStep);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['uploaded'] = Variable<bool>(uploaded);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<int>(uploadedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SubdivisionApplicationsCompanion toCompanion(bool nullToAbsent) {
    return SubdivisionApplicationsCompanion(
      clientId: Value(clientId),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      applicationNumber:
          applicationNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(applicationNumber),
      zoneId: Value(zoneId),
      localityId: Value(localityId),
      applicantId: Value(applicantId),
      currentStep: Value(currentStep),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      uploaded: Value(uploaded),
      uploadedAt:
          uploadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubdivisionApplication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubdivisionApplication(
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      applicationNumber: serializer.fromJson<String?>(
        json['applicationNumber'],
      ),
      zoneId: serializer.fromJson<int>(json['zoneId']),
      localityId: serializer.fromJson<int>(json['localityId']),
      applicantId: serializer.fromJson<String>(json['applicantId']),
      currentStep: serializer.fromJson<int>(json['currentStep']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      uploadedAt: serializer.fromJson<int?>(json['uploadedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<int?>(serverId),
      'applicationNumber': serializer.toJson<String?>(applicationNumber),
      'zoneId': serializer.toJson<int>(zoneId),
      'localityId': serializer.toJson<int>(localityId),
      'applicantId': serializer.toJson<String>(applicantId),
      'currentStep': serializer.toJson<int>(currentStep),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'uploaded': serializer.toJson<bool>(uploaded),
      'uploadedAt': serializer.toJson<int?>(uploadedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SubdivisionApplication copyWith({
    String? clientId,
    Value<int?> serverId = const Value.absent(),
    Value<String?> applicationNumber = const Value.absent(),
    int? zoneId,
    int? localityId,
    String? applicantId,
    int? currentStep,
    String? status,
    Value<String?> notes = const Value.absent(),
    bool? uploaded,
    Value<int?> uploadedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => SubdivisionApplication(
    clientId: clientId ?? this.clientId,
    serverId: serverId.present ? serverId.value : this.serverId,
    applicationNumber:
        applicationNumber.present
            ? applicationNumber.value
            : this.applicationNumber,
    zoneId: zoneId ?? this.zoneId,
    localityId: localityId ?? this.localityId,
    applicantId: applicantId ?? this.applicantId,
    currentStep: currentStep ?? this.currentStep,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    uploaded: uploaded ?? this.uploaded,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubdivisionApplication copyWithCompanion(
    SubdivisionApplicationsCompanion data,
  ) {
    return SubdivisionApplication(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      applicationNumber:
          data.applicationNumber.present
              ? data.applicationNumber.value
              : this.applicationNumber,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      applicantId:
          data.applicantId.present ? data.applicantId.value : this.applicantId,
      currentStep:
          data.currentStep.present ? data.currentStep.value : this.currentStep,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubdivisionApplication(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('applicationNumber: $applicationNumber, ')
          ..write('zoneId: $zoneId, ')
          ..write('localityId: $localityId, ')
          ..write('applicantId: $applicantId, ')
          ..write('currentStep: $currentStep, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    serverId,
    applicationNumber,
    zoneId,
    localityId,
    applicantId,
    currentStep,
    status,
    notes,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubdivisionApplication &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.applicationNumber == this.applicationNumber &&
          other.zoneId == this.zoneId &&
          other.localityId == this.localityId &&
          other.applicantId == this.applicantId &&
          other.currentStep == this.currentStep &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.uploaded == this.uploaded &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubdivisionApplicationsCompanion
    extends UpdateCompanion<SubdivisionApplication> {
  final Value<String> clientId;
  final Value<int?> serverId;
  final Value<String?> applicationNumber;
  final Value<int> zoneId;
  final Value<int> localityId;
  final Value<String> applicantId;
  final Value<int> currentStep;
  final Value<String> status;
  final Value<String?> notes;
  final Value<bool> uploaded;
  final Value<int?> uploadedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SubdivisionApplicationsCompanion({
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.applicationNumber = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.applicantId = const Value.absent(),
    this.currentStep = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubdivisionApplicationsCompanion.insert({
    required String clientId,
    this.serverId = const Value.absent(),
    this.applicationNumber = const Value.absent(),
    required int zoneId,
    required int localityId,
    required String applicantId,
    this.currentStep = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       zoneId = Value(zoneId),
       localityId = Value(localityId),
       applicantId = Value(applicantId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SubdivisionApplication> custom({
    Expression<String>? clientId,
    Expression<int>? serverId,
    Expression<String>? applicationNumber,
    Expression<int>? zoneId,
    Expression<int>? localityId,
    Expression<String>? applicantId,
    Expression<int>? currentStep,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<bool>? uploaded,
    Expression<int>? uploadedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (applicationNumber != null) 'application_number': applicationNumber,
      if (zoneId != null) 'zone_id': zoneId,
      if (localityId != null) 'locality_id': localityId,
      if (applicantId != null) 'applicant_id': applicantId,
      if (currentStep != null) 'current_step': currentStep,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (uploaded != null) 'uploaded': uploaded,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubdivisionApplicationsCompanion copyWith({
    Value<String>? clientId,
    Value<int?>? serverId,
    Value<String?>? applicationNumber,
    Value<int>? zoneId,
    Value<int>? localityId,
    Value<String>? applicantId,
    Value<int>? currentStep,
    Value<String>? status,
    Value<String?>? notes,
    Value<bool>? uploaded,
    Value<int?>? uploadedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubdivisionApplicationsCompanion(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      applicationNumber: applicationNumber ?? this.applicationNumber,
      zoneId: zoneId ?? this.zoneId,
      localityId: localityId ?? this.localityId,
      applicantId: applicantId ?? this.applicantId,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (applicationNumber.present) {
      map['application_number'] = Variable<String>(applicationNumber.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<int>(zoneId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (applicantId.present) {
      map['applicant_id'] = Variable<String>(applicantId.value);
    }
    if (currentStep.present) {
      map['current_step'] = Variable<int>(currentStep.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('SubdivisionApplicationsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('applicationNumber: $applicationNumber, ')
          ..write('zoneId: $zoneId, ')
          ..write('localityId: $localityId, ')
          ..write('applicantId: $applicantId, ')
          ..write('currentStep: $currentStep, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partyTypeMeta = const VerificationMeta(
    'partyType',
  );
  @override
  late final GeneratedColumn<String> partyType = GeneratedColumn<String>(
    'party_type',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nidaNumberMeta = const VerificationMeta(
    'nidaNumber',
  );
  @override
  late final GeneratedColumn<String> nidaNumber = GeneratedColumn<String>(
    'nida_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCitizenMeta = const VerificationMeta(
    'isCitizen',
  );
  @override
  late final GeneratedColumn<bool> isCitizen = GeneratedColumn<bool>(
    'is_citizen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_citizen" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _maritalStatusMeta = const VerificationMeta(
    'maritalStatus',
  );
  @override
  late final GeneratedColumn<String> maritalStatus = GeneratedColumn<String>(
    'marital_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    serverId,
    partyType,
    firstName,
    middleName,
    lastName,
    nidaNumber,
    phone,
    email,
    gender,
    dateOfBirth,
    isCitizen,
    maritalStatus,
    occupation,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Party> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('party_type')) {
      context.handle(
        _partyTypeMeta,
        partyType.isAcceptableOrUnknown(data['party_type']!, _partyTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_partyTypeMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middleNameMeta,
        middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('nida_number')) {
      context.handle(
        _nidaNumberMeta,
        nidaNumber.isAcceptableOrUnknown(data['nida_number']!, _nidaNumberMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('is_citizen')) {
      context.handle(
        _isCitizenMeta,
        isCitizen.isAcceptableOrUnknown(data['is_citizen']!, _isCitizenMeta),
      );
    }
    if (data.containsKey('marital_status')) {
      context.handle(
        _maritalStatusMeta,
        maritalStatus.isAcceptableOrUnknown(
          data['marital_status']!,
          _maritalStatusMeta,
        ),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
      clientId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      partyType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}party_type'],
          )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      ),
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      nidaNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nida_number'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      ),
      isCitizen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_citizen'],
          )!,
      maritalStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marital_status'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      uploaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}uploaded'],
          )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }
}

class Party extends DataClass implements Insertable<Party> {
  final String clientId;
  final int? serverId;
  final String partyType;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? nidaNumber;
  final String? phone;
  final String? email;
  final String? gender;
  final String? dateOfBirth;
  final bool isCitizen;
  final String? maritalStatus;
  final String? occupation;
  final bool uploaded;
  final int? uploadedAt;
  final int createdAt;
  final int updatedAt;
  const Party({
    required this.clientId,
    this.serverId,
    required this.partyType,
    this.firstName,
    this.middleName,
    this.lastName,
    this.nidaNumber,
    this.phone,
    this.email,
    this.gender,
    this.dateOfBirth,
    required this.isCitizen,
    this.maritalStatus,
    this.occupation,
    required this.uploaded,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['party_type'] = Variable<String>(partyType);
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || nidaNumber != null) {
      map['nida_number'] = Variable<String>(nidaNumber);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    map['is_citizen'] = Variable<bool>(isCitizen);
    if (!nullToAbsent || maritalStatus != null) {
      map['marital_status'] = Variable<String>(maritalStatus);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    map['uploaded'] = Variable<bool>(uploaded);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<int>(uploadedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      clientId: Value(clientId),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      partyType: Value(partyType),
      firstName:
          firstName == null && nullToAbsent
              ? const Value.absent()
              : Value(firstName),
      middleName:
          middleName == null && nullToAbsent
              ? const Value.absent()
              : Value(middleName),
      lastName:
          lastName == null && nullToAbsent
              ? const Value.absent()
              : Value(lastName),
      nidaNumber:
          nidaNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(nidaNumber),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      dateOfBirth:
          dateOfBirth == null && nullToAbsent
              ? const Value.absent()
              : Value(dateOfBirth),
      isCitizen: Value(isCitizen),
      maritalStatus:
          maritalStatus == null && nullToAbsent
              ? const Value.absent()
              : Value(maritalStatus),
      occupation:
          occupation == null && nullToAbsent
              ? const Value.absent()
              : Value(occupation),
      uploaded: Value(uploaded),
      uploadedAt:
          uploadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Party.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      partyType: serializer.fromJson<String>(json['partyType']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      nidaNumber: serializer.fromJson<String?>(json['nidaNumber']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      gender: serializer.fromJson<String?>(json['gender']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      isCitizen: serializer.fromJson<bool>(json['isCitizen']),
      maritalStatus: serializer.fromJson<String?>(json['maritalStatus']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      uploadedAt: serializer.fromJson<int?>(json['uploadedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<int?>(serverId),
      'partyType': serializer.toJson<String>(partyType),
      'firstName': serializer.toJson<String?>(firstName),
      'middleName': serializer.toJson<String?>(middleName),
      'lastName': serializer.toJson<String?>(lastName),
      'nidaNumber': serializer.toJson<String?>(nidaNumber),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'gender': serializer.toJson<String?>(gender),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'isCitizen': serializer.toJson<bool>(isCitizen),
      'maritalStatus': serializer.toJson<String?>(maritalStatus),
      'occupation': serializer.toJson<String?>(occupation),
      'uploaded': serializer.toJson<bool>(uploaded),
      'uploadedAt': serializer.toJson<int?>(uploadedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Party copyWith({
    String? clientId,
    Value<int?> serverId = const Value.absent(),
    String? partyType,
    Value<String?> firstName = const Value.absent(),
    Value<String?> middleName = const Value.absent(),
    Value<String?> lastName = const Value.absent(),
    Value<String?> nidaNumber = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> dateOfBirth = const Value.absent(),
    bool? isCitizen,
    Value<String?> maritalStatus = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    bool? uploaded,
    Value<int?> uploadedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Party(
    clientId: clientId ?? this.clientId,
    serverId: serverId.present ? serverId.value : this.serverId,
    partyType: partyType ?? this.partyType,
    firstName: firstName.present ? firstName.value : this.firstName,
    middleName: middleName.present ? middleName.value : this.middleName,
    lastName: lastName.present ? lastName.value : this.lastName,
    nidaNumber: nidaNumber.present ? nidaNumber.value : this.nidaNumber,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    gender: gender.present ? gender.value : this.gender,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    isCitizen: isCitizen ?? this.isCitizen,
    maritalStatus:
        maritalStatus.present ? maritalStatus.value : this.maritalStatus,
    occupation: occupation.present ? occupation.value : this.occupation,
    uploaded: uploaded ?? this.uploaded,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      partyType: data.partyType.present ? data.partyType.value : this.partyType,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName:
          data.middleName.present ? data.middleName.value : this.middleName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      nidaNumber:
          data.nidaNumber.present ? data.nidaNumber.value : this.nidaNumber,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      gender: data.gender.present ? data.gender.value : this.gender,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      isCitizen: data.isCitizen.present ? data.isCitizen.value : this.isCitizen,
      maritalStatus:
          data.maritalStatus.present
              ? data.maritalStatus.value
              : this.maritalStatus,
      occupation:
          data.occupation.present ? data.occupation.value : this.occupation,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Party(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('partyType: $partyType, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('nidaNumber: $nidaNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('isCitizen: $isCitizen, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('occupation: $occupation, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    serverId,
    partyType,
    firstName,
    middleName,
    lastName,
    nidaNumber,
    phone,
    email,
    gender,
    dateOfBirth,
    isCitizen,
    maritalStatus,
    occupation,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Party &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.partyType == this.partyType &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.lastName == this.lastName &&
          other.nidaNumber == this.nidaNumber &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.gender == this.gender &&
          other.dateOfBirth == this.dateOfBirth &&
          other.isCitizen == this.isCitizen &&
          other.maritalStatus == this.maritalStatus &&
          other.occupation == this.occupation &&
          other.uploaded == this.uploaded &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartiesCompanion extends UpdateCompanion<Party> {
  final Value<String> clientId;
  final Value<int?> serverId;
  final Value<String> partyType;
  final Value<String?> firstName;
  final Value<String?> middleName;
  final Value<String?> lastName;
  final Value<String?> nidaNumber;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> gender;
  final Value<String?> dateOfBirth;
  final Value<bool> isCitizen;
  final Value<String?> maritalStatus;
  final Value<String?> occupation;
  final Value<bool> uploaded;
  final Value<int?> uploadedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PartiesCompanion({
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.partyType = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.nidaNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.gender = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.isCitizen = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.occupation = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartiesCompanion.insert({
    required String clientId,
    this.serverId = const Value.absent(),
    required String partyType,
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.nidaNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.gender = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.isCitizen = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.occupation = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       partyType = Value(partyType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Party> custom({
    Expression<String>? clientId,
    Expression<int>? serverId,
    Expression<String>? partyType,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? lastName,
    Expression<String>? nidaNumber,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? gender,
    Expression<String>? dateOfBirth,
    Expression<bool>? isCitizen,
    Expression<String>? maritalStatus,
    Expression<String>? occupation,
    Expression<bool>? uploaded,
    Expression<int>? uploadedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (partyType != null) 'party_type': partyType,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (lastName != null) 'last_name': lastName,
      if (nidaNumber != null) 'nida_number': nidaNumber,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (isCitizen != null) 'is_citizen': isCitizen,
      if (maritalStatus != null) 'marital_status': maritalStatus,
      if (occupation != null) 'occupation': occupation,
      if (uploaded != null) 'uploaded': uploaded,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartiesCompanion copyWith({
    Value<String>? clientId,
    Value<int?>? serverId,
    Value<String>? partyType,
    Value<String?>? firstName,
    Value<String?>? middleName,
    Value<String?>? lastName,
    Value<String?>? nidaNumber,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? gender,
    Value<String?>? dateOfBirth,
    Value<bool>? isCitizen,
    Value<String?>? maritalStatus,
    Value<String?>? occupation,
    Value<bool>? uploaded,
    Value<int?>? uploadedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PartiesCompanion(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      partyType: partyType ?? this.partyType,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      nidaNumber: nidaNumber ?? this.nidaNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isCitizen: isCitizen ?? this.isCitizen,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (partyType.present) {
      map['party_type'] = Variable<String>(partyType.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (nidaNumber.present) {
      map['nida_number'] = Variable<String>(nidaNumber.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (isCitizen.present) {
      map['is_citizen'] = Variable<bool>(isCitizen.value);
    }
    if (maritalStatus.present) {
      map['marital_status'] = Variable<String>(maritalStatus.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('PartiesCompanion(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('partyType: $partyType, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('nidaNumber: $nidaNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('gender: $gender, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('isCitizen: $isCitizen, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('occupation: $occupation, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParcelsTable extends Parcels with TableInfo<$ParcelsTable, Parcel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParcelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parcelNumberMeta = const VerificationMeta(
    'parcelNumber',
  );
  @override
  late final GeneratedColumn<String> parcelNumber = GeneratedColumn<String>(
    'parcel_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _applicationIdMeta = const VerificationMeta(
    'applicationId',
  );
  @override
  late final GeneratedColumn<String> applicationId = GeneratedColumn<String>(
    'application_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<int> zoneId = GeneratedColumn<int>(
    'zone_id',
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
  static const VerificationMeta _hamletIdMeta = const VerificationMeta(
    'hamletId',
  );
  @override
  late final GeneratedColumn<int> hamletId = GeneratedColumn<int>(
    'hamlet_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geomJsonMeta = const VerificationMeta(
    'geomJson',
  );
  @override
  late final GeneratedColumn<String> geomJson = GeneratedColumn<String>(
    'geom_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _geometryTypeMeta = const VerificationMeta(
    'geometryType',
  );
  @override
  late final GeneratedColumn<String> geometryType = GeneratedColumn<String>(
    'geometry_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaSqmMeta = const VerificationMeta(
    'areaSqm',
  );
  @override
  late final GeneratedColumn<double> areaSqm = GeneratedColumn<double>(
    'area_sqm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _northMeta = const VerificationMeta('north');
  @override
  late final GeneratedColumn<String> north = GeneratedColumn<String>(
    'north',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _southMeta = const VerificationMeta('south');
  @override
  late final GeneratedColumn<String> south = GeneratedColumn<String>(
    'south',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eastMeta = const VerificationMeta('east');
  @override
  late final GeneratedColumn<String> east = GeneratedColumn<String>(
    'east',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _westMeta = const VerificationMeta('west');
  @override
  late final GeneratedColumn<String> west = GeneratedColumn<String>(
    'west',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupancyTypeMeta = const VerificationMeta(
    'occupancyType',
  );
  @override
  late final GeneratedColumn<int> occupancyType = GeneratedColumn<int>(
    'occupancy_type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _hasConflictsMeta = const VerificationMeta(
    'hasConflicts',
  );
  @override
  late final GeneratedColumn<bool> hasConflicts = GeneratedColumn<bool>(
    'has_conflicts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_conflicts" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    serverId,
    parcelNumber,
    applicationId,
    zoneId,
    localityId,
    hamletId,
    geomJson,
    geometryType,
    areaSqm,
    north,
    south,
    east,
    west,
    occupancyType,
    stage,
    hasConflicts,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parcels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Parcel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('parcel_number')) {
      context.handle(
        _parcelNumberMeta,
        parcelNumber.isAcceptableOrUnknown(
          data['parcel_number']!,
          _parcelNumberMeta,
        ),
      );
    }
    if (data.containsKey('application_id')) {
      context.handle(
        _applicationIdMeta,
        applicationId.isAcceptableOrUnknown(
          data['application_id']!,
          _applicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationIdMeta);
    }
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('hamlet_id')) {
      context.handle(
        _hamletIdMeta,
        hamletId.isAcceptableOrUnknown(data['hamlet_id']!, _hamletIdMeta),
      );
    }
    if (data.containsKey('geom_json')) {
      context.handle(
        _geomJsonMeta,
        geomJson.isAcceptableOrUnknown(data['geom_json']!, _geomJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_geomJsonMeta);
    }
    if (data.containsKey('geometry_type')) {
      context.handle(
        _geometryTypeMeta,
        geometryType.isAcceptableOrUnknown(
          data['geometry_type']!,
          _geometryTypeMeta,
        ),
      );
    }
    if (data.containsKey('area_sqm')) {
      context.handle(
        _areaSqmMeta,
        areaSqm.isAcceptableOrUnknown(data['area_sqm']!, _areaSqmMeta),
      );
    }
    if (data.containsKey('north')) {
      context.handle(
        _northMeta,
        north.isAcceptableOrUnknown(data['north']!, _northMeta),
      );
    }
    if (data.containsKey('south')) {
      context.handle(
        _southMeta,
        south.isAcceptableOrUnknown(data['south']!, _southMeta),
      );
    }
    if (data.containsKey('east')) {
      context.handle(
        _eastMeta,
        east.isAcceptableOrUnknown(data['east']!, _eastMeta),
      );
    }
    if (data.containsKey('west')) {
      context.handle(
        _westMeta,
        west.isAcceptableOrUnknown(data['west']!, _westMeta),
      );
    }
    if (data.containsKey('occupancy_type')) {
      context.handle(
        _occupancyTypeMeta,
        occupancyType.isAcceptableOrUnknown(
          data['occupancy_type']!,
          _occupancyTypeMeta,
        ),
      );
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    }
    if (data.containsKey('has_conflicts')) {
      context.handle(
        _hasConflictsMeta,
        hasConflicts.isAcceptableOrUnknown(
          data['has_conflicts']!,
          _hasConflictsMeta,
        ),
      );
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  Parcel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Parcel(
      clientId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      parcelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel_number'],
      ),
      applicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}application_id'],
          )!,
      zoneId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}zone_id'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      hamletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hamlet_id'],
      ),
      geomJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}geom_json'],
          )!,
      geometryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geometry_type'],
      ),
      areaSqm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_sqm'],
      ),
      north: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}north'],
      ),
      south: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}south'],
      ),
      east: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}east'],
      ),
      west: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}west'],
      ),
      occupancyType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occupancy_type'],
      ),
      stage:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}stage'],
          )!,
      hasConflicts:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}has_conflicts'],
          )!,
      uploaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}uploaded'],
          )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ParcelsTable createAlias(String alias) {
    return $ParcelsTable(attachedDatabase, alias);
  }
}

class Parcel extends DataClass implements Insertable<Parcel> {
  final String clientId;
  final int? serverId;
  final String? parcelNumber;
  final String applicationId;
  final int zoneId;
  final int localityId;
  final int? hamletId;
  final String geomJson;
  final String? geometryType;
  final double? areaSqm;
  final String? north;
  final String? south;
  final String? east;
  final String? west;
  final int? occupancyType;
  final String stage;
  final bool hasConflicts;
  final bool uploaded;
  final int? uploadedAt;
  final int createdAt;
  final int updatedAt;
  const Parcel({
    required this.clientId,
    this.serverId,
    this.parcelNumber,
    required this.applicationId,
    required this.zoneId,
    required this.localityId,
    this.hamletId,
    required this.geomJson,
    this.geometryType,
    this.areaSqm,
    this.north,
    this.south,
    this.east,
    this.west,
    this.occupancyType,
    required this.stage,
    required this.hasConflicts,
    required this.uploaded,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    if (!nullToAbsent || parcelNumber != null) {
      map['parcel_number'] = Variable<String>(parcelNumber);
    }
    map['application_id'] = Variable<String>(applicationId);
    map['zone_id'] = Variable<int>(zoneId);
    map['locality_id'] = Variable<int>(localityId);
    if (!nullToAbsent || hamletId != null) {
      map['hamlet_id'] = Variable<int>(hamletId);
    }
    map['geom_json'] = Variable<String>(geomJson);
    if (!nullToAbsent || geometryType != null) {
      map['geometry_type'] = Variable<String>(geometryType);
    }
    if (!nullToAbsent || areaSqm != null) {
      map['area_sqm'] = Variable<double>(areaSqm);
    }
    if (!nullToAbsent || north != null) {
      map['north'] = Variable<String>(north);
    }
    if (!nullToAbsent || south != null) {
      map['south'] = Variable<String>(south);
    }
    if (!nullToAbsent || east != null) {
      map['east'] = Variable<String>(east);
    }
    if (!nullToAbsent || west != null) {
      map['west'] = Variable<String>(west);
    }
    if (!nullToAbsent || occupancyType != null) {
      map['occupancy_type'] = Variable<int>(occupancyType);
    }
    map['stage'] = Variable<String>(stage);
    map['has_conflicts'] = Variable<bool>(hasConflicts);
    map['uploaded'] = Variable<bool>(uploaded);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<int>(uploadedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ParcelsCompanion toCompanion(bool nullToAbsent) {
    return ParcelsCompanion(
      clientId: Value(clientId),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      parcelNumber:
          parcelNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(parcelNumber),
      applicationId: Value(applicationId),
      zoneId: Value(zoneId),
      localityId: Value(localityId),
      hamletId:
          hamletId == null && nullToAbsent
              ? const Value.absent()
              : Value(hamletId),
      geomJson: Value(geomJson),
      geometryType:
          geometryType == null && nullToAbsent
              ? const Value.absent()
              : Value(geometryType),
      areaSqm:
          areaSqm == null && nullToAbsent
              ? const Value.absent()
              : Value(areaSqm),
      north:
          north == null && nullToAbsent ? const Value.absent() : Value(north),
      south:
          south == null && nullToAbsent ? const Value.absent() : Value(south),
      east: east == null && nullToAbsent ? const Value.absent() : Value(east),
      west: west == null && nullToAbsent ? const Value.absent() : Value(west),
      occupancyType:
          occupancyType == null && nullToAbsent
              ? const Value.absent()
              : Value(occupancyType),
      stage: Value(stage),
      hasConflicts: Value(hasConflicts),
      uploaded: Value(uploaded),
      uploadedAt:
          uploadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Parcel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Parcel(
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      parcelNumber: serializer.fromJson<String?>(json['parcelNumber']),
      applicationId: serializer.fromJson<String>(json['applicationId']),
      zoneId: serializer.fromJson<int>(json['zoneId']),
      localityId: serializer.fromJson<int>(json['localityId']),
      hamletId: serializer.fromJson<int?>(json['hamletId']),
      geomJson: serializer.fromJson<String>(json['geomJson']),
      geometryType: serializer.fromJson<String?>(json['geometryType']),
      areaSqm: serializer.fromJson<double?>(json['areaSqm']),
      north: serializer.fromJson<String?>(json['north']),
      south: serializer.fromJson<String?>(json['south']),
      east: serializer.fromJson<String?>(json['east']),
      west: serializer.fromJson<String?>(json['west']),
      occupancyType: serializer.fromJson<int?>(json['occupancyType']),
      stage: serializer.fromJson<String>(json['stage']),
      hasConflicts: serializer.fromJson<bool>(json['hasConflicts']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      uploadedAt: serializer.fromJson<int?>(json['uploadedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<int?>(serverId),
      'parcelNumber': serializer.toJson<String?>(parcelNumber),
      'applicationId': serializer.toJson<String>(applicationId),
      'zoneId': serializer.toJson<int>(zoneId),
      'localityId': serializer.toJson<int>(localityId),
      'hamletId': serializer.toJson<int?>(hamletId),
      'geomJson': serializer.toJson<String>(geomJson),
      'geometryType': serializer.toJson<String?>(geometryType),
      'areaSqm': serializer.toJson<double?>(areaSqm),
      'north': serializer.toJson<String?>(north),
      'south': serializer.toJson<String?>(south),
      'east': serializer.toJson<String?>(east),
      'west': serializer.toJson<String?>(west),
      'occupancyType': serializer.toJson<int?>(occupancyType),
      'stage': serializer.toJson<String>(stage),
      'hasConflicts': serializer.toJson<bool>(hasConflicts),
      'uploaded': serializer.toJson<bool>(uploaded),
      'uploadedAt': serializer.toJson<int?>(uploadedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Parcel copyWith({
    String? clientId,
    Value<int?> serverId = const Value.absent(),
    Value<String?> parcelNumber = const Value.absent(),
    String? applicationId,
    int? zoneId,
    int? localityId,
    Value<int?> hamletId = const Value.absent(),
    String? geomJson,
    Value<String?> geometryType = const Value.absent(),
    Value<double?> areaSqm = const Value.absent(),
    Value<String?> north = const Value.absent(),
    Value<String?> south = const Value.absent(),
    Value<String?> east = const Value.absent(),
    Value<String?> west = const Value.absent(),
    Value<int?> occupancyType = const Value.absent(),
    String? stage,
    bool? hasConflicts,
    bool? uploaded,
    Value<int?> uploadedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Parcel(
    clientId: clientId ?? this.clientId,
    serverId: serverId.present ? serverId.value : this.serverId,
    parcelNumber: parcelNumber.present ? parcelNumber.value : this.parcelNumber,
    applicationId: applicationId ?? this.applicationId,
    zoneId: zoneId ?? this.zoneId,
    localityId: localityId ?? this.localityId,
    hamletId: hamletId.present ? hamletId.value : this.hamletId,
    geomJson: geomJson ?? this.geomJson,
    geometryType: geometryType.present ? geometryType.value : this.geometryType,
    areaSqm: areaSqm.present ? areaSqm.value : this.areaSqm,
    north: north.present ? north.value : this.north,
    south: south.present ? south.value : this.south,
    east: east.present ? east.value : this.east,
    west: west.present ? west.value : this.west,
    occupancyType:
        occupancyType.present ? occupancyType.value : this.occupancyType,
    stage: stage ?? this.stage,
    hasConflicts: hasConflicts ?? this.hasConflicts,
    uploaded: uploaded ?? this.uploaded,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Parcel copyWithCompanion(ParcelsCompanion data) {
    return Parcel(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      parcelNumber:
          data.parcelNumber.present
              ? data.parcelNumber.value
              : this.parcelNumber,
      applicationId:
          data.applicationId.present
              ? data.applicationId.value
              : this.applicationId,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      hamletId: data.hamletId.present ? data.hamletId.value : this.hamletId,
      geomJson: data.geomJson.present ? data.geomJson.value : this.geomJson,
      geometryType:
          data.geometryType.present
              ? data.geometryType.value
              : this.geometryType,
      areaSqm: data.areaSqm.present ? data.areaSqm.value : this.areaSqm,
      north: data.north.present ? data.north.value : this.north,
      south: data.south.present ? data.south.value : this.south,
      east: data.east.present ? data.east.value : this.east,
      west: data.west.present ? data.west.value : this.west,
      occupancyType:
          data.occupancyType.present
              ? data.occupancyType.value
              : this.occupancyType,
      stage: data.stage.present ? data.stage.value : this.stage,
      hasConflicts:
          data.hasConflicts.present
              ? data.hasConflicts.value
              : this.hasConflicts,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Parcel(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('parcelNumber: $parcelNumber, ')
          ..write('applicationId: $applicationId, ')
          ..write('zoneId: $zoneId, ')
          ..write('localityId: $localityId, ')
          ..write('hamletId: $hamletId, ')
          ..write('geomJson: $geomJson, ')
          ..write('geometryType: $geometryType, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('north: $north, ')
          ..write('south: $south, ')
          ..write('east: $east, ')
          ..write('west: $west, ')
          ..write('occupancyType: $occupancyType, ')
          ..write('stage: $stage, ')
          ..write('hasConflicts: $hasConflicts, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    clientId,
    serverId,
    parcelNumber,
    applicationId,
    zoneId,
    localityId,
    hamletId,
    geomJson,
    geometryType,
    areaSqm,
    north,
    south,
    east,
    west,
    occupancyType,
    stage,
    hasConflicts,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parcel &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.parcelNumber == this.parcelNumber &&
          other.applicationId == this.applicationId &&
          other.zoneId == this.zoneId &&
          other.localityId == this.localityId &&
          other.hamletId == this.hamletId &&
          other.geomJson == this.geomJson &&
          other.geometryType == this.geometryType &&
          other.areaSqm == this.areaSqm &&
          other.north == this.north &&
          other.south == this.south &&
          other.east == this.east &&
          other.west == this.west &&
          other.occupancyType == this.occupancyType &&
          other.stage == this.stage &&
          other.hasConflicts == this.hasConflicts &&
          other.uploaded == this.uploaded &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParcelsCompanion extends UpdateCompanion<Parcel> {
  final Value<String> clientId;
  final Value<int?> serverId;
  final Value<String?> parcelNumber;
  final Value<String> applicationId;
  final Value<int> zoneId;
  final Value<int> localityId;
  final Value<int?> hamletId;
  final Value<String> geomJson;
  final Value<String?> geometryType;
  final Value<double?> areaSqm;
  final Value<String?> north;
  final Value<String?> south;
  final Value<String?> east;
  final Value<String?> west;
  final Value<int?> occupancyType;
  final Value<String> stage;
  final Value<bool> hasConflicts;
  final Value<bool> uploaded;
  final Value<int?> uploadedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ParcelsCompanion({
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.parcelNumber = const Value.absent(),
    this.applicationId = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.hamletId = const Value.absent(),
    this.geomJson = const Value.absent(),
    this.geometryType = const Value.absent(),
    this.areaSqm = const Value.absent(),
    this.north = const Value.absent(),
    this.south = const Value.absent(),
    this.east = const Value.absent(),
    this.west = const Value.absent(),
    this.occupancyType = const Value.absent(),
    this.stage = const Value.absent(),
    this.hasConflicts = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParcelsCompanion.insert({
    required String clientId,
    this.serverId = const Value.absent(),
    this.parcelNumber = const Value.absent(),
    required String applicationId,
    required int zoneId,
    required int localityId,
    this.hamletId = const Value.absent(),
    required String geomJson,
    this.geometryType = const Value.absent(),
    this.areaSqm = const Value.absent(),
    this.north = const Value.absent(),
    this.south = const Value.absent(),
    this.east = const Value.absent(),
    this.west = const Value.absent(),
    this.occupancyType = const Value.absent(),
    this.stage = const Value.absent(),
    this.hasConflicts = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       applicationId = Value(applicationId),
       zoneId = Value(zoneId),
       localityId = Value(localityId),
       geomJson = Value(geomJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Parcel> custom({
    Expression<String>? clientId,
    Expression<int>? serverId,
    Expression<String>? parcelNumber,
    Expression<String>? applicationId,
    Expression<int>? zoneId,
    Expression<int>? localityId,
    Expression<int>? hamletId,
    Expression<String>? geomJson,
    Expression<String>? geometryType,
    Expression<double>? areaSqm,
    Expression<String>? north,
    Expression<String>? south,
    Expression<String>? east,
    Expression<String>? west,
    Expression<int>? occupancyType,
    Expression<String>? stage,
    Expression<bool>? hasConflicts,
    Expression<bool>? uploaded,
    Expression<int>? uploadedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (parcelNumber != null) 'parcel_number': parcelNumber,
      if (applicationId != null) 'application_id': applicationId,
      if (zoneId != null) 'zone_id': zoneId,
      if (localityId != null) 'locality_id': localityId,
      if (hamletId != null) 'hamlet_id': hamletId,
      if (geomJson != null) 'geom_json': geomJson,
      if (geometryType != null) 'geometry_type': geometryType,
      if (areaSqm != null) 'area_sqm': areaSqm,
      if (north != null) 'north': north,
      if (south != null) 'south': south,
      if (east != null) 'east': east,
      if (west != null) 'west': west,
      if (occupancyType != null) 'occupancy_type': occupancyType,
      if (stage != null) 'stage': stage,
      if (hasConflicts != null) 'has_conflicts': hasConflicts,
      if (uploaded != null) 'uploaded': uploaded,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParcelsCompanion copyWith({
    Value<String>? clientId,
    Value<int?>? serverId,
    Value<String?>? parcelNumber,
    Value<String>? applicationId,
    Value<int>? zoneId,
    Value<int>? localityId,
    Value<int?>? hamletId,
    Value<String>? geomJson,
    Value<String?>? geometryType,
    Value<double?>? areaSqm,
    Value<String?>? north,
    Value<String?>? south,
    Value<String?>? east,
    Value<String?>? west,
    Value<int?>? occupancyType,
    Value<String>? stage,
    Value<bool>? hasConflicts,
    Value<bool>? uploaded,
    Value<int?>? uploadedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ParcelsCompanion(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      applicationId: applicationId ?? this.applicationId,
      zoneId: zoneId ?? this.zoneId,
      localityId: localityId ?? this.localityId,
      hamletId: hamletId ?? this.hamletId,
      geomJson: geomJson ?? this.geomJson,
      geometryType: geometryType ?? this.geometryType,
      areaSqm: areaSqm ?? this.areaSqm,
      north: north ?? this.north,
      south: south ?? this.south,
      east: east ?? this.east,
      west: west ?? this.west,
      occupancyType: occupancyType ?? this.occupancyType,
      stage: stage ?? this.stage,
      hasConflicts: hasConflicts ?? this.hasConflicts,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (parcelNumber.present) {
      map['parcel_number'] = Variable<String>(parcelNumber.value);
    }
    if (applicationId.present) {
      map['application_id'] = Variable<String>(applicationId.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<int>(zoneId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (hamletId.present) {
      map['hamlet_id'] = Variable<int>(hamletId.value);
    }
    if (geomJson.present) {
      map['geom_json'] = Variable<String>(geomJson.value);
    }
    if (geometryType.present) {
      map['geometry_type'] = Variable<String>(geometryType.value);
    }
    if (areaSqm.present) {
      map['area_sqm'] = Variable<double>(areaSqm.value);
    }
    if (north.present) {
      map['north'] = Variable<String>(north.value);
    }
    if (south.present) {
      map['south'] = Variable<String>(south.value);
    }
    if (east.present) {
      map['east'] = Variable<String>(east.value);
    }
    if (west.present) {
      map['west'] = Variable<String>(west.value);
    }
    if (occupancyType.present) {
      map['occupancy_type'] = Variable<int>(occupancyType.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (hasConflicts.present) {
      map['has_conflicts'] = Variable<bool>(hasConflicts.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ParcelsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('parcelNumber: $parcelNumber, ')
          ..write('applicationId: $applicationId, ')
          ..write('zoneId: $zoneId, ')
          ..write('localityId: $localityId, ')
          ..write('hamletId: $hamletId, ')
          ..write('geomJson: $geomJson, ')
          ..write('geometryType: $geometryType, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('north: $north, ')
          ..write('south: $south, ')
          ..write('east: $east, ')
          ..write('west: $west, ')
          ..write('occupancyType: $occupancyType, ')
          ..write('stage: $stage, ')
          ..write('hasConflicts: $hasConflicts, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParcelDraftsTable extends ParcelDrafts
    with TableInfo<$ParcelDraftsTable, ParcelDraftData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParcelDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _applicationIdMeta = const VerificationMeta(
    'applicationId',
  );
  @override
  late final GeneratedColumn<String> applicationId = GeneratedColumn<String>(
    'application_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<int> zoneId = GeneratedColumn<int>(
    'zone_id',
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
  static const VerificationMeta _inputMethodMeta = const VerificationMeta(
    'inputMethod',
  );
  @override
  late final GeneratedColumn<String> inputMethod = GeneratedColumn<String>(
    'input_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tapping'),
  );
  static const VerificationMeta _areaSqmMeta = const VerificationMeta(
    'areaSqm',
  );
  @override
  late final GeneratedColumn<double> areaSqm = GeneratedColumn<double>(
    'area_sqm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    applicationId,
    zoneId,
    localityId,
    coordsJson,
    inputMethod,
    areaSqm,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parcel_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParcelDraftData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('application_id')) {
      context.handle(
        _applicationIdMeta,
        applicationId.isAcceptableOrUnknown(
          data['application_id']!,
          _applicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationIdMeta);
    }
    if (data.containsKey('zone_id')) {
      context.handle(
        _zoneIdMeta,
        zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localityIdMeta);
    }
    if (data.containsKey('coords_json')) {
      context.handle(
        _coordsJsonMeta,
        coordsJson.isAcceptableOrUnknown(data['coords_json']!, _coordsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_coordsJsonMeta);
    }
    if (data.containsKey('input_method')) {
      context.handle(
        _inputMethodMeta,
        inputMethod.isAcceptableOrUnknown(
          data['input_method']!,
          _inputMethodMeta,
        ),
      );
    }
    if (data.containsKey('area_sqm')) {
      context.handle(
        _areaSqmMeta,
        areaSqm.isAcceptableOrUnknown(data['area_sqm']!, _areaSqmMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  ParcelDraftData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParcelDraftData(
      clientId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_id'],
          )!,
      applicationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}application_id'],
          )!,
      zoneId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}zone_id'],
          )!,
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      coordsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}coords_json'],
          )!,
      inputMethod:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}input_method'],
          )!,
      areaSqm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_sqm'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ParcelDraftsTable createAlias(String alias) {
    return $ParcelDraftsTable(attachedDatabase, alias);
  }
}

class ParcelDraftData extends DataClass implements Insertable<ParcelDraftData> {
  final String clientId;
  final String applicationId;
  final int zoneId;
  final int localityId;
  final String coordsJson;
  final String inputMethod;
  final double? areaSqm;
  final int createdAt;
  final int updatedAt;
  const ParcelDraftData({
    required this.clientId,
    required this.applicationId,
    required this.zoneId,
    required this.localityId,
    required this.coordsJson,
    required this.inputMethod,
    this.areaSqm,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['application_id'] = Variable<String>(applicationId);
    map['zone_id'] = Variable<int>(zoneId);
    map['locality_id'] = Variable<int>(localityId);
    map['coords_json'] = Variable<String>(coordsJson);
    map['input_method'] = Variable<String>(inputMethod);
    if (!nullToAbsent || areaSqm != null) {
      map['area_sqm'] = Variable<double>(areaSqm);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ParcelDraftsCompanion toCompanion(bool nullToAbsent) {
    return ParcelDraftsCompanion(
      clientId: Value(clientId),
      applicationId: Value(applicationId),
      zoneId: Value(zoneId),
      localityId: Value(localityId),
      coordsJson: Value(coordsJson),
      inputMethod: Value(inputMethod),
      areaSqm:
          areaSqm == null && nullToAbsent
              ? const Value.absent()
              : Value(areaSqm),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ParcelDraftData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParcelDraftData(
      clientId: serializer.fromJson<String>(json['clientId']),
      applicationId: serializer.fromJson<String>(json['applicationId']),
      zoneId: serializer.fromJson<int>(json['zoneId']),
      localityId: serializer.fromJson<int>(json['localityId']),
      coordsJson: serializer.fromJson<String>(json['coordsJson']),
      inputMethod: serializer.fromJson<String>(json['inputMethod']),
      areaSqm: serializer.fromJson<double?>(json['areaSqm']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'applicationId': serializer.toJson<String>(applicationId),
      'zoneId': serializer.toJson<int>(zoneId),
      'localityId': serializer.toJson<int>(localityId),
      'coordsJson': serializer.toJson<String>(coordsJson),
      'inputMethod': serializer.toJson<String>(inputMethod),
      'areaSqm': serializer.toJson<double?>(areaSqm),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ParcelDraftData copyWith({
    String? clientId,
    String? applicationId,
    int? zoneId,
    int? localityId,
    String? coordsJson,
    String? inputMethod,
    Value<double?> areaSqm = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ParcelDraftData(
    clientId: clientId ?? this.clientId,
    applicationId: applicationId ?? this.applicationId,
    zoneId: zoneId ?? this.zoneId,
    localityId: localityId ?? this.localityId,
    coordsJson: coordsJson ?? this.coordsJson,
    inputMethod: inputMethod ?? this.inputMethod,
    areaSqm: areaSqm.present ? areaSqm.value : this.areaSqm,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ParcelDraftData copyWithCompanion(ParcelDraftsCompanion data) {
    return ParcelDraftData(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      applicationId:
          data.applicationId.present
              ? data.applicationId.value
              : this.applicationId,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      coordsJson:
          data.coordsJson.present ? data.coordsJson.value : this.coordsJson,
      inputMethod:
          data.inputMethod.present ? data.inputMethod.value : this.inputMethod,
      areaSqm: data.areaSqm.present ? data.areaSqm.value : this.areaSqm,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParcelDraftData(')
          ..write('clientId: $clientId, ')
          ..write('applicationId: $applicationId, ')
          ..write('zoneId: $zoneId, ')
          ..write('localityId: $localityId, ')
          ..write('coordsJson: $coordsJson, ')
          ..write('inputMethod: $inputMethod, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    applicationId,
    zoneId,
    localityId,
    coordsJson,
    inputMethod,
    areaSqm,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParcelDraftData &&
          other.clientId == this.clientId &&
          other.applicationId == this.applicationId &&
          other.zoneId == this.zoneId &&
          other.localityId == this.localityId &&
          other.coordsJson == this.coordsJson &&
          other.inputMethod == this.inputMethod &&
          other.areaSqm == this.areaSqm &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParcelDraftsCompanion extends UpdateCompanion<ParcelDraftData> {
  final Value<String> clientId;
  final Value<String> applicationId;
  final Value<int> zoneId;
  final Value<int> localityId;
  final Value<String> coordsJson;
  final Value<String> inputMethod;
  final Value<double?> areaSqm;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ParcelDraftsCompanion({
    this.clientId = const Value.absent(),
    this.applicationId = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.localityId = const Value.absent(),
    this.coordsJson = const Value.absent(),
    this.inputMethod = const Value.absent(),
    this.areaSqm = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParcelDraftsCompanion.insert({
    required String clientId,
    required String applicationId,
    required int zoneId,
    required int localityId,
    required String coordsJson,
    this.inputMethod = const Value.absent(),
    this.areaSqm = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       applicationId = Value(applicationId),
       zoneId = Value(zoneId),
       localityId = Value(localityId),
       coordsJson = Value(coordsJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ParcelDraftData> custom({
    Expression<String>? clientId,
    Expression<String>? applicationId,
    Expression<int>? zoneId,
    Expression<int>? localityId,
    Expression<String>? coordsJson,
    Expression<String>? inputMethod,
    Expression<double>? areaSqm,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (applicationId != null) 'application_id': applicationId,
      if (zoneId != null) 'zone_id': zoneId,
      if (localityId != null) 'locality_id': localityId,
      if (coordsJson != null) 'coords_json': coordsJson,
      if (inputMethod != null) 'input_method': inputMethod,
      if (areaSqm != null) 'area_sqm': areaSqm,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParcelDraftsCompanion copyWith({
    Value<String>? clientId,
    Value<String>? applicationId,
    Value<int>? zoneId,
    Value<int>? localityId,
    Value<String>? coordsJson,
    Value<String>? inputMethod,
    Value<double?>? areaSqm,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ParcelDraftsCompanion(
      clientId: clientId ?? this.clientId,
      applicationId: applicationId ?? this.applicationId,
      zoneId: zoneId ?? this.zoneId,
      localityId: localityId ?? this.localityId,
      coordsJson: coordsJson ?? this.coordsJson,
      inputMethod: inputMethod ?? this.inputMethod,
      areaSqm: areaSqm ?? this.areaSqm,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (applicationId.present) {
      map['application_id'] = Variable<String>(applicationId.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<int>(zoneId.value);
    }
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (coordsJson.present) {
      map['coords_json'] = Variable<String>(coordsJson.value);
    }
    if (inputMethod.present) {
      map['input_method'] = Variable<String>(inputMethod.value);
    }
    if (areaSqm.present) {
      map['area_sqm'] = Variable<double>(areaSqm.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ParcelDraftsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('applicationId: $applicationId, ')
          ..write('zoneId: $zoneId, ')
          ..write('localityId: $localityId, ')
          ..write('coordsJson: $coordsJson, ')
          ..write('inputMethod: $inputMethod, ')
          ..write('areaSqm: $areaSqm, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllocationsTable extends Allocations
    with TableInfo<$AllocationsTable, Allocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parcelIdMeta = const VerificationMeta(
    'parcelId',
  );
  @override
  late final GeneratedColumn<String> parcelId = GeneratedColumn<String>(
    'parcel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyIdMeta = const VerificationMeta(
    'partyId',
  );
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
    'party_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partyNameMeta = const VerificationMeta(
    'partyName',
  );
  @override
  late final GeneratedColumn<String> partyName = GeneratedColumn<String>(
    'party_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nidaNumberMeta = const VerificationMeta(
    'nidaNumber',
  );
  @override
  late final GeneratedColumn<String> nidaNumber = GeneratedColumn<String>(
    'nida_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proposedShareMeta = const VerificationMeta(
    'proposedShare',
  );
  @override
  late final GeneratedColumn<double> proposedShare = GeneratedColumn<double>(
    'proposed_share',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proposedRightTypeMeta = const VerificationMeta(
    'proposedRightType',
  );
  @override
  late final GeneratedColumn<String> proposedRightType =
      GeneratedColumn<String>(
        'proposed_right_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('customary'),
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('proposed'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    serverId,
    parcelId,
    partyId,
    partyName,
    phoneNumber,
    nidaNumber,
    proposedShare,
    proposedRightType,
    status,
    notes,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Allocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('parcel_id')) {
      context.handle(
        _parcelIdMeta,
        parcelId.isAcceptableOrUnknown(data['parcel_id']!, _parcelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelIdMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(
        _partyIdMeta,
        partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta),
      );
    }
    if (data.containsKey('party_name')) {
      context.handle(
        _partyNameMeta,
        partyName.isAcceptableOrUnknown(data['party_name']!, _partyNameMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('nida_number')) {
      context.handle(
        _nidaNumberMeta,
        nidaNumber.isAcceptableOrUnknown(data['nida_number']!, _nidaNumberMeta),
      );
    }
    if (data.containsKey('proposed_share')) {
      context.handle(
        _proposedShareMeta,
        proposedShare.isAcceptableOrUnknown(
          data['proposed_share']!,
          _proposedShareMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proposedShareMeta);
    }
    if (data.containsKey('proposed_right_type')) {
      context.handle(
        _proposedRightTypeMeta,
        proposedRightType.isAcceptableOrUnknown(
          data['proposed_right_type']!,
          _proposedRightTypeMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  Allocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Allocation(
      clientId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      parcelId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}parcel_id'],
          )!,
      partyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_id'],
      ),
      partyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_name'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      nidaNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nida_number'],
      ),
      proposedShare:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}proposed_share'],
          )!,
      proposedRightType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}proposed_right_type'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      uploaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}uploaded'],
          )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AllocationsTable createAlias(String alias) {
    return $AllocationsTable(attachedDatabase, alias);
  }
}

class Allocation extends DataClass implements Insertable<Allocation> {
  final String clientId;
  final int? serverId;
  final String parcelId;
  final String? partyId;
  final String? partyName;
  final String? phoneNumber;
  final String? nidaNumber;
  final double proposedShare;
  final String proposedRightType;
  final String status;
  final String? notes;
  final bool uploaded;
  final int? uploadedAt;
  final int createdAt;
  final int updatedAt;
  const Allocation({
    required this.clientId,
    this.serverId,
    required this.parcelId,
    this.partyId,
    this.partyName,
    this.phoneNumber,
    this.nidaNumber,
    required this.proposedShare,
    required this.proposedRightType,
    required this.status,
    this.notes,
    required this.uploaded,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['parcel_id'] = Variable<String>(parcelId);
    if (!nullToAbsent || partyId != null) {
      map['party_id'] = Variable<String>(partyId);
    }
    if (!nullToAbsent || partyName != null) {
      map['party_name'] = Variable<String>(partyName);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || nidaNumber != null) {
      map['nida_number'] = Variable<String>(nidaNumber);
    }
    map['proposed_share'] = Variable<double>(proposedShare);
    map['proposed_right_type'] = Variable<String>(proposedRightType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['uploaded'] = Variable<bool>(uploaded);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<int>(uploadedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AllocationsCompanion toCompanion(bool nullToAbsent) {
    return AllocationsCompanion(
      clientId: Value(clientId),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      parcelId: Value(parcelId),
      partyId:
          partyId == null && nullToAbsent
              ? const Value.absent()
              : Value(partyId),
      partyName:
          partyName == null && nullToAbsent
              ? const Value.absent()
              : Value(partyName),
      phoneNumber:
          phoneNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(phoneNumber),
      nidaNumber:
          nidaNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(nidaNumber),
      proposedShare: Value(proposedShare),
      proposedRightType: Value(proposedRightType),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      uploaded: Value(uploaded),
      uploadedAt:
          uploadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Allocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Allocation(
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      parcelId: serializer.fromJson<String>(json['parcelId']),
      partyId: serializer.fromJson<String?>(json['partyId']),
      partyName: serializer.fromJson<String?>(json['partyName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      nidaNumber: serializer.fromJson<String?>(json['nidaNumber']),
      proposedShare: serializer.fromJson<double>(json['proposedShare']),
      proposedRightType: serializer.fromJson<String>(json['proposedRightType']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      uploadedAt: serializer.fromJson<int?>(json['uploadedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<int?>(serverId),
      'parcelId': serializer.toJson<String>(parcelId),
      'partyId': serializer.toJson<String?>(partyId),
      'partyName': serializer.toJson<String?>(partyName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'nidaNumber': serializer.toJson<String?>(nidaNumber),
      'proposedShare': serializer.toJson<double>(proposedShare),
      'proposedRightType': serializer.toJson<String>(proposedRightType),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'uploaded': serializer.toJson<bool>(uploaded),
      'uploadedAt': serializer.toJson<int?>(uploadedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Allocation copyWith({
    String? clientId,
    Value<int?> serverId = const Value.absent(),
    String? parcelId,
    Value<String?> partyId = const Value.absent(),
    Value<String?> partyName = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> nidaNumber = const Value.absent(),
    double? proposedShare,
    String? proposedRightType,
    String? status,
    Value<String?> notes = const Value.absent(),
    bool? uploaded,
    Value<int?> uploadedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Allocation(
    clientId: clientId ?? this.clientId,
    serverId: serverId.present ? serverId.value : this.serverId,
    parcelId: parcelId ?? this.parcelId,
    partyId: partyId.present ? partyId.value : this.partyId,
    partyName: partyName.present ? partyName.value : this.partyName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    nidaNumber: nidaNumber.present ? nidaNumber.value : this.nidaNumber,
    proposedShare: proposedShare ?? this.proposedShare,
    proposedRightType: proposedRightType ?? this.proposedRightType,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    uploaded: uploaded ?? this.uploaded,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Allocation copyWithCompanion(AllocationsCompanion data) {
    return Allocation(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      parcelId: data.parcelId.present ? data.parcelId.value : this.parcelId,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      partyName: data.partyName.present ? data.partyName.value : this.partyName,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      nidaNumber:
          data.nidaNumber.present ? data.nidaNumber.value : this.nidaNumber,
      proposedShare:
          data.proposedShare.present
              ? data.proposedShare.value
              : this.proposedShare,
      proposedRightType:
          data.proposedRightType.present
              ? data.proposedRightType.value
              : this.proposedRightType,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Allocation(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('parcelId: $parcelId, ')
          ..write('partyId: $partyId, ')
          ..write('partyName: $partyName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('nidaNumber: $nidaNumber, ')
          ..write('proposedShare: $proposedShare, ')
          ..write('proposedRightType: $proposedRightType, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    serverId,
    parcelId,
    partyId,
    partyName,
    phoneNumber,
    nidaNumber,
    proposedShare,
    proposedRightType,
    status,
    notes,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Allocation &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.parcelId == this.parcelId &&
          other.partyId == this.partyId &&
          other.partyName == this.partyName &&
          other.phoneNumber == this.phoneNumber &&
          other.nidaNumber == this.nidaNumber &&
          other.proposedShare == this.proposedShare &&
          other.proposedRightType == this.proposedRightType &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.uploaded == this.uploaded &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AllocationsCompanion extends UpdateCompanion<Allocation> {
  final Value<String> clientId;
  final Value<int?> serverId;
  final Value<String> parcelId;
  final Value<String?> partyId;
  final Value<String?> partyName;
  final Value<String?> phoneNumber;
  final Value<String?> nidaNumber;
  final Value<double> proposedShare;
  final Value<String> proposedRightType;
  final Value<String> status;
  final Value<String?> notes;
  final Value<bool> uploaded;
  final Value<int?> uploadedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AllocationsCompanion({
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.parcelId = const Value.absent(),
    this.partyId = const Value.absent(),
    this.partyName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.nidaNumber = const Value.absent(),
    this.proposedShare = const Value.absent(),
    this.proposedRightType = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllocationsCompanion.insert({
    required String clientId,
    this.serverId = const Value.absent(),
    required String parcelId,
    this.partyId = const Value.absent(),
    this.partyName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.nidaNumber = const Value.absent(),
    required double proposedShare,
    this.proposedRightType = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       parcelId = Value(parcelId),
       proposedShare = Value(proposedShare),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Allocation> custom({
    Expression<String>? clientId,
    Expression<int>? serverId,
    Expression<String>? parcelId,
    Expression<String>? partyId,
    Expression<String>? partyName,
    Expression<String>? phoneNumber,
    Expression<String>? nidaNumber,
    Expression<double>? proposedShare,
    Expression<String>? proposedRightType,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<bool>? uploaded,
    Expression<int>? uploadedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (parcelId != null) 'parcel_id': parcelId,
      if (partyId != null) 'party_id': partyId,
      if (partyName != null) 'party_name': partyName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (nidaNumber != null) 'nida_number': nidaNumber,
      if (proposedShare != null) 'proposed_share': proposedShare,
      if (proposedRightType != null) 'proposed_right_type': proposedRightType,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (uploaded != null) 'uploaded': uploaded,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllocationsCompanion copyWith({
    Value<String>? clientId,
    Value<int?>? serverId,
    Value<String>? parcelId,
    Value<String?>? partyId,
    Value<String?>? partyName,
    Value<String?>? phoneNumber,
    Value<String?>? nidaNumber,
    Value<double>? proposedShare,
    Value<String>? proposedRightType,
    Value<String>? status,
    Value<String?>? notes,
    Value<bool>? uploaded,
    Value<int?>? uploadedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AllocationsCompanion(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      parcelId: parcelId ?? this.parcelId,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nidaNumber: nidaNumber ?? this.nidaNumber,
      proposedShare: proposedShare ?? this.proposedShare,
      proposedRightType: proposedRightType ?? this.proposedRightType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (parcelId.present) {
      map['parcel_id'] = Variable<String>(parcelId.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (partyName.present) {
      map['party_name'] = Variable<String>(partyName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (nidaNumber.present) {
      map['nida_number'] = Variable<String>(nidaNumber.value);
    }
    if (proposedShare.present) {
      map['proposed_share'] = Variable<double>(proposedShare.value);
    }
    if (proposedRightType.present) {
      map['proposed_right_type'] = Variable<String>(proposedRightType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('AllocationsCompanion(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('parcelId: $parcelId, ')
          ..write('partyId: $partyId, ')
          ..write('partyName: $partyName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('nidaNumber: $nidaNumber, ')
          ..write('proposedShare: $proposedShare, ')
          ..write('proposedRightType: $proposedRightType, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParcelPhotosTable extends ParcelPhotos
    with TableInfo<$ParcelPhotosTable, ParcelPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParcelPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parcelIdMeta = const VerificationMeta(
    'parcelId',
  );
  @override
  late final GeneratedColumn<String> parcelId = GeneratedColumn<String>(
    'parcel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoTypeMeta = const VerificationMeta(
    'photoType',
  );
  @override
  late final GeneratedColumn<String> photoType = GeneratedColumn<String>(
    'photo_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('site'),
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<int> capturedAt = GeneratedColumn<int>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<int> uploadedAt = GeneratedColumn<int>(
    'uploaded_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    serverId,
    parcelId,
    photoPath,
    photoUrl,
    photoType,
    caption,
    capturedAt,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parcel_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParcelPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('parcel_id')) {
      context.handle(
        _parcelIdMeta,
        parcelId.isAcceptableOrUnknown(data['parcel_id']!, _parcelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelIdMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('photo_type')) {
      context.handle(
        _photoTypeMeta,
        photoType.isAcceptableOrUnknown(data['photo_type']!, _photoTypeMeta),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  ParcelPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParcelPhoto(
      clientId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}client_id'],
          )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      parcelId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}parcel_id'],
          )!,
      photoPath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}photo_path'],
          )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      photoType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}photo_type'],
          )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      capturedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}captured_at'],
          )!,
      uploaded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}uploaded'],
          )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ParcelPhotosTable createAlias(String alias) {
    return $ParcelPhotosTable(attachedDatabase, alias);
  }
}

class ParcelPhoto extends DataClass implements Insertable<ParcelPhoto> {
  final String clientId;
  final int? serverId;
  final String parcelId;
  final String photoPath;
  final String? photoUrl;
  final String photoType;
  final String? caption;
  final int capturedAt;
  final bool uploaded;
  final int? uploadedAt;
  final int createdAt;
  final int updatedAt;
  const ParcelPhoto({
    required this.clientId,
    this.serverId,
    required this.parcelId,
    required this.photoPath,
    this.photoUrl,
    required this.photoType,
    this.caption,
    required this.capturedAt,
    required this.uploaded,
    this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['parcel_id'] = Variable<String>(parcelId);
    map['photo_path'] = Variable<String>(photoPath);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['photo_type'] = Variable<String>(photoType);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['captured_at'] = Variable<int>(capturedAt);
    map['uploaded'] = Variable<bool>(uploaded);
    if (!nullToAbsent || uploadedAt != null) {
      map['uploaded_at'] = Variable<int>(uploadedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ParcelPhotosCompanion toCompanion(bool nullToAbsent) {
    return ParcelPhotosCompanion(
      clientId: Value(clientId),
      serverId:
          serverId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverId),
      parcelId: Value(parcelId),
      photoPath: Value(photoPath),
      photoUrl:
          photoUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(photoUrl),
      photoType: Value(photoType),
      caption:
          caption == null && nullToAbsent
              ? const Value.absent()
              : Value(caption),
      capturedAt: Value(capturedAt),
      uploaded: Value(uploaded),
      uploadedAt:
          uploadedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(uploadedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ParcelPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParcelPhoto(
      clientId: serializer.fromJson<String>(json['clientId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      parcelId: serializer.fromJson<String>(json['parcelId']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      photoType: serializer.fromJson<String>(json['photoType']),
      caption: serializer.fromJson<String?>(json['caption']),
      capturedAt: serializer.fromJson<int>(json['capturedAt']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      uploadedAt: serializer.fromJson<int?>(json['uploadedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'serverId': serializer.toJson<int?>(serverId),
      'parcelId': serializer.toJson<String>(parcelId),
      'photoPath': serializer.toJson<String>(photoPath),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'photoType': serializer.toJson<String>(photoType),
      'caption': serializer.toJson<String?>(caption),
      'capturedAt': serializer.toJson<int>(capturedAt),
      'uploaded': serializer.toJson<bool>(uploaded),
      'uploadedAt': serializer.toJson<int?>(uploadedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ParcelPhoto copyWith({
    String? clientId,
    Value<int?> serverId = const Value.absent(),
    String? parcelId,
    String? photoPath,
    Value<String?> photoUrl = const Value.absent(),
    String? photoType,
    Value<String?> caption = const Value.absent(),
    int? capturedAt,
    bool? uploaded,
    Value<int?> uploadedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ParcelPhoto(
    clientId: clientId ?? this.clientId,
    serverId: serverId.present ? serverId.value : this.serverId,
    parcelId: parcelId ?? this.parcelId,
    photoPath: photoPath ?? this.photoPath,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    photoType: photoType ?? this.photoType,
    caption: caption.present ? caption.value : this.caption,
    capturedAt: capturedAt ?? this.capturedAt,
    uploaded: uploaded ?? this.uploaded,
    uploadedAt: uploadedAt.present ? uploadedAt.value : this.uploadedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ParcelPhoto copyWithCompanion(ParcelPhotosCompanion data) {
    return ParcelPhoto(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      parcelId: data.parcelId.present ? data.parcelId.value : this.parcelId,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      photoType: data.photoType.present ? data.photoType.value : this.photoType,
      caption: data.caption.present ? data.caption.value : this.caption,
      capturedAt:
          data.capturedAt.present ? data.capturedAt.value : this.capturedAt,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParcelPhoto(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('parcelId: $parcelId, ')
          ..write('photoPath: $photoPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('photoType: $photoType, ')
          ..write('caption: $caption, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    serverId,
    parcelId,
    photoPath,
    photoUrl,
    photoType,
    caption,
    capturedAt,
    uploaded,
    uploadedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParcelPhoto &&
          other.clientId == this.clientId &&
          other.serverId == this.serverId &&
          other.parcelId == this.parcelId &&
          other.photoPath == this.photoPath &&
          other.photoUrl == this.photoUrl &&
          other.photoType == this.photoType &&
          other.caption == this.caption &&
          other.capturedAt == this.capturedAt &&
          other.uploaded == this.uploaded &&
          other.uploadedAt == this.uploadedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParcelPhotosCompanion extends UpdateCompanion<ParcelPhoto> {
  final Value<String> clientId;
  final Value<int?> serverId;
  final Value<String> parcelId;
  final Value<String> photoPath;
  final Value<String?> photoUrl;
  final Value<String> photoType;
  final Value<String?> caption;
  final Value<int> capturedAt;
  final Value<bool> uploaded;
  final Value<int?> uploadedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ParcelPhotosCompanion({
    this.clientId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.parcelId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.photoType = const Value.absent(),
    this.caption = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParcelPhotosCompanion.insert({
    required String clientId,
    this.serverId = const Value.absent(),
    required String parcelId,
    required String photoPath,
    this.photoUrl = const Value.absent(),
    this.photoType = const Value.absent(),
    this.caption = const Value.absent(),
    required int capturedAt,
    this.uploaded = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId),
       parcelId = Value(parcelId),
       photoPath = Value(photoPath),
       capturedAt = Value(capturedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ParcelPhoto> custom({
    Expression<String>? clientId,
    Expression<int>? serverId,
    Expression<String>? parcelId,
    Expression<String>? photoPath,
    Expression<String>? photoUrl,
    Expression<String>? photoType,
    Expression<String>? caption,
    Expression<int>? capturedAt,
    Expression<bool>? uploaded,
    Expression<int>? uploadedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (serverId != null) 'server_id': serverId,
      if (parcelId != null) 'parcel_id': parcelId,
      if (photoPath != null) 'photo_path': photoPath,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (photoType != null) 'photo_type': photoType,
      if (caption != null) 'caption': caption,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (uploaded != null) 'uploaded': uploaded,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParcelPhotosCompanion copyWith({
    Value<String>? clientId,
    Value<int?>? serverId,
    Value<String>? parcelId,
    Value<String>? photoPath,
    Value<String?>? photoUrl,
    Value<String>? photoType,
    Value<String?>? caption,
    Value<int>? capturedAt,
    Value<bool>? uploaded,
    Value<int?>? uploadedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ParcelPhotosCompanion(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      parcelId: parcelId ?? this.parcelId,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
      photoType: photoType ?? this.photoType,
      caption: caption ?? this.caption,
      capturedAt: capturedAt ?? this.capturedAt,
      uploaded: uploaded ?? this.uploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (parcelId.present) {
      map['parcel_id'] = Variable<String>(parcelId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (photoType.present) {
      map['photo_type'] = Variable<String>(photoType.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<int>(capturedAt.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<int>(uploadedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ParcelPhotosCompanion(')
          ..write('clientId: $clientId, ')
          ..write('serverId: $serverId, ')
          ..write('parcelId: $parcelId, ')
          ..write('photoPath: $photoPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('photoType: $photoType, ')
          ..write('caption: $caption, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('uploaded: $uploaded, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MvtTilesetsTable extends MvtTilesets
    with TableInfo<$MvtTilesetsTable, MvtTileset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MvtTilesetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localityIdMeta = const VerificationMeta(
    'localityId',
  );
  @override
  late final GeneratedColumn<int> localityId = GeneratedColumn<int>(
    'locality_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mbtilesPathMeta = const VerificationMeta(
    'mbtilesPath',
  );
  @override
  late final GeneratedColumn<String> mbtilesPath = GeneratedColumn<String>(
    'mbtiles_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minZoomMeta = const VerificationMeta(
    'minZoom',
  );
  @override
  late final GeneratedColumn<int> minZoom = GeneratedColumn<int>(
    'min_zoom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxZoomMeta = const VerificationMeta(
    'maxZoom',
  );
  @override
  late final GeneratedColumn<int> maxZoom = GeneratedColumn<int>(
    'max_zoom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boundsJsonMeta = const VerificationMeta(
    'boundsJson',
  );
  @override
  late final GeneratedColumn<String> boundsJson = GeneratedColumn<String>(
    'bounds_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isProposedMeta = const VerificationMeta(
    'isProposed',
  );
  @override
  late final GeneratedColumn<bool> isProposed = GeneratedColumn<bool>(
    'is_proposed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_proposed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tileCountMeta = const VerificationMeta(
    'tileCount',
  );
  @override
  late final GeneratedColumn<int> tileCount = GeneratedColumn<int>(
    'tile_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<int> downloadedAt = GeneratedColumn<int>(
    'downloaded_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    localityId,
    mbtilesPath,
    minZoom,
    maxZoom,
    boundsJson,
    isProposed,
    tileCount,
    downloadedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mvt_tilesets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MvtTileset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('locality_id')) {
      context.handle(
        _localityIdMeta,
        localityId.isAcceptableOrUnknown(data['locality_id']!, _localityIdMeta),
      );
    }
    if (data.containsKey('mbtiles_path')) {
      context.handle(
        _mbtilesPathMeta,
        mbtilesPath.isAcceptableOrUnknown(
          data['mbtiles_path']!,
          _mbtilesPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mbtilesPathMeta);
    }
    if (data.containsKey('min_zoom')) {
      context.handle(
        _minZoomMeta,
        minZoom.isAcceptableOrUnknown(data['min_zoom']!, _minZoomMeta),
      );
    } else if (isInserting) {
      context.missing(_minZoomMeta);
    }
    if (data.containsKey('max_zoom')) {
      context.handle(
        _maxZoomMeta,
        maxZoom.isAcceptableOrUnknown(data['max_zoom']!, _maxZoomMeta),
      );
    } else if (isInserting) {
      context.missing(_maxZoomMeta);
    }
    if (data.containsKey('bounds_json')) {
      context.handle(
        _boundsJsonMeta,
        boundsJson.isAcceptableOrUnknown(data['bounds_json']!, _boundsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_boundsJsonMeta);
    }
    if (data.containsKey('is_proposed')) {
      context.handle(
        _isProposedMeta,
        isProposed.isAcceptableOrUnknown(data['is_proposed']!, _isProposedMeta),
      );
    }
    if (data.containsKey('tile_count')) {
      context.handle(
        _tileCountMeta,
        tileCount.isAcceptableOrUnknown(data['tile_count']!, _tileCountMeta),
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
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {localityId};
  @override
  MvtTileset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MvtTileset(
      localityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}locality_id'],
          )!,
      mbtilesPath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mbtiles_path'],
          )!,
      minZoom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}min_zoom'],
          )!,
      maxZoom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}max_zoom'],
          )!,
      boundsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bounds_json'],
          )!,
      isProposed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_proposed'],
          )!,
      tileCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tile_count'],
          )!,
      downloadedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}downloaded_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $MvtTilesetsTable createAlias(String alias) {
    return $MvtTilesetsTable(attachedDatabase, alias);
  }
}

class MvtTileset extends DataClass implements Insertable<MvtTileset> {
  final int localityId;
  final String mbtilesPath;
  final int minZoom;
  final int maxZoom;
  final String boundsJson;
  final bool isProposed;
  final int tileCount;
  final int downloadedAt;
  final int updatedAt;
  const MvtTileset({
    required this.localityId,
    required this.mbtilesPath,
    required this.minZoom,
    required this.maxZoom,
    required this.boundsJson,
    required this.isProposed,
    required this.tileCount,
    required this.downloadedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['locality_id'] = Variable<int>(localityId);
    map['mbtiles_path'] = Variable<String>(mbtilesPath);
    map['min_zoom'] = Variable<int>(minZoom);
    map['max_zoom'] = Variable<int>(maxZoom);
    map['bounds_json'] = Variable<String>(boundsJson);
    map['is_proposed'] = Variable<bool>(isProposed);
    map['tile_count'] = Variable<int>(tileCount);
    map['downloaded_at'] = Variable<int>(downloadedAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  MvtTilesetsCompanion toCompanion(bool nullToAbsent) {
    return MvtTilesetsCompanion(
      localityId: Value(localityId),
      mbtilesPath: Value(mbtilesPath),
      minZoom: Value(minZoom),
      maxZoom: Value(maxZoom),
      boundsJson: Value(boundsJson),
      isProposed: Value(isProposed),
      tileCount: Value(tileCount),
      downloadedAt: Value(downloadedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MvtTileset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MvtTileset(
      localityId: serializer.fromJson<int>(json['localityId']),
      mbtilesPath: serializer.fromJson<String>(json['mbtilesPath']),
      minZoom: serializer.fromJson<int>(json['minZoom']),
      maxZoom: serializer.fromJson<int>(json['maxZoom']),
      boundsJson: serializer.fromJson<String>(json['boundsJson']),
      isProposed: serializer.fromJson<bool>(json['isProposed']),
      tileCount: serializer.fromJson<int>(json['tileCount']),
      downloadedAt: serializer.fromJson<int>(json['downloadedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localityId': serializer.toJson<int>(localityId),
      'mbtilesPath': serializer.toJson<String>(mbtilesPath),
      'minZoom': serializer.toJson<int>(minZoom),
      'maxZoom': serializer.toJson<int>(maxZoom),
      'boundsJson': serializer.toJson<String>(boundsJson),
      'isProposed': serializer.toJson<bool>(isProposed),
      'tileCount': serializer.toJson<int>(tileCount),
      'downloadedAt': serializer.toJson<int>(downloadedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  MvtTileset copyWith({
    int? localityId,
    String? mbtilesPath,
    int? minZoom,
    int? maxZoom,
    String? boundsJson,
    bool? isProposed,
    int? tileCount,
    int? downloadedAt,
    int? updatedAt,
  }) => MvtTileset(
    localityId: localityId ?? this.localityId,
    mbtilesPath: mbtilesPath ?? this.mbtilesPath,
    minZoom: minZoom ?? this.minZoom,
    maxZoom: maxZoom ?? this.maxZoom,
    boundsJson: boundsJson ?? this.boundsJson,
    isProposed: isProposed ?? this.isProposed,
    tileCount: tileCount ?? this.tileCount,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MvtTileset copyWithCompanion(MvtTilesetsCompanion data) {
    return MvtTileset(
      localityId:
          data.localityId.present ? data.localityId.value : this.localityId,
      mbtilesPath:
          data.mbtilesPath.present ? data.mbtilesPath.value : this.mbtilesPath,
      minZoom: data.minZoom.present ? data.minZoom.value : this.minZoom,
      maxZoom: data.maxZoom.present ? data.maxZoom.value : this.maxZoom,
      boundsJson:
          data.boundsJson.present ? data.boundsJson.value : this.boundsJson,
      isProposed:
          data.isProposed.present ? data.isProposed.value : this.isProposed,
      tileCount: data.tileCount.present ? data.tileCount.value : this.tileCount,
      downloadedAt:
          data.downloadedAt.present
              ? data.downloadedAt.value
              : this.downloadedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MvtTileset(')
          ..write('localityId: $localityId, ')
          ..write('mbtilesPath: $mbtilesPath, ')
          ..write('minZoom: $minZoom, ')
          ..write('maxZoom: $maxZoom, ')
          ..write('boundsJson: $boundsJson, ')
          ..write('isProposed: $isProposed, ')
          ..write('tileCount: $tileCount, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localityId,
    mbtilesPath,
    minZoom,
    maxZoom,
    boundsJson,
    isProposed,
    tileCount,
    downloadedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MvtTileset &&
          other.localityId == this.localityId &&
          other.mbtilesPath == this.mbtilesPath &&
          other.minZoom == this.minZoom &&
          other.maxZoom == this.maxZoom &&
          other.boundsJson == this.boundsJson &&
          other.isProposed == this.isProposed &&
          other.tileCount == this.tileCount &&
          other.downloadedAt == this.downloadedAt &&
          other.updatedAt == this.updatedAt);
}

class MvtTilesetsCompanion extends UpdateCompanion<MvtTileset> {
  final Value<int> localityId;
  final Value<String> mbtilesPath;
  final Value<int> minZoom;
  final Value<int> maxZoom;
  final Value<String> boundsJson;
  final Value<bool> isProposed;
  final Value<int> tileCount;
  final Value<int> downloadedAt;
  final Value<int> updatedAt;
  const MvtTilesetsCompanion({
    this.localityId = const Value.absent(),
    this.mbtilesPath = const Value.absent(),
    this.minZoom = const Value.absent(),
    this.maxZoom = const Value.absent(),
    this.boundsJson = const Value.absent(),
    this.isProposed = const Value.absent(),
    this.tileCount = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MvtTilesetsCompanion.insert({
    this.localityId = const Value.absent(),
    required String mbtilesPath,
    required int minZoom,
    required int maxZoom,
    required String boundsJson,
    this.isProposed = const Value.absent(),
    this.tileCount = const Value.absent(),
    required int downloadedAt,
    required int updatedAt,
  }) : mbtilesPath = Value(mbtilesPath),
       minZoom = Value(minZoom),
       maxZoom = Value(maxZoom),
       boundsJson = Value(boundsJson),
       downloadedAt = Value(downloadedAt),
       updatedAt = Value(updatedAt);
  static Insertable<MvtTileset> custom({
    Expression<int>? localityId,
    Expression<String>? mbtilesPath,
    Expression<int>? minZoom,
    Expression<int>? maxZoom,
    Expression<String>? boundsJson,
    Expression<bool>? isProposed,
    Expression<int>? tileCount,
    Expression<int>? downloadedAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (localityId != null) 'locality_id': localityId,
      if (mbtilesPath != null) 'mbtiles_path': mbtilesPath,
      if (minZoom != null) 'min_zoom': minZoom,
      if (maxZoom != null) 'max_zoom': maxZoom,
      if (boundsJson != null) 'bounds_json': boundsJson,
      if (isProposed != null) 'is_proposed': isProposed,
      if (tileCount != null) 'tile_count': tileCount,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MvtTilesetsCompanion copyWith({
    Value<int>? localityId,
    Value<String>? mbtilesPath,
    Value<int>? minZoom,
    Value<int>? maxZoom,
    Value<String>? boundsJson,
    Value<bool>? isProposed,
    Value<int>? tileCount,
    Value<int>? downloadedAt,
    Value<int>? updatedAt,
  }) {
    return MvtTilesetsCompanion(
      localityId: localityId ?? this.localityId,
      mbtilesPath: mbtilesPath ?? this.mbtilesPath,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      boundsJson: boundsJson ?? this.boundsJson,
      isProposed: isProposed ?? this.isProposed,
      tileCount: tileCount ?? this.tileCount,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localityId.present) {
      map['locality_id'] = Variable<int>(localityId.value);
    }
    if (mbtilesPath.present) {
      map['mbtiles_path'] = Variable<String>(mbtilesPath.value);
    }
    if (minZoom.present) {
      map['min_zoom'] = Variable<int>(minZoom.value);
    }
    if (maxZoom.present) {
      map['max_zoom'] = Variable<int>(maxZoom.value);
    }
    if (boundsJson.present) {
      map['bounds_json'] = Variable<String>(boundsJson.value);
    }
    if (isProposed.present) {
      map['is_proposed'] = Variable<bool>(isProposed.value);
    }
    if (tileCount.present) {
      map['tile_count'] = Variable<int>(tileCount.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<int>(downloadedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MvtTilesetsCompanion(')
          ..write('localityId: $localityId, ')
          ..write('mbtilesPath: $mbtilesPath, ')
          ..write('minZoom: $minZoom, ')
          ..write('maxZoom: $maxZoom, ')
          ..write('boundsJson: $boundsJson, ')
          ..write('isProposed: $isProposed, ')
          ..write('tileCount: $tileCount, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('updatedAt: $updatedAt')
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
  late final $ZoningFeatureHistoryTable zoningFeatureHistory =
      $ZoningFeatureHistoryTable(this);
  late final $FeatureUploadQueueTable featureUploadQueue =
      $FeatureUploadQueueTable(this);
  late final $ManualZoneDraftsTable manualZoneDrafts = $ManualZoneDraftsTable(
    this,
  );
  late final $LandUsesTable landUses = $LandUsesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SubdivisionZonesTable subdivisionZones = $SubdivisionZonesTable(
    this,
  );
  late final $SubdivisionApplicationsTable subdivisionApplications =
      $SubdivisionApplicationsTable(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $ParcelsTable parcels = $ParcelsTable(this);
  late final $ParcelDraftsTable parcelDrafts = $ParcelDraftsTable(this);
  late final $AllocationsTable allocations = $AllocationsTable(this);
  late final $ParcelPhotosTable parcelPhotos = $ParcelPhotosTable(this);
  late final $MvtTilesetsTable mvtTilesets = $MvtTilesetsTable(this);
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
    zoningFeatureHistory,
    featureUploadQueue,
    manualZoneDrafts,
    landUses,
    appSettings,
    subdivisionZones,
    subdivisionApplications,
    parties,
    parcels,
    parcelDrafts,
    allocations,
    parcelPhotos,
    mvtTilesets,
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
      Value<int> localityId,
      required String geoJson,
      Value<double?> centerLat,
      Value<double?> centerLng,
      Value<double?> zoom,
      required int downloadedAt,
      required int updatedAt,
    });
typedef $$BaseMapsTableUpdateCompanionBuilder =
    BaseMapsCompanion Function({
      Value<int> localityId,
      Value<String> geoJson,
      Value<double?> centerLat,
      Value<double?> centerLng,
      Value<double?> zoom,
      Value<int> downloadedAt,
      Value<int> updatedAt,
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
  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geoJson => $composableBuilder(
    column: $table.geoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get centerLat => $composableBuilder(
    column: $table.centerLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get centerLng => $composableBuilder(
    column: $table.centerLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get zoom => $composableBuilder(
    column: $table.zoom,
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

class $$BaseMapsTableOrderingComposer
    extends Composer<_$AppDatabase, $BaseMapsTable> {
  $$BaseMapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geoJson => $composableBuilder(
    column: $table.geoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get centerLat => $composableBuilder(
    column: $table.centerLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get centerLng => $composableBuilder(
    column: $table.centerLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get zoom => $composableBuilder(
    column: $table.zoom,
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

class $$BaseMapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BaseMapsTable> {
  $$BaseMapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get geoJson =>
      $composableBuilder(column: $table.geoJson, builder: (column) => column);

  GeneratedColumn<double> get centerLat =>
      $composableBuilder(column: $table.centerLat, builder: (column) => column);

  GeneratedColumn<double> get centerLng =>
      $composableBuilder(column: $table.centerLng, builder: (column) => column);

  GeneratedColumn<double> get zoom =>
      $composableBuilder(column: $table.zoom, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

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
                Value<int> localityId = const Value.absent(),
                Value<String> geoJson = const Value.absent(),
                Value<double?> centerLat = const Value.absent(),
                Value<double?> centerLng = const Value.absent(),
                Value<double?> zoom = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => BaseMapsCompanion(
                localityId: localityId,
                geoJson: geoJson,
                centerLat: centerLat,
                centerLng: centerLng,
                zoom: zoom,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localityId = const Value.absent(),
                required String geoJson,
                Value<double?> centerLat = const Value.absent(),
                Value<double?> centerLng = const Value.absent(),
                Value<double?> zoom = const Value.absent(),
                required int downloadedAt,
                required int updatedAt,
              }) => BaseMapsCompanion.insert(
                localityId: localityId,
                geoJson: geoJson,
                centerLat: centerLat,
                centerLng: centerLng,
                zoom: zoom,
                downloadedAt: downloadedAt,
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
      required String clientUuid,
      Value<String?> serverId,
      required String projectId,
      required int localityId,
      Value<int?> landUseId,
      required String geomType,
      Value<int> srid,
      required String coordsJson,
      Value<double?> areaSqm,
      Value<double?> lengthM,
      Value<double> buffer,
      Value<String?> propertiesJson,
      Value<bool> isDraft,
      Value<bool> isProposed,
      Value<String> status,
      Value<String> source,
      Value<int> version,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      required int createdAt,
      required int updatedAt,
      Value<String?> metadataJson,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$ZoningFeaturesTableUpdateCompanionBuilder =
    ZoningFeaturesCompanion Function({
      Value<String> clientUuid,
      Value<String?> serverId,
      Value<String> projectId,
      Value<int> localityId,
      Value<int?> landUseId,
      Value<String> geomType,
      Value<int> srid,
      Value<String> coordsJson,
      Value<double?> areaSqm,
      Value<double?> lengthM,
      Value<double> buffer,
      Value<String?> propertiesJson,
      Value<bool> isDraft,
      Value<bool> isProposed,
      Value<String> status,
      Value<String> source,
      Value<int> version,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<String?> metadataJson,
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
  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get landUseId => $composableBuilder(
    column: $table.landUseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geomType => $composableBuilder(
    column: $table.geomType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get srid => $composableBuilder(
    column: $table.srid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lengthM => $composableBuilder(
    column: $table.lengthM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get buffer => $composableBuilder(
    column: $table.buffer,
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

  ColumnFilters<bool> get isProposed => $composableBuilder(
    column: $table.isProposed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get landUseId => $composableBuilder(
    column: $table.landUseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geomType => $composableBuilder(
    column: $table.geomType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get srid => $composableBuilder(
    column: $table.srid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lengthM => $composableBuilder(
    column: $table.lengthM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get buffer => $composableBuilder(
    column: $table.buffer,
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

  ColumnOrderings<bool> get isProposed => $composableBuilder(
    column: $table.isProposed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
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
  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get landUseId =>
      $composableBuilder(column: $table.landUseId, builder: (column) => column);

  GeneratedColumn<String> get geomType =>
      $composableBuilder(column: $table.geomType, builder: (column) => column);

  GeneratedColumn<int> get srid =>
      $composableBuilder(column: $table.srid, builder: (column) => column);

  GeneratedColumn<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaSqm =>
      $composableBuilder(column: $table.areaSqm, builder: (column) => column);

  GeneratedColumn<double> get lengthM =>
      $composableBuilder(column: $table.lengthM, builder: (column) => column);

  GeneratedColumn<double> get buffer =>
      $composableBuilder(column: $table.buffer, builder: (column) => column);

  GeneratedColumn<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<bool> get isProposed => $composableBuilder(
    column: $table.isProposed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

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
                Value<String> clientUuid = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<int?> landUseId = const Value.absent(),
                Value<String> geomType = const Value.absent(),
                Value<int> srid = const Value.absent(),
                Value<String> coordsJson = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                Value<double?> lengthM = const Value.absent(),
                Value<double> buffer = const Value.absent(),
                Value<String?> propertiesJson = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<bool> isProposed = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZoningFeaturesCompanion(
                clientUuid: clientUuid,
                serverId: serverId,
                projectId: projectId,
                localityId: localityId,
                landUseId: landUseId,
                geomType: geomType,
                srid: srid,
                coordsJson: coordsJson,
                areaSqm: areaSqm,
                lengthM: lengthM,
                buffer: buffer,
                propertiesJson: propertiesJson,
                isDraft: isDraft,
                isProposed: isProposed,
                status: status,
                source: source,
                version: version,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                metadataJson: metadataJson,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientUuid,
                Value<String?> serverId = const Value.absent(),
                required String projectId,
                required int localityId,
                Value<int?> landUseId = const Value.absent(),
                required String geomType,
                Value<int> srid = const Value.absent(),
                required String coordsJson,
                Value<double?> areaSqm = const Value.absent(),
                Value<double?> lengthM = const Value.absent(),
                Value<double> buffer = const Value.absent(),
                Value<String?> propertiesJson = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<bool> isProposed = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<String?> metadataJson = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZoningFeaturesCompanion.insert(
                clientUuid: clientUuid,
                serverId: serverId,
                projectId: projectId,
                localityId: localityId,
                landUseId: landUseId,
                geomType: geomType,
                srid: srid,
                coordsJson: coordsJson,
                areaSqm: areaSqm,
                lengthM: lengthM,
                buffer: buffer,
                propertiesJson: propertiesJson,
                isDraft: isDraft,
                isProposed: isProposed,
                status: status,
                source: source,
                version: version,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                metadataJson: metadataJson,
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
typedef $$ZoningFeatureHistoryTableCreateCompanionBuilder =
    ZoningFeatureHistoryCompanion Function({
      required String id,
      required String featureId,
      required String action,
      Value<String?> userId,
      Value<String?> oldDataJson,
      required String newDataJson,
      Value<String?> changesJson,
      required int timestamp,
      Value<int> rowid,
    });
typedef $$ZoningFeatureHistoryTableUpdateCompanionBuilder =
    ZoningFeatureHistoryCompanion Function({
      Value<String> id,
      Value<String> featureId,
      Value<String> action,
      Value<String?> userId,
      Value<String?> oldDataJson,
      Value<String> newDataJson,
      Value<String?> changesJson,
      Value<int> timestamp,
      Value<int> rowid,
    });

class $$ZoningFeatureHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ZoningFeatureHistoryTable> {
  $$ZoningFeatureHistoryTableFilterComposer({
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

  ColumnFilters<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldDataJson => $composableBuilder(
    column: $table.oldDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newDataJson => $composableBuilder(
    column: $table.newDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ZoningFeatureHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ZoningFeatureHistoryTable> {
  $$ZoningFeatureHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldDataJson => $composableBuilder(
    column: $table.oldDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newDataJson => $composableBuilder(
    column: $table.newDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZoningFeatureHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZoningFeatureHistoryTable> {
  $$ZoningFeatureHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get featureId =>
      $composableBuilder(column: $table.featureId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get oldDataJson => $composableBuilder(
    column: $table.oldDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newDataJson => $composableBuilder(
    column: $table.newDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changesJson => $composableBuilder(
    column: $table.changesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ZoningFeatureHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZoningFeatureHistoryTable,
          ZoningFeatureHistoryData,
          $$ZoningFeatureHistoryTableFilterComposer,
          $$ZoningFeatureHistoryTableOrderingComposer,
          $$ZoningFeatureHistoryTableAnnotationComposer,
          $$ZoningFeatureHistoryTableCreateCompanionBuilder,
          $$ZoningFeatureHistoryTableUpdateCompanionBuilder,
          (
            ZoningFeatureHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ZoningFeatureHistoryTable,
              ZoningFeatureHistoryData
            >,
          ),
          ZoningFeatureHistoryData,
          PrefetchHooks Function()
        > {
  $$ZoningFeatureHistoryTableTableManager(
    _$AppDatabase db,
    $ZoningFeatureHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ZoningFeatureHistoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ZoningFeatureHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ZoningFeatureHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> featureId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> oldDataJson = const Value.absent(),
                Value<String> newDataJson = const Value.absent(),
                Value<String?> changesJson = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZoningFeatureHistoryCompanion(
                id: id,
                featureId: featureId,
                action: action,
                userId: userId,
                oldDataJson: oldDataJson,
                newDataJson: newDataJson,
                changesJson: changesJson,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String featureId,
                required String action,
                Value<String?> userId = const Value.absent(),
                Value<String?> oldDataJson = const Value.absent(),
                required String newDataJson,
                Value<String?> changesJson = const Value.absent(),
                required int timestamp,
                Value<int> rowid = const Value.absent(),
              }) => ZoningFeatureHistoryCompanion.insert(
                id: id,
                featureId: featureId,
                action: action,
                userId: userId,
                oldDataJson: oldDataJson,
                newDataJson: newDataJson,
                changesJson: changesJson,
                timestamp: timestamp,
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

typedef $$ZoningFeatureHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZoningFeatureHistoryTable,
      ZoningFeatureHistoryData,
      $$ZoningFeatureHistoryTableFilterComposer,
      $$ZoningFeatureHistoryTableOrderingComposer,
      $$ZoningFeatureHistoryTableAnnotationComposer,
      $$ZoningFeatureHistoryTableCreateCompanionBuilder,
      $$ZoningFeatureHistoryTableUpdateCompanionBuilder,
      (
        ZoningFeatureHistoryData,
        BaseReferences<
          _$AppDatabase,
          $ZoningFeatureHistoryTable,
          ZoningFeatureHistoryData
        >,
      ),
      ZoningFeatureHistoryData,
      PrefetchHooks Function()
    >;
typedef $$FeatureUploadQueueTableCreateCompanionBuilder =
    FeatureUploadQueueCompanion Function({
      required String id,
      required String featureId,
      required String projectId,
      Value<int> retryCount,
      Value<int> maxRetries,
      Value<int?> nextRetryAt,
      Value<String?> lastError,
      Value<String> status,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$FeatureUploadQueueTableUpdateCompanionBuilder =
    FeatureUploadQueueCompanion Function({
      Value<String> id,
      Value<String> featureId,
      Value<String> projectId,
      Value<int> retryCount,
      Value<int> maxRetries,
      Value<int?> nextRetryAt,
      Value<String?> lastError,
      Value<String> status,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$FeatureUploadQueueTableFilterComposer
    extends Composer<_$AppDatabase, $FeatureUploadQueueTable> {
  $$FeatureUploadQueueTableFilterComposer({
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

  ColumnFilters<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeatureUploadQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $FeatureUploadQueueTable> {
  $$FeatureUploadQueueTableOrderingComposer({
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

  ColumnOrderings<String> get featureId => $composableBuilder(
    column: $table.featureId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeatureUploadQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeatureUploadQueueTable> {
  $$FeatureUploadQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get featureId =>
      $composableBuilder(column: $table.featureId, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxRetries => $composableBuilder(
    column: $table.maxRetries,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FeatureUploadQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeatureUploadQueueTable,
          FeatureUploadQueueData,
          $$FeatureUploadQueueTableFilterComposer,
          $$FeatureUploadQueueTableOrderingComposer,
          $$FeatureUploadQueueTableAnnotationComposer,
          $$FeatureUploadQueueTableCreateCompanionBuilder,
          $$FeatureUploadQueueTableUpdateCompanionBuilder,
          (
            FeatureUploadQueueData,
            BaseReferences<
              _$AppDatabase,
              $FeatureUploadQueueTable,
              FeatureUploadQueueData
            >,
          ),
          FeatureUploadQueueData,
          PrefetchHooks Function()
        > {
  $$FeatureUploadQueueTableTableManager(
    _$AppDatabase db,
    $FeatureUploadQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FeatureUploadQueueTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$FeatureUploadQueueTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$FeatureUploadQueueTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> featureId = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> maxRetries = const Value.absent(),
                Value<int?> nextRetryAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatureUploadQueueCompanion(
                id: id,
                featureId: featureId,
                projectId: projectId,
                retryCount: retryCount,
                maxRetries: maxRetries,
                nextRetryAt: nextRetryAt,
                lastError: lastError,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String featureId,
                required String projectId,
                Value<int> retryCount = const Value.absent(),
                Value<int> maxRetries = const Value.absent(),
                Value<int?> nextRetryAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FeatureUploadQueueCompanion.insert(
                id: id,
                featureId: featureId,
                projectId: projectId,
                retryCount: retryCount,
                maxRetries: maxRetries,
                nextRetryAt: nextRetryAt,
                lastError: lastError,
                status: status,
                createdAt: createdAt,
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

typedef $$FeatureUploadQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeatureUploadQueueTable,
      FeatureUploadQueueData,
      $$FeatureUploadQueueTableFilterComposer,
      $$FeatureUploadQueueTableOrderingComposer,
      $$FeatureUploadQueueTableAnnotationComposer,
      $$FeatureUploadQueueTableCreateCompanionBuilder,
      $$FeatureUploadQueueTableUpdateCompanionBuilder,
      (
        FeatureUploadQueueData,
        BaseReferences<
          _$AppDatabase,
          $FeatureUploadQueueTable,
          FeatureUploadQueueData
        >,
      ),
      FeatureUploadQueueData,
      PrefetchHooks Function()
    >;
typedef $$ManualZoneDraftsTableCreateCompanionBuilder =
    ManualZoneDraftsCompanion Function({
      required String id,
      required String projectId,
      required String zoneName,
      Value<String?> description,
      required int srid,
      required String featureType,
      required String pointsJson,
      Value<int> pointCount,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ManualZoneDraftsTableUpdateCompanionBuilder =
    ManualZoneDraftsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> zoneName,
      Value<String?> description,
      Value<int> srid,
      Value<String> featureType,
      Value<String> pointsJson,
      Value<int> pointCount,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ManualZoneDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $ManualZoneDraftsTable> {
  $$ManualZoneDraftsTableFilterComposer({
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

  ColumnFilters<String> get zoneName => $composableBuilder(
    column: $table.zoneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get srid => $composableBuilder(
    column: $table.srid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureType => $composableBuilder(
    column: $table.featureType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ManualZoneDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ManualZoneDraftsTable> {
  $$ManualZoneDraftsTableOrderingComposer({
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

  ColumnOrderings<String> get zoneName => $composableBuilder(
    column: $table.zoneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get srid => $composableBuilder(
    column: $table.srid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureType => $composableBuilder(
    column: $table.featureType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ManualZoneDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManualZoneDraftsTable> {
  $$ManualZoneDraftsTableAnnotationComposer({
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

  GeneratedColumn<String> get zoneName =>
      $composableBuilder(column: $table.zoneName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get srid =>
      $composableBuilder(column: $table.srid, builder: (column) => column);

  GeneratedColumn<String> get featureType => $composableBuilder(
    column: $table.featureType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ManualZoneDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManualZoneDraftsTable,
          ManualZoneDraft,
          $$ManualZoneDraftsTableFilterComposer,
          $$ManualZoneDraftsTableOrderingComposer,
          $$ManualZoneDraftsTableAnnotationComposer,
          $$ManualZoneDraftsTableCreateCompanionBuilder,
          $$ManualZoneDraftsTableUpdateCompanionBuilder,
          (
            ManualZoneDraft,
            BaseReferences<
              _$AppDatabase,
              $ManualZoneDraftsTable,
              ManualZoneDraft
            >,
          ),
          ManualZoneDraft,
          PrefetchHooks Function()
        > {
  $$ManualZoneDraftsTableTableManager(
    _$AppDatabase db,
    $ManualZoneDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$ManualZoneDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ManualZoneDraftsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ManualZoneDraftsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> zoneName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> srid = const Value.absent(),
                Value<String> featureType = const Value.absent(),
                Value<String> pointsJson = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManualZoneDraftsCompanion(
                id: id,
                projectId: projectId,
                zoneName: zoneName,
                description: description,
                srid: srid,
                featureType: featureType,
                pointsJson: pointsJson,
                pointCount: pointCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String zoneName,
                Value<String?> description = const Value.absent(),
                required int srid,
                required String featureType,
                required String pointsJson,
                Value<int> pointCount = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ManualZoneDraftsCompanion.insert(
                id: id,
                projectId: projectId,
                zoneName: zoneName,
                description: description,
                srid: srid,
                featureType: featureType,
                pointsJson: pointsJson,
                pointCount: pointCount,
                createdAt: createdAt,
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

typedef $$ManualZoneDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManualZoneDraftsTable,
      ManualZoneDraft,
      $$ManualZoneDraftsTableFilterComposer,
      $$ManualZoneDraftsTableOrderingComposer,
      $$ManualZoneDraftsTableAnnotationComposer,
      $$ManualZoneDraftsTableCreateCompanionBuilder,
      $$ManualZoneDraftsTableUpdateCompanionBuilder,
      (
        ManualZoneDraft,
        BaseReferences<_$AppDatabase, $ManualZoneDraftsTable, ManualZoneDraft>,
      ),
      ManualZoneDraft,
      PrefetchHooks Function()
    >;
typedef $$LandUsesTableCreateCompanionBuilder =
    LandUsesCompanion Function({
      Value<int> id,
      required String name,
      required String description,
      required String color,
      Value<String?> styleJson,
      required int updatedAt,
    });
typedef $$LandUsesTableUpdateCompanionBuilder =
    LandUsesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<String> color,
      Value<String?> styleJson,
      Value<int> updatedAt,
    });

class $$LandUsesTableFilterComposer
    extends Composer<_$AppDatabase, $LandUsesTable> {
  $$LandUsesTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get styleJson => $composableBuilder(
    column: $table.styleJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LandUsesTableOrderingComposer
    extends Composer<_$AppDatabase, $LandUsesTable> {
  $$LandUsesTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get styleJson => $composableBuilder(
    column: $table.styleJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LandUsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LandUsesTable> {
  $$LandUsesTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get styleJson =>
      $composableBuilder(column: $table.styleJson, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LandUsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LandUsesTable,
          LandUse,
          $$LandUsesTableFilterComposer,
          $$LandUsesTableOrderingComposer,
          $$LandUsesTableAnnotationComposer,
          $$LandUsesTableCreateCompanionBuilder,
          $$LandUsesTableUpdateCompanionBuilder,
          (LandUse, BaseReferences<_$AppDatabase, $LandUsesTable, LandUse>),
          LandUse,
          PrefetchHooks Function()
        > {
  $$LandUsesTableTableManager(_$AppDatabase db, $LandUsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LandUsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LandUsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LandUsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> styleJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => LandUsesCompanion(
                id: id,
                name: name,
                description: description,
                color: color,
                styleJson: styleJson,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String description,
                required String color,
                Value<String?> styleJson = const Value.absent(),
                required int updatedAt,
              }) => LandUsesCompanion.insert(
                id: id,
                name: name,
                description: description,
                color: color,
                styleJson: styleJson,
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

typedef $$LandUsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LandUsesTable,
      LandUse,
      $$LandUsesTableFilterComposer,
      $$LandUsesTableOrderingComposer,
      $$LandUsesTableAnnotationComposer,
      $$LandUsesTableCreateCompanionBuilder,
      $$LandUsesTableUpdateCompanionBuilder,
      (LandUse, BaseReferences<_$AppDatabase, $LandUsesTable, LandUse>),
      LandUse,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
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

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$SubdivisionZonesTableCreateCompanionBuilder =
    SubdivisionZonesCompanion Function({
      Value<int> id,
      required String zoneName,
      required int localityId,
      required String localityName,
      Value<String?> landUseName,
      Value<bool> canBeSubdivided,
      Value<double?> areaSqm,
      Value<String?> geomJson,
      required int downloadedAt,
      required int updatedAt,
    });
typedef $$SubdivisionZonesTableUpdateCompanionBuilder =
    SubdivisionZonesCompanion Function({
      Value<int> id,
      Value<String> zoneName,
      Value<int> localityId,
      Value<String> localityName,
      Value<String?> landUseName,
      Value<bool> canBeSubdivided,
      Value<double?> areaSqm,
      Value<String?> geomJson,
      Value<int> downloadedAt,
      Value<int> updatedAt,
    });

class $$SubdivisionZonesTableFilterComposer
    extends Composer<_$AppDatabase, $SubdivisionZonesTable> {
  $$SubdivisionZonesTableFilterComposer({
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

  ColumnFilters<String> get zoneName => $composableBuilder(
    column: $table.zoneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localityName => $composableBuilder(
    column: $table.localityName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get landUseName => $composableBuilder(
    column: $table.landUseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canBeSubdivided => $composableBuilder(
    column: $table.canBeSubdivided,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geomJson => $composableBuilder(
    column: $table.geomJson,
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

class $$SubdivisionZonesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubdivisionZonesTable> {
  $$SubdivisionZonesTableOrderingComposer({
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

  ColumnOrderings<String> get zoneName => $composableBuilder(
    column: $table.zoneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localityName => $composableBuilder(
    column: $table.localityName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get landUseName => $composableBuilder(
    column: $table.landUseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canBeSubdivided => $composableBuilder(
    column: $table.canBeSubdivided,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geomJson => $composableBuilder(
    column: $table.geomJson,
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

class $$SubdivisionZonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubdivisionZonesTable> {
  $$SubdivisionZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get zoneName =>
      $composableBuilder(column: $table.zoneName, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localityName => $composableBuilder(
    column: $table.localityName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get landUseName => $composableBuilder(
    column: $table.landUseName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get canBeSubdivided => $composableBuilder(
    column: $table.canBeSubdivided,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaSqm =>
      $composableBuilder(column: $table.areaSqm, builder: (column) => column);

  GeneratedColumn<String> get geomJson =>
      $composableBuilder(column: $table.geomJson, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubdivisionZonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubdivisionZonesTable,
          SubdivisionZone,
          $$SubdivisionZonesTableFilterComposer,
          $$SubdivisionZonesTableOrderingComposer,
          $$SubdivisionZonesTableAnnotationComposer,
          $$SubdivisionZonesTableCreateCompanionBuilder,
          $$SubdivisionZonesTableUpdateCompanionBuilder,
          (
            SubdivisionZone,
            BaseReferences<
              _$AppDatabase,
              $SubdivisionZonesTable,
              SubdivisionZone
            >,
          ),
          SubdivisionZone,
          PrefetchHooks Function()
        > {
  $$SubdivisionZonesTableTableManager(
    _$AppDatabase db,
    $SubdivisionZonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SubdivisionZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SubdivisionZonesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SubdivisionZonesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> zoneName = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<String> localityName = const Value.absent(),
                Value<String?> landUseName = const Value.absent(),
                Value<bool> canBeSubdivided = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                Value<String?> geomJson = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => SubdivisionZonesCompanion(
                id: id,
                zoneName: zoneName,
                localityId: localityId,
                localityName: localityName,
                landUseName: landUseName,
                canBeSubdivided: canBeSubdivided,
                areaSqm: areaSqm,
                geomJson: geomJson,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String zoneName,
                required int localityId,
                required String localityName,
                Value<String?> landUseName = const Value.absent(),
                Value<bool> canBeSubdivided = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                Value<String?> geomJson = const Value.absent(),
                required int downloadedAt,
                required int updatedAt,
              }) => SubdivisionZonesCompanion.insert(
                id: id,
                zoneName: zoneName,
                localityId: localityId,
                localityName: localityName,
                landUseName: landUseName,
                canBeSubdivided: canBeSubdivided,
                areaSqm: areaSqm,
                geomJson: geomJson,
                downloadedAt: downloadedAt,
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

typedef $$SubdivisionZonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubdivisionZonesTable,
      SubdivisionZone,
      $$SubdivisionZonesTableFilterComposer,
      $$SubdivisionZonesTableOrderingComposer,
      $$SubdivisionZonesTableAnnotationComposer,
      $$SubdivisionZonesTableCreateCompanionBuilder,
      $$SubdivisionZonesTableUpdateCompanionBuilder,
      (
        SubdivisionZone,
        BaseReferences<_$AppDatabase, $SubdivisionZonesTable, SubdivisionZone>,
      ),
      SubdivisionZone,
      PrefetchHooks Function()
    >;
typedef $$SubdivisionApplicationsTableCreateCompanionBuilder =
    SubdivisionApplicationsCompanion Function({
      required String clientId,
      Value<int?> serverId,
      Value<String?> applicationNumber,
      required int zoneId,
      required int localityId,
      required String applicantId,
      Value<int> currentStep,
      Value<String> status,
      Value<String?> notes,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$SubdivisionApplicationsTableUpdateCompanionBuilder =
    SubdivisionApplicationsCompanion Function({
      Value<String> clientId,
      Value<int?> serverId,
      Value<String?> applicationNumber,
      Value<int> zoneId,
      Value<int> localityId,
      Value<String> applicantId,
      Value<int> currentStep,
      Value<String> status,
      Value<String?> notes,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$SubdivisionApplicationsTableFilterComposer
    extends Composer<_$AppDatabase, $SubdivisionApplicationsTable> {
  $$SubdivisionApplicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicationNumber => $composableBuilder(
    column: $table.applicationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicantId => $composableBuilder(
    column: $table.applicantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubdivisionApplicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubdivisionApplicationsTable> {
  $$SubdivisionApplicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicationNumber => $composableBuilder(
    column: $table.applicationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicantId => $composableBuilder(
    column: $table.applicantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubdivisionApplicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubdivisionApplicationsTable> {
  $$SubdivisionApplicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get applicationNumber => $composableBuilder(
    column: $table.applicationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get applicantId => $composableBuilder(
    column: $table.applicantId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStep => $composableBuilder(
    column: $table.currentStep,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubdivisionApplicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubdivisionApplicationsTable,
          SubdivisionApplication,
          $$SubdivisionApplicationsTableFilterComposer,
          $$SubdivisionApplicationsTableOrderingComposer,
          $$SubdivisionApplicationsTableAnnotationComposer,
          $$SubdivisionApplicationsTableCreateCompanionBuilder,
          $$SubdivisionApplicationsTableUpdateCompanionBuilder,
          (
            SubdivisionApplication,
            BaseReferences<
              _$AppDatabase,
              $SubdivisionApplicationsTable,
              SubdivisionApplication
            >,
          ),
          SubdivisionApplication,
          PrefetchHooks Function()
        > {
  $$SubdivisionApplicationsTableTableManager(
    _$AppDatabase db,
    $SubdivisionApplicationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SubdivisionApplicationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SubdivisionApplicationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SubdivisionApplicationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String?> applicationNumber = const Value.absent(),
                Value<int> zoneId = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<String> applicantId = const Value.absent(),
                Value<int> currentStep = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubdivisionApplicationsCompanion(
                clientId: clientId,
                serverId: serverId,
                applicationNumber: applicationNumber,
                zoneId: zoneId,
                localityId: localityId,
                applicantId: applicantId,
                currentStep: currentStep,
                status: status,
                notes: notes,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<int?> serverId = const Value.absent(),
                Value<String?> applicationNumber = const Value.absent(),
                required int zoneId,
                required int localityId,
                required String applicantId,
                Value<int> currentStep = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubdivisionApplicationsCompanion.insert(
                clientId: clientId,
                serverId: serverId,
                applicationNumber: applicationNumber,
                zoneId: zoneId,
                localityId: localityId,
                applicantId: applicantId,
                currentStep: currentStep,
                status: status,
                notes: notes,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
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

typedef $$SubdivisionApplicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubdivisionApplicationsTable,
      SubdivisionApplication,
      $$SubdivisionApplicationsTableFilterComposer,
      $$SubdivisionApplicationsTableOrderingComposer,
      $$SubdivisionApplicationsTableAnnotationComposer,
      $$SubdivisionApplicationsTableCreateCompanionBuilder,
      $$SubdivisionApplicationsTableUpdateCompanionBuilder,
      (
        SubdivisionApplication,
        BaseReferences<
          _$AppDatabase,
          $SubdivisionApplicationsTable,
          SubdivisionApplication
        >,
      ),
      SubdivisionApplication,
      PrefetchHooks Function()
    >;
typedef $$PartiesTableCreateCompanionBuilder =
    PartiesCompanion Function({
      required String clientId,
      Value<int?> serverId,
      required String partyType,
      Value<String?> firstName,
      Value<String?> middleName,
      Value<String?> lastName,
      Value<String?> nidaNumber,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> gender,
      Value<String?> dateOfBirth,
      Value<bool> isCitizen,
      Value<String?> maritalStatus,
      Value<String?> occupation,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$PartiesTableUpdateCompanionBuilder =
    PartiesCompanion Function({
      Value<String> clientId,
      Value<int?> serverId,
      Value<String> partyType,
      Value<String?> firstName,
      Value<String?> middleName,
      Value<String?> lastName,
      Value<String?> nidaNumber,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> gender,
      Value<String?> dateOfBirth,
      Value<bool> isCitizen,
      Value<String?> maritalStatus,
      Value<String?> occupation,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyType => $composableBuilder(
    column: $table.partyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nidaNumber => $composableBuilder(
    column: $table.nidaNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCitizen => $composableBuilder(
    column: $table.isCitizen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyType => $composableBuilder(
    column: $table.partyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nidaNumber => $composableBuilder(
    column: $table.nidaNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCitizen => $composableBuilder(
    column: $table.isCitizen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get partyType =>
      $composableBuilder(column: $table.partyType, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get nidaNumber => $composableBuilder(
    column: $table.nidaNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCitizen =>
      $composableBuilder(column: $table.isCitizen, builder: (column) => column);

  GeneratedColumn<String> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartiesTable,
          Party,
          $$PartiesTableFilterComposer,
          $$PartiesTableOrderingComposer,
          $$PartiesTableAnnotationComposer,
          $$PartiesTableCreateCompanionBuilder,
          $$PartiesTableUpdateCompanionBuilder,
          (Party, BaseReferences<_$AppDatabase, $PartiesTable, Party>),
          Party,
          PrefetchHooks Function()
        > {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String> partyType = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> nidaNumber = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<bool> isCitizen = const Value.absent(),
                Value<String?> maritalStatus = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartiesCompanion(
                clientId: clientId,
                serverId: serverId,
                partyType: partyType,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                nidaNumber: nidaNumber,
                phone: phone,
                email: email,
                gender: gender,
                dateOfBirth: dateOfBirth,
                isCitizen: isCitizen,
                maritalStatus: maritalStatus,
                occupation: occupation,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<int?> serverId = const Value.absent(),
                required String partyType,
                Value<String?> firstName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> nidaNumber = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<bool> isCitizen = const Value.absent(),
                Value<String?> maritalStatus = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PartiesCompanion.insert(
                clientId: clientId,
                serverId: serverId,
                partyType: partyType,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                nidaNumber: nidaNumber,
                phone: phone,
                email: email,
                gender: gender,
                dateOfBirth: dateOfBirth,
                isCitizen: isCitizen,
                maritalStatus: maritalStatus,
                occupation: occupation,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
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

typedef $$PartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartiesTable,
      Party,
      $$PartiesTableFilterComposer,
      $$PartiesTableOrderingComposer,
      $$PartiesTableAnnotationComposer,
      $$PartiesTableCreateCompanionBuilder,
      $$PartiesTableUpdateCompanionBuilder,
      (Party, BaseReferences<_$AppDatabase, $PartiesTable, Party>),
      Party,
      PrefetchHooks Function()
    >;
typedef $$ParcelsTableCreateCompanionBuilder =
    ParcelsCompanion Function({
      required String clientId,
      Value<int?> serverId,
      Value<String?> parcelNumber,
      required String applicationId,
      required int zoneId,
      required int localityId,
      Value<int?> hamletId,
      required String geomJson,
      Value<String?> geometryType,
      Value<double?> areaSqm,
      Value<String?> north,
      Value<String?> south,
      Value<String?> east,
      Value<String?> west,
      Value<int?> occupancyType,
      Value<String> stage,
      Value<bool> hasConflicts,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ParcelsTableUpdateCompanionBuilder =
    ParcelsCompanion Function({
      Value<String> clientId,
      Value<int?> serverId,
      Value<String?> parcelNumber,
      Value<String> applicationId,
      Value<int> zoneId,
      Value<int> localityId,
      Value<int?> hamletId,
      Value<String> geomJson,
      Value<String?> geometryType,
      Value<double?> areaSqm,
      Value<String?> north,
      Value<String?> south,
      Value<String?> east,
      Value<String?> west,
      Value<int?> occupancyType,
      Value<String> stage,
      Value<bool> hasConflicts,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ParcelsTableFilterComposer
    extends Composer<_$AppDatabase, $ParcelsTable> {
  $$ParcelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelNumber => $composableBuilder(
    column: $table.parcelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicationId => $composableBuilder(
    column: $table.applicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hamletId => $composableBuilder(
    column: $table.hamletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geomJson => $composableBuilder(
    column: $table.geomJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geometryType => $composableBuilder(
    column: $table.geometryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get north => $composableBuilder(
    column: $table.north,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get south => $composableBuilder(
    column: $table.south,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get east => $composableBuilder(
    column: $table.east,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get west => $composableBuilder(
    column: $table.west,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occupancyType => $composableBuilder(
    column: $table.occupancyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasConflicts => $composableBuilder(
    column: $table.hasConflicts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParcelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParcelsTable> {
  $$ParcelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelNumber => $composableBuilder(
    column: $table.parcelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicationId => $composableBuilder(
    column: $table.applicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hamletId => $composableBuilder(
    column: $table.hamletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geomJson => $composableBuilder(
    column: $table.geomJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geometryType => $composableBuilder(
    column: $table.geometryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get north => $composableBuilder(
    column: $table.north,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get south => $composableBuilder(
    column: $table.south,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get east => $composableBuilder(
    column: $table.east,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get west => $composableBuilder(
    column: $table.west,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occupancyType => $composableBuilder(
    column: $table.occupancyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasConflicts => $composableBuilder(
    column: $table.hasConflicts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParcelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParcelsTable> {
  $$ParcelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get parcelNumber => $composableBuilder(
    column: $table.parcelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get applicationId => $composableBuilder(
    column: $table.applicationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hamletId =>
      $composableBuilder(column: $table.hamletId, builder: (column) => column);

  GeneratedColumn<String> get geomJson =>
      $composableBuilder(column: $table.geomJson, builder: (column) => column);

  GeneratedColumn<String> get geometryType => $composableBuilder(
    column: $table.geometryType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaSqm =>
      $composableBuilder(column: $table.areaSqm, builder: (column) => column);

  GeneratedColumn<String> get north =>
      $composableBuilder(column: $table.north, builder: (column) => column);

  GeneratedColumn<String> get south =>
      $composableBuilder(column: $table.south, builder: (column) => column);

  GeneratedColumn<String> get east =>
      $composableBuilder(column: $table.east, builder: (column) => column);

  GeneratedColumn<String> get west =>
      $composableBuilder(column: $table.west, builder: (column) => column);

  GeneratedColumn<int> get occupancyType => $composableBuilder(
    column: $table.occupancyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<bool> get hasConflicts => $composableBuilder(
    column: $table.hasConflicts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ParcelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParcelsTable,
          Parcel,
          $$ParcelsTableFilterComposer,
          $$ParcelsTableOrderingComposer,
          $$ParcelsTableAnnotationComposer,
          $$ParcelsTableCreateCompanionBuilder,
          $$ParcelsTableUpdateCompanionBuilder,
          (Parcel, BaseReferences<_$AppDatabase, $ParcelsTable, Parcel>),
          Parcel,
          PrefetchHooks Function()
        > {
  $$ParcelsTableTableManager(_$AppDatabase db, $ParcelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ParcelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ParcelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ParcelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String?> parcelNumber = const Value.absent(),
                Value<String> applicationId = const Value.absent(),
                Value<int> zoneId = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<int?> hamletId = const Value.absent(),
                Value<String> geomJson = const Value.absent(),
                Value<String?> geometryType = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                Value<String?> north = const Value.absent(),
                Value<String?> south = const Value.absent(),
                Value<String?> east = const Value.absent(),
                Value<String?> west = const Value.absent(),
                Value<int?> occupancyType = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<bool> hasConflicts = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParcelsCompanion(
                clientId: clientId,
                serverId: serverId,
                parcelNumber: parcelNumber,
                applicationId: applicationId,
                zoneId: zoneId,
                localityId: localityId,
                hamletId: hamletId,
                geomJson: geomJson,
                geometryType: geometryType,
                areaSqm: areaSqm,
                north: north,
                south: south,
                east: east,
                west: west,
                occupancyType: occupancyType,
                stage: stage,
                hasConflicts: hasConflicts,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<int?> serverId = const Value.absent(),
                Value<String?> parcelNumber = const Value.absent(),
                required String applicationId,
                required int zoneId,
                required int localityId,
                Value<int?> hamletId = const Value.absent(),
                required String geomJson,
                Value<String?> geometryType = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                Value<String?> north = const Value.absent(),
                Value<String?> south = const Value.absent(),
                Value<String?> east = const Value.absent(),
                Value<String?> west = const Value.absent(),
                Value<int?> occupancyType = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<bool> hasConflicts = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ParcelsCompanion.insert(
                clientId: clientId,
                serverId: serverId,
                parcelNumber: parcelNumber,
                applicationId: applicationId,
                zoneId: zoneId,
                localityId: localityId,
                hamletId: hamletId,
                geomJson: geomJson,
                geometryType: geometryType,
                areaSqm: areaSqm,
                north: north,
                south: south,
                east: east,
                west: west,
                occupancyType: occupancyType,
                stage: stage,
                hasConflicts: hasConflicts,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
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

typedef $$ParcelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParcelsTable,
      Parcel,
      $$ParcelsTableFilterComposer,
      $$ParcelsTableOrderingComposer,
      $$ParcelsTableAnnotationComposer,
      $$ParcelsTableCreateCompanionBuilder,
      $$ParcelsTableUpdateCompanionBuilder,
      (Parcel, BaseReferences<_$AppDatabase, $ParcelsTable, Parcel>),
      Parcel,
      PrefetchHooks Function()
    >;
typedef $$ParcelDraftsTableCreateCompanionBuilder =
    ParcelDraftsCompanion Function({
      required String clientId,
      required String applicationId,
      required int zoneId,
      required int localityId,
      required String coordsJson,
      Value<String> inputMethod,
      Value<double?> areaSqm,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ParcelDraftsTableUpdateCompanionBuilder =
    ParcelDraftsCompanion Function({
      Value<String> clientId,
      Value<String> applicationId,
      Value<int> zoneId,
      Value<int> localityId,
      Value<String> coordsJson,
      Value<String> inputMethod,
      Value<double?> areaSqm,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ParcelDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $ParcelDraftsTable> {
  $$ParcelDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicationId => $composableBuilder(
    column: $table.applicationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputMethod => $composableBuilder(
    column: $table.inputMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParcelDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParcelDraftsTable> {
  $$ParcelDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicationId => $composableBuilder(
    column: $table.applicationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zoneId => $composableBuilder(
    column: $table.zoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputMethod => $composableBuilder(
    column: $table.inputMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaSqm => $composableBuilder(
    column: $table.areaSqm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParcelDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParcelDraftsTable> {
  $$ParcelDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get applicationId => $composableBuilder(
    column: $table.applicationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get zoneId =>
      $composableBuilder(column: $table.zoneId, builder: (column) => column);

  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coordsJson => $composableBuilder(
    column: $table.coordsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inputMethod => $composableBuilder(
    column: $table.inputMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaSqm =>
      $composableBuilder(column: $table.areaSqm, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ParcelDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParcelDraftsTable,
          ParcelDraftData,
          $$ParcelDraftsTableFilterComposer,
          $$ParcelDraftsTableOrderingComposer,
          $$ParcelDraftsTableAnnotationComposer,
          $$ParcelDraftsTableCreateCompanionBuilder,
          $$ParcelDraftsTableUpdateCompanionBuilder,
          (
            ParcelDraftData,
            BaseReferences<_$AppDatabase, $ParcelDraftsTable, ParcelDraftData>,
          ),
          ParcelDraftData,
          PrefetchHooks Function()
        > {
  $$ParcelDraftsTableTableManager(_$AppDatabase db, $ParcelDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ParcelDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ParcelDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ParcelDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<String> applicationId = const Value.absent(),
                Value<int> zoneId = const Value.absent(),
                Value<int> localityId = const Value.absent(),
                Value<String> coordsJson = const Value.absent(),
                Value<String> inputMethod = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParcelDraftsCompanion(
                clientId: clientId,
                applicationId: applicationId,
                zoneId: zoneId,
                localityId: localityId,
                coordsJson: coordsJson,
                inputMethod: inputMethod,
                areaSqm: areaSqm,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                required String applicationId,
                required int zoneId,
                required int localityId,
                required String coordsJson,
                Value<String> inputMethod = const Value.absent(),
                Value<double?> areaSqm = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ParcelDraftsCompanion.insert(
                clientId: clientId,
                applicationId: applicationId,
                zoneId: zoneId,
                localityId: localityId,
                coordsJson: coordsJson,
                inputMethod: inputMethod,
                areaSqm: areaSqm,
                createdAt: createdAt,
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

typedef $$ParcelDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParcelDraftsTable,
      ParcelDraftData,
      $$ParcelDraftsTableFilterComposer,
      $$ParcelDraftsTableOrderingComposer,
      $$ParcelDraftsTableAnnotationComposer,
      $$ParcelDraftsTableCreateCompanionBuilder,
      $$ParcelDraftsTableUpdateCompanionBuilder,
      (
        ParcelDraftData,
        BaseReferences<_$AppDatabase, $ParcelDraftsTable, ParcelDraftData>,
      ),
      ParcelDraftData,
      PrefetchHooks Function()
    >;
typedef $$AllocationsTableCreateCompanionBuilder =
    AllocationsCompanion Function({
      required String clientId,
      Value<int?> serverId,
      required String parcelId,
      Value<String?> partyId,
      Value<String?> partyName,
      Value<String?> phoneNumber,
      Value<String?> nidaNumber,
      required double proposedShare,
      Value<String> proposedRightType,
      Value<String> status,
      Value<String?> notes,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AllocationsTableUpdateCompanionBuilder =
    AllocationsCompanion Function({
      Value<String> clientId,
      Value<int?> serverId,
      Value<String> parcelId,
      Value<String?> partyId,
      Value<String?> partyName,
      Value<String?> phoneNumber,
      Value<String?> nidaNumber,
      Value<double> proposedShare,
      Value<String> proposedRightType,
      Value<String> status,
      Value<String?> notes,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyId => $composableBuilder(
    column: $table.partyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nidaNumber => $composableBuilder(
    column: $table.nidaNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proposedShare => $composableBuilder(
    column: $table.proposedShare,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposedRightType => $composableBuilder(
    column: $table.proposedRightType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyId => $composableBuilder(
    column: $table.partyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nidaNumber => $composableBuilder(
    column: $table.nidaNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proposedShare => $composableBuilder(
    column: $table.proposedShare,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposedRightType => $composableBuilder(
    column: $table.proposedRightType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get parcelId =>
      $composableBuilder(column: $table.parcelId, builder: (column) => column);

  GeneratedColumn<String> get partyId =>
      $composableBuilder(column: $table.partyId, builder: (column) => column);

  GeneratedColumn<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nidaNumber => $composableBuilder(
    column: $table.nidaNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proposedShare => $composableBuilder(
    column: $table.proposedShare,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proposedRightType => $composableBuilder(
    column: $table.proposedRightType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllocationsTable,
          Allocation,
          $$AllocationsTableFilterComposer,
          $$AllocationsTableOrderingComposer,
          $$AllocationsTableAnnotationComposer,
          $$AllocationsTableCreateCompanionBuilder,
          $$AllocationsTableUpdateCompanionBuilder,
          (
            Allocation,
            BaseReferences<_$AppDatabase, $AllocationsTable, Allocation>,
          ),
          Allocation,
          PrefetchHooks Function()
        > {
  $$AllocationsTableTableManager(_$AppDatabase db, $AllocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String> parcelId = const Value.absent(),
                Value<String?> partyId = const Value.absent(),
                Value<String?> partyName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> nidaNumber = const Value.absent(),
                Value<double> proposedShare = const Value.absent(),
                Value<String> proposedRightType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllocationsCompanion(
                clientId: clientId,
                serverId: serverId,
                parcelId: parcelId,
                partyId: partyId,
                partyName: partyName,
                phoneNumber: phoneNumber,
                nidaNumber: nidaNumber,
                proposedShare: proposedShare,
                proposedRightType: proposedRightType,
                status: status,
                notes: notes,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<int?> serverId = const Value.absent(),
                required String parcelId,
                Value<String?> partyId = const Value.absent(),
                Value<String?> partyName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> nidaNumber = const Value.absent(),
                required double proposedShare,
                Value<String> proposedRightType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AllocationsCompanion.insert(
                clientId: clientId,
                serverId: serverId,
                parcelId: parcelId,
                partyId: partyId,
                partyName: partyName,
                phoneNumber: phoneNumber,
                nidaNumber: nidaNumber,
                proposedShare: proposedShare,
                proposedRightType: proposedRightType,
                status: status,
                notes: notes,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
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

typedef $$AllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllocationsTable,
      Allocation,
      $$AllocationsTableFilterComposer,
      $$AllocationsTableOrderingComposer,
      $$AllocationsTableAnnotationComposer,
      $$AllocationsTableCreateCompanionBuilder,
      $$AllocationsTableUpdateCompanionBuilder,
      (
        Allocation,
        BaseReferences<_$AppDatabase, $AllocationsTable, Allocation>,
      ),
      Allocation,
      PrefetchHooks Function()
    >;
typedef $$ParcelPhotosTableCreateCompanionBuilder =
    ParcelPhotosCompanion Function({
      required String clientId,
      Value<int?> serverId,
      required String parcelId,
      required String photoPath,
      Value<String?> photoUrl,
      Value<String> photoType,
      Value<String?> caption,
      required int capturedAt,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ParcelPhotosTableUpdateCompanionBuilder =
    ParcelPhotosCompanion Function({
      Value<String> clientId,
      Value<int?> serverId,
      Value<String> parcelId,
      Value<String> photoPath,
      Value<String?> photoUrl,
      Value<String> photoType,
      Value<String?> caption,
      Value<int> capturedAt,
      Value<bool> uploaded,
      Value<int?> uploadedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ParcelPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $ParcelPhotosTable> {
  $$ParcelPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoType => $composableBuilder(
    column: $table.photoType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParcelPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $ParcelPhotosTable> {
  $$ParcelPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoType => $composableBuilder(
    column: $table.photoType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParcelPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParcelPhotosTable> {
  $$ParcelPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get parcelId =>
      $composableBuilder(column: $table.parcelId, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get photoType =>
      $composableBuilder(column: $table.photoType, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<int> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<int> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ParcelPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParcelPhotosTable,
          ParcelPhoto,
          $$ParcelPhotosTableFilterComposer,
          $$ParcelPhotosTableOrderingComposer,
          $$ParcelPhotosTableAnnotationComposer,
          $$ParcelPhotosTableCreateCompanionBuilder,
          $$ParcelPhotosTableUpdateCompanionBuilder,
          (
            ParcelPhoto,
            BaseReferences<_$AppDatabase, $ParcelPhotosTable, ParcelPhoto>,
          ),
          ParcelPhoto,
          PrefetchHooks Function()
        > {
  $$ParcelPhotosTableTableManager(_$AppDatabase db, $ParcelPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ParcelPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ParcelPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ParcelPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String> parcelId = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> photoType = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> capturedAt = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParcelPhotosCompanion(
                clientId: clientId,
                serverId: serverId,
                parcelId: parcelId,
                photoPath: photoPath,
                photoUrl: photoUrl,
                photoType: photoType,
                caption: caption,
                capturedAt: capturedAt,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<int?> serverId = const Value.absent(),
                required String parcelId,
                required String photoPath,
                Value<String?> photoUrl = const Value.absent(),
                Value<String> photoType = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                required int capturedAt,
                Value<bool> uploaded = const Value.absent(),
                Value<int?> uploadedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ParcelPhotosCompanion.insert(
                clientId: clientId,
                serverId: serverId,
                parcelId: parcelId,
                photoPath: photoPath,
                photoUrl: photoUrl,
                photoType: photoType,
                caption: caption,
                capturedAt: capturedAt,
                uploaded: uploaded,
                uploadedAt: uploadedAt,
                createdAt: createdAt,
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

typedef $$ParcelPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParcelPhotosTable,
      ParcelPhoto,
      $$ParcelPhotosTableFilterComposer,
      $$ParcelPhotosTableOrderingComposer,
      $$ParcelPhotosTableAnnotationComposer,
      $$ParcelPhotosTableCreateCompanionBuilder,
      $$ParcelPhotosTableUpdateCompanionBuilder,
      (
        ParcelPhoto,
        BaseReferences<_$AppDatabase, $ParcelPhotosTable, ParcelPhoto>,
      ),
      ParcelPhoto,
      PrefetchHooks Function()
    >;
typedef $$MvtTilesetsTableCreateCompanionBuilder =
    MvtTilesetsCompanion Function({
      Value<int> localityId,
      required String mbtilesPath,
      required int minZoom,
      required int maxZoom,
      required String boundsJson,
      Value<bool> isProposed,
      Value<int> tileCount,
      required int downloadedAt,
      required int updatedAt,
    });
typedef $$MvtTilesetsTableUpdateCompanionBuilder =
    MvtTilesetsCompanion Function({
      Value<int> localityId,
      Value<String> mbtilesPath,
      Value<int> minZoom,
      Value<int> maxZoom,
      Value<String> boundsJson,
      Value<bool> isProposed,
      Value<int> tileCount,
      Value<int> downloadedAt,
      Value<int> updatedAt,
    });

class $$MvtTilesetsTableFilterComposer
    extends Composer<_$AppDatabase, $MvtTilesetsTable> {
  $$MvtTilesetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mbtilesPath => $composableBuilder(
    column: $table.mbtilesPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minZoom => $composableBuilder(
    column: $table.minZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxZoom => $composableBuilder(
    column: $table.maxZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boundsJson => $composableBuilder(
    column: $table.boundsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProposed => $composableBuilder(
    column: $table.isProposed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tileCount => $composableBuilder(
    column: $table.tileCount,
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

class $$MvtTilesetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MvtTilesetsTable> {
  $$MvtTilesetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mbtilesPath => $composableBuilder(
    column: $table.mbtilesPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minZoom => $composableBuilder(
    column: $table.minZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxZoom => $composableBuilder(
    column: $table.maxZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boundsJson => $composableBuilder(
    column: $table.boundsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProposed => $composableBuilder(
    column: $table.isProposed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tileCount => $composableBuilder(
    column: $table.tileCount,
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

class $$MvtTilesetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MvtTilesetsTable> {
  $$MvtTilesetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localityId => $composableBuilder(
    column: $table.localityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mbtilesPath => $composableBuilder(
    column: $table.mbtilesPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minZoom =>
      $composableBuilder(column: $table.minZoom, builder: (column) => column);

  GeneratedColumn<int> get maxZoom =>
      $composableBuilder(column: $table.maxZoom, builder: (column) => column);

  GeneratedColumn<String> get boundsJson => $composableBuilder(
    column: $table.boundsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isProposed => $composableBuilder(
    column: $table.isProposed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tileCount =>
      $composableBuilder(column: $table.tileCount, builder: (column) => column);

  GeneratedColumn<int> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MvtTilesetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MvtTilesetsTable,
          MvtTileset,
          $$MvtTilesetsTableFilterComposer,
          $$MvtTilesetsTableOrderingComposer,
          $$MvtTilesetsTableAnnotationComposer,
          $$MvtTilesetsTableCreateCompanionBuilder,
          $$MvtTilesetsTableUpdateCompanionBuilder,
          (
            MvtTileset,
            BaseReferences<_$AppDatabase, $MvtTilesetsTable, MvtTileset>,
          ),
          MvtTileset,
          PrefetchHooks Function()
        > {
  $$MvtTilesetsTableTableManager(_$AppDatabase db, $MvtTilesetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MvtTilesetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MvtTilesetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$MvtTilesetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> localityId = const Value.absent(),
                Value<String> mbtilesPath = const Value.absent(),
                Value<int> minZoom = const Value.absent(),
                Value<int> maxZoom = const Value.absent(),
                Value<String> boundsJson = const Value.absent(),
                Value<bool> isProposed = const Value.absent(),
                Value<int> tileCount = const Value.absent(),
                Value<int> downloadedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => MvtTilesetsCompanion(
                localityId: localityId,
                mbtilesPath: mbtilesPath,
                minZoom: minZoom,
                maxZoom: maxZoom,
                boundsJson: boundsJson,
                isProposed: isProposed,
                tileCount: tileCount,
                downloadedAt: downloadedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localityId = const Value.absent(),
                required String mbtilesPath,
                required int minZoom,
                required int maxZoom,
                required String boundsJson,
                Value<bool> isProposed = const Value.absent(),
                Value<int> tileCount = const Value.absent(),
                required int downloadedAt,
                required int updatedAt,
              }) => MvtTilesetsCompanion.insert(
                localityId: localityId,
                mbtilesPath: mbtilesPath,
                minZoom: minZoom,
                maxZoom: maxZoom,
                boundsJson: boundsJson,
                isProposed: isProposed,
                tileCount: tileCount,
                downloadedAt: downloadedAt,
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

typedef $$MvtTilesetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MvtTilesetsTable,
      MvtTileset,
      $$MvtTilesetsTableFilterComposer,
      $$MvtTilesetsTableOrderingComposer,
      $$MvtTilesetsTableAnnotationComposer,
      $$MvtTilesetsTableCreateCompanionBuilder,
      $$MvtTilesetsTableUpdateCompanionBuilder,
      (
        MvtTileset,
        BaseReferences<_$AppDatabase, $MvtTilesetsTable, MvtTileset>,
      ),
      MvtTileset,
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
  $$ZoningFeatureHistoryTableTableManager get zoningFeatureHistory =>
      $$ZoningFeatureHistoryTableTableManager(_db, _db.zoningFeatureHistory);
  $$FeatureUploadQueueTableTableManager get featureUploadQueue =>
      $$FeatureUploadQueueTableTableManager(_db, _db.featureUploadQueue);
  $$ManualZoneDraftsTableTableManager get manualZoneDrafts =>
      $$ManualZoneDraftsTableTableManager(_db, _db.manualZoneDrafts);
  $$LandUsesTableTableManager get landUses =>
      $$LandUsesTableTableManager(_db, _db.landUses);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SubdivisionZonesTableTableManager get subdivisionZones =>
      $$SubdivisionZonesTableTableManager(_db, _db.subdivisionZones);
  $$SubdivisionApplicationsTableTableManager get subdivisionApplications =>
      $$SubdivisionApplicationsTableTableManager(
        _db,
        _db.subdivisionApplications,
      );
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$ParcelsTableTableManager get parcels =>
      $$ParcelsTableTableManager(_db, _db.parcels);
  $$ParcelDraftsTableTableManager get parcelDrafts =>
      $$ParcelDraftsTableTableManager(_db, _db.parcelDrafts);
  $$AllocationsTableTableManager get allocations =>
      $$AllocationsTableTableManager(_db, _db.allocations);
  $$ParcelPhotosTableTableManager get parcelPhotos =>
      $$ParcelPhotosTableTableManager(_db, _db.parcelPhotos);
  $$MvtTilesetsTableTableManager get mvtTilesets =>
      $$MvtTilesetsTableTableManager(_db, _db.mvtTilesets);
}
