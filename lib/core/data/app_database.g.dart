// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _descriptionArMeta = const VerificationMeta(
    'descriptionAr',
  );
  @override
  late final GeneratedColumn<String> descriptionAr = GeneratedColumn<String>(
    'description_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('group'),
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<int> accent = GeneratedColumn<int>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0B5D3B),
  );
  static const VerificationMeta _headNameMeta = const VerificationMeta(
    'headName',
  );
  @override
  late final GeneratedColumn<String> headName = GeneratedColumn<String>(
    'head_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _headNameArMeta = const VerificationMeta(
    'headNameAr',
  );
  @override
  late final GeneratedColumn<String> headNameAr = GeneratedColumn<String>(
    'head_name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contactEmailMeta = const VerificationMeta(
    'contactEmail',
  );
  @override
  late final GeneratedColumn<String> contactEmail = GeneratedColumn<String>(
    'contact_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contactPhoneMeta = const VerificationMeta(
    'contactPhone',
  );
  @override
  late final GeneratedColumn<String> contactPhone = GeneratedColumn<String>(
    'contact_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameAr,
    description,
    descriptionAr,
    iconKey,
    accent,
    headName,
    headNameAr,
    contactEmail,
    contactPhone,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Department> instance, {
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
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
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
    if (data.containsKey('description_ar')) {
      context.handle(
        _descriptionArMeta,
        descriptionAr.isAcceptableOrUnknown(
          data['description_ar']!,
          _descriptionArMeta,
        ),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    }
    if (data.containsKey('head_name')) {
      context.handle(
        _headNameMeta,
        headName.isAcceptableOrUnknown(data['head_name']!, _headNameMeta),
      );
    }
    if (data.containsKey('head_name_ar')) {
      context.handle(
        _headNameArMeta,
        headNameAr.isAcceptableOrUnknown(
          data['head_name_ar']!,
          _headNameArMeta,
        ),
      );
    }
    if (data.containsKey('contact_email')) {
      context.handle(
        _contactEmailMeta,
        contactEmail.isAcceptableOrUnknown(
          data['contact_email']!,
          _contactEmailMeta,
        ),
      );
    }
    if (data.containsKey('contact_phone')) {
      context.handle(
        _contactPhoneMeta,
        contactPhone.isAcceptableOrUnknown(
          data['contact_phone']!,
          _contactPhoneMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      descriptionAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_ar'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent'],
      )!,
      headName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}head_name'],
      )!,
      headNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}head_name_ar'],
      )!,
      contactEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_email'],
      )!,
      contactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_phone'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String iconKey;
  final int accent;
  final String headName;
  final String headNameAr;
  final String contactEmail;
  final String contactPhone;
  final int sortOrder;
  const Department({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.iconKey,
    required this.accent,
    required this.headName,
    required this.headNameAr,
    required this.contactEmail,
    required this.contactPhone,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['name_ar'] = Variable<String>(nameAr);
    map['description'] = Variable<String>(description);
    map['description_ar'] = Variable<String>(descriptionAr);
    map['icon_key'] = Variable<String>(iconKey);
    map['accent'] = Variable<int>(accent);
    map['head_name'] = Variable<String>(headName);
    map['head_name_ar'] = Variable<String>(headNameAr);
    map['contact_email'] = Variable<String>(contactEmail);
    map['contact_phone'] = Variable<String>(contactPhone);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      name: Value(name),
      nameAr: Value(nameAr),
      description: Value(description),
      descriptionAr: Value(descriptionAr),
      iconKey: Value(iconKey),
      accent: Value(accent),
      headName: Value(headName),
      headNameAr: Value(headNameAr),
      contactEmail: Value(contactEmail),
      contactPhone: Value(contactPhone),
      sortOrder: Value(sortOrder),
    );
  }

  factory Department.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      description: serializer.fromJson<String>(json['description']),
      descriptionAr: serializer.fromJson<String>(json['descriptionAr']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      accent: serializer.fromJson<int>(json['accent']),
      headName: serializer.fromJson<String>(json['headName']),
      headNameAr: serializer.fromJson<String>(json['headNameAr']),
      contactEmail: serializer.fromJson<String>(json['contactEmail']),
      contactPhone: serializer.fromJson<String>(json['contactPhone']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String>(nameAr),
      'description': serializer.toJson<String>(description),
      'descriptionAr': serializer.toJson<String>(descriptionAr),
      'iconKey': serializer.toJson<String>(iconKey),
      'accent': serializer.toJson<int>(accent),
      'headName': serializer.toJson<String>(headName),
      'headNameAr': serializer.toJson<String>(headNameAr),
      'contactEmail': serializer.toJson<String>(contactEmail),
      'contactPhone': serializer.toJson<String>(contactPhone),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Department copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? iconKey,
    int? accent,
    String? headName,
    String? headNameAr,
    String? contactEmail,
    String? contactPhone,
    int? sortOrder,
  }) => Department(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAr: nameAr ?? this.nameAr,
    description: description ?? this.description,
    descriptionAr: descriptionAr ?? this.descriptionAr,
    iconKey: iconKey ?? this.iconKey,
    accent: accent ?? this.accent,
    headName: headName ?? this.headName,
    headNameAr: headNameAr ?? this.headNameAr,
    contactEmail: contactEmail ?? this.contactEmail,
    contactPhone: contactPhone ?? this.contactPhone,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionAr: data.descriptionAr.present
          ? data.descriptionAr.value
          : this.descriptionAr,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      accent: data.accent.present ? data.accent.value : this.accent,
      headName: data.headName.present ? data.headName.value : this.headName,
      headNameAr: data.headNameAr.present
          ? data.headNameAr.value
          : this.headNameAr,
      contactEmail: data.contactEmail.present
          ? data.contactEmail.value
          : this.contactEmail,
      contactPhone: data.contactPhone.present
          ? data.contactPhone.value
          : this.contactPhone,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('descriptionAr: $descriptionAr, ')
          ..write('iconKey: $iconKey, ')
          ..write('accent: $accent, ')
          ..write('headName: $headName, ')
          ..write('headNameAr: $headNameAr, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameAr,
    description,
    descriptionAr,
    iconKey,
    accent,
    headName,
    headNameAr,
    contactEmail,
    contactPhone,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.description == this.description &&
          other.descriptionAr == this.descriptionAr &&
          other.iconKey == this.iconKey &&
          other.accent == this.accent &&
          other.headName == this.headName &&
          other.headNameAr == this.headNameAr &&
          other.contactEmail == this.contactEmail &&
          other.contactPhone == this.contactPhone &&
          other.sortOrder == this.sortOrder);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> nameAr;
  final Value<String> description;
  final Value<String> descriptionAr;
  final Value<String> iconKey;
  final Value<int> accent;
  final Value<String> headName;
  final Value<String> headNameAr;
  final Value<String> contactEmail;
  final Value<String> contactPhone;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionAr = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.accent = const Value.absent(),
    this.headName = const Value.absent(),
    this.headNameAr = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    required String id,
    required String name,
    this.nameAr = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionAr = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.accent = const Value.absent(),
    this.headName = const Value.absent(),
    this.headNameAr = const Value.absent(),
    this.contactEmail = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Department> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? description,
    Expression<String>? descriptionAr,
    Expression<String>? iconKey,
    Expression<int>? accent,
    Expression<String>? headName,
    Expression<String>? headNameAr,
    Expression<String>? contactEmail,
    Expression<String>? contactPhone,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (description != null) 'description': description,
      if (descriptionAr != null) 'description_ar': descriptionAr,
      if (iconKey != null) 'icon_key': iconKey,
      if (accent != null) 'accent': accent,
      if (headName != null) 'head_name': headName,
      if (headNameAr != null) 'head_name_ar': headNameAr,
      if (contactEmail != null) 'contact_email': contactEmail,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? nameAr,
    Value<String>? description,
    Value<String>? descriptionAr,
    Value<String>? iconKey,
    Value<int>? accent,
    Value<String>? headName,
    Value<String>? headNameAr,
    Value<String>? contactEmail,
    Value<String>? contactPhone,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      iconKey: iconKey ?? this.iconKey,
      accent: accent ?? this.accent,
      headName: headName ?? this.headName,
      headNameAr: headNameAr ?? this.headNameAr,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionAr.present) {
      map['description_ar'] = Variable<String>(descriptionAr.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (accent.present) {
      map['accent'] = Variable<int>(accent.value);
    }
    if (headName.present) {
      map['head_name'] = Variable<String>(headName.value);
    }
    if (headNameAr.present) {
      map['head_name_ar'] = Variable<String>(headNameAr.value);
    }
    if (contactEmail.present) {
      map['contact_email'] = Variable<String>(contactEmail.value);
    }
    if (contactPhone.present) {
      map['contact_phone'] = Variable<String>(contactPhone.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('descriptionAr: $descriptionAr, ')
          ..write('iconKey: $iconKey, ')
          ..write('accent: $accent, ')
          ..write('headName: $headName, ')
          ..write('headNameAr: $headNameAr, ')
          ..write('contactEmail: $contactEmail, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameArMeta = const VerificationMeta(
    'fullNameAr',
  );
  @override
  late final GeneratedColumn<String> fullNameAr = GeneratedColumn<String>(
    'full_name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleCodeMeta = const VerificationMeta(
    'roleCode',
  );
  @override
  late final GeneratedColumn<String> roleCode = GeneratedColumn<String>(
    'role_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastActiveMeta = const VerificationMeta(
    'lastActive',
  );
  @override
  late final GeneratedColumn<DateTime> lastActive = GeneratedColumn<DateTime>(
    'last_active',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    fullNameAr,
    username,
    email,
    passwordHash,
    roleCode,
    departmentId,
    active,
    lastActive,
    createdAt,
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('full_name_ar')) {
      context.handle(
        _fullNameArMeta,
        fullNameAr.isAcceptableOrUnknown(
          data['full_name_ar']!,
          _fullNameArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fullNameArMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role_code')) {
      context.handle(
        _roleCodeMeta,
        roleCode.isAcceptableOrUnknown(data['role_code']!, _roleCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_roleCodeMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('last_active')) {
      context.handle(
        _lastActiveMeta,
        lastActive.isAcceptableOrUnknown(data['last_active']!, _lastActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      fullNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name_ar'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      roleCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_code'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      lastActive: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_active'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String fullName;
  final String fullNameAr;
  final String username;
  final String email;
  final String passwordHash;
  final String roleCode;

  /// For department-head accounts: the department they manage.
  final String? departmentId;
  final bool active;
  final DateTime? lastActive;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.fullName,
    required this.fullNameAr,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.roleCode,
    this.departmentId,
    required this.active,
    this.lastActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['full_name_ar'] = Variable<String>(fullNameAr);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role_code'] = Variable<String>(roleCode);
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<String>(departmentId);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || lastActive != null) {
      map['last_active'] = Variable<DateTime>(lastActive);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      fullNameAr: Value(fullNameAr),
      username: Value(username),
      email: Value(email),
      passwordHash: Value(passwordHash),
      roleCode: Value(roleCode),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      active: Value(active),
      lastActive: lastActive == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActive),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      fullNameAr: serializer.fromJson<String>(json['fullNameAr']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      roleCode: serializer.fromJson<String>(json['roleCode']),
      departmentId: serializer.fromJson<String?>(json['departmentId']),
      active: serializer.fromJson<bool>(json['active']),
      lastActive: serializer.fromJson<DateTime?>(json['lastActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'fullNameAr': serializer.toJson<String>(fullNameAr),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'roleCode': serializer.toJson<String>(roleCode),
      'departmentId': serializer.toJson<String?>(departmentId),
      'active': serializer.toJson<bool>(active),
      'lastActive': serializer.toJson<DateTime?>(lastActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? fullNameAr,
    String? username,
    String? email,
    String? passwordHash,
    String? roleCode,
    Value<String?> departmentId = const Value.absent(),
    bool? active,
    Value<DateTime?> lastActive = const Value.absent(),
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    fullNameAr: fullNameAr ?? this.fullNameAr,
    username: username ?? this.username,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    roleCode: roleCode ?? this.roleCode,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    active: active ?? this.active,
    lastActive: lastActive.present ? lastActive.value : this.lastActive,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      fullNameAr: data.fullNameAr.present
          ? data.fullNameAr.value
          : this.fullNameAr,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      roleCode: data.roleCode.present ? data.roleCode.value : this.roleCode,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      active: data.active.present ? data.active.value : this.active,
      lastActive: data.lastActive.present
          ? data.lastActive.value
          : this.lastActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('fullNameAr: $fullNameAr, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('roleCode: $roleCode, ')
          ..write('departmentId: $departmentId, ')
          ..write('active: $active, ')
          ..write('lastActive: $lastActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fullName,
    fullNameAr,
    username,
    email,
    passwordHash,
    roleCode,
    departmentId,
    active,
    lastActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.fullNameAr == this.fullNameAr &&
          other.username == this.username &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.roleCode == this.roleCode &&
          other.departmentId == this.departmentId &&
          other.active == this.active &&
          other.lastActive == this.lastActive &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> fullNameAr;
  final Value<String> username;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> roleCode;
  final Value<String?> departmentId;
  final Value<bool> active;
  final Value<DateTime?> lastActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.fullNameAr = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.roleCode = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.active = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String fullName,
    required String fullNameAr,
    required String username,
    this.email = const Value.absent(),
    required String passwordHash,
    required String roleCode,
    this.departmentId = const Value.absent(),
    this.active = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       fullNameAr = Value(fullNameAr),
       username = Value(username),
       passwordHash = Value(passwordHash),
       roleCode = Value(roleCode);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? fullNameAr,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? roleCode,
    Expression<String>? departmentId,
    Expression<bool>? active,
    Expression<DateTime>? lastActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (fullNameAr != null) 'full_name_ar': fullNameAr,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (roleCode != null) 'role_code': roleCode,
      if (departmentId != null) 'department_id': departmentId,
      if (active != null) 'active': active,
      if (lastActive != null) 'last_active': lastActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String>? fullNameAr,
    Value<String>? username,
    Value<String>? email,
    Value<String>? passwordHash,
    Value<String>? roleCode,
    Value<String?>? departmentId,
    Value<bool>? active,
    Value<DateTime?>? lastActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      fullNameAr: fullNameAr ?? this.fullNameAr,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      roleCode: roleCode ?? this.roleCode,
      departmentId: departmentId ?? this.departmentId,
      active: active ?? this.active,
      lastActive: lastActive ?? this.lastActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (fullNameAr.present) {
      map['full_name_ar'] = Variable<String>(fullNameAr.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (roleCode.present) {
      map['role_code'] = Variable<String>(roleCode.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (lastActive.present) {
      map['last_active'] = Variable<DateTime>(lastActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('fullNameAr: $fullNameAr, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('roleCode: $roleCode, ')
          ..write('departmentId: $departmentId, ')
          ..write('active: $active, ')
          ..write('lastActive: $lastActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeadersTable extends Leaders with TableInfo<$LeadersTable, Leader> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionArMeta = const VerificationMeta(
    'positionAr',
  );
  @override
  late final GeneratedColumn<String> positionAr = GeneratedColumn<String>(
    'position_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceYearsMeta = const VerificationMeta(
    'serviceYears',
  );
  @override
  late final GeneratedColumn<String> serviceYears = GeneratedColumn<String>(
    'service_years',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bioArMeta = const VerificationMeta('bioAr');
  @override
  late final GeneratedColumn<String> bioAr = GeneratedColumn<String>(
    'bio_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _achievementsMeta = const VerificationMeta(
    'achievements',
  );
  @override
  late final GeneratedColumn<String> achievements = GeneratedColumn<String>(
    'achievements',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _achievementsArMeta = const VerificationMeta(
    'achievementsAr',
  );
  @override
  late final GeneratedColumn<String> achievementsAr = GeneratedColumn<String>(
    'achievements_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _responsibilitiesMeta = const VerificationMeta(
    'responsibilities',
  );
  @override
  late final GeneratedColumn<String> responsibilities = GeneratedColumn<String>(
    'responsibilities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _responsibilitiesArMeta =
      const VerificationMeta('responsibilitiesAr');
  @override
  late final GeneratedColumn<String> responsibilitiesAr =
      GeneratedColumn<String>(
        'responsibilities_ar',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<int> accent = GeneratedColumn<int>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0B5D3B),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameAr,
    position,
    positionAr,
    category,
    serviceYears,
    bio,
    bioAr,
    achievements,
    achievementsAr,
    responsibilities,
    responsibilitiesAr,
    email,
    phone,
    accent,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leaders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Leader> instance, {
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
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('position_ar')) {
      context.handle(
        _positionArMeta,
        positionAr.isAcceptableOrUnknown(data['position_ar']!, _positionArMeta),
      );
    } else if (isInserting) {
      context.missing(_positionArMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('service_years')) {
      context.handle(
        _serviceYearsMeta,
        serviceYears.isAcceptableOrUnknown(
          data['service_years']!,
          _serviceYearsMeta,
        ),
      );
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    }
    if (data.containsKey('bio_ar')) {
      context.handle(
        _bioArMeta,
        bioAr.isAcceptableOrUnknown(data['bio_ar']!, _bioArMeta),
      );
    }
    if (data.containsKey('achievements')) {
      context.handle(
        _achievementsMeta,
        achievements.isAcceptableOrUnknown(
          data['achievements']!,
          _achievementsMeta,
        ),
      );
    }
    if (data.containsKey('achievements_ar')) {
      context.handle(
        _achievementsArMeta,
        achievementsAr.isAcceptableOrUnknown(
          data['achievements_ar']!,
          _achievementsArMeta,
        ),
      );
    }
    if (data.containsKey('responsibilities')) {
      context.handle(
        _responsibilitiesMeta,
        responsibilities.isAcceptableOrUnknown(
          data['responsibilities']!,
          _responsibilitiesMeta,
        ),
      );
    }
    if (data.containsKey('responsibilities_ar')) {
      context.handle(
        _responsibilitiesArMeta,
        responsibilitiesAr.isAcceptableOrUnknown(
          data['responsibilities_ar']!,
          _responsibilitiesArMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Leader map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Leader(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      positionAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_ar'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      serviceYears: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_years'],
      )!,
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      )!,
      bioAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio_ar'],
      )!,
      achievements: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievements'],
      )!,
      achievementsAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievements_ar'],
      )!,
      responsibilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsibilities'],
      )!,
      responsibilitiesAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsibilities_ar'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LeadersTable createAlias(String alias) {
    return $LeadersTable(attachedDatabase, alias);
  }
}

class Leader extends DataClass implements Insertable<Leader> {
  final String id;
  final String name;
  final String nameAr;
  final String position;
  final String positionAr;
  final String category;
  final String serviceYears;
  final String bio;
  final String bioAr;

  /// Newline-separated lists.
  final String achievements;
  final String achievementsAr;
  final String responsibilities;
  final String responsibilitiesAr;
  final String email;
  final String phone;
  final int accent;
  final int sortOrder;
  final DateTime createdAt;
  const Leader({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.position,
    required this.positionAr,
    required this.category,
    required this.serviceYears,
    required this.bio,
    required this.bioAr,
    required this.achievements,
    required this.achievementsAr,
    required this.responsibilities,
    required this.responsibilitiesAr,
    required this.email,
    required this.phone,
    required this.accent,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['name_ar'] = Variable<String>(nameAr);
    map['position'] = Variable<String>(position);
    map['position_ar'] = Variable<String>(positionAr);
    map['category'] = Variable<String>(category);
    map['service_years'] = Variable<String>(serviceYears);
    map['bio'] = Variable<String>(bio);
    map['bio_ar'] = Variable<String>(bioAr);
    map['achievements'] = Variable<String>(achievements);
    map['achievements_ar'] = Variable<String>(achievementsAr);
    map['responsibilities'] = Variable<String>(responsibilities);
    map['responsibilities_ar'] = Variable<String>(responsibilitiesAr);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['accent'] = Variable<int>(accent);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LeadersCompanion toCompanion(bool nullToAbsent) {
    return LeadersCompanion(
      id: Value(id),
      name: Value(name),
      nameAr: Value(nameAr),
      position: Value(position),
      positionAr: Value(positionAr),
      category: Value(category),
      serviceYears: Value(serviceYears),
      bio: Value(bio),
      bioAr: Value(bioAr),
      achievements: Value(achievements),
      achievementsAr: Value(achievementsAr),
      responsibilities: Value(responsibilities),
      responsibilitiesAr: Value(responsibilitiesAr),
      email: Value(email),
      phone: Value(phone),
      accent: Value(accent),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Leader.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Leader(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      position: serializer.fromJson<String>(json['position']),
      positionAr: serializer.fromJson<String>(json['positionAr']),
      category: serializer.fromJson<String>(json['category']),
      serviceYears: serializer.fromJson<String>(json['serviceYears']),
      bio: serializer.fromJson<String>(json['bio']),
      bioAr: serializer.fromJson<String>(json['bioAr']),
      achievements: serializer.fromJson<String>(json['achievements']),
      achievementsAr: serializer.fromJson<String>(json['achievementsAr']),
      responsibilities: serializer.fromJson<String>(json['responsibilities']),
      responsibilitiesAr: serializer.fromJson<String>(
        json['responsibilitiesAr'],
      ),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      accent: serializer.fromJson<int>(json['accent']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String>(nameAr),
      'position': serializer.toJson<String>(position),
      'positionAr': serializer.toJson<String>(positionAr),
      'category': serializer.toJson<String>(category),
      'serviceYears': serializer.toJson<String>(serviceYears),
      'bio': serializer.toJson<String>(bio),
      'bioAr': serializer.toJson<String>(bioAr),
      'achievements': serializer.toJson<String>(achievements),
      'achievementsAr': serializer.toJson<String>(achievementsAr),
      'responsibilities': serializer.toJson<String>(responsibilities),
      'responsibilitiesAr': serializer.toJson<String>(responsibilitiesAr),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'accent': serializer.toJson<int>(accent),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Leader copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? position,
    String? positionAr,
    String? category,
    String? serviceYears,
    String? bio,
    String? bioAr,
    String? achievements,
    String? achievementsAr,
    String? responsibilities,
    String? responsibilitiesAr,
    String? email,
    String? phone,
    int? accent,
    int? sortOrder,
    DateTime? createdAt,
  }) => Leader(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAr: nameAr ?? this.nameAr,
    position: position ?? this.position,
    positionAr: positionAr ?? this.positionAr,
    category: category ?? this.category,
    serviceYears: serviceYears ?? this.serviceYears,
    bio: bio ?? this.bio,
    bioAr: bioAr ?? this.bioAr,
    achievements: achievements ?? this.achievements,
    achievementsAr: achievementsAr ?? this.achievementsAr,
    responsibilities: responsibilities ?? this.responsibilities,
    responsibilitiesAr: responsibilitiesAr ?? this.responsibilitiesAr,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    accent: accent ?? this.accent,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Leader copyWithCompanion(LeadersCompanion data) {
    return Leader(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      position: data.position.present ? data.position.value : this.position,
      positionAr: data.positionAr.present
          ? data.positionAr.value
          : this.positionAr,
      category: data.category.present ? data.category.value : this.category,
      serviceYears: data.serviceYears.present
          ? data.serviceYears.value
          : this.serviceYears,
      bio: data.bio.present ? data.bio.value : this.bio,
      bioAr: data.bioAr.present ? data.bioAr.value : this.bioAr,
      achievements: data.achievements.present
          ? data.achievements.value
          : this.achievements,
      achievementsAr: data.achievementsAr.present
          ? data.achievementsAr.value
          : this.achievementsAr,
      responsibilities: data.responsibilities.present
          ? data.responsibilities.value
          : this.responsibilities,
      responsibilitiesAr: data.responsibilitiesAr.present
          ? data.responsibilitiesAr.value
          : this.responsibilitiesAr,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      accent: data.accent.present ? data.accent.value : this.accent,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Leader(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('position: $position, ')
          ..write('positionAr: $positionAr, ')
          ..write('category: $category, ')
          ..write('serviceYears: $serviceYears, ')
          ..write('bio: $bio, ')
          ..write('bioAr: $bioAr, ')
          ..write('achievements: $achievements, ')
          ..write('achievementsAr: $achievementsAr, ')
          ..write('responsibilities: $responsibilities, ')
          ..write('responsibilitiesAr: $responsibilitiesAr, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('accent: $accent, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameAr,
    position,
    positionAr,
    category,
    serviceYears,
    bio,
    bioAr,
    achievements,
    achievementsAr,
    responsibilities,
    responsibilitiesAr,
    email,
    phone,
    accent,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Leader &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.position == this.position &&
          other.positionAr == this.positionAr &&
          other.category == this.category &&
          other.serviceYears == this.serviceYears &&
          other.bio == this.bio &&
          other.bioAr == this.bioAr &&
          other.achievements == this.achievements &&
          other.achievementsAr == this.achievementsAr &&
          other.responsibilities == this.responsibilities &&
          other.responsibilitiesAr == this.responsibilitiesAr &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.accent == this.accent &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class LeadersCompanion extends UpdateCompanion<Leader> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> nameAr;
  final Value<String> position;
  final Value<String> positionAr;
  final Value<String> category;
  final Value<String> serviceYears;
  final Value<String> bio;
  final Value<String> bioAr;
  final Value<String> achievements;
  final Value<String> achievementsAr;
  final Value<String> responsibilities;
  final Value<String> responsibilitiesAr;
  final Value<String> email;
  final Value<String> phone;
  final Value<int> accent;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LeadersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.position = const Value.absent(),
    this.positionAr = const Value.absent(),
    this.category = const Value.absent(),
    this.serviceYears = const Value.absent(),
    this.bio = const Value.absent(),
    this.bioAr = const Value.absent(),
    this.achievements = const Value.absent(),
    this.achievementsAr = const Value.absent(),
    this.responsibilities = const Value.absent(),
    this.responsibilitiesAr = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.accent = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeadersCompanion.insert({
    required String id,
    required String name,
    required String nameAr,
    required String position,
    required String positionAr,
    required String category,
    this.serviceYears = const Value.absent(),
    this.bio = const Value.absent(),
    this.bioAr = const Value.absent(),
    this.achievements = const Value.absent(),
    this.achievementsAr = const Value.absent(),
    this.responsibilities = const Value.absent(),
    this.responsibilitiesAr = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.accent = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       nameAr = Value(nameAr),
       position = Value(position),
       positionAr = Value(positionAr),
       category = Value(category);
  static Insertable<Leader> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? position,
    Expression<String>? positionAr,
    Expression<String>? category,
    Expression<String>? serviceYears,
    Expression<String>? bio,
    Expression<String>? bioAr,
    Expression<String>? achievements,
    Expression<String>? achievementsAr,
    Expression<String>? responsibilities,
    Expression<String>? responsibilitiesAr,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<int>? accent,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (position != null) 'position': position,
      if (positionAr != null) 'position_ar': positionAr,
      if (category != null) 'category': category,
      if (serviceYears != null) 'service_years': serviceYears,
      if (bio != null) 'bio': bio,
      if (bioAr != null) 'bio_ar': bioAr,
      if (achievements != null) 'achievements': achievements,
      if (achievementsAr != null) 'achievements_ar': achievementsAr,
      if (responsibilities != null) 'responsibilities': responsibilities,
      if (responsibilitiesAr != null) 'responsibilities_ar': responsibilitiesAr,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (accent != null) 'accent': accent,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeadersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? nameAr,
    Value<String>? position,
    Value<String>? positionAr,
    Value<String>? category,
    Value<String>? serviceYears,
    Value<String>? bio,
    Value<String>? bioAr,
    Value<String>? achievements,
    Value<String>? achievementsAr,
    Value<String>? responsibilities,
    Value<String>? responsibilitiesAr,
    Value<String>? email,
    Value<String>? phone,
    Value<int>? accent,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LeadersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      position: position ?? this.position,
      positionAr: positionAr ?? this.positionAr,
      category: category ?? this.category,
      serviceYears: serviceYears ?? this.serviceYears,
      bio: bio ?? this.bio,
      bioAr: bioAr ?? this.bioAr,
      achievements: achievements ?? this.achievements,
      achievementsAr: achievementsAr ?? this.achievementsAr,
      responsibilities: responsibilities ?? this.responsibilities,
      responsibilitiesAr: responsibilitiesAr ?? this.responsibilitiesAr,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accent: accent ?? this.accent,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
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
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (positionAr.present) {
      map['position_ar'] = Variable<String>(positionAr.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (serviceYears.present) {
      map['service_years'] = Variable<String>(serviceYears.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (bioAr.present) {
      map['bio_ar'] = Variable<String>(bioAr.value);
    }
    if (achievements.present) {
      map['achievements'] = Variable<String>(achievements.value);
    }
    if (achievementsAr.present) {
      map['achievements_ar'] = Variable<String>(achievementsAr.value);
    }
    if (responsibilities.present) {
      map['responsibilities'] = Variable<String>(responsibilities.value);
    }
    if (responsibilitiesAr.present) {
      map['responsibilities_ar'] = Variable<String>(responsibilitiesAr.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (accent.present) {
      map['accent'] = Variable<int>(accent.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeadersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('position: $position, ')
          ..write('positionAr: $positionAr, ')
          ..write('category: $category, ')
          ..write('serviceYears: $serviceYears, ')
          ..write('bio: $bio, ')
          ..write('bioAr: $bioAr, ')
          ..write('achievements: $achievements, ')
          ..write('achievementsAr: $achievementsAr, ')
          ..write('responsibilities: $responsibilities, ')
          ..write('responsibilitiesAr: $responsibilitiesAr, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('accent: $accent, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE SET NULL',
    ),
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
  static const VerificationMeta _actionArMeta = const VerificationMeta(
    'actionAr',
  );
  @override
  late final GeneratedColumn<String> actionAr = GeneratedColumn<String>(
    'action_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleArMeta = const VerificationMeta(
    'moduleAr',
  );
  @override
  late final GeneratedColumn<String> moduleAr = GeneratedColumn<String>(
    'module_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    userId,
    action,
    actionAr,
    module,
    moduleAr,
    timestamp,
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
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('action_ar')) {
      context.handle(
        _actionArMeta,
        actionAr.isAcceptableOrUnknown(data['action_ar']!, _actionArMeta),
      );
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('module_ar')) {
      context.handle(
        _moduleArMeta,
        moduleAr.isAcceptableOrUnknown(data['module_ar']!, _moduleArMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      actionAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_ar'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      moduleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_ar'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final String id;
  final String username;

  /// Optional link to the acting user. The [username] snapshot is always kept
  /// so the trail survives a user being renamed or deleted (SET NULL).
  final String? userId;
  final String action;
  final String actionAr;
  final String module;
  final String moduleAr;
  final DateTime timestamp;
  const AuditLog({
    required this.id,
    required this.username,
    this.userId,
    required this.action,
    required this.actionAr,
    required this.module,
    required this.moduleAr,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['action'] = Variable<String>(action);
    map['action_ar'] = Variable<String>(actionAr);
    map['module'] = Variable<String>(module);
    map['module_ar'] = Variable<String>(moduleAr);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      username: Value(username),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      action: Value(action),
      actionAr: Value(actionAr),
      module: Value(module),
      moduleAr: Value(moduleAr),
      timestamp: Value(timestamp),
    );
  }

  factory AuditLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      userId: serializer.fromJson<String?>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      actionAr: serializer.fromJson<String>(json['actionAr']),
      module: serializer.fromJson<String>(json['module']),
      moduleAr: serializer.fromJson<String>(json['moduleAr']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'userId': serializer.toJson<String?>(userId),
      'action': serializer.toJson<String>(action),
      'actionAr': serializer.toJson<String>(actionAr),
      'module': serializer.toJson<String>(module),
      'moduleAr': serializer.toJson<String>(moduleAr),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  AuditLog copyWith({
    String? id,
    String? username,
    Value<String?> userId = const Value.absent(),
    String? action,
    String? actionAr,
    String? module,
    String? moduleAr,
    DateTime? timestamp,
  }) => AuditLog(
    id: id ?? this.id,
    username: username ?? this.username,
    userId: userId.present ? userId.value : this.userId,
    action: action ?? this.action,
    actionAr: actionAr ?? this.actionAr,
    module: module ?? this.module,
    moduleAr: moduleAr ?? this.moduleAr,
    timestamp: timestamp ?? this.timestamp,
  );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      actionAr: data.actionAr.present ? data.actionAr.value : this.actionAr,
      module: data.module.present ? data.module.value : this.module,
      moduleAr: data.moduleAr.present ? data.moduleAr.value : this.moduleAr,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('actionAr: $actionAr, ')
          ..write('module: $module, ')
          ..write('moduleAr: $moduleAr, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    userId,
    action,
    actionAr,
    module,
    moduleAr,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.username == this.username &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.actionAr == this.actionAr &&
          other.module == this.module &&
          other.moduleAr == this.moduleAr &&
          other.timestamp == this.timestamp);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<String> id;
  final Value<String> username;
  final Value<String?> userId;
  final Value<String> action;
  final Value<String> actionAr;
  final Value<String> module;
  final Value<String> moduleAr;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.actionAr = const Value.absent(),
    this.module = const Value.absent(),
    this.moduleAr = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    required String id,
    required String username,
    this.userId = const Value.absent(),
    required String action,
    this.actionAr = const Value.absent(),
    required String module,
    this.moduleAr = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       username = Value(username),
       action = Value(action),
       module = Value(module);
  static Insertable<AuditLog> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? actionAr,
    Expression<String>? module,
    Expression<String>? moduleAr,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (actionAr != null) 'action_ar': actionAr,
      if (module != null) 'module': module,
      if (moduleAr != null) 'module_ar': moduleAr,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String?>? userId,
    Value<String>? action,
    Value<String>? actionAr,
    Value<String>? module,
    Value<String>? moduleAr,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      actionAr: actionAr ?? this.actionAr,
      module: module ?? this.module,
      moduleAr: moduleAr ?? this.moduleAr,
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
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (actionAr.present) {
      map['action_ar'] = Variable<String>(actionAr.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (moduleAr.present) {
      map['module_ar'] = Variable<String>(moduleAr.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('actionAr: $actionAr, ')
          ..write('module: $module, ')
          ..write('moduleAr: $moduleAr, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TarbiyaAreasTable extends TarbiyaAreas
    with TableInfo<$TarbiyaAreasTable, TarbiyaArea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TarbiyaAreasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _regionArMeta = const VerificationMeta(
    'regionAr',
  );
  @override
  late final GeneratedColumn<String> regionAr = GeneratedColumn<String>(
    'region_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<int> accent = GeneratedColumn<int>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0B5D3B),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameAr,
    region,
    regionAr,
    accent,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tarbiya_areas';
  @override
  VerificationContext validateIntegrity(
    Insertable<TarbiyaArea> instance, {
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
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('region_ar')) {
      context.handle(
        _regionArMeta,
        regionAr.isAcceptableOrUnknown(data['region_ar']!, _regionArMeta),
      );
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TarbiyaArea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TarbiyaArea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      regionAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_ar'],
      )!,
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TarbiyaAreasTable createAlias(String alias) {
    return $TarbiyaAreasTable(attachedDatabase, alias);
  }
}

class TarbiyaArea extends DataClass implements Insertable<TarbiyaArea> {
  final String id;
  final String name;
  final String nameAr;
  final String region;
  final String regionAr;
  final int accent;
  final int sortOrder;
  const TarbiyaArea({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.region,
    required this.regionAr,
    required this.accent,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['name_ar'] = Variable<String>(nameAr);
    map['region'] = Variable<String>(region);
    map['region_ar'] = Variable<String>(regionAr);
    map['accent'] = Variable<int>(accent);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TarbiyaAreasCompanion toCompanion(bool nullToAbsent) {
    return TarbiyaAreasCompanion(
      id: Value(id),
      name: Value(name),
      nameAr: Value(nameAr),
      region: Value(region),
      regionAr: Value(regionAr),
      accent: Value(accent),
      sortOrder: Value(sortOrder),
    );
  }

  factory TarbiyaArea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TarbiyaArea(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      region: serializer.fromJson<String>(json['region']),
      regionAr: serializer.fromJson<String>(json['regionAr']),
      accent: serializer.fromJson<int>(json['accent']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String>(nameAr),
      'region': serializer.toJson<String>(region),
      'regionAr': serializer.toJson<String>(regionAr),
      'accent': serializer.toJson<int>(accent),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TarbiyaArea copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? region,
    String? regionAr,
    int? accent,
    int? sortOrder,
  }) => TarbiyaArea(
    id: id ?? this.id,
    name: name ?? this.name,
    nameAr: nameAr ?? this.nameAr,
    region: region ?? this.region,
    regionAr: regionAr ?? this.regionAr,
    accent: accent ?? this.accent,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TarbiyaArea copyWithCompanion(TarbiyaAreasCompanion data) {
    return TarbiyaArea(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      region: data.region.present ? data.region.value : this.region,
      regionAr: data.regionAr.present ? data.regionAr.value : this.regionAr,
      accent: data.accent.present ? data.accent.value : this.accent,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TarbiyaArea(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('region: $region, ')
          ..write('regionAr: $regionAr, ')
          ..write('accent: $accent, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameAr, region, regionAr, accent, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TarbiyaArea &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.region == this.region &&
          other.regionAr == this.regionAr &&
          other.accent == this.accent &&
          other.sortOrder == this.sortOrder);
}

class TarbiyaAreasCompanion extends UpdateCompanion<TarbiyaArea> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> nameAr;
  final Value<String> region;
  final Value<String> regionAr;
  final Value<int> accent;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TarbiyaAreasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.region = const Value.absent(),
    this.regionAr = const Value.absent(),
    this.accent = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TarbiyaAreasCompanion.insert({
    required String id,
    required String name,
    this.nameAr = const Value.absent(),
    this.region = const Value.absent(),
    this.regionAr = const Value.absent(),
    this.accent = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<TarbiyaArea> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<String>? region,
    Expression<String>? regionAr,
    Expression<int>? accent,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (region != null) 'region': region,
      if (regionAr != null) 'region_ar': regionAr,
      if (accent != null) 'accent': accent,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TarbiyaAreasCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? nameAr,
    Value<String>? region,
    Value<String>? regionAr,
    Value<int>? accent,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TarbiyaAreasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      region: region ?? this.region,
      regionAr: regionAr ?? this.regionAr,
      accent: accent ?? this.accent,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (regionAr.present) {
      map['region_ar'] = Variable<String>(regionAr.value);
    }
    if (accent.present) {
      map['accent'] = Variable<int>(accent.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TarbiyaAreasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('region: $region, ')
          ..write('regionAr: $regionAr, ')
          ..write('accent: $accent, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShubasTable extends Shubas with TableInfo<$ShubasTable, Shuba> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShubasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaIdMeta = const VerificationMeta('areaId');
  @override
  late final GeneratedColumn<String> areaId = GeneratedColumn<String>(
    'area_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tarbiya_areas (id) ON DELETE RESTRICT',
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, areaId, name, nameAr, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shubas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shuba> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('area_id')) {
      context.handle(
        _areaIdMeta,
        areaId.isAcceptableOrUnknown(data['area_id']!, _areaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_areaIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shuba map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shuba(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      areaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ShubasTable createAlias(String alias) {
    return $ShubasTable(attachedDatabase, alias);
  }
}

class Shuba extends DataClass implements Insertable<Shuba> {
  final String id;
  final String areaId;
  final String name;
  final String nameAr;
  final int sortOrder;
  const Shuba({
    required this.id,
    required this.areaId,
    required this.name,
    required this.nameAr,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['area_id'] = Variable<String>(areaId);
    map['name'] = Variable<String>(name);
    map['name_ar'] = Variable<String>(nameAr);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ShubasCompanion toCompanion(bool nullToAbsent) {
    return ShubasCompanion(
      id: Value(id),
      areaId: Value(areaId),
      name: Value(name),
      nameAr: Value(nameAr),
      sortOrder: Value(sortOrder),
    );
  }

  factory Shuba.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shuba(
      id: serializer.fromJson<String>(json['id']),
      areaId: serializer.fromJson<String>(json['areaId']),
      name: serializer.fromJson<String>(json['name']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'areaId': serializer.toJson<String>(areaId),
      'name': serializer.toJson<String>(name),
      'nameAr': serializer.toJson<String>(nameAr),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Shuba copyWith({
    String? id,
    String? areaId,
    String? name,
    String? nameAr,
    int? sortOrder,
  }) => Shuba(
    id: id ?? this.id,
    areaId: areaId ?? this.areaId,
    name: name ?? this.name,
    nameAr: nameAr ?? this.nameAr,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Shuba copyWithCompanion(ShubasCompanion data) {
    return Shuba(
      id: data.id.present ? data.id.value : this.id,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
      name: data.name.present ? data.name.value : this.name,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shuba(')
          ..write('id: $id, ')
          ..write('areaId: $areaId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, areaId, name, nameAr, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shuba &&
          other.id == this.id &&
          other.areaId == this.areaId &&
          other.name == this.name &&
          other.nameAr == this.nameAr &&
          other.sortOrder == this.sortOrder);
}

class ShubasCompanion extends UpdateCompanion<Shuba> {
  final Value<String> id;
  final Value<String> areaId;
  final Value<String> name;
  final Value<String> nameAr;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ShubasCompanion({
    this.id = const Value.absent(),
    this.areaId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShubasCompanion.insert({
    required String id,
    required String areaId,
    required String name,
    this.nameAr = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       areaId = Value(areaId),
       name = Value(name);
  static Insertable<Shuba> custom({
    Expression<String>? id,
    Expression<String>? areaId,
    Expression<String>? name,
    Expression<String>? nameAr,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (areaId != null) 'area_id': areaId,
      if (name != null) 'name': name,
      if (nameAr != null) 'name_ar': nameAr,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShubasCompanion copyWith({
    Value<String>? id,
    Value<String>? areaId,
    Value<String>? name,
    Value<String>? nameAr,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ShubasCompanion(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (areaId.present) {
      map['area_id'] = Variable<String>(areaId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShubasCompanion(')
          ..write('id: $id, ')
          ..write('areaId: $areaId, ')
          ..write('name: $name, ')
          ..write('nameAr: $nameAr, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shubaIdMeta = const VerificationMeta(
    'shubaId',
  );
  @override
  late final GeneratedColumn<String> shubaId = GeneratedColumn<String>(
    'shuba_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shubas (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _suffixMeta = const VerificationMeta('suffix');
  @override
  late final GeneratedColumn<String> suffix = GeneratedColumn<String>(
    'suffix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('M'),
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<String> dob = GeneratedColumn<String>(
    'dob',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _placeOfBirthMeta = const VerificationMeta(
    'placeOfBirth',
  );
  @override
  late final GeneratedColumn<String> placeOfBirth = GeneratedColumn<String>(
    'place_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _contactNumberMeta = const VerificationMeta(
    'contactNumber',
  );
  @override
  late final GeneratedColumn<String> contactNumber = GeneratedColumn<String>(
    'contact_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ethnicityMeta = const VerificationMeta(
    'ethnicity',
  );
  @override
  late final GeneratedColumn<String> ethnicity = GeneratedColumn<String>(
    'ethnicity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _civilStatusMeta = const VerificationMeta(
    'civilStatus',
  );
  @override
  late final GeneratedColumn<String> civilStatus = GeneratedColumn<String>(
    'civil_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('single'),
  );
  static const VerificationMeta _spouseNameMeta = const VerificationMeta(
    'spouseName',
  );
  @override
  late final GeneratedColumn<String> spouseName = GeneratedColumn<String>(
    'spouse_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _spouseDateMeta = const VerificationMeta(
    'spouseDate',
  );
  @override
  late final GeneratedColumn<String> spouseDate = GeneratedColumn<String>(
    'spouse_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _dateJoinedMeta = const VerificationMeta(
    'dateJoined',
  );
  @override
  late final GeneratedColumn<String> dateJoined = GeneratedColumn<String>(
    'date_joined',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _usraNameMeta = const VerificationMeta(
    'usraName',
  );
  @override
  late final GeneratedColumn<String> usraName = GeneratedColumn<String>(
    'usra_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _usraEstablishedYearMeta =
      const VerificationMeta('usraEstablishedYear');
  @override
  late final GeneratedColumn<String> usraEstablishedYear =
      GeneratedColumn<String>(
        'usra_established_year',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _usraMeetingScheduleMeta =
      const VerificationMeta('usraMeetingSchedule');
  @override
  late final GeneratedColumn<String> usraMeetingSchedule =
      GeneratedColumn<String>(
        'usra_meeting_schedule',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _naqibMemberIdMeta = const VerificationMeta(
    'naqibMemberId',
  );
  @override
  late final GeneratedColumn<String> naqibMemberId = GeneratedColumn<String>(
    'naqib_member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE SET NULL',
    ),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shubaId,
    level,
    firstName,
    middleName,
    lastName,
    suffix,
    nameAr,
    gender,
    dob,
    placeOfBirth,
    contactNumber,
    email,
    address,
    ethnicity,
    occupation,
    photoPath,
    civilStatus,
    spouseName,
    spouseDate,
    status,
    dateJoined,
    usraName,
    usraEstablishedYear,
    usraMeetingSchedule,
    naqibMemberId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shuba_id')) {
      context.handle(
        _shubaIdMeta,
        shubaId.isAcceptableOrUnknown(data['shuba_id']!, _shubaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shubaIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
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
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('suffix')) {
      context.handle(
        _suffixMeta,
        suffix.isAcceptableOrUnknown(data['suffix']!, _suffixMeta),
      );
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    if (data.containsKey('place_of_birth')) {
      context.handle(
        _placeOfBirthMeta,
        placeOfBirth.isAcceptableOrUnknown(
          data['place_of_birth']!,
          _placeOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('contact_number')) {
      context.handle(
        _contactNumberMeta,
        contactNumber.isAcceptableOrUnknown(
          data['contact_number']!,
          _contactNumberMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('ethnicity')) {
      context.handle(
        _ethnicityMeta,
        ethnicity.isAcceptableOrUnknown(data['ethnicity']!, _ethnicityMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('civil_status')) {
      context.handle(
        _civilStatusMeta,
        civilStatus.isAcceptableOrUnknown(
          data['civil_status']!,
          _civilStatusMeta,
        ),
      );
    }
    if (data.containsKey('spouse_name')) {
      context.handle(
        _spouseNameMeta,
        spouseName.isAcceptableOrUnknown(data['spouse_name']!, _spouseNameMeta),
      );
    }
    if (data.containsKey('spouse_date')) {
      context.handle(
        _spouseDateMeta,
        spouseDate.isAcceptableOrUnknown(data['spouse_date']!, _spouseDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('date_joined')) {
      context.handle(
        _dateJoinedMeta,
        dateJoined.isAcceptableOrUnknown(data['date_joined']!, _dateJoinedMeta),
      );
    }
    if (data.containsKey('usra_name')) {
      context.handle(
        _usraNameMeta,
        usraName.isAcceptableOrUnknown(data['usra_name']!, _usraNameMeta),
      );
    }
    if (data.containsKey('usra_established_year')) {
      context.handle(
        _usraEstablishedYearMeta,
        usraEstablishedYear.isAcceptableOrUnknown(
          data['usra_established_year']!,
          _usraEstablishedYearMeta,
        ),
      );
    }
    if (data.containsKey('usra_meeting_schedule')) {
      context.handle(
        _usraMeetingScheduleMeta,
        usraMeetingSchedule.isAcceptableOrUnknown(
          data['usra_meeting_schedule']!,
          _usraMeetingScheduleMeta,
        ),
      );
    }
    if (data.containsKey('naqib_member_id')) {
      context.handle(
        _naqibMemberIdMeta,
        naqibMemberId.isAcceptableOrUnknown(
          data['naqib_member_id']!,
          _naqibMemberIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shubaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shuba_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      suffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suffix'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dob'],
      )!,
      placeOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_of_birth'],
      )!,
      contactNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_number'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      ethnicity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ethnicity'],
      )!,
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      )!,
      civilStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}civil_status'],
      )!,
      spouseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spouse_name'],
      )!,
      spouseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spouse_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dateJoined: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_joined'],
      )!,
      usraName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usra_name'],
      )!,
      usraEstablishedYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usra_established_year'],
      )!,
      usraMeetingSchedule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usra_meeting_schedule'],
      )!,
      naqibMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}naqib_member_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final String id;
  final String shubaId;
  final int level;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String nameAr;
  final String gender;
  final String dob;
  final String placeOfBirth;
  final String contactNumber;
  final String email;
  final String address;
  final String ethnicity;
  final String occupation;
  final String photoPath;
  final String civilStatus;
  final String spouseName;
  final String spouseDate;
  final String status;
  final String dateJoined;
  final String usraName;
  final String usraEstablishedYear;
  final String usraMeetingSchedule;

  /// Self-reference to this member's naqib (another member). SET NULL so a
  /// deleted naqib doesn't strand their mentees.
  final String? naqibMemberId;
  final DateTime createdAt;
  const Member({
    required this.id,
    required this.shubaId,
    required this.level,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.nameAr,
    required this.gender,
    required this.dob,
    required this.placeOfBirth,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.ethnicity,
    required this.occupation,
    required this.photoPath,
    required this.civilStatus,
    required this.spouseName,
    required this.spouseDate,
    required this.status,
    required this.dateJoined,
    required this.usraName,
    required this.usraEstablishedYear,
    required this.usraMeetingSchedule,
    this.naqibMemberId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shuba_id'] = Variable<String>(shubaId);
    map['level'] = Variable<int>(level);
    map['first_name'] = Variable<String>(firstName);
    map['middle_name'] = Variable<String>(middleName);
    map['last_name'] = Variable<String>(lastName);
    map['suffix'] = Variable<String>(suffix);
    map['name_ar'] = Variable<String>(nameAr);
    map['gender'] = Variable<String>(gender);
    map['dob'] = Variable<String>(dob);
    map['place_of_birth'] = Variable<String>(placeOfBirth);
    map['contact_number'] = Variable<String>(contactNumber);
    map['email'] = Variable<String>(email);
    map['address'] = Variable<String>(address);
    map['ethnicity'] = Variable<String>(ethnicity);
    map['occupation'] = Variable<String>(occupation);
    map['photo_path'] = Variable<String>(photoPath);
    map['civil_status'] = Variable<String>(civilStatus);
    map['spouse_name'] = Variable<String>(spouseName);
    map['spouse_date'] = Variable<String>(spouseDate);
    map['status'] = Variable<String>(status);
    map['date_joined'] = Variable<String>(dateJoined);
    map['usra_name'] = Variable<String>(usraName);
    map['usra_established_year'] = Variable<String>(usraEstablishedYear);
    map['usra_meeting_schedule'] = Variable<String>(usraMeetingSchedule);
    if (!nullToAbsent || naqibMemberId != null) {
      map['naqib_member_id'] = Variable<String>(naqibMemberId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      shubaId: Value(shubaId),
      level: Value(level),
      firstName: Value(firstName),
      middleName: Value(middleName),
      lastName: Value(lastName),
      suffix: Value(suffix),
      nameAr: Value(nameAr),
      gender: Value(gender),
      dob: Value(dob),
      placeOfBirth: Value(placeOfBirth),
      contactNumber: Value(contactNumber),
      email: Value(email),
      address: Value(address),
      ethnicity: Value(ethnicity),
      occupation: Value(occupation),
      photoPath: Value(photoPath),
      civilStatus: Value(civilStatus),
      spouseName: Value(spouseName),
      spouseDate: Value(spouseDate),
      status: Value(status),
      dateJoined: Value(dateJoined),
      usraName: Value(usraName),
      usraEstablishedYear: Value(usraEstablishedYear),
      usraMeetingSchedule: Value(usraMeetingSchedule),
      naqibMemberId: naqibMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(naqibMemberId),
      createdAt: Value(createdAt),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<String>(json['id']),
      shubaId: serializer.fromJson<String>(json['shubaId']),
      level: serializer.fromJson<int>(json['level']),
      firstName: serializer.fromJson<String>(json['firstName']),
      middleName: serializer.fromJson<String>(json['middleName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      suffix: serializer.fromJson<String>(json['suffix']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      gender: serializer.fromJson<String>(json['gender']),
      dob: serializer.fromJson<String>(json['dob']),
      placeOfBirth: serializer.fromJson<String>(json['placeOfBirth']),
      contactNumber: serializer.fromJson<String>(json['contactNumber']),
      email: serializer.fromJson<String>(json['email']),
      address: serializer.fromJson<String>(json['address']),
      ethnicity: serializer.fromJson<String>(json['ethnicity']),
      occupation: serializer.fromJson<String>(json['occupation']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      civilStatus: serializer.fromJson<String>(json['civilStatus']),
      spouseName: serializer.fromJson<String>(json['spouseName']),
      spouseDate: serializer.fromJson<String>(json['spouseDate']),
      status: serializer.fromJson<String>(json['status']),
      dateJoined: serializer.fromJson<String>(json['dateJoined']),
      usraName: serializer.fromJson<String>(json['usraName']),
      usraEstablishedYear: serializer.fromJson<String>(
        json['usraEstablishedYear'],
      ),
      usraMeetingSchedule: serializer.fromJson<String>(
        json['usraMeetingSchedule'],
      ),
      naqibMemberId: serializer.fromJson<String?>(json['naqibMemberId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shubaId': serializer.toJson<String>(shubaId),
      'level': serializer.toJson<int>(level),
      'firstName': serializer.toJson<String>(firstName),
      'middleName': serializer.toJson<String>(middleName),
      'lastName': serializer.toJson<String>(lastName),
      'suffix': serializer.toJson<String>(suffix),
      'nameAr': serializer.toJson<String>(nameAr),
      'gender': serializer.toJson<String>(gender),
      'dob': serializer.toJson<String>(dob),
      'placeOfBirth': serializer.toJson<String>(placeOfBirth),
      'contactNumber': serializer.toJson<String>(contactNumber),
      'email': serializer.toJson<String>(email),
      'address': serializer.toJson<String>(address),
      'ethnicity': serializer.toJson<String>(ethnicity),
      'occupation': serializer.toJson<String>(occupation),
      'photoPath': serializer.toJson<String>(photoPath),
      'civilStatus': serializer.toJson<String>(civilStatus),
      'spouseName': serializer.toJson<String>(spouseName),
      'spouseDate': serializer.toJson<String>(spouseDate),
      'status': serializer.toJson<String>(status),
      'dateJoined': serializer.toJson<String>(dateJoined),
      'usraName': serializer.toJson<String>(usraName),
      'usraEstablishedYear': serializer.toJson<String>(usraEstablishedYear),
      'usraMeetingSchedule': serializer.toJson<String>(usraMeetingSchedule),
      'naqibMemberId': serializer.toJson<String?>(naqibMemberId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Member copyWith({
    String? id,
    String? shubaId,
    int? level,
    String? firstName,
    String? middleName,
    String? lastName,
    String? suffix,
    String? nameAr,
    String? gender,
    String? dob,
    String? placeOfBirth,
    String? contactNumber,
    String? email,
    String? address,
    String? ethnicity,
    String? occupation,
    String? photoPath,
    String? civilStatus,
    String? spouseName,
    String? spouseDate,
    String? status,
    String? dateJoined,
    String? usraName,
    String? usraEstablishedYear,
    String? usraMeetingSchedule,
    Value<String?> naqibMemberId = const Value.absent(),
    DateTime? createdAt,
  }) => Member(
    id: id ?? this.id,
    shubaId: shubaId ?? this.shubaId,
    level: level ?? this.level,
    firstName: firstName ?? this.firstName,
    middleName: middleName ?? this.middleName,
    lastName: lastName ?? this.lastName,
    suffix: suffix ?? this.suffix,
    nameAr: nameAr ?? this.nameAr,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    placeOfBirth: placeOfBirth ?? this.placeOfBirth,
    contactNumber: contactNumber ?? this.contactNumber,
    email: email ?? this.email,
    address: address ?? this.address,
    ethnicity: ethnicity ?? this.ethnicity,
    occupation: occupation ?? this.occupation,
    photoPath: photoPath ?? this.photoPath,
    civilStatus: civilStatus ?? this.civilStatus,
    spouseName: spouseName ?? this.spouseName,
    spouseDate: spouseDate ?? this.spouseDate,
    status: status ?? this.status,
    dateJoined: dateJoined ?? this.dateJoined,
    usraName: usraName ?? this.usraName,
    usraEstablishedYear: usraEstablishedYear ?? this.usraEstablishedYear,
    usraMeetingSchedule: usraMeetingSchedule ?? this.usraMeetingSchedule,
    naqibMemberId: naqibMemberId.present
        ? naqibMemberId.value
        : this.naqibMemberId,
    createdAt: createdAt ?? this.createdAt,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      shubaId: data.shubaId.present ? data.shubaId.value : this.shubaId,
      level: data.level.present ? data.level.value : this.level,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName: data.middleName.present
          ? data.middleName.value
          : this.middleName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      suffix: data.suffix.present ? data.suffix.value : this.suffix,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      gender: data.gender.present ? data.gender.value : this.gender,
      dob: data.dob.present ? data.dob.value : this.dob,
      placeOfBirth: data.placeOfBirth.present
          ? data.placeOfBirth.value
          : this.placeOfBirth,
      contactNumber: data.contactNumber.present
          ? data.contactNumber.value
          : this.contactNumber,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      ethnicity: data.ethnicity.present ? data.ethnicity.value : this.ethnicity,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      civilStatus: data.civilStatus.present
          ? data.civilStatus.value
          : this.civilStatus,
      spouseName: data.spouseName.present
          ? data.spouseName.value
          : this.spouseName,
      spouseDate: data.spouseDate.present
          ? data.spouseDate.value
          : this.spouseDate,
      status: data.status.present ? data.status.value : this.status,
      dateJoined: data.dateJoined.present
          ? data.dateJoined.value
          : this.dateJoined,
      usraName: data.usraName.present ? data.usraName.value : this.usraName,
      usraEstablishedYear: data.usraEstablishedYear.present
          ? data.usraEstablishedYear.value
          : this.usraEstablishedYear,
      usraMeetingSchedule: data.usraMeetingSchedule.present
          ? data.usraMeetingSchedule.value
          : this.usraMeetingSchedule,
      naqibMemberId: data.naqibMemberId.present
          ? data.naqibMemberId.value
          : this.naqibMemberId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('shubaId: $shubaId, ')
          ..write('level: $level, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('suffix: $suffix, ')
          ..write('nameAr: $nameAr, ')
          ..write('gender: $gender, ')
          ..write('dob: $dob, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('contactNumber: $contactNumber, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('ethnicity: $ethnicity, ')
          ..write('occupation: $occupation, ')
          ..write('photoPath: $photoPath, ')
          ..write('civilStatus: $civilStatus, ')
          ..write('spouseName: $spouseName, ')
          ..write('spouseDate: $spouseDate, ')
          ..write('status: $status, ')
          ..write('dateJoined: $dateJoined, ')
          ..write('usraName: $usraName, ')
          ..write('usraEstablishedYear: $usraEstablishedYear, ')
          ..write('usraMeetingSchedule: $usraMeetingSchedule, ')
          ..write('naqibMemberId: $naqibMemberId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    shubaId,
    level,
    firstName,
    middleName,
    lastName,
    suffix,
    nameAr,
    gender,
    dob,
    placeOfBirth,
    contactNumber,
    email,
    address,
    ethnicity,
    occupation,
    photoPath,
    civilStatus,
    spouseName,
    spouseDate,
    status,
    dateJoined,
    usraName,
    usraEstablishedYear,
    usraMeetingSchedule,
    naqibMemberId,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.shubaId == this.shubaId &&
          other.level == this.level &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.lastName == this.lastName &&
          other.suffix == this.suffix &&
          other.nameAr == this.nameAr &&
          other.gender == this.gender &&
          other.dob == this.dob &&
          other.placeOfBirth == this.placeOfBirth &&
          other.contactNumber == this.contactNumber &&
          other.email == this.email &&
          other.address == this.address &&
          other.ethnicity == this.ethnicity &&
          other.occupation == this.occupation &&
          other.photoPath == this.photoPath &&
          other.civilStatus == this.civilStatus &&
          other.spouseName == this.spouseName &&
          other.spouseDate == this.spouseDate &&
          other.status == this.status &&
          other.dateJoined == this.dateJoined &&
          other.usraName == this.usraName &&
          other.usraEstablishedYear == this.usraEstablishedYear &&
          other.usraMeetingSchedule == this.usraMeetingSchedule &&
          other.naqibMemberId == this.naqibMemberId &&
          other.createdAt == this.createdAt);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<String> id;
  final Value<String> shubaId;
  final Value<int> level;
  final Value<String> firstName;
  final Value<String> middleName;
  final Value<String> lastName;
  final Value<String> suffix;
  final Value<String> nameAr;
  final Value<String> gender;
  final Value<String> dob;
  final Value<String> placeOfBirth;
  final Value<String> contactNumber;
  final Value<String> email;
  final Value<String> address;
  final Value<String> ethnicity;
  final Value<String> occupation;
  final Value<String> photoPath;
  final Value<String> civilStatus;
  final Value<String> spouseName;
  final Value<String> spouseDate;
  final Value<String> status;
  final Value<String> dateJoined;
  final Value<String> usraName;
  final Value<String> usraEstablishedYear;
  final Value<String> usraMeetingSchedule;
  final Value<String?> naqibMemberId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.shubaId = const Value.absent(),
    this.level = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.suffix = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.gender = const Value.absent(),
    this.dob = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.contactNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.ethnicity = const Value.absent(),
    this.occupation = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.civilStatus = const Value.absent(),
    this.spouseName = const Value.absent(),
    this.spouseDate = const Value.absent(),
    this.status = const Value.absent(),
    this.dateJoined = const Value.absent(),
    this.usraName = const Value.absent(),
    this.usraEstablishedYear = const Value.absent(),
    this.usraMeetingSchedule = const Value.absent(),
    this.naqibMemberId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String shubaId,
    this.level = const Value.absent(),
    required String firstName,
    this.middleName = const Value.absent(),
    required String lastName,
    this.suffix = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.gender = const Value.absent(),
    this.dob = const Value.absent(),
    this.placeOfBirth = const Value.absent(),
    this.contactNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.ethnicity = const Value.absent(),
    this.occupation = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.civilStatus = const Value.absent(),
    this.spouseName = const Value.absent(),
    this.spouseDate = const Value.absent(),
    this.status = const Value.absent(),
    this.dateJoined = const Value.absent(),
    this.usraName = const Value.absent(),
    this.usraEstablishedYear = const Value.absent(),
    this.usraMeetingSchedule = const Value.absent(),
    this.naqibMemberId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shubaId = Value(shubaId),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<Member> custom({
    Expression<String>? id,
    Expression<String>? shubaId,
    Expression<int>? level,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? lastName,
    Expression<String>? suffix,
    Expression<String>? nameAr,
    Expression<String>? gender,
    Expression<String>? dob,
    Expression<String>? placeOfBirth,
    Expression<String>? contactNumber,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? ethnicity,
    Expression<String>? occupation,
    Expression<String>? photoPath,
    Expression<String>? civilStatus,
    Expression<String>? spouseName,
    Expression<String>? spouseDate,
    Expression<String>? status,
    Expression<String>? dateJoined,
    Expression<String>? usraName,
    Expression<String>? usraEstablishedYear,
    Expression<String>? usraMeetingSchedule,
    Expression<String>? naqibMemberId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shubaId != null) 'shuba_id': shubaId,
      if (level != null) 'level': level,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (lastName != null) 'last_name': lastName,
      if (suffix != null) 'suffix': suffix,
      if (nameAr != null) 'name_ar': nameAr,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (placeOfBirth != null) 'place_of_birth': placeOfBirth,
      if (contactNumber != null) 'contact_number': contactNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (ethnicity != null) 'ethnicity': ethnicity,
      if (occupation != null) 'occupation': occupation,
      if (photoPath != null) 'photo_path': photoPath,
      if (civilStatus != null) 'civil_status': civilStatus,
      if (spouseName != null) 'spouse_name': spouseName,
      if (spouseDate != null) 'spouse_date': spouseDate,
      if (status != null) 'status': status,
      if (dateJoined != null) 'date_joined': dateJoined,
      if (usraName != null) 'usra_name': usraName,
      if (usraEstablishedYear != null)
        'usra_established_year': usraEstablishedYear,
      if (usraMeetingSchedule != null)
        'usra_meeting_schedule': usraMeetingSchedule,
      if (naqibMemberId != null) 'naqib_member_id': naqibMemberId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? shubaId,
    Value<int>? level,
    Value<String>? firstName,
    Value<String>? middleName,
    Value<String>? lastName,
    Value<String>? suffix,
    Value<String>? nameAr,
    Value<String>? gender,
    Value<String>? dob,
    Value<String>? placeOfBirth,
    Value<String>? contactNumber,
    Value<String>? email,
    Value<String>? address,
    Value<String>? ethnicity,
    Value<String>? occupation,
    Value<String>? photoPath,
    Value<String>? civilStatus,
    Value<String>? spouseName,
    Value<String>? spouseDate,
    Value<String>? status,
    Value<String>? dateJoined,
    Value<String>? usraName,
    Value<String>? usraEstablishedYear,
    Value<String>? usraMeetingSchedule,
    Value<String?>? naqibMemberId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      shubaId: shubaId ?? this.shubaId,
      level: level ?? this.level,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      suffix: suffix ?? this.suffix,
      nameAr: nameAr ?? this.nameAr,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      ethnicity: ethnicity ?? this.ethnicity,
      occupation: occupation ?? this.occupation,
      photoPath: photoPath ?? this.photoPath,
      civilStatus: civilStatus ?? this.civilStatus,
      spouseName: spouseName ?? this.spouseName,
      spouseDate: spouseDate ?? this.spouseDate,
      status: status ?? this.status,
      dateJoined: dateJoined ?? this.dateJoined,
      usraName: usraName ?? this.usraName,
      usraEstablishedYear: usraEstablishedYear ?? this.usraEstablishedYear,
      usraMeetingSchedule: usraMeetingSchedule ?? this.usraMeetingSchedule,
      naqibMemberId: naqibMemberId ?? this.naqibMemberId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shubaId.present) {
      map['shuba_id'] = Variable<String>(shubaId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
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
    if (suffix.present) {
      map['suffix'] = Variable<String>(suffix.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (dob.present) {
      map['dob'] = Variable<String>(dob.value);
    }
    if (placeOfBirth.present) {
      map['place_of_birth'] = Variable<String>(placeOfBirth.value);
    }
    if (contactNumber.present) {
      map['contact_number'] = Variable<String>(contactNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (ethnicity.present) {
      map['ethnicity'] = Variable<String>(ethnicity.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (civilStatus.present) {
      map['civil_status'] = Variable<String>(civilStatus.value);
    }
    if (spouseName.present) {
      map['spouse_name'] = Variable<String>(spouseName.value);
    }
    if (spouseDate.present) {
      map['spouse_date'] = Variable<String>(spouseDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dateJoined.present) {
      map['date_joined'] = Variable<String>(dateJoined.value);
    }
    if (usraName.present) {
      map['usra_name'] = Variable<String>(usraName.value);
    }
    if (usraEstablishedYear.present) {
      map['usra_established_year'] = Variable<String>(
        usraEstablishedYear.value,
      );
    }
    if (usraMeetingSchedule.present) {
      map['usra_meeting_schedule'] = Variable<String>(
        usraMeetingSchedule.value,
      );
    }
    if (naqibMemberId.present) {
      map['naqib_member_id'] = Variable<String>(naqibMemberId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('shubaId: $shubaId, ')
          ..write('level: $level, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('lastName: $lastName, ')
          ..write('suffix: $suffix, ')
          ..write('nameAr: $nameAr, ')
          ..write('gender: $gender, ')
          ..write('dob: $dob, ')
          ..write('placeOfBirth: $placeOfBirth, ')
          ..write('contactNumber: $contactNumber, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('ethnicity: $ethnicity, ')
          ..write('occupation: $occupation, ')
          ..write('photoPath: $photoPath, ')
          ..write('civilStatus: $civilStatus, ')
          ..write('spouseName: $spouseName, ')
          ..write('spouseDate: $spouseDate, ')
          ..write('status: $status, ')
          ..write('dateJoined: $dateJoined, ')
          ..write('usraName: $usraName, ')
          ..write('usraEstablishedYear: $usraEstablishedYear, ')
          ..write('usraMeetingSchedule: $usraMeetingSchedule, ')
          ..write('naqibMemberId: $naqibMemberId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberChildrenTable extends MemberChildren
    with TableInfo<$MemberChildrenTable, MemberChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
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
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<String> dob = GeneratedColumn<String>(
    'dob',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, memberId, name, dob];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_children';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberChildrenData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberChildrenData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dob'],
      )!,
    );
  }

  @override
  $MemberChildrenTable createAlias(String alias) {
    return $MemberChildrenTable(attachedDatabase, alias);
  }
}

class MemberChildrenData extends DataClass
    implements Insertable<MemberChildrenData> {
  final String id;
  final String memberId;
  final String name;
  final String dob;
  const MemberChildrenData({
    required this.id,
    required this.memberId,
    required this.name,
    required this.dob,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['name'] = Variable<String>(name);
    map['dob'] = Variable<String>(dob);
    return map;
  }

  MemberChildrenCompanion toCompanion(bool nullToAbsent) {
    return MemberChildrenCompanion(
      id: Value(id),
      memberId: Value(memberId),
      name: Value(name),
      dob: Value(dob),
    );
  }

  factory MemberChildrenData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberChildrenData(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      name: serializer.fromJson<String>(json['name']),
      dob: serializer.fromJson<String>(json['dob']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'name': serializer.toJson<String>(name),
      'dob': serializer.toJson<String>(dob),
    };
  }

  MemberChildrenData copyWith({
    String? id,
    String? memberId,
    String? name,
    String? dob,
  }) => MemberChildrenData(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    name: name ?? this.name,
    dob: dob ?? this.dob,
  );
  MemberChildrenData copyWithCompanion(MemberChildrenCompanion data) {
    return MemberChildrenData(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      name: data.name.present ? data.name.value : this.name,
      dob: data.dob.present ? data.dob.value : this.dob,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberChildrenData(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('dob: $dob')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, memberId, name, dob);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberChildrenData &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.name == this.name &&
          other.dob == this.dob);
}

class MemberChildrenCompanion extends UpdateCompanion<MemberChildrenData> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<String> name;
  final Value<String> dob;
  final Value<int> rowid;
  const MemberChildrenCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.name = const Value.absent(),
    this.dob = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberChildrenCompanion.insert({
    required String id,
    required String memberId,
    required String name,
    this.dob = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       name = Value(name);
  static Insertable<MemberChildrenData> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<String>? name,
    Expression<String>? dob,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (name != null) 'name': name,
      if (dob != null) 'dob': dob,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberChildrenCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<String>? name,
    Value<String>? dob,
    Value<int>? rowid,
  }) {
    return MemberChildrenCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dob.present) {
      map['dob'] = Variable<String>(dob.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberChildrenCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('dob: $dob, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberEducationTable extends MemberEducation
    with TableInfo<$MemberEducationTable, MemberEducationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberEducationTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolNameMeta = const VerificationMeta(
    'schoolName',
  );
  @override
  late final GeneratedColumn<String> schoolName = GeneratedColumn<String>(
    'school_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _degreeMeta = const VerificationMeta('degree');
  @override
  late final GeneratedColumn<String> degree = GeneratedColumn<String>(
    'degree',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _programMeta = const VerificationMeta(
    'program',
  );
  @override
  late final GeneratedColumn<String> program = GeneratedColumn<String>(
    'program',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearGraduatedMeta = const VerificationMeta(
    'yearGraduated',
  );
  @override
  late final GeneratedColumn<String> yearGraduated = GeneratedColumn<String>(
    'year_graduated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    stage,
    schoolName,
    degree,
    program,
    yearGraduated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_education';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberEducationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('school_name')) {
      context.handle(
        _schoolNameMeta,
        schoolName.isAcceptableOrUnknown(data['school_name']!, _schoolNameMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolNameMeta);
    }
    if (data.containsKey('degree')) {
      context.handle(
        _degreeMeta,
        degree.isAcceptableOrUnknown(data['degree']!, _degreeMeta),
      );
    }
    if (data.containsKey('program')) {
      context.handle(
        _programMeta,
        program.isAcceptableOrUnknown(data['program']!, _programMeta),
      );
    }
    if (data.containsKey('year_graduated')) {
      context.handle(
        _yearGraduatedMeta,
        yearGraduated.isAcceptableOrUnknown(
          data['year_graduated']!,
          _yearGraduatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberEducationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberEducationData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      schoolName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_name'],
      )!,
      degree: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}degree'],
      )!,
      program: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program'],
      )!,
      yearGraduated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_graduated'],
      )!,
    );
  }

  @override
  $MemberEducationTable createAlias(String alias) {
    return $MemberEducationTable(attachedDatabase, alias);
  }
}

class MemberEducationData extends DataClass
    implements Insertable<MemberEducationData> {
  final String id;
  final String memberId;
  final String stage;
  final String schoolName;
  final String degree;
  final String program;
  final String yearGraduated;
  const MemberEducationData({
    required this.id,
    required this.memberId,
    required this.stage,
    required this.schoolName,
    required this.degree,
    required this.program,
    required this.yearGraduated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['stage'] = Variable<String>(stage);
    map['school_name'] = Variable<String>(schoolName);
    map['degree'] = Variable<String>(degree);
    map['program'] = Variable<String>(program);
    map['year_graduated'] = Variable<String>(yearGraduated);
    return map;
  }

  MemberEducationCompanion toCompanion(bool nullToAbsent) {
    return MemberEducationCompanion(
      id: Value(id),
      memberId: Value(memberId),
      stage: Value(stage),
      schoolName: Value(schoolName),
      degree: Value(degree),
      program: Value(program),
      yearGraduated: Value(yearGraduated),
    );
  }

  factory MemberEducationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberEducationData(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      stage: serializer.fromJson<String>(json['stage']),
      schoolName: serializer.fromJson<String>(json['schoolName']),
      degree: serializer.fromJson<String>(json['degree']),
      program: serializer.fromJson<String>(json['program']),
      yearGraduated: serializer.fromJson<String>(json['yearGraduated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'stage': serializer.toJson<String>(stage),
      'schoolName': serializer.toJson<String>(schoolName),
      'degree': serializer.toJson<String>(degree),
      'program': serializer.toJson<String>(program),
      'yearGraduated': serializer.toJson<String>(yearGraduated),
    };
  }

  MemberEducationData copyWith({
    String? id,
    String? memberId,
    String? stage,
    String? schoolName,
    String? degree,
    String? program,
    String? yearGraduated,
  }) => MemberEducationData(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    stage: stage ?? this.stage,
    schoolName: schoolName ?? this.schoolName,
    degree: degree ?? this.degree,
    program: program ?? this.program,
    yearGraduated: yearGraduated ?? this.yearGraduated,
  );
  MemberEducationData copyWithCompanion(MemberEducationCompanion data) {
    return MemberEducationData(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      stage: data.stage.present ? data.stage.value : this.stage,
      schoolName: data.schoolName.present
          ? data.schoolName.value
          : this.schoolName,
      degree: data.degree.present ? data.degree.value : this.degree,
      program: data.program.present ? data.program.value : this.program,
      yearGraduated: data.yearGraduated.present
          ? data.yearGraduated.value
          : this.yearGraduated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberEducationData(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('stage: $stage, ')
          ..write('schoolName: $schoolName, ')
          ..write('degree: $degree, ')
          ..write('program: $program, ')
          ..write('yearGraduated: $yearGraduated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    memberId,
    stage,
    schoolName,
    degree,
    program,
    yearGraduated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberEducationData &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.stage == this.stage &&
          other.schoolName == this.schoolName &&
          other.degree == this.degree &&
          other.program == this.program &&
          other.yearGraduated == this.yearGraduated);
}

class MemberEducationCompanion extends UpdateCompanion<MemberEducationData> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<String> stage;
  final Value<String> schoolName;
  final Value<String> degree;
  final Value<String> program;
  final Value<String> yearGraduated;
  final Value<int> rowid;
  const MemberEducationCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.stage = const Value.absent(),
    this.schoolName = const Value.absent(),
    this.degree = const Value.absent(),
    this.program = const Value.absent(),
    this.yearGraduated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberEducationCompanion.insert({
    required String id,
    required String memberId,
    required String stage,
    required String schoolName,
    this.degree = const Value.absent(),
    this.program = const Value.absent(),
    this.yearGraduated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       stage = Value(stage),
       schoolName = Value(schoolName);
  static Insertable<MemberEducationData> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<String>? stage,
    Expression<String>? schoolName,
    Expression<String>? degree,
    Expression<String>? program,
    Expression<String>? yearGraduated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (stage != null) 'stage': stage,
      if (schoolName != null) 'school_name': schoolName,
      if (degree != null) 'degree': degree,
      if (program != null) 'program': program,
      if (yearGraduated != null) 'year_graduated': yearGraduated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberEducationCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<String>? stage,
    Value<String>? schoolName,
    Value<String>? degree,
    Value<String>? program,
    Value<String>? yearGraduated,
    Value<int>? rowid,
  }) {
    return MemberEducationCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      stage: stage ?? this.stage,
      schoolName: schoolName ?? this.schoolName,
      degree: degree ?? this.degree,
      program: program ?? this.program,
      yearGraduated: yearGraduated ?? this.yearGraduated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (schoolName.present) {
      map['school_name'] = Variable<String>(schoolName.value);
    }
    if (degree.present) {
      map['degree'] = Variable<String>(degree.value);
    }
    if (program.present) {
      map['program'] = Variable<String>(program.value);
    }
    if (yearGraduated.present) {
      map['year_graduated'] = Variable<String>(yearGraduated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberEducationCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('stage: $stage, ')
          ..write('schoolName: $schoolName, ')
          ..write('degree: $degree, ')
          ..write('program: $program, ')
          ..write('yearGraduated: $yearGraduated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberActivitiesTable extends MemberActivities
    with TableInfo<$MemberActivitiesTable, MemberActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _attendanceStatusMeta = const VerificationMeta(
    'attendanceStatus',
  );
  @override
  late final GeneratedColumn<String> attendanceStatus = GeneratedColumn<String>(
    'attendance_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('present'),
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    name,
    type,
    date,
    attendanceStatus,
    remarks,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('attendance_status')) {
      context.handle(
        _attendanceStatusMeta,
        attendanceStatus.isAcceptableOrUnknown(
          data['attendance_status']!,
          _attendanceStatusMeta,
        ),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      attendanceStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attendance_status'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      )!,
    );
  }

  @override
  $MemberActivitiesTable createAlias(String alias) {
    return $MemberActivitiesTable(attachedDatabase, alias);
  }
}

class MemberActivity extends DataClass implements Insertable<MemberActivity> {
  final String id;
  final String memberId;
  final String name;
  final String type;
  final String date;
  final String attendanceStatus;
  final String remarks;
  const MemberActivity({
    required this.id,
    required this.memberId,
    required this.name,
    required this.type,
    required this.date,
    required this.attendanceStatus,
    required this.remarks,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['date'] = Variable<String>(date);
    map['attendance_status'] = Variable<String>(attendanceStatus);
    map['remarks'] = Variable<String>(remarks);
    return map;
  }

  MemberActivitiesCompanion toCompanion(bool nullToAbsent) {
    return MemberActivitiesCompanion(
      id: Value(id),
      memberId: Value(memberId),
      name: Value(name),
      type: Value(type),
      date: Value(date),
      attendanceStatus: Value(attendanceStatus),
      remarks: Value(remarks),
    );
  }

  factory MemberActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberActivity(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<String>(json['date']),
      attendanceStatus: serializer.fromJson<String>(json['attendanceStatus']),
      remarks: serializer.fromJson<String>(json['remarks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<String>(date),
      'attendanceStatus': serializer.toJson<String>(attendanceStatus),
      'remarks': serializer.toJson<String>(remarks),
    };
  }

  MemberActivity copyWith({
    String? id,
    String? memberId,
    String? name,
    String? type,
    String? date,
    String? attendanceStatus,
    String? remarks,
  }) => MemberActivity(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    name: name ?? this.name,
    type: type ?? this.type,
    date: date ?? this.date,
    attendanceStatus: attendanceStatus ?? this.attendanceStatus,
    remarks: remarks ?? this.remarks,
  );
  MemberActivity copyWithCompanion(MemberActivitiesCompanion data) {
    return MemberActivity(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      attendanceStatus: data.attendanceStatus.present
          ? data.attendanceStatus.value
          : this.attendanceStatus,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberActivity(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, name, type, date, attendanceStatus, remarks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberActivity &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.name == this.name &&
          other.type == this.type &&
          other.date == this.date &&
          other.attendanceStatus == this.attendanceStatus &&
          other.remarks == this.remarks);
}

class MemberActivitiesCompanion extends UpdateCompanion<MemberActivity> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<String> name;
  final Value<String> type;
  final Value<String> date;
  final Value<String> attendanceStatus;
  final Value<String> remarks;
  final Value<int> rowid;
  const MemberActivitiesCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.attendanceStatus = const Value.absent(),
    this.remarks = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberActivitiesCompanion.insert({
    required String id,
    required String memberId,
    required String name,
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.attendanceStatus = const Value.absent(),
    this.remarks = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       name = Value(name);
  static Insertable<MemberActivity> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? date,
    Expression<String>? attendanceStatus,
    Expression<String>? remarks,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (attendanceStatus != null) 'attendance_status': attendanceStatus,
      if (remarks != null) 'remarks': remarks,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<String>? name,
    Value<String>? type,
    Value<String>? date,
    Value<String>? attendanceStatus,
    Value<String>? remarks,
    Value<int>? rowid,
  }) {
    return MemberActivitiesCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      type: type ?? this.type,
      date: date ?? this.date,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      remarks: remarks ?? this.remarks,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (attendanceStatus.present) {
      map['attendance_status'] = Variable<String>(attendanceStatus.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('attendanceStatus: $attendanceStatus, ')
          ..write('remarks: $remarks, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberContributionsTable extends MemberContributions
    with TableInfo<$MemberContributionsTable, MemberContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    title,
    description,
    date,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberContribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MemberContributionsTable createAlias(String alias) {
    return $MemberContributionsTable(attachedDatabase, alias);
  }
}

class MemberContribution extends DataClass
    implements Insertable<MemberContribution> {
  final String id;
  final String memberId;
  final String title;
  final String description;
  final String date;
  final String status;
  const MemberContribution({
    required this.id,
    required this.memberId,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<String>(date);
    map['status'] = Variable<String>(status);
    return map;
  }

  MemberContributionsCompanion toCompanion(bool nullToAbsent) {
    return MemberContributionsCompanion(
      id: Value(id),
      memberId: Value(memberId),
      title: Value(title),
      description: Value(description),
      date: Value(date),
      status: Value(status),
    );
  }

  factory MemberContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberContribution(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<String>(json['date']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(status),
    };
  }

  MemberContribution copyWith({
    String? id,
    String? memberId,
    String? title,
    String? description,
    String? date,
    String? status,
  }) => MemberContribution(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    title: title ?? this.title,
    description: description ?? this.description,
    date: date ?? this.date,
    status: status ?? this.status,
  );
  MemberContribution copyWithCompanion(MemberContributionsCompanion data) {
    return MemberContribution(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberContribution(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, title, description, date, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberContribution &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date &&
          other.status == this.status);
}

class MemberContributionsCompanion extends UpdateCompanion<MemberContribution> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> date;
  final Value<String> status;
  final Value<int> rowid;
  const MemberContributionsCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberContributionsCompanion.insert({
    required String id,
    required String memberId,
    required String title,
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       title = Value(title);
  static Insertable<MemberContribution> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? date,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberContributionsCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? date,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return MemberContributionsCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberContributionsCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberTasedTable extends MemberTased
    with TableInfo<$MemberTasedTable, MemberTasedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberTasedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inactive'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, memberId, level, year, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_tased';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberTasedData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberTasedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberTasedData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MemberTasedTable createAlias(String alias) {
    return $MemberTasedTable(attachedDatabase, alias);
  }
}

class MemberTasedData extends DataClass implements Insertable<MemberTasedData> {
  final String id;
  final String memberId;
  final int level;
  final String year;
  final String status;
  const MemberTasedData({
    required this.id,
    required this.memberId,
    required this.level,
    required this.year,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['level'] = Variable<int>(level);
    map['year'] = Variable<String>(year);
    map['status'] = Variable<String>(status);
    return map;
  }

  MemberTasedCompanion toCompanion(bool nullToAbsent) {
    return MemberTasedCompanion(
      id: Value(id),
      memberId: Value(memberId),
      level: Value(level),
      year: Value(year),
      status: Value(status),
    );
  }

  factory MemberTasedData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberTasedData(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      level: serializer.fromJson<int>(json['level']),
      year: serializer.fromJson<String>(json['year']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'level': serializer.toJson<int>(level),
      'year': serializer.toJson<String>(year),
      'status': serializer.toJson<String>(status),
    };
  }

  MemberTasedData copyWith({
    String? id,
    String? memberId,
    int? level,
    String? year,
    String? status,
  }) => MemberTasedData(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    level: level ?? this.level,
    year: year ?? this.year,
    status: status ?? this.status,
  );
  MemberTasedData copyWithCompanion(MemberTasedCompanion data) {
    return MemberTasedData(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      level: data.level.present ? data.level.value : this.level,
      year: data.year.present ? data.year.value : this.year,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberTasedData(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('level: $level, ')
          ..write('year: $year, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, memberId, level, year, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberTasedData &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.level == this.level &&
          other.year == this.year &&
          other.status == this.status);
}

class MemberTasedCompanion extends UpdateCompanion<MemberTasedData> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<int> level;
  final Value<String> year;
  final Value<String> status;
  final Value<int> rowid;
  const MemberTasedCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.level = const Value.absent(),
    this.year = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberTasedCompanion.insert({
    required String id,
    required String memberId,
    required int level,
    this.year = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       level = Value(level);
  static Insertable<MemberTasedData> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<int>? level,
    Expression<String>? year,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (level != null) 'level': level,
      if (year != null) 'year': year,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberTasedCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<int>? level,
    Value<String>? year,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return MemberTasedCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      level: level ?? this.level,
      year: year ?? this.year,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberTasedCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('level: $level, ')
          ..write('year: $year, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberDonationsTable extends MemberDonations
    with TableInfo<$MemberDonationsTable, MemberDonation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberDonationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _donatedMeta = const VerificationMeta(
    'donated',
  );
  @override
  late final GeneratedColumn<bool> donated = GeneratedColumn<bool>(
    'donated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("donated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    year,
    month,
    donated,
    date,
    amount,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_donations';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberDonation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('donated')) {
      context.handle(
        _donatedMeta,
        donated.isAcceptableOrUnknown(data['donated']!, _donatedMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {memberId, year, month},
  ];
  @override
  MemberDonation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberDonation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      donated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}donated'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $MemberDonationsTable createAlias(String alias) {
    return $MemberDonationsTable(attachedDatabase, alias);
  }
}

class MemberDonation extends DataClass implements Insertable<MemberDonation> {
  final String id;
  final String memberId;
  final int year;
  final int month;
  final bool donated;
  final String date;
  final double amount;
  final String notes;
  const MemberDonation({
    required this.id,
    required this.memberId,
    required this.year,
    required this.month,
    required this.donated,
    required this.date,
    required this.amount,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['donated'] = Variable<bool>(donated);
    map['date'] = Variable<String>(date);
    map['amount'] = Variable<double>(amount);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  MemberDonationsCompanion toCompanion(bool nullToAbsent) {
    return MemberDonationsCompanion(
      id: Value(id),
      memberId: Value(memberId),
      year: Value(year),
      month: Value(month),
      donated: Value(donated),
      date: Value(date),
      amount: Value(amount),
      notes: Value(notes),
    );
  }

  factory MemberDonation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberDonation(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      donated: serializer.fromJson<bool>(json['donated']),
      date: serializer.fromJson<String>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'donated': serializer.toJson<bool>(donated),
      'date': serializer.toJson<String>(date),
      'amount': serializer.toJson<double>(amount),
      'notes': serializer.toJson<String>(notes),
    };
  }

  MemberDonation copyWith({
    String? id,
    String? memberId,
    int? year,
    int? month,
    bool? donated,
    String? date,
    double? amount,
    String? notes,
  }) => MemberDonation(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    year: year ?? this.year,
    month: month ?? this.month,
    donated: donated ?? this.donated,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    notes: notes ?? this.notes,
  );
  MemberDonation copyWithCompanion(MemberDonationsCompanion data) {
    return MemberDonation(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      donated: data.donated.present ? data.donated.value : this.donated,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberDonation(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('donated: $donated, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, memberId, year, month, donated, date, amount, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberDonation &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.year == this.year &&
          other.month == this.month &&
          other.donated == this.donated &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.notes == this.notes);
}

class MemberDonationsCompanion extends UpdateCompanion<MemberDonation> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<int> year;
  final Value<int> month;
  final Value<bool> donated;
  final Value<String> date;
  final Value<double> amount;
  final Value<String> notes;
  final Value<int> rowid;
  const MemberDonationsCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.donated = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberDonationsCompanion.insert({
    required String id,
    required String memberId,
    required int year,
    required int month,
    this.donated = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       year = Value(year),
       month = Value(month);
  static Insertable<MemberDonation> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<bool>? donated,
    Expression<String>? date,
    Expression<double>? amount,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (donated != null) 'donated': donated,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberDonationsCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<int>? year,
    Value<int>? month,
    Value<bool>? donated,
    Value<String>? date,
    Value<double>? amount,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return MemberDonationsCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      year: year ?? this.year,
      month: month ?? this.month,
      donated: donated ?? this.donated,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (donated.present) {
      map['donated'] = Variable<bool>(donated.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberDonationsCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('donated: $donated, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberRolesTable extends MemberRoles
    with TableInfo<$MemberRolesTable, MemberRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberRolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionTitleMeta = const VerificationMeta(
    'positionTitle',
  );
  @override
  late final GeneratedColumn<String> positionTitle = GeneratedColumn<String>(
    'position_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    positionTitle,
    department,
    departmentId,
    startDate,
    endDate,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberRole> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('position_title')) {
      context.handle(
        _positionTitleMeta,
        positionTitle.isAcceptableOrUnknown(
          data['position_title']!,
          _positionTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionTitleMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberRole(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      positionTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_title'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MemberRolesTable createAlias(String alias) {
    return $MemberRolesTable(attachedDatabase, alias);
  }
}

class MemberRole extends DataClass implements Insertable<MemberRole> {
  final String id;
  final String memberId;
  final String positionTitle;

  /// Legacy free-text department label (retained for back-compat).
  final String department;

  /// Structured link to a department (preferred over [department]).
  final String? departmentId;
  final String startDate;
  final String endDate;
  final String status;
  const MemberRole({
    required this.id,
    required this.memberId,
    required this.positionTitle,
    required this.department,
    this.departmentId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['member_id'] = Variable<String>(memberId);
    map['position_title'] = Variable<String>(positionTitle);
    map['department'] = Variable<String>(department);
    if (!nullToAbsent || departmentId != null) {
      map['department_id'] = Variable<String>(departmentId);
    }
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    map['status'] = Variable<String>(status);
    return map;
  }

  MemberRolesCompanion toCompanion(bool nullToAbsent) {
    return MemberRolesCompanion(
      id: Value(id),
      memberId: Value(memberId),
      positionTitle: Value(positionTitle),
      department: Value(department),
      departmentId: departmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(departmentId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
    );
  }

  factory MemberRole.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberRole(
      id: serializer.fromJson<String>(json['id']),
      memberId: serializer.fromJson<String>(json['memberId']),
      positionTitle: serializer.fromJson<String>(json['positionTitle']),
      department: serializer.fromJson<String>(json['department']),
      departmentId: serializer.fromJson<String?>(json['departmentId']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'memberId': serializer.toJson<String>(memberId),
      'positionTitle': serializer.toJson<String>(positionTitle),
      'department': serializer.toJson<String>(department),
      'departmentId': serializer.toJson<String?>(departmentId),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'status': serializer.toJson<String>(status),
    };
  }

  MemberRole copyWith({
    String? id,
    String? memberId,
    String? positionTitle,
    String? department,
    Value<String?> departmentId = const Value.absent(),
    String? startDate,
    String? endDate,
    String? status,
  }) => MemberRole(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    positionTitle: positionTitle ?? this.positionTitle,
    department: department ?? this.department,
    departmentId: departmentId.present ? departmentId.value : this.departmentId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    status: status ?? this.status,
  );
  MemberRole copyWithCompanion(MemberRolesCompanion data) {
    return MemberRole(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      positionTitle: data.positionTitle.present
          ? data.positionTitle.value
          : this.positionTitle,
      department: data.department.present
          ? data.department.value
          : this.department,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberRole(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('positionTitle: $positionTitle, ')
          ..write('department: $department, ')
          ..write('departmentId: $departmentId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    memberId,
    positionTitle,
    department,
    departmentId,
    startDate,
    endDate,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberRole &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.positionTitle == this.positionTitle &&
          other.department == this.department &&
          other.departmentId == this.departmentId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status);
}

class MemberRolesCompanion extends UpdateCompanion<MemberRole> {
  final Value<String> id;
  final Value<String> memberId;
  final Value<String> positionTitle;
  final Value<String> department;
  final Value<String?> departmentId;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<String> status;
  final Value<int> rowid;
  const MemberRolesCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.positionTitle = const Value.absent(),
    this.department = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberRolesCompanion.insert({
    required String id,
    required String memberId,
    required String positionTitle,
    this.department = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memberId = Value(memberId),
       positionTitle = Value(positionTitle);
  static Insertable<MemberRole> custom({
    Expression<String>? id,
    Expression<String>? memberId,
    Expression<String>? positionTitle,
    Expression<String>? department,
    Expression<String>? departmentId,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (positionTitle != null) 'position_title': positionTitle,
      if (department != null) 'department': department,
      if (departmentId != null) 'department_id': departmentId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberRolesCompanion copyWith({
    Value<String>? id,
    Value<String>? memberId,
    Value<String>? positionTitle,
    Value<String>? department,
    Value<String?>? departmentId,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return MemberRolesCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      positionTitle: positionTitle ?? this.positionTitle,
      department: department ?? this.department,
      departmentId: departmentId ?? this.departmentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (positionTitle.present) {
      map['position_title'] = Variable<String>(positionTitle.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberRolesCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('positionTitle: $positionTitle, ')
          ..write('department: $department, ')
          ..write('departmentId: $departmentId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeptActivitiesTable extends DeptActivities
    with TableInfo<$DeptActivitiesTable, DeptActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeptActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planned'),
  );
  static const VerificationMeta _attendanceMeta = const VerificationMeta(
    'attendance',
  );
  @override
  late final GeneratedColumn<int> attendance = GeneratedColumn<int>(
    'attendance',
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    departmentId,
    title,
    titleAr,
    description,
    date,
    status,
    attendance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dept_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeptActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
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
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attendance')) {
      context.handle(
        _attendanceMeta,
        attendance.isAcceptableOrUnknown(data['attendance']!, _attendanceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeptActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeptActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attendance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attendance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DeptActivitiesTable createAlias(String alias) {
    return $DeptActivitiesTable(attachedDatabase, alias);
  }
}

class DeptActivity extends DataClass implements Insertable<DeptActivity> {
  final String id;
  final String departmentId;
  final String title;
  final String titleAr;
  final String description;
  final String date;
  final String status;
  final int attendance;
  final DateTime createdAt;
  const DeptActivity({
    required this.id,
    required this.departmentId,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.date,
    required this.status,
    required this.attendance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['department_id'] = Variable<String>(departmentId);
    map['title'] = Variable<String>(title);
    map['title_ar'] = Variable<String>(titleAr);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<String>(date);
    map['status'] = Variable<String>(status);
    map['attendance'] = Variable<int>(attendance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DeptActivitiesCompanion toCompanion(bool nullToAbsent) {
    return DeptActivitiesCompanion(
      id: Value(id),
      departmentId: Value(departmentId),
      title: Value(title),
      titleAr: Value(titleAr),
      description: Value(description),
      date: Value(date),
      status: Value(status),
      attendance: Value(attendance),
      createdAt: Value(createdAt),
    );
  }

  factory DeptActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeptActivity(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      title: serializer.fromJson<String>(json['title']),
      titleAr: serializer.fromJson<String>(json['titleAr']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<String>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      attendance: serializer.fromJson<int>(json['attendance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String>(departmentId),
      'title': serializer.toJson<String>(title),
      'titleAr': serializer.toJson<String>(titleAr),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(status),
      'attendance': serializer.toJson<int>(attendance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DeptActivity copyWith({
    String? id,
    String? departmentId,
    String? title,
    String? titleAr,
    String? description,
    String? date,
    String? status,
    int? attendance,
    DateTime? createdAt,
  }) => DeptActivity(
    id: id ?? this.id,
    departmentId: departmentId ?? this.departmentId,
    title: title ?? this.title,
    titleAr: titleAr ?? this.titleAr,
    description: description ?? this.description,
    date: date ?? this.date,
    status: status ?? this.status,
    attendance: attendance ?? this.attendance,
    createdAt: createdAt ?? this.createdAt,
  );
  DeptActivity copyWithCompanion(DeptActivitiesCompanion data) {
    return DeptActivity(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      title: data.title.present ? data.title.value : this.title,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      attendance: data.attendance.present
          ? data.attendance.value
          : this.attendance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeptActivity(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('title: $title, ')
          ..write('titleAr: $titleAr, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('attendance: $attendance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    departmentId,
    title,
    titleAr,
    description,
    date,
    status,
    attendance,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeptActivity &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.title == this.title &&
          other.titleAr == this.titleAr &&
          other.description == this.description &&
          other.date == this.date &&
          other.status == this.status &&
          other.attendance == this.attendance &&
          other.createdAt == this.createdAt);
}

class DeptActivitiesCompanion extends UpdateCompanion<DeptActivity> {
  final Value<String> id;
  final Value<String> departmentId;
  final Value<String> title;
  final Value<String> titleAr;
  final Value<String> description;
  final Value<String> date;
  final Value<String> status;
  final Value<int> attendance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DeptActivitiesCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.title = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.attendance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeptActivitiesCompanion.insert({
    required String id,
    required String departmentId,
    required String title,
    this.titleAr = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.attendance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       departmentId = Value(departmentId),
       title = Value(title);
  static Insertable<DeptActivity> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? title,
    Expression<String>? titleAr,
    Expression<String>? description,
    Expression<String>? date,
    Expression<String>? status,
    Expression<int>? attendance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (title != null) 'title': title,
      if (titleAr != null) 'title_ar': titleAr,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (attendance != null) 'attendance': attendance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeptActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? departmentId,
    Value<String>? title,
    Value<String>? titleAr,
    Value<String>? description,
    Value<String>? date,
    Value<String>? status,
    Value<int>? attendance,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DeptActivitiesCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      attendance: attendance ?? this.attendance,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attendance.present) {
      map['attendance'] = Variable<int>(attendance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeptActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('title: $title, ')
          ..write('titleAr: $titleAr, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('attendance: $attendance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportsTable extends Reports with TableInfo<$ReportsTable, Report> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES departments (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _summaryArMeta = const VerificationMeta(
    'summaryAr',
  );
  @override
  late final GeneratedColumn<String> summaryAr = GeneratedColumn<String>(
    'summary_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('minutes'),
  );
  static const VerificationMeta _pagesMeta = const VerificationMeta('pages');
  @override
  late final GeneratedColumn<int> pages = GeneratedColumn<int>(
    'pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    departmentId,
    title,
    titleAr,
    summary,
    summaryAr,
    date,
    year,
    type,
    pages,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<Report> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('summary_ar')) {
      context.handle(
        _summaryArMeta,
        summaryAr.isAcceptableOrUnknown(data['summary_ar']!, _summaryArMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('pages')) {
      context.handle(
        _pagesMeta,
        pages.isAcceptableOrUnknown(data['pages']!, _pagesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Report map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Report(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      summaryAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_ar'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      pages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pages'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReportsTable createAlias(String alias) {
    return $ReportsTable(attachedDatabase, alias);
  }
}

class Report extends DataClass implements Insertable<Report> {
  final String id;
  final String departmentId;
  final String title;
  final String titleAr;
  final String summary;
  final String summaryAr;
  final String date;
  final int year;
  final String type;
  final int pages;
  final DateTime createdAt;
  const Report({
    required this.id,
    required this.departmentId,
    required this.title,
    required this.titleAr,
    required this.summary,
    required this.summaryAr,
    required this.date,
    required this.year,
    required this.type,
    required this.pages,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['department_id'] = Variable<String>(departmentId);
    map['title'] = Variable<String>(title);
    map['title_ar'] = Variable<String>(titleAr);
    map['summary'] = Variable<String>(summary);
    map['summary_ar'] = Variable<String>(summaryAr);
    map['date'] = Variable<String>(date);
    map['year'] = Variable<int>(year);
    map['type'] = Variable<String>(type);
    map['pages'] = Variable<int>(pages);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReportsCompanion toCompanion(bool nullToAbsent) {
    return ReportsCompanion(
      id: Value(id),
      departmentId: Value(departmentId),
      title: Value(title),
      titleAr: Value(titleAr),
      summary: Value(summary),
      summaryAr: Value(summaryAr),
      date: Value(date),
      year: Value(year),
      type: Value(type),
      pages: Value(pages),
      createdAt: Value(createdAt),
    );
  }

  factory Report.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Report(
      id: serializer.fromJson<String>(json['id']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      title: serializer.fromJson<String>(json['title']),
      titleAr: serializer.fromJson<String>(json['titleAr']),
      summary: serializer.fromJson<String>(json['summary']),
      summaryAr: serializer.fromJson<String>(json['summaryAr']),
      date: serializer.fromJson<String>(json['date']),
      year: serializer.fromJson<int>(json['year']),
      type: serializer.fromJson<String>(json['type']),
      pages: serializer.fromJson<int>(json['pages']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'departmentId': serializer.toJson<String>(departmentId),
      'title': serializer.toJson<String>(title),
      'titleAr': serializer.toJson<String>(titleAr),
      'summary': serializer.toJson<String>(summary),
      'summaryAr': serializer.toJson<String>(summaryAr),
      'date': serializer.toJson<String>(date),
      'year': serializer.toJson<int>(year),
      'type': serializer.toJson<String>(type),
      'pages': serializer.toJson<int>(pages),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Report copyWith({
    String? id,
    String? departmentId,
    String? title,
    String? titleAr,
    String? summary,
    String? summaryAr,
    String? date,
    int? year,
    String? type,
    int? pages,
    DateTime? createdAt,
  }) => Report(
    id: id ?? this.id,
    departmentId: departmentId ?? this.departmentId,
    title: title ?? this.title,
    titleAr: titleAr ?? this.titleAr,
    summary: summary ?? this.summary,
    summaryAr: summaryAr ?? this.summaryAr,
    date: date ?? this.date,
    year: year ?? this.year,
    type: type ?? this.type,
    pages: pages ?? this.pages,
    createdAt: createdAt ?? this.createdAt,
  );
  Report copyWithCompanion(ReportsCompanion data) {
    return Report(
      id: data.id.present ? data.id.value : this.id,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      title: data.title.present ? data.title.value : this.title,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      summary: data.summary.present ? data.summary.value : this.summary,
      summaryAr: data.summaryAr.present ? data.summaryAr.value : this.summaryAr,
      date: data.date.present ? data.date.value : this.date,
      year: data.year.present ? data.year.value : this.year,
      type: data.type.present ? data.type.value : this.type,
      pages: data.pages.present ? data.pages.value : this.pages,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Report(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('title: $title, ')
          ..write('titleAr: $titleAr, ')
          ..write('summary: $summary, ')
          ..write('summaryAr: $summaryAr, ')
          ..write('date: $date, ')
          ..write('year: $year, ')
          ..write('type: $type, ')
          ..write('pages: $pages, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    departmentId,
    title,
    titleAr,
    summary,
    summaryAr,
    date,
    year,
    type,
    pages,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Report &&
          other.id == this.id &&
          other.departmentId == this.departmentId &&
          other.title == this.title &&
          other.titleAr == this.titleAr &&
          other.summary == this.summary &&
          other.summaryAr == this.summaryAr &&
          other.date == this.date &&
          other.year == this.year &&
          other.type == this.type &&
          other.pages == this.pages &&
          other.createdAt == this.createdAt);
}

class ReportsCompanion extends UpdateCompanion<Report> {
  final Value<String> id;
  final Value<String> departmentId;
  final Value<String> title;
  final Value<String> titleAr;
  final Value<String> summary;
  final Value<String> summaryAr;
  final Value<String> date;
  final Value<int> year;
  final Value<String> type;
  final Value<int> pages;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReportsCompanion({
    this.id = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.title = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.summary = const Value.absent(),
    this.summaryAr = const Value.absent(),
    this.date = const Value.absent(),
    this.year = const Value.absent(),
    this.type = const Value.absent(),
    this.pages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsCompanion.insert({
    required String id,
    required String departmentId,
    required String title,
    this.titleAr = const Value.absent(),
    this.summary = const Value.absent(),
    this.summaryAr = const Value.absent(),
    this.date = const Value.absent(),
    this.year = const Value.absent(),
    this.type = const Value.absent(),
    this.pages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       departmentId = Value(departmentId),
       title = Value(title);
  static Insertable<Report> custom({
    Expression<String>? id,
    Expression<String>? departmentId,
    Expression<String>? title,
    Expression<String>? titleAr,
    Expression<String>? summary,
    Expression<String>? summaryAr,
    Expression<String>? date,
    Expression<int>? year,
    Expression<String>? type,
    Expression<int>? pages,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (departmentId != null) 'department_id': departmentId,
      if (title != null) 'title': title,
      if (titleAr != null) 'title_ar': titleAr,
      if (summary != null) 'summary': summary,
      if (summaryAr != null) 'summary_ar': summaryAr,
      if (date != null) 'date': date,
      if (year != null) 'year': year,
      if (type != null) 'type': type,
      if (pages != null) 'pages': pages,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? departmentId,
    Value<String>? title,
    Value<String>? titleAr,
    Value<String>? summary,
    Value<String>? summaryAr,
    Value<String>? date,
    Value<int>? year,
    Value<String>? type,
    Value<int>? pages,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReportsCompanion(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      summary: summary ?? this.summary,
      summaryAr: summaryAr ?? this.summaryAr,
      date: date ?? this.date,
      year: year ?? this.year,
      type: type ?? this.type,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (summaryAr.present) {
      map['summary_ar'] = Variable<String>(summaryAr.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pages.present) {
      map['pages'] = Variable<int>(pages.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCompanion(')
          ..write('id: $id, ')
          ..write('departmentId: $departmentId, ')
          ..write('title: $title, ')
          ..write('titleAr: $titleAr, ')
          ..write('summary: $summary, ')
          ..write('summaryAr: $summaryAr, ')
          ..write('date: $date, ')
          ..write('year: $year, ')
          ..write('type: $type, ')
          ..write('pages: $pages, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GalleryPhotosTable extends GalleryPhotos
    with TableInfo<$GalleryPhotosTable, GalleryPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GalleryPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _eventMeta = const VerificationMeta('event');
  @override
  late final GeneratedColumn<String> event = GeneratedColumn<String>(
    'event',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _eventArMeta = const VerificationMeta(
    'eventAr',
  );
  @override
  late final GeneratedColumn<String> eventAr = GeneratedColumn<String>(
    'event_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('photo'),
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<int> accent = GeneratedColumn<int>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0B5D3B),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _heightHintMeta = const VerificationMeta(
    'heightHint',
  );
  @override
  late final GeneratedColumn<int> heightHint = GeneratedColumn<int>(
    'height_hint',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(220),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleAr,
    year,
    event,
    eventAr,
    iconKey,
    accent,
    imagePath,
    heightHint,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gallery_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<GalleryPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('event')) {
      context.handle(
        _eventMeta,
        event.isAcceptableOrUnknown(data['event']!, _eventMeta),
      );
    }
    if (data.containsKey('event_ar')) {
      context.handle(
        _eventArMeta,
        eventAr.isAcceptableOrUnknown(data['event_ar']!, _eventArMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('height_hint')) {
      context.handle(
        _heightHintMeta,
        heightHint.isAcceptableOrUnknown(data['height_hint']!, _heightHintMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GalleryPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GalleryPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      event: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event'],
      )!,
      eventAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_ar'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      heightHint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_hint'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GalleryPhotosTable createAlias(String alias) {
    return $GalleryPhotosTable(attachedDatabase, alias);
  }
}

class GalleryPhoto extends DataClass implements Insertable<GalleryPhoto> {
  final String id;
  final String title;
  final String titleAr;
  final int year;
  final String event;
  final String eventAr;
  final String iconKey;
  final int accent;
  final String imagePath;
  final int heightHint;
  final DateTime createdAt;
  const GalleryPhoto({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.year,
    required this.event,
    required this.eventAr,
    required this.iconKey,
    required this.accent,
    required this.imagePath,
    required this.heightHint,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_ar'] = Variable<String>(titleAr);
    map['year'] = Variable<int>(year);
    map['event'] = Variable<String>(event);
    map['event_ar'] = Variable<String>(eventAr);
    map['icon_key'] = Variable<String>(iconKey);
    map['accent'] = Variable<int>(accent);
    map['image_path'] = Variable<String>(imagePath);
    map['height_hint'] = Variable<int>(heightHint);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GalleryPhotosCompanion toCompanion(bool nullToAbsent) {
    return GalleryPhotosCompanion(
      id: Value(id),
      title: Value(title),
      titleAr: Value(titleAr),
      year: Value(year),
      event: Value(event),
      eventAr: Value(eventAr),
      iconKey: Value(iconKey),
      accent: Value(accent),
      imagePath: Value(imagePath),
      heightHint: Value(heightHint),
      createdAt: Value(createdAt),
    );
  }

  factory GalleryPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GalleryPhoto(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleAr: serializer.fromJson<String>(json['titleAr']),
      year: serializer.fromJson<int>(json['year']),
      event: serializer.fromJson<String>(json['event']),
      eventAr: serializer.fromJson<String>(json['eventAr']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      accent: serializer.fromJson<int>(json['accent']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      heightHint: serializer.fromJson<int>(json['heightHint']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleAr': serializer.toJson<String>(titleAr),
      'year': serializer.toJson<int>(year),
      'event': serializer.toJson<String>(event),
      'eventAr': serializer.toJson<String>(eventAr),
      'iconKey': serializer.toJson<String>(iconKey),
      'accent': serializer.toJson<int>(accent),
      'imagePath': serializer.toJson<String>(imagePath),
      'heightHint': serializer.toJson<int>(heightHint),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GalleryPhoto copyWith({
    String? id,
    String? title,
    String? titleAr,
    int? year,
    String? event,
    String? eventAr,
    String? iconKey,
    int? accent,
    String? imagePath,
    int? heightHint,
    DateTime? createdAt,
  }) => GalleryPhoto(
    id: id ?? this.id,
    title: title ?? this.title,
    titleAr: titleAr ?? this.titleAr,
    year: year ?? this.year,
    event: event ?? this.event,
    eventAr: eventAr ?? this.eventAr,
    iconKey: iconKey ?? this.iconKey,
    accent: accent ?? this.accent,
    imagePath: imagePath ?? this.imagePath,
    heightHint: heightHint ?? this.heightHint,
    createdAt: createdAt ?? this.createdAt,
  );
  GalleryPhoto copyWithCompanion(GalleryPhotosCompanion data) {
    return GalleryPhoto(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      year: data.year.present ? data.year.value : this.year,
      event: data.event.present ? data.event.value : this.event,
      eventAr: data.eventAr.present ? data.eventAr.value : this.eventAr,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      accent: data.accent.present ? data.accent.value : this.accent,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      heightHint: data.heightHint.present
          ? data.heightHint.value
          : this.heightHint,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GalleryPhoto(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleAr: $titleAr, ')
          ..write('year: $year, ')
          ..write('event: $event, ')
          ..write('eventAr: $eventAr, ')
          ..write('iconKey: $iconKey, ')
          ..write('accent: $accent, ')
          ..write('imagePath: $imagePath, ')
          ..write('heightHint: $heightHint, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleAr,
    year,
    event,
    eventAr,
    iconKey,
    accent,
    imagePath,
    heightHint,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GalleryPhoto &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleAr == this.titleAr &&
          other.year == this.year &&
          other.event == this.event &&
          other.eventAr == this.eventAr &&
          other.iconKey == this.iconKey &&
          other.accent == this.accent &&
          other.imagePath == this.imagePath &&
          other.heightHint == this.heightHint &&
          other.createdAt == this.createdAt);
}

class GalleryPhotosCompanion extends UpdateCompanion<GalleryPhoto> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleAr;
  final Value<int> year;
  final Value<String> event;
  final Value<String> eventAr;
  final Value<String> iconKey;
  final Value<int> accent;
  final Value<String> imagePath;
  final Value<int> heightHint;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GalleryPhotosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.year = const Value.absent(),
    this.event = const Value.absent(),
    this.eventAr = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.accent = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.heightHint = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GalleryPhotosCompanion.insert({
    required String id,
    required String title,
    this.titleAr = const Value.absent(),
    this.year = const Value.absent(),
    this.event = const Value.absent(),
    this.eventAr = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.accent = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.heightHint = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<GalleryPhoto> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleAr,
    Expression<int>? year,
    Expression<String>? event,
    Expression<String>? eventAr,
    Expression<String>? iconKey,
    Expression<int>? accent,
    Expression<String>? imagePath,
    Expression<int>? heightHint,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleAr != null) 'title_ar': titleAr,
      if (year != null) 'year': year,
      if (event != null) 'event': event,
      if (eventAr != null) 'event_ar': eventAr,
      if (iconKey != null) 'icon_key': iconKey,
      if (accent != null) 'accent': accent,
      if (imagePath != null) 'image_path': imagePath,
      if (heightHint != null) 'height_hint': heightHint,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GalleryPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? titleAr,
    Value<int>? year,
    Value<String>? event,
    Value<String>? eventAr,
    Value<String>? iconKey,
    Value<int>? accent,
    Value<String>? imagePath,
    Value<int>? heightHint,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GalleryPhotosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      year: year ?? this.year,
      event: event ?? this.event,
      eventAr: eventAr ?? this.eventAr,
      iconKey: iconKey ?? this.iconKey,
      accent: accent ?? this.accent,
      imagePath: imagePath ?? this.imagePath,
      heightHint: heightHint ?? this.heightHint,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (event.present) {
      map['event'] = Variable<String>(event.value);
    }
    if (eventAr.present) {
      map['event_ar'] = Variable<String>(eventAr.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (accent.present) {
      map['accent'] = Variable<int>(accent.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (heightHint.present) {
      map['height_hint'] = Variable<int>(heightHint.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GalleryPhotosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleAr: $titleAr, ')
          ..write('year: $year, ')
          ..write('event: $event, ')
          ..write('eventAr: $eventAr, ')
          ..write('iconKey: $iconKey, ')
          ..write('accent: $accent, ')
          ..write('imagePath: $imagePath, ')
          ..write('heightHint: $heightHint, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $LeadersTable leaders = $LeadersTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $TarbiyaAreasTable tarbiyaAreas = $TarbiyaAreasTable(this);
  late final $ShubasTable shubas = $ShubasTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $MemberChildrenTable memberChildren = $MemberChildrenTable(this);
  late final $MemberEducationTable memberEducation = $MemberEducationTable(
    this,
  );
  late final $MemberActivitiesTable memberActivities = $MemberActivitiesTable(
    this,
  );
  late final $MemberContributionsTable memberContributions =
      $MemberContributionsTable(this);
  late final $MemberTasedTable memberTased = $MemberTasedTable(this);
  late final $MemberDonationsTable memberDonations = $MemberDonationsTable(
    this,
  );
  late final $MemberRolesTable memberRoles = $MemberRolesTable(this);
  late final $DeptActivitiesTable deptActivities = $DeptActivitiesTable(this);
  late final $ReportsTable reports = $ReportsTable(this);
  late final $GalleryPhotosTable galleryPhotos = $GalleryPhotosTable(this);
  late final Index idxUsersDepartment = Index(
    'idx_users_department',
    'CREATE INDEX idx_users_department ON users (department_id)',
  );
  late final Index idxLeadersCategory = Index(
    'idx_leaders_category',
    'CREATE INDEX idx_leaders_category ON leaders (category, sort_order)',
  );
  late final Index idxAuditTimestamp = Index(
    'idx_audit_timestamp',
    'CREATE INDEX idx_audit_timestamp ON audit_logs (timestamp)',
  );
  late final Index idxShubasArea = Index(
    'idx_shubas_area',
    'CREATE INDEX idx_shubas_area ON shubas (area_id)',
  );
  late final Index idxMembersShubaLevel = Index(
    'idx_members_shuba_level',
    'CREATE INDEX idx_members_shuba_level ON members (shuba_id, level)',
  );
  late final Index idxMembersNaqib = Index(
    'idx_members_naqib',
    'CREATE INDEX idx_members_naqib ON members (naqib_member_id)',
  );
  late final Index idxMemberChildrenMember = Index(
    'idx_member_children_member',
    'CREATE INDEX idx_member_children_member ON member_children (member_id)',
  );
  late final Index idxMemberEducationMember = Index(
    'idx_member_education_member',
    'CREATE INDEX idx_member_education_member ON member_education (member_id)',
  );
  late final Index idxMemberActivitiesMember = Index(
    'idx_member_activities_member',
    'CREATE INDEX idx_member_activities_member ON member_activities (member_id)',
  );
  late final Index idxMemberContributionsMember = Index(
    'idx_member_contributions_member',
    'CREATE INDEX idx_member_contributions_member ON member_contributions (member_id)',
  );
  late final Index idxMemberTasedMember = Index(
    'idx_member_tased_member',
    'CREATE INDEX idx_member_tased_member ON member_tased (member_id)',
  );
  late final Index idxMemberDonationsMemberYear = Index(
    'idx_member_donations_member_year',
    'CREATE INDEX idx_member_donations_member_year ON member_donations (member_id, year)',
  );
  late final Index idxMemberRolesMember = Index(
    'idx_member_roles_member',
    'CREATE INDEX idx_member_roles_member ON member_roles (member_id)',
  );
  late final Index idxDeptActivitiesDept = Index(
    'idx_dept_activities_dept',
    'CREATE INDEX idx_dept_activities_dept ON dept_activities (department_id)',
  );
  late final Index idxReportsDeptYear = Index(
    'idx_reports_dept_year',
    'CREATE INDEX idx_reports_dept_year ON reports (department_id, year)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    departments,
    users,
    leaders,
    auditLogs,
    tarbiyaAreas,
    shubas,
    members,
    memberChildren,
    memberEducation,
    memberActivities,
    memberContributions,
    memberTased,
    memberDonations,
    memberRoles,
    deptActivities,
    reports,
    galleryPhotos,
    idxUsersDepartment,
    idxLeadersCategory,
    idxAuditTimestamp,
    idxShubasArea,
    idxMembersShubaLevel,
    idxMembersNaqib,
    idxMemberChildrenMember,
    idxMemberEducationMember,
    idxMemberActivitiesMember,
    idxMemberContributionsMember,
    idxMemberTasedMember,
    idxMemberDonationsMemberYear,
    idxMemberRolesMember,
    idxDeptActivitiesDept,
    idxReportsDeptYear,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'departments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('users', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('audit_logs', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('members', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_children', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_education', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_activities', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_contributions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_tased', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_donations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_roles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'departments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('member_roles', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'departments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dept_activities', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DepartmentsTableCreateCompanionBuilder =
    DepartmentsCompanion Function({
      required String id,
      required String name,
      Value<String> nameAr,
      Value<String> description,
      Value<String> descriptionAr,
      Value<String> iconKey,
      Value<int> accent,
      Value<String> headName,
      Value<String> headNameAr,
      Value<String> contactEmail,
      Value<String> contactPhone,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DepartmentsTableUpdateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> nameAr,
      Value<String> description,
      Value<String> descriptionAr,
      Value<String> iconKey,
      Value<int> accent,
      Value<String> headName,
      Value<String> headNameAr,
      Value<String> contactEmail,
      Value<String> contactPhone,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$DepartmentsTableReferences
    extends BaseReferences<_$AppDatabase, $DepartmentsTable, Department> {
  $$DepartmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UsersTable, List<User>> _usersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.users,
    aliasName: 'departments__id__users__department_id',
  );

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberRolesTable, List<MemberRole>>
  _memberRolesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberRoles,
    aliasName: 'departments__id__member_roles__department_id',
  );

  $$MemberRolesTableProcessedTableManager get memberRolesRefs {
    final manager = $$MemberRolesTableTableManager(
      $_db,
      $_db.memberRoles,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_memberRolesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeptActivitiesTable, List<DeptActivity>>
  _deptActivitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deptActivities,
    aliasName: 'departments__id__dept_activities__department_id',
  );

  $$DeptActivitiesTableProcessedTableManager get deptActivitiesRefs {
    final manager = $$DeptActivitiesTableTableManager(
      $_db,
      $_db.deptActivities,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deptActivitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReportsTable, List<Report>> _reportsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reports,
    aliasName: 'departments__id__reports__department_id',
  );

  $$ReportsTableProcessedTableManager get reportsRefs {
    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.departmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
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

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionAr => $composableBuilder(
    column: $table.descriptionAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headName => $composableBuilder(
    column: $table.headName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headNameAr => $composableBuilder(
    column: $table.headNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> usersRefs(
    Expression<bool> Function($$UsersTableFilterComposer f) f,
  ) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberRolesRefs(
    Expression<bool> Function($$MemberRolesTableFilterComposer f) f,
  ) {
    final $$MemberRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberRoles,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberRolesTableFilterComposer(
            $db: $db,
            $table: $db.memberRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deptActivitiesRefs(
    Expression<bool> Function($$DeptActivitiesTableFilterComposer f) f,
  ) {
    final $$DeptActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deptActivities,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeptActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.deptActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reportsRefs(
    Expression<bool> Function($$ReportsTableFilterComposer f) f,
  ) {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
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

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionAr => $composableBuilder(
    column: $table.descriptionAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headName => $composableBuilder(
    column: $table.headName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headNameAr => $composableBuilder(
    column: $table.headNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionAr => $composableBuilder(
    column: $table.descriptionAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<String> get headName =>
      $composableBuilder(column: $table.headName, builder: (column) => column);

  GeneratedColumn<String> get headNameAr => $composableBuilder(
    column: $table.headNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactEmail => $composableBuilder(
    column: $table.contactEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactPhone => $composableBuilder(
    column: $table.contactPhone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> usersRefs<T extends Object>(
    Expression<T> Function($$UsersTableAnnotationComposer a) f,
  ) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberRolesRefs<T extends Object>(
    Expression<T> Function($$MemberRolesTableAnnotationComposer a) f,
  ) {
    final $$MemberRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberRoles,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.memberRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deptActivitiesRefs<T extends Object>(
    Expression<T> Function($$DeptActivitiesTableAnnotationComposer a) f,
  ) {
    final $$DeptActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deptActivities,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeptActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.deptActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reportsRefs<T extends Object>(
    Expression<T> Function($$ReportsTableAnnotationComposer a) f,
  ) {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.departmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentsTable,
          Department,
          $$DepartmentsTableFilterComposer,
          $$DepartmentsTableOrderingComposer,
          $$DepartmentsTableAnnotationComposer,
          $$DepartmentsTableCreateCompanionBuilder,
          $$DepartmentsTableUpdateCompanionBuilder,
          (Department, $$DepartmentsTableReferences),
          Department,
          PrefetchHooks Function({
            bool usersRefs,
            bool memberRolesRefs,
            bool deptActivitiesRefs,
            bool reportsRefs,
          })
        > {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> descriptionAr = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<String> headName = const Value.absent(),
                Value<String> headNameAr = const Value.absent(),
                Value<String> contactEmail = const Value.absent(),
                Value<String> contactPhone = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion(
                id: id,
                name: name,
                nameAr: nameAr,
                description: description,
                descriptionAr: descriptionAr,
                iconKey: iconKey,
                accent: accent,
                headName: headName,
                headNameAr: headNameAr,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> nameAr = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> descriptionAr = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<String> headName = const Value.absent(),
                Value<String> headNameAr = const Value.absent(),
                Value<String> contactEmail = const Value.absent(),
                Value<String> contactPhone = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion.insert(
                id: id,
                name: name,
                nameAr: nameAr,
                description: description,
                descriptionAr: descriptionAr,
                iconKey: iconKey,
                accent: accent,
                headName: headName,
                headNameAr: headNameAr,
                contactEmail: contactEmail,
                contactPhone: contactPhone,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepartmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                usersRefs = false,
                memberRolesRefs = false,
                deptActivitiesRefs = false,
                reportsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (usersRefs) db.users,
                    if (memberRolesRefs) db.memberRoles,
                    if (deptActivitiesRefs) db.deptActivities,
                    if (reportsRefs) db.reports,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (usersRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          User
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._usersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).usersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberRolesRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          MemberRole
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._memberRolesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).memberRolesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deptActivitiesRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          DeptActivity
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._deptActivitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).deptActivitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reportsRefs)
                        await $_getPrefetchedData<
                          Department,
                          $DepartmentsTable,
                          Report
                        >(
                          currentTable: table,
                          referencedTable: $$DepartmentsTableReferences
                              ._reportsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DepartmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.departmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentsTable,
      Department,
      $$DepartmentsTableFilterComposer,
      $$DepartmentsTableOrderingComposer,
      $$DepartmentsTableAnnotationComposer,
      $$DepartmentsTableCreateCompanionBuilder,
      $$DepartmentsTableUpdateCompanionBuilder,
      (Department, $$DepartmentsTableReferences),
      Department,
      PrefetchHooks Function({
        bool usersRefs,
        bool memberRolesRefs,
        bool deptActivitiesRefs,
        bool reportsRefs,
      })
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String fullName,
      required String fullNameAr,
      required String username,
      Value<String> email,
      required String passwordHash,
      required String roleCode,
      Value<String?> departmentId,
      Value<bool> active,
      Value<DateTime?> lastActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String> fullNameAr,
      Value<String> username,
      Value<String> email,
      Value<String> passwordHash,
      Value<String> roleCode,
      Value<String?> departmentId,
      Value<bool> active,
      Value<DateTime?> lastActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias('users__department_id__departments__id');

  $$DepartmentsTableProcessedTableManager? get departmentId {
    final $_column = $_itemColumn<String>('department_id');
    if ($_column == null) return null;
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AuditLogsTable, List<AuditLog>>
  _auditLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditLogs,
    aliasName: 'users__id__audit_logs__user_id',
  );

  $$AuditLogsTableProcessedTableManager get auditLogsRefs {
    final manager = $$AuditLogsTableTableManager(
      $_db,
      $_db.auditLogs,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullNameAr => $composableBuilder(
    column: $table.fullNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleCode => $composableBuilder(
    column: $table.roleCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActive => $composableBuilder(
    column: $table.lastActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> auditLogsRefs(
    Expression<bool> Function($$AuditLogsTableFilterComposer f) f,
  ) {
    final $$AuditLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditLogs,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditLogsTableFilterComposer(
            $db: $db,
            $table: $db.auditLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullNameAr => $composableBuilder(
    column: $table.fullNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleCode => $composableBuilder(
    column: $table.roleCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActive => $composableBuilder(
    column: $table.lastActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get fullNameAr => $composableBuilder(
    column: $table.fullNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roleCode =>
      $composableBuilder(column: $table.roleCode, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get lastActive => $composableBuilder(
    column: $table.lastActive,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> auditLogsRefs<T extends Object>(
    Expression<T> Function($$AuditLogsTableAnnotationComposer a) f,
  ) {
    final $$AuditLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditLogs,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.auditLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool departmentId, bool auditLogsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> fullNameAr = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> roleCode = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> lastActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                fullName: fullName,
                fullNameAr: fullNameAr,
                username: username,
                email: email,
                passwordHash: passwordHash,
                roleCode: roleCode,
                departmentId: departmentId,
                active: active,
                lastActive: lastActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                required String fullNameAr,
                required String username,
                Value<String> email = const Value.absent(),
                required String passwordHash,
                required String roleCode,
                Value<String?> departmentId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> lastActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                fullName: fullName,
                fullNameAr: fullNameAr,
                username: username,
                email: email,
                passwordHash: passwordHash,
                roleCode: roleCode,
                departmentId: departmentId,
                active: active,
                lastActive: lastActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({departmentId = false, auditLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (auditLogsRefs) db.auditLogs],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (departmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.departmentId,
                                    referencedTable: $$UsersTableReferences
                                        ._departmentIdTable(db),
                                    referencedColumn: $$UsersTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (auditLogsRefs)
                        await $_getPrefetchedData<User, $UsersTable, AuditLog>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._auditLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).auditLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool departmentId, bool auditLogsRefs})
    >;
typedef $$LeadersTableCreateCompanionBuilder =
    LeadersCompanion Function({
      required String id,
      required String name,
      required String nameAr,
      required String position,
      required String positionAr,
      required String category,
      Value<String> serviceYears,
      Value<String> bio,
      Value<String> bioAr,
      Value<String> achievements,
      Value<String> achievementsAr,
      Value<String> responsibilities,
      Value<String> responsibilitiesAr,
      Value<String> email,
      Value<String> phone,
      Value<int> accent,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LeadersTableUpdateCompanionBuilder =
    LeadersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> nameAr,
      Value<String> position,
      Value<String> positionAr,
      Value<String> category,
      Value<String> serviceYears,
      Value<String> bio,
      Value<String> bioAr,
      Value<String> achievements,
      Value<String> achievementsAr,
      Value<String> responsibilities,
      Value<String> responsibilitiesAr,
      Value<String> email,
      Value<String> phone,
      Value<int> accent,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LeadersTableFilterComposer
    extends Composer<_$AppDatabase, $LeadersTable> {
  $$LeadersTableFilterComposer({
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

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get positionAr => $composableBuilder(
    column: $table.positionAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceYears => $composableBuilder(
    column: $table.serviceYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bioAr => $composableBuilder(
    column: $table.bioAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievements => $composableBuilder(
    column: $table.achievements,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementsAr => $composableBuilder(
    column: $table.achievementsAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsibilities => $composableBuilder(
    column: $table.responsibilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsibilitiesAr => $composableBuilder(
    column: $table.responsibilitiesAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeadersTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadersTable> {
  $$LeadersTableOrderingComposer({
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

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get positionAr => $composableBuilder(
    column: $table.positionAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceYears => $composableBuilder(
    column: $table.serviceYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bioAr => $composableBuilder(
    column: $table.bioAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievements => $composableBuilder(
    column: $table.achievements,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementsAr => $composableBuilder(
    column: $table.achievementsAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsibilities => $composableBuilder(
    column: $table.responsibilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsibilitiesAr => $composableBuilder(
    column: $table.responsibilitiesAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeadersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadersTable> {
  $$LeadersTableAnnotationComposer({
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

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get positionAr => $composableBuilder(
    column: $table.positionAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get serviceYears => $composableBuilder(
    column: $table.serviceYears,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get bioAr =>
      $composableBuilder(column: $table.bioAr, builder: (column) => column);

  GeneratedColumn<String> get achievements => $composableBuilder(
    column: $table.achievements,
    builder: (column) => column,
  );

  GeneratedColumn<String> get achievementsAr => $composableBuilder(
    column: $table.achievementsAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responsibilities => $composableBuilder(
    column: $table.responsibilities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responsibilitiesAr => $composableBuilder(
    column: $table.responsibilitiesAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<int> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LeadersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadersTable,
          Leader,
          $$LeadersTableFilterComposer,
          $$LeadersTableOrderingComposer,
          $$LeadersTableAnnotationComposer,
          $$LeadersTableCreateCompanionBuilder,
          $$LeadersTableUpdateCompanionBuilder,
          (Leader, BaseReferences<_$AppDatabase, $LeadersTable, Leader>),
          Leader,
          PrefetchHooks Function()
        > {
  $$LeadersTableTableManager(_$AppDatabase db, $LeadersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<String> positionAr = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> serviceYears = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<String> bioAr = const Value.absent(),
                Value<String> achievements = const Value.absent(),
                Value<String> achievementsAr = const Value.absent(),
                Value<String> responsibilities = const Value.absent(),
                Value<String> responsibilitiesAr = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadersCompanion(
                id: id,
                name: name,
                nameAr: nameAr,
                position: position,
                positionAr: positionAr,
                category: category,
                serviceYears: serviceYears,
                bio: bio,
                bioAr: bioAr,
                achievements: achievements,
                achievementsAr: achievementsAr,
                responsibilities: responsibilities,
                responsibilitiesAr: responsibilitiesAr,
                email: email,
                phone: phone,
                accent: accent,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String nameAr,
                required String position,
                required String positionAr,
                required String category,
                Value<String> serviceYears = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<String> bioAr = const Value.absent(),
                Value<String> achievements = const Value.absent(),
                Value<String> achievementsAr = const Value.absent(),
                Value<String> responsibilities = const Value.absent(),
                Value<String> responsibilitiesAr = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadersCompanion.insert(
                id: id,
                name: name,
                nameAr: nameAr,
                position: position,
                positionAr: positionAr,
                category: category,
                serviceYears: serviceYears,
                bio: bio,
                bioAr: bioAr,
                achievements: achievements,
                achievementsAr: achievementsAr,
                responsibilities: responsibilities,
                responsibilitiesAr: responsibilitiesAr,
                email: email,
                phone: phone,
                accent: accent,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeadersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadersTable,
      Leader,
      $$LeadersTableFilterComposer,
      $$LeadersTableOrderingComposer,
      $$LeadersTableAnnotationComposer,
      $$LeadersTableCreateCompanionBuilder,
      $$LeadersTableUpdateCompanionBuilder,
      (Leader, BaseReferences<_$AppDatabase, $LeadersTable, Leader>),
      Leader,
      PrefetchHooks Function()
    >;
typedef $$AuditLogsTableCreateCompanionBuilder =
    AuditLogsCompanion Function({
      required String id,
      required String username,
      Value<String?> userId,
      required String action,
      Value<String> actionAr,
      required String module,
      Value<String> moduleAr,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });
typedef $$AuditLogsTableUpdateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<String> id,
      Value<String> username,
      Value<String?> userId,
      Value<String> action,
      Value<String> actionAr,
      Value<String> module,
      Value<String> moduleAr,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

final class $$AuditLogsTableReferences
    extends BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog> {
  $$AuditLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('audit_logs__user_id__users__id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionAr => $composableBuilder(
    column: $table.actionAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleAr => $composableBuilder(
    column: $table.moduleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionAr => $composableBuilder(
    column: $table.actionAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleAr => $composableBuilder(
    column: $table.moduleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get actionAr =>
      $composableBuilder(column: $table.actionAr, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<String> get moduleAr =>
      $composableBuilder(column: $table.moduleAr, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (AuditLog, $$AuditLogsTableReferences),
          AuditLog,
          PrefetchHooks Function({bool userId})
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
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> actionAr = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<String> moduleAr = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogsCompanion(
                id: id,
                username: username,
                userId: userId,
                action: action,
                actionAr: actionAr,
                module: module,
                moduleAr: moduleAr,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String username,
                Value<String?> userId = const Value.absent(),
                required String action,
                Value<String> actionAr = const Value.absent(),
                required String module,
                Value<String> moduleAr = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogsCompanion.insert(
                id: id,
                username: username,
                userId: userId,
                action: action,
                actionAr: actionAr,
                module: module,
                moduleAr: moduleAr,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$AuditLogsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$AuditLogsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (AuditLog, $$AuditLogsTableReferences),
      AuditLog,
      PrefetchHooks Function({bool userId})
    >;
typedef $$TarbiyaAreasTableCreateCompanionBuilder =
    TarbiyaAreasCompanion Function({
      required String id,
      required String name,
      Value<String> nameAr,
      Value<String> region,
      Value<String> regionAr,
      Value<int> accent,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TarbiyaAreasTableUpdateCompanionBuilder =
    TarbiyaAreasCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> nameAr,
      Value<String> region,
      Value<String> regionAr,
      Value<int> accent,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TarbiyaAreasTableReferences
    extends BaseReferences<_$AppDatabase, $TarbiyaAreasTable, TarbiyaArea> {
  $$TarbiyaAreasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShubasTable, List<Shuba>> _shubasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.shubas,
    aliasName: 'tarbiya_areas__id__shubas__area_id',
  );

  $$ShubasTableProcessedTableManager get shubasRefs {
    final manager = $$ShubasTableTableManager(
      $_db,
      $_db.shubas,
    ).filter((f) => f.areaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shubasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TarbiyaAreasTableFilterComposer
    extends Composer<_$AppDatabase, $TarbiyaAreasTable> {
  $$TarbiyaAreasTableFilterComposer({
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

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regionAr => $composableBuilder(
    column: $table.regionAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shubasRefs(
    Expression<bool> Function($$ShubasTableFilterComposer f) f,
  ) {
    final $$ShubasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shubas,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShubasTableFilterComposer(
            $db: $db,
            $table: $db.shubas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TarbiyaAreasTableOrderingComposer
    extends Composer<_$AppDatabase, $TarbiyaAreasTable> {
  $$TarbiyaAreasTableOrderingComposer({
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

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regionAr => $composableBuilder(
    column: $table.regionAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TarbiyaAreasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TarbiyaAreasTable> {
  $$TarbiyaAreasTableAnnotationComposer({
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

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get regionAr =>
      $composableBuilder(column: $table.regionAr, builder: (column) => column);

  GeneratedColumn<int> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> shubasRefs<T extends Object>(
    Expression<T> Function($$ShubasTableAnnotationComposer a) f,
  ) {
    final $$ShubasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shubas,
      getReferencedColumn: (t) => t.areaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShubasTableAnnotationComposer(
            $db: $db,
            $table: $db.shubas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TarbiyaAreasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TarbiyaAreasTable,
          TarbiyaArea,
          $$TarbiyaAreasTableFilterComposer,
          $$TarbiyaAreasTableOrderingComposer,
          $$TarbiyaAreasTableAnnotationComposer,
          $$TarbiyaAreasTableCreateCompanionBuilder,
          $$TarbiyaAreasTableUpdateCompanionBuilder,
          (TarbiyaArea, $$TarbiyaAreasTableReferences),
          TarbiyaArea,
          PrefetchHooks Function({bool shubasRefs})
        > {
  $$TarbiyaAreasTableTableManager(_$AppDatabase db, $TarbiyaAreasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TarbiyaAreasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TarbiyaAreasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TarbiyaAreasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<String> regionAr = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TarbiyaAreasCompanion(
                id: id,
                name: name,
                nameAr: nameAr,
                region: region,
                regionAr: regionAr,
                accent: accent,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> nameAr = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<String> regionAr = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TarbiyaAreasCompanion.insert(
                id: id,
                name: name,
                nameAr: nameAr,
                region: region,
                regionAr: regionAr,
                accent: accent,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TarbiyaAreasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shubasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (shubasRefs) db.shubas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shubasRefs)
                    await $_getPrefetchedData<
                      TarbiyaArea,
                      $TarbiyaAreasTable,
                      Shuba
                    >(
                      currentTable: table,
                      referencedTable: $$TarbiyaAreasTableReferences
                          ._shubasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TarbiyaAreasTableReferences(
                            db,
                            table,
                            p0,
                          ).shubasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.areaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TarbiyaAreasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TarbiyaAreasTable,
      TarbiyaArea,
      $$TarbiyaAreasTableFilterComposer,
      $$TarbiyaAreasTableOrderingComposer,
      $$TarbiyaAreasTableAnnotationComposer,
      $$TarbiyaAreasTableCreateCompanionBuilder,
      $$TarbiyaAreasTableUpdateCompanionBuilder,
      (TarbiyaArea, $$TarbiyaAreasTableReferences),
      TarbiyaArea,
      PrefetchHooks Function({bool shubasRefs})
    >;
typedef $$ShubasTableCreateCompanionBuilder =
    ShubasCompanion Function({
      required String id,
      required String areaId,
      required String name,
      Value<String> nameAr,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ShubasTableUpdateCompanionBuilder =
    ShubasCompanion Function({
      Value<String> id,
      Value<String> areaId,
      Value<String> name,
      Value<String> nameAr,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$ShubasTableReferences
    extends BaseReferences<_$AppDatabase, $ShubasTable, Shuba> {
  $$ShubasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TarbiyaAreasTable _areaIdTable(_$AppDatabase db) =>
      db.tarbiyaAreas.createAlias('shubas__area_id__tarbiya_areas__id');

  $$TarbiyaAreasTableProcessedTableManager get areaId {
    final $_column = $_itemColumn<String>('area_id')!;

    final manager = $$TarbiyaAreasTableTableManager(
      $_db,
      $_db.tarbiyaAreas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_areaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MembersTable, List<Member>> _membersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.members,
    aliasName: 'shubas__id__members__shuba_id',
  );

  $$MembersTableProcessedTableManager get membersRefs {
    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.shubaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_membersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShubasTableFilterComposer
    extends Composer<_$AppDatabase, $ShubasTable> {
  $$ShubasTableFilterComposer({
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

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TarbiyaAreasTableFilterComposer get areaId {
    final $$TarbiyaAreasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.tarbiyaAreas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TarbiyaAreasTableFilterComposer(
            $db: $db,
            $table: $db.tarbiyaAreas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> membersRefs(
    Expression<bool> Function($$MembersTableFilterComposer f) f,
  ) {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.shubaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShubasTableOrderingComposer
    extends Composer<_$AppDatabase, $ShubasTable> {
  $$ShubasTableOrderingComposer({
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

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TarbiyaAreasTableOrderingComposer get areaId {
    final $$TarbiyaAreasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.tarbiyaAreas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TarbiyaAreasTableOrderingComposer(
            $db: $db,
            $table: $db.tarbiyaAreas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShubasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShubasTable> {
  $$ShubasTableAnnotationComposer({
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

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TarbiyaAreasTableAnnotationComposer get areaId {
    final $$TarbiyaAreasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.areaId,
      referencedTable: $db.tarbiyaAreas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TarbiyaAreasTableAnnotationComposer(
            $db: $db,
            $table: $db.tarbiyaAreas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> membersRefs<T extends Object>(
    Expression<T> Function($$MembersTableAnnotationComposer a) f,
  ) {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.shubaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShubasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShubasTable,
          Shuba,
          $$ShubasTableFilterComposer,
          $$ShubasTableOrderingComposer,
          $$ShubasTableAnnotationComposer,
          $$ShubasTableCreateCompanionBuilder,
          $$ShubasTableUpdateCompanionBuilder,
          (Shuba, $$ShubasTableReferences),
          Shuba,
          PrefetchHooks Function({bool areaId, bool membersRefs})
        > {
  $$ShubasTableTableManager(_$AppDatabase db, $ShubasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShubasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShubasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShubasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> areaId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShubasCompanion(
                id: id,
                areaId: areaId,
                name: name,
                nameAr: nameAr,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String areaId,
                required String name,
                Value<String> nameAr = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShubasCompanion.insert(
                id: id,
                areaId: areaId,
                name: name,
                nameAr: nameAr,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ShubasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({areaId = false, membersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (membersRefs) db.members],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (areaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.areaId,
                                referencedTable: $$ShubasTableReferences
                                    ._areaIdTable(db),
                                referencedColumn: $$ShubasTableReferences
                                    ._areaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (membersRefs)
                    await $_getPrefetchedData<Shuba, $ShubasTable, Member>(
                      currentTable: table,
                      referencedTable: $$ShubasTableReferences
                          ._membersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ShubasTableReferences(db, table, p0).membersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.shubaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShubasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShubasTable,
      Shuba,
      $$ShubasTableFilterComposer,
      $$ShubasTableOrderingComposer,
      $$ShubasTableAnnotationComposer,
      $$ShubasTableCreateCompanionBuilder,
      $$ShubasTableUpdateCompanionBuilder,
      (Shuba, $$ShubasTableReferences),
      Shuba,
      PrefetchHooks Function({bool areaId, bool membersRefs})
    >;
typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      required String id,
      required String shubaId,
      Value<int> level,
      required String firstName,
      Value<String> middleName,
      required String lastName,
      Value<String> suffix,
      Value<String> nameAr,
      Value<String> gender,
      Value<String> dob,
      Value<String> placeOfBirth,
      Value<String> contactNumber,
      Value<String> email,
      Value<String> address,
      Value<String> ethnicity,
      Value<String> occupation,
      Value<String> photoPath,
      Value<String> civilStatus,
      Value<String> spouseName,
      Value<String> spouseDate,
      Value<String> status,
      Value<String> dateJoined,
      Value<String> usraName,
      Value<String> usraEstablishedYear,
      Value<String> usraMeetingSchedule,
      Value<String?> naqibMemberId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<String> id,
      Value<String> shubaId,
      Value<int> level,
      Value<String> firstName,
      Value<String> middleName,
      Value<String> lastName,
      Value<String> suffix,
      Value<String> nameAr,
      Value<String> gender,
      Value<String> dob,
      Value<String> placeOfBirth,
      Value<String> contactNumber,
      Value<String> email,
      Value<String> address,
      Value<String> ethnicity,
      Value<String> occupation,
      Value<String> photoPath,
      Value<String> civilStatus,
      Value<String> spouseName,
      Value<String> spouseDate,
      Value<String> status,
      Value<String> dateJoined,
      Value<String> usraName,
      Value<String> usraEstablishedYear,
      Value<String> usraMeetingSchedule,
      Value<String?> naqibMemberId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MembersTableReferences
    extends BaseReferences<_$AppDatabase, $MembersTable, Member> {
  $$MembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShubasTable _shubaIdTable(_$AppDatabase db) =>
      db.shubas.createAlias('members__shuba_id__shubas__id');

  $$ShubasTableProcessedTableManager get shubaId {
    final $_column = $_itemColumn<String>('shuba_id')!;

    final manager = $$ShubasTableTableManager(
      $_db,
      $_db.shubas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shubaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _naqibMemberIdTable(_$AppDatabase db) =>
      db.members.createAlias('members__naqib_member_id__members__id');

  $$MembersTableProcessedTableManager? get naqibMemberId {
    final $_column = $_itemColumn<String>('naqib_member_id');
    if ($_column == null) return null;
    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_naqibMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MemberChildrenTable, List<MemberChildrenData>>
  _memberChildrenRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberChildren,
    aliasName: 'members__id__member_children__member_id',
  );

  $$MemberChildrenTableProcessedTableManager get memberChildrenRefs {
    final manager = $$MemberChildrenTableTableManager(
      $_db,
      $_db.memberChildren,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_memberChildrenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberEducationTable, List<MemberEducationData>>
  _memberEducationRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberEducation,
    aliasName: 'members__id__member_education__member_id',
  );

  $$MemberEducationTableProcessedTableManager get memberEducationRefs {
    final manager = $$MemberEducationTableTableManager(
      $_db,
      $_db.memberEducation,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memberEducationRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberActivitiesTable, List<MemberActivity>>
  _memberActivitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberActivities,
    aliasName: 'members__id__member_activities__member_id',
  );

  $$MemberActivitiesTableProcessedTableManager get memberActivitiesRefs {
    final manager = $$MemberActivitiesTableTableManager(
      $_db,
      $_db.memberActivities,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memberActivitiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MemberContributionsTable,
    List<MemberContribution>
  >
  _memberContributionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.memberContributions,
        aliasName: 'members__id__member_contributions__member_id',
      );

  $$MemberContributionsTableProcessedTableManager get memberContributionsRefs {
    final manager = $$MemberContributionsTableTableManager(
      $_db,
      $_db.memberContributions,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memberContributionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberTasedTable, List<MemberTasedData>>
  _memberTasedRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberTased,
    aliasName: 'members__id__member_tased__member_id',
  );

  $$MemberTasedTableProcessedTableManager get memberTasedRefs {
    final manager = $$MemberTasedTableTableManager(
      $_db,
      $_db.memberTased,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_memberTasedRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberDonationsTable, List<MemberDonation>>
  _memberDonationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberDonations,
    aliasName: 'members__id__member_donations__member_id',
  );

  $$MemberDonationsTableProcessedTableManager get memberDonationsRefs {
    final manager = $$MemberDonationsTableTableManager(
      $_db,
      $_db.memberDonations,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _memberDonationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemberRolesTable, List<MemberRole>>
  _memberRolesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memberRoles,
    aliasName: 'members__id__member_roles__member_id',
  );

  $$MemberRolesTableProcessedTableManager get memberRolesRefs {
    final manager = $$MemberRolesTableTableManager(
      $_db,
      $_db.memberRoles,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_memberRolesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
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

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
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

  ColumnFilters<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactNumber => $composableBuilder(
    column: $table.contactNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ethnicity => $composableBuilder(
    column: $table.ethnicity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get civilStatus => $composableBuilder(
    column: $table.civilStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spouseName => $composableBuilder(
    column: $table.spouseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spouseDate => $composableBuilder(
    column: $table.spouseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateJoined => $composableBuilder(
    column: $table.dateJoined,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usraName => $composableBuilder(
    column: $table.usraName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usraEstablishedYear => $composableBuilder(
    column: $table.usraEstablishedYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usraMeetingSchedule => $composableBuilder(
    column: $table.usraMeetingSchedule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShubasTableFilterComposer get shubaId {
    final $$ShubasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shubaId,
      referencedTable: $db.shubas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShubasTableFilterComposer(
            $db: $db,
            $table: $db.shubas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get naqibMemberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.naqibMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memberChildrenRefs(
    Expression<bool> Function($$MemberChildrenTableFilterComposer f) f,
  ) {
    final $$MemberChildrenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberChildren,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberChildrenTableFilterComposer(
            $db: $db,
            $table: $db.memberChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberEducationRefs(
    Expression<bool> Function($$MemberEducationTableFilterComposer f) f,
  ) {
    final $$MemberEducationTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberEducation,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberEducationTableFilterComposer(
            $db: $db,
            $table: $db.memberEducation,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberActivitiesRefs(
    Expression<bool> Function($$MemberActivitiesTableFilterComposer f) f,
  ) {
    final $$MemberActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberActivities,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.memberActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberContributionsRefs(
    Expression<bool> Function($$MemberContributionsTableFilterComposer f) f,
  ) {
    final $$MemberContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberContributions,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberContributionsTableFilterComposer(
            $db: $db,
            $table: $db.memberContributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberTasedRefs(
    Expression<bool> Function($$MemberTasedTableFilterComposer f) f,
  ) {
    final $$MemberTasedTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberTased,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberTasedTableFilterComposer(
            $db: $db,
            $table: $db.memberTased,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberDonationsRefs(
    Expression<bool> Function($$MemberDonationsTableFilterComposer f) f,
  ) {
    final $$MemberDonationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberDonations,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberDonationsTableFilterComposer(
            $db: $db,
            $table: $db.memberDonations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memberRolesRefs(
    Expression<bool> Function($$MemberRolesTableFilterComposer f) f,
  ) {
    final $$MemberRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberRoles,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberRolesTableFilterComposer(
            $db: $db,
            $table: $db.memberRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
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

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
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

  ColumnOrderings<String> get suffix => $composableBuilder(
    column: $table.suffix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactNumber => $composableBuilder(
    column: $table.contactNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ethnicity => $composableBuilder(
    column: $table.ethnicity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get civilStatus => $composableBuilder(
    column: $table.civilStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spouseName => $composableBuilder(
    column: $table.spouseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spouseDate => $composableBuilder(
    column: $table.spouseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateJoined => $composableBuilder(
    column: $table.dateJoined,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usraName => $composableBuilder(
    column: $table.usraName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usraEstablishedYear => $composableBuilder(
    column: $table.usraEstablishedYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usraMeetingSchedule => $composableBuilder(
    column: $table.usraMeetingSchedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShubasTableOrderingComposer get shubaId {
    final $$ShubasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shubaId,
      referencedTable: $db.shubas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShubasTableOrderingComposer(
            $db: $db,
            $table: $db.shubas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get naqibMemberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.naqibMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get suffix =>
      $composableBuilder(column: $table.suffix, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get placeOfBirth => $composableBuilder(
    column: $table.placeOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactNumber => $composableBuilder(
    column: $table.contactNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get ethnicity =>
      $composableBuilder(column: $table.ethnicity, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get civilStatus => $composableBuilder(
    column: $table.civilStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spouseName => $composableBuilder(
    column: $table.spouseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spouseDate => $composableBuilder(
    column: $table.spouseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dateJoined => $composableBuilder(
    column: $table.dateJoined,
    builder: (column) => column,
  );

  GeneratedColumn<String> get usraName =>
      $composableBuilder(column: $table.usraName, builder: (column) => column);

  GeneratedColumn<String> get usraEstablishedYear => $composableBuilder(
    column: $table.usraEstablishedYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get usraMeetingSchedule => $composableBuilder(
    column: $table.usraMeetingSchedule,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShubasTableAnnotationComposer get shubaId {
    final $$ShubasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shubaId,
      referencedTable: $db.shubas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShubasTableAnnotationComposer(
            $db: $db,
            $table: $db.shubas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get naqibMemberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.naqibMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memberChildrenRefs<T extends Object>(
    Expression<T> Function($$MemberChildrenTableAnnotationComposer a) f,
  ) {
    final $$MemberChildrenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberChildren,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberChildrenTableAnnotationComposer(
            $db: $db,
            $table: $db.memberChildren,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberEducationRefs<T extends Object>(
    Expression<T> Function($$MemberEducationTableAnnotationComposer a) f,
  ) {
    final $$MemberEducationTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberEducation,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberEducationTableAnnotationComposer(
            $db: $db,
            $table: $db.memberEducation,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberActivitiesRefs<T extends Object>(
    Expression<T> Function($$MemberActivitiesTableAnnotationComposer a) f,
  ) {
    final $$MemberActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberActivities,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.memberActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberContributionsRefs<T extends Object>(
    Expression<T> Function($$MemberContributionsTableAnnotationComposer a) f,
  ) {
    final $$MemberContributionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.memberContributions,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MemberContributionsTableAnnotationComposer(
                $db: $db,
                $table: $db.memberContributions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> memberTasedRefs<T extends Object>(
    Expression<T> Function($$MemberTasedTableAnnotationComposer a) f,
  ) {
    final $$MemberTasedTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberTased,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberTasedTableAnnotationComposer(
            $db: $db,
            $table: $db.memberTased,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberDonationsRefs<T extends Object>(
    Expression<T> Function($$MemberDonationsTableAnnotationComposer a) f,
  ) {
    final $$MemberDonationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberDonations,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberDonationsTableAnnotationComposer(
            $db: $db,
            $table: $db.memberDonations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memberRolesRefs<T extends Object>(
    Expression<T> Function($$MemberRolesTableAnnotationComposer a) f,
  ) {
    final $$MemberRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memberRoles,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemberRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.memberRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, $$MembersTableReferences),
          Member,
          PrefetchHooks Function({
            bool shubaId,
            bool naqibMemberId,
            bool memberChildrenRefs,
            bool memberEducationRefs,
            bool memberActivitiesRefs,
            bool memberContributionsRefs,
            bool memberTasedRefs,
            bool memberDonationsRefs,
            bool memberRolesRefs,
          })
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shubaId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> middleName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> suffix = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> dob = const Value.absent(),
                Value<String> placeOfBirth = const Value.absent(),
                Value<String> contactNumber = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> ethnicity = const Value.absent(),
                Value<String> occupation = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<String> civilStatus = const Value.absent(),
                Value<String> spouseName = const Value.absent(),
                Value<String> spouseDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> dateJoined = const Value.absent(),
                Value<String> usraName = const Value.absent(),
                Value<String> usraEstablishedYear = const Value.absent(),
                Value<String> usraMeetingSchedule = const Value.absent(),
                Value<String?> naqibMemberId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                shubaId: shubaId,
                level: level,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                suffix: suffix,
                nameAr: nameAr,
                gender: gender,
                dob: dob,
                placeOfBirth: placeOfBirth,
                contactNumber: contactNumber,
                email: email,
                address: address,
                ethnicity: ethnicity,
                occupation: occupation,
                photoPath: photoPath,
                civilStatus: civilStatus,
                spouseName: spouseName,
                spouseDate: spouseDate,
                status: status,
                dateJoined: dateJoined,
                usraName: usraName,
                usraEstablishedYear: usraEstablishedYear,
                usraMeetingSchedule: usraMeetingSchedule,
                naqibMemberId: naqibMemberId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shubaId,
                Value<int> level = const Value.absent(),
                required String firstName,
                Value<String> middleName = const Value.absent(),
                required String lastName,
                Value<String> suffix = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> dob = const Value.absent(),
                Value<String> placeOfBirth = const Value.absent(),
                Value<String> contactNumber = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> ethnicity = const Value.absent(),
                Value<String> occupation = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<String> civilStatus = const Value.absent(),
                Value<String> spouseName = const Value.absent(),
                Value<String> spouseDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> dateJoined = const Value.absent(),
                Value<String> usraName = const Value.absent(),
                Value<String> usraEstablishedYear = const Value.absent(),
                Value<String> usraMeetingSchedule = const Value.absent(),
                Value<String?> naqibMemberId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                shubaId: shubaId,
                level: level,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                suffix: suffix,
                nameAr: nameAr,
                gender: gender,
                dob: dob,
                placeOfBirth: placeOfBirth,
                contactNumber: contactNumber,
                email: email,
                address: address,
                ethnicity: ethnicity,
                occupation: occupation,
                photoPath: photoPath,
                civilStatus: civilStatus,
                spouseName: spouseName,
                spouseDate: spouseDate,
                status: status,
                dateJoined: dateJoined,
                usraName: usraName,
                usraEstablishedYear: usraEstablishedYear,
                usraMeetingSchedule: usraMeetingSchedule,
                naqibMemberId: naqibMemberId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shubaId = false,
                naqibMemberId = false,
                memberChildrenRefs = false,
                memberEducationRefs = false,
                memberActivitiesRefs = false,
                memberContributionsRefs = false,
                memberTasedRefs = false,
                memberDonationsRefs = false,
                memberRolesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memberChildrenRefs) db.memberChildren,
                    if (memberEducationRefs) db.memberEducation,
                    if (memberActivitiesRefs) db.memberActivities,
                    if (memberContributionsRefs) db.memberContributions,
                    if (memberTasedRefs) db.memberTased,
                    if (memberDonationsRefs) db.memberDonations,
                    if (memberRolesRefs) db.memberRoles,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (shubaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shubaId,
                                    referencedTable: $$MembersTableReferences
                                        ._shubaIdTable(db),
                                    referencedColumn: $$MembersTableReferences
                                        ._shubaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (naqibMemberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.naqibMemberId,
                                    referencedTable: $$MembersTableReferences
                                        ._naqibMemberIdTable(db),
                                    referencedColumn: $$MembersTableReferences
                                        ._naqibMemberIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memberChildrenRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberChildrenData
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberChildrenRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberChildrenRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberEducationRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberEducationData
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberEducationRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberEducationRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberActivitiesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberActivity
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberActivitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberActivitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberContributionsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberContribution
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberContributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberContributionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberTasedRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberTasedData
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberTasedRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberTasedRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberDonationsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberDonation
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberDonationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberDonationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memberRolesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          MemberRole
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._memberRolesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).memberRolesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, $$MembersTableReferences),
      Member,
      PrefetchHooks Function({
        bool shubaId,
        bool naqibMemberId,
        bool memberChildrenRefs,
        bool memberEducationRefs,
        bool memberActivitiesRefs,
        bool memberContributionsRefs,
        bool memberTasedRefs,
        bool memberDonationsRefs,
        bool memberRolesRefs,
      })
    >;
typedef $$MemberChildrenTableCreateCompanionBuilder =
    MemberChildrenCompanion Function({
      required String id,
      required String memberId,
      required String name,
      Value<String> dob,
      Value<int> rowid,
    });
typedef $$MemberChildrenTableUpdateCompanionBuilder =
    MemberChildrenCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<String> name,
      Value<String> dob,
      Value<int> rowid,
    });

final class $$MemberChildrenTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemberChildrenTable,
          MemberChildrenData
        > {
  $$MemberChildrenTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_children__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $MemberChildrenTable> {
  $$MemberChildrenTableFilterComposer({
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

  ColumnFilters<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberChildrenTable> {
  $$MemberChildrenTableOrderingComposer({
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

  ColumnOrderings<String> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberChildrenTable> {
  $$MemberChildrenTableAnnotationComposer({
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

  GeneratedColumn<String> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberChildrenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberChildrenTable,
          MemberChildrenData,
          $$MemberChildrenTableFilterComposer,
          $$MemberChildrenTableOrderingComposer,
          $$MemberChildrenTableAnnotationComposer,
          $$MemberChildrenTableCreateCompanionBuilder,
          $$MemberChildrenTableUpdateCompanionBuilder,
          (MemberChildrenData, $$MemberChildrenTableReferences),
          MemberChildrenData,
          PrefetchHooks Function({bool memberId})
        > {
  $$MemberChildrenTableTableManager(
    _$AppDatabase db,
    $MemberChildrenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dob = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberChildrenCompanion(
                id: id,
                memberId: memberId,
                name: name,
                dob: dob,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required String name,
                Value<String> dob = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberChildrenCompanion.insert(
                id: id,
                memberId: memberId,
                name: name,
                dob: dob,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberChildrenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$MemberChildrenTableReferences
                                    ._memberIdTable(db),
                                referencedColumn:
                                    $$MemberChildrenTableReferences
                                        ._memberIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberChildrenTable,
      MemberChildrenData,
      $$MemberChildrenTableFilterComposer,
      $$MemberChildrenTableOrderingComposer,
      $$MemberChildrenTableAnnotationComposer,
      $$MemberChildrenTableCreateCompanionBuilder,
      $$MemberChildrenTableUpdateCompanionBuilder,
      (MemberChildrenData, $$MemberChildrenTableReferences),
      MemberChildrenData,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$MemberEducationTableCreateCompanionBuilder =
    MemberEducationCompanion Function({
      required String id,
      required String memberId,
      required String stage,
      required String schoolName,
      Value<String> degree,
      Value<String> program,
      Value<String> yearGraduated,
      Value<int> rowid,
    });
typedef $$MemberEducationTableUpdateCompanionBuilder =
    MemberEducationCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<String> stage,
      Value<String> schoolName,
      Value<String> degree,
      Value<String> program,
      Value<String> yearGraduated,
      Value<int> rowid,
    });

final class $$MemberEducationTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemberEducationTable,
          MemberEducationData
        > {
  $$MemberEducationTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_education__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberEducationTableFilterComposer
    extends Composer<_$AppDatabase, $MemberEducationTable> {
  $$MemberEducationTableFilterComposer({
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

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get program => $composableBuilder(
    column: $table.program,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearGraduated => $composableBuilder(
    column: $table.yearGraduated,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberEducationTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberEducationTable> {
  $$MemberEducationTableOrderingComposer({
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

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get program => $composableBuilder(
    column: $table.program,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearGraduated => $composableBuilder(
    column: $table.yearGraduated,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberEducationTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberEducationTable> {
  $$MemberEducationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get degree =>
      $composableBuilder(column: $table.degree, builder: (column) => column);

  GeneratedColumn<String> get program =>
      $composableBuilder(column: $table.program, builder: (column) => column);

  GeneratedColumn<String> get yearGraduated => $composableBuilder(
    column: $table.yearGraduated,
    builder: (column) => column,
  );

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberEducationTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberEducationTable,
          MemberEducationData,
          $$MemberEducationTableFilterComposer,
          $$MemberEducationTableOrderingComposer,
          $$MemberEducationTableAnnotationComposer,
          $$MemberEducationTableCreateCompanionBuilder,
          $$MemberEducationTableUpdateCompanionBuilder,
          (MemberEducationData, $$MemberEducationTableReferences),
          MemberEducationData,
          PrefetchHooks Function({bool memberId})
        > {
  $$MemberEducationTableTableManager(
    _$AppDatabase db,
    $MemberEducationTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberEducationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberEducationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberEducationTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<String> schoolName = const Value.absent(),
                Value<String> degree = const Value.absent(),
                Value<String> program = const Value.absent(),
                Value<String> yearGraduated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberEducationCompanion(
                id: id,
                memberId: memberId,
                stage: stage,
                schoolName: schoolName,
                degree: degree,
                program: program,
                yearGraduated: yearGraduated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required String stage,
                required String schoolName,
                Value<String> degree = const Value.absent(),
                Value<String> program = const Value.absent(),
                Value<String> yearGraduated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberEducationCompanion.insert(
                id: id,
                memberId: memberId,
                stage: stage,
                schoolName: schoolName,
                degree: degree,
                program: program,
                yearGraduated: yearGraduated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberEducationTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable:
                                    $$MemberEducationTableReferences
                                        ._memberIdTable(db),
                                referencedColumn:
                                    $$MemberEducationTableReferences
                                        ._memberIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberEducationTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberEducationTable,
      MemberEducationData,
      $$MemberEducationTableFilterComposer,
      $$MemberEducationTableOrderingComposer,
      $$MemberEducationTableAnnotationComposer,
      $$MemberEducationTableCreateCompanionBuilder,
      $$MemberEducationTableUpdateCompanionBuilder,
      (MemberEducationData, $$MemberEducationTableReferences),
      MemberEducationData,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$MemberActivitiesTableCreateCompanionBuilder =
    MemberActivitiesCompanion Function({
      required String id,
      required String memberId,
      required String name,
      Value<String> type,
      Value<String> date,
      Value<String> attendanceStatus,
      Value<String> remarks,
      Value<int> rowid,
    });
typedef $$MemberActivitiesTableUpdateCompanionBuilder =
    MemberActivitiesCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<String> name,
      Value<String> type,
      Value<String> date,
      Value<String> attendanceStatus,
      Value<String> remarks,
      Value<int> rowid,
    });

final class $$MemberActivitiesTableReferences
    extends
        BaseReferences<_$AppDatabase, $MemberActivitiesTable, MemberActivity> {
  $$MemberActivitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_activities__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $MemberActivitiesTable> {
  $$MemberActivitiesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attendanceStatus => $composableBuilder(
    column: $table.attendanceStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberActivitiesTable> {
  $$MemberActivitiesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attendanceStatus => $composableBuilder(
    column: $table.attendanceStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberActivitiesTable> {
  $$MemberActivitiesTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get attendanceStatus => $composableBuilder(
    column: $table.attendanceStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberActivitiesTable,
          MemberActivity,
          $$MemberActivitiesTableFilterComposer,
          $$MemberActivitiesTableOrderingComposer,
          $$MemberActivitiesTableAnnotationComposer,
          $$MemberActivitiesTableCreateCompanionBuilder,
          $$MemberActivitiesTableUpdateCompanionBuilder,
          (MemberActivity, $$MemberActivitiesTableReferences),
          MemberActivity,
          PrefetchHooks Function({bool memberId})
        > {
  $$MemberActivitiesTableTableManager(
    _$AppDatabase db,
    $MemberActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> attendanceStatus = const Value.absent(),
                Value<String> remarks = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberActivitiesCompanion(
                id: id,
                memberId: memberId,
                name: name,
                type: type,
                date: date,
                attendanceStatus: attendanceStatus,
                remarks: remarks,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required String name,
                Value<String> type = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> attendanceStatus = const Value.absent(),
                Value<String> remarks = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberActivitiesCompanion.insert(
                id: id,
                memberId: memberId,
                name: name,
                type: type,
                date: date,
                attendanceStatus: attendanceStatus,
                remarks: remarks,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable:
                                    $$MemberActivitiesTableReferences
                                        ._memberIdTable(db),
                                referencedColumn:
                                    $$MemberActivitiesTableReferences
                                        ._memberIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberActivitiesTable,
      MemberActivity,
      $$MemberActivitiesTableFilterComposer,
      $$MemberActivitiesTableOrderingComposer,
      $$MemberActivitiesTableAnnotationComposer,
      $$MemberActivitiesTableCreateCompanionBuilder,
      $$MemberActivitiesTableUpdateCompanionBuilder,
      (MemberActivity, $$MemberActivitiesTableReferences),
      MemberActivity,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$MemberContributionsTableCreateCompanionBuilder =
    MemberContributionsCompanion Function({
      required String id,
      required String memberId,
      required String title,
      Value<String> description,
      Value<String> date,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$MemberContributionsTableUpdateCompanionBuilder =
    MemberContributionsCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<String> title,
      Value<String> description,
      Value<String> date,
      Value<String> status,
      Value<int> rowid,
    });

final class $$MemberContributionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MemberContributionsTable,
          MemberContribution
        > {
  $$MemberContributionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_contributions__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $MemberContributionsTable> {
  $$MemberContributionsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberContributionsTable> {
  $$MemberContributionsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberContributionsTable> {
  $$MemberContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberContributionsTable,
          MemberContribution,
          $$MemberContributionsTableFilterComposer,
          $$MemberContributionsTableOrderingComposer,
          $$MemberContributionsTableAnnotationComposer,
          $$MemberContributionsTableCreateCompanionBuilder,
          $$MemberContributionsTableUpdateCompanionBuilder,
          (MemberContribution, $$MemberContributionsTableReferences),
          MemberContribution,
          PrefetchHooks Function({bool memberId})
        > {
  $$MemberContributionsTableTableManager(
    _$AppDatabase db,
    $MemberContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberContributionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MemberContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberContributionsCompanion(
                id: id,
                memberId: memberId,
                title: title,
                description: description,
                date: date,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required String title,
                Value<String> description = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberContributionsCompanion.insert(
                id: id,
                memberId: memberId,
                title: title,
                description: description,
                date: date,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberContributionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable:
                                    $$MemberContributionsTableReferences
                                        ._memberIdTable(db),
                                referencedColumn:
                                    $$MemberContributionsTableReferences
                                        ._memberIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberContributionsTable,
      MemberContribution,
      $$MemberContributionsTableFilterComposer,
      $$MemberContributionsTableOrderingComposer,
      $$MemberContributionsTableAnnotationComposer,
      $$MemberContributionsTableCreateCompanionBuilder,
      $$MemberContributionsTableUpdateCompanionBuilder,
      (MemberContribution, $$MemberContributionsTableReferences),
      MemberContribution,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$MemberTasedTableCreateCompanionBuilder =
    MemberTasedCompanion Function({
      required String id,
      required String memberId,
      required int level,
      Value<String> year,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$MemberTasedTableUpdateCompanionBuilder =
    MemberTasedCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<int> level,
      Value<String> year,
      Value<String> status,
      Value<int> rowid,
    });

final class $$MemberTasedTableReferences
    extends BaseReferences<_$AppDatabase, $MemberTasedTable, MemberTasedData> {
  $$MemberTasedTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_tased__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberTasedTableFilterComposer
    extends Composer<_$AppDatabase, $MemberTasedTable> {
  $$MemberTasedTableFilterComposer({
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

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberTasedTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberTasedTable> {
  $$MemberTasedTableOrderingComposer({
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

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberTasedTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberTasedTable> {
  $$MemberTasedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberTasedTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberTasedTable,
          MemberTasedData,
          $$MemberTasedTableFilterComposer,
          $$MemberTasedTableOrderingComposer,
          $$MemberTasedTableAnnotationComposer,
          $$MemberTasedTableCreateCompanionBuilder,
          $$MemberTasedTableUpdateCompanionBuilder,
          (MemberTasedData, $$MemberTasedTableReferences),
          MemberTasedData,
          PrefetchHooks Function({bool memberId})
        > {
  $$MemberTasedTableTableManager(_$AppDatabase db, $MemberTasedTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberTasedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberTasedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberTasedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> year = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberTasedCompanion(
                id: id,
                memberId: memberId,
                level: level,
                year: year,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required int level,
                Value<String> year = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberTasedCompanion.insert(
                id: id,
                memberId: memberId,
                level: level,
                year: year,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberTasedTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$MemberTasedTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$MemberTasedTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberTasedTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberTasedTable,
      MemberTasedData,
      $$MemberTasedTableFilterComposer,
      $$MemberTasedTableOrderingComposer,
      $$MemberTasedTableAnnotationComposer,
      $$MemberTasedTableCreateCompanionBuilder,
      $$MemberTasedTableUpdateCompanionBuilder,
      (MemberTasedData, $$MemberTasedTableReferences),
      MemberTasedData,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$MemberDonationsTableCreateCompanionBuilder =
    MemberDonationsCompanion Function({
      required String id,
      required String memberId,
      required int year,
      required int month,
      Value<bool> donated,
      Value<String> date,
      Value<double> amount,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$MemberDonationsTableUpdateCompanionBuilder =
    MemberDonationsCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<int> year,
      Value<int> month,
      Value<bool> donated,
      Value<String> date,
      Value<double> amount,
      Value<String> notes,
      Value<int> rowid,
    });

final class $$MemberDonationsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MemberDonationsTable, MemberDonation> {
  $$MemberDonationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_donations__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberDonationsTableFilterComposer
    extends Composer<_$AppDatabase, $MemberDonationsTable> {
  $$MemberDonationsTableFilterComposer({
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

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get donated => $composableBuilder(
    column: $table.donated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberDonationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberDonationsTable> {
  $$MemberDonationsTableOrderingComposer({
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

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get donated => $composableBuilder(
    column: $table.donated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberDonationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberDonationsTable> {
  $$MemberDonationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<bool> get donated =>
      $composableBuilder(column: $table.donated, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberDonationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberDonationsTable,
          MemberDonation,
          $$MemberDonationsTableFilterComposer,
          $$MemberDonationsTableOrderingComposer,
          $$MemberDonationsTableAnnotationComposer,
          $$MemberDonationsTableCreateCompanionBuilder,
          $$MemberDonationsTableUpdateCompanionBuilder,
          (MemberDonation, $$MemberDonationsTableReferences),
          MemberDonation,
          PrefetchHooks Function({bool memberId})
        > {
  $$MemberDonationsTableTableManager(
    _$AppDatabase db,
    $MemberDonationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberDonationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberDonationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberDonationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<bool> donated = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberDonationsCompanion(
                id: id,
                memberId: memberId,
                year: year,
                month: month,
                donated: donated,
                date: date,
                amount: amount,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required int year,
                required int month,
                Value<bool> donated = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberDonationsCompanion.insert(
                id: id,
                memberId: memberId,
                year: year,
                month: month,
                donated: donated,
                date: date,
                amount: amount,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberDonationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable:
                                    $$MemberDonationsTableReferences
                                        ._memberIdTable(db),
                                referencedColumn:
                                    $$MemberDonationsTableReferences
                                        ._memberIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberDonationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberDonationsTable,
      MemberDonation,
      $$MemberDonationsTableFilterComposer,
      $$MemberDonationsTableOrderingComposer,
      $$MemberDonationsTableAnnotationComposer,
      $$MemberDonationsTableCreateCompanionBuilder,
      $$MemberDonationsTableUpdateCompanionBuilder,
      (MemberDonation, $$MemberDonationsTableReferences),
      MemberDonation,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$MemberRolesTableCreateCompanionBuilder =
    MemberRolesCompanion Function({
      required String id,
      required String memberId,
      required String positionTitle,
      Value<String> department,
      Value<String?> departmentId,
      Value<String> startDate,
      Value<String> endDate,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$MemberRolesTableUpdateCompanionBuilder =
    MemberRolesCompanion Function({
      Value<String> id,
      Value<String> memberId,
      Value<String> positionTitle,
      Value<String> department,
      Value<String?> departmentId,
      Value<String> startDate,
      Value<String> endDate,
      Value<String> status,
      Value<int> rowid,
    });

final class $$MemberRolesTableReferences
    extends BaseReferences<_$AppDatabase, $MemberRolesTable, MemberRole> {
  $$MemberRolesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('member_roles__member_id__members__id');

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) => db
      .departments
      .createAlias('member_roles__department_id__departments__id');

  $$DepartmentsTableProcessedTableManager? get departmentId {
    final $_column = $_itemColumn<String>('department_id');
    if ($_column == null) return null;
    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemberRolesTableFilterComposer
    extends Composer<_$AppDatabase, $MemberRolesTable> {
  $$MemberRolesTableFilterComposer({
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

  ColumnFilters<String> get positionTitle => $composableBuilder(
    column: $table.positionTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberRolesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberRolesTable> {
  $$MemberRolesTableOrderingComposer({
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

  ColumnOrderings<String> get positionTitle => $composableBuilder(
    column: $table.positionTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberRolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberRolesTable> {
  $$MemberRolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get positionTitle => $composableBuilder(
    column: $table.positionTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemberRolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberRolesTable,
          MemberRole,
          $$MemberRolesTableFilterComposer,
          $$MemberRolesTableOrderingComposer,
          $$MemberRolesTableAnnotationComposer,
          $$MemberRolesTableCreateCompanionBuilder,
          $$MemberRolesTableUpdateCompanionBuilder,
          (MemberRole, $$MemberRolesTableReferences),
          MemberRole,
          PrefetchHooks Function({bool memberId, bool departmentId})
        > {
  $$MemberRolesTableTableManager(_$AppDatabase db, $MemberRolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberRolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberRolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberRolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> positionTitle = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberRolesCompanion(
                id: id,
                memberId: memberId,
                positionTitle: positionTitle,
                department: department,
                departmentId: departmentId,
                startDate: startDate,
                endDate: endDate,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String memberId,
                required String positionTitle,
                Value<String> department = const Value.absent(),
                Value<String?> departmentId = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberRolesCompanion.insert(
                id: id,
                memberId: memberId,
                positionTitle: positionTitle,
                department: department,
                departmentId: departmentId,
                startDate: startDate,
                endDate: endDate,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemberRolesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false, departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$MemberRolesTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$MemberRolesTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (departmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.departmentId,
                                referencedTable: $$MemberRolesTableReferences
                                    ._departmentIdTable(db),
                                referencedColumn: $$MemberRolesTableReferences
                                    ._departmentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemberRolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberRolesTable,
      MemberRole,
      $$MemberRolesTableFilterComposer,
      $$MemberRolesTableOrderingComposer,
      $$MemberRolesTableAnnotationComposer,
      $$MemberRolesTableCreateCompanionBuilder,
      $$MemberRolesTableUpdateCompanionBuilder,
      (MemberRole, $$MemberRolesTableReferences),
      MemberRole,
      PrefetchHooks Function({bool memberId, bool departmentId})
    >;
typedef $$DeptActivitiesTableCreateCompanionBuilder =
    DeptActivitiesCompanion Function({
      required String id,
      required String departmentId,
      required String title,
      Value<String> titleAr,
      Value<String> description,
      Value<String> date,
      Value<String> status,
      Value<int> attendance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$DeptActivitiesTableUpdateCompanionBuilder =
    DeptActivitiesCompanion Function({
      Value<String> id,
      Value<String> departmentId,
      Value<String> title,
      Value<String> titleAr,
      Value<String> description,
      Value<String> date,
      Value<String> status,
      Value<int> attendance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$DeptActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $DeptActivitiesTable, DeptActivity> {
  $$DeptActivitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) => db
      .departments
      .createAlias('dept_activities__department_id__departments__id');

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<String>('department_id')!;

    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeptActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $DeptActivitiesTable> {
  $$DeptActivitiesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attendance => $composableBuilder(
    column: $table.attendance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeptActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeptActivitiesTable> {
  $$DeptActivitiesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attendance => $composableBuilder(
    column: $table.attendance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeptActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeptActivitiesTable> {
  $$DeptActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attendance => $composableBuilder(
    column: $table.attendance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeptActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeptActivitiesTable,
          DeptActivity,
          $$DeptActivitiesTableFilterComposer,
          $$DeptActivitiesTableOrderingComposer,
          $$DeptActivitiesTableAnnotationComposer,
          $$DeptActivitiesTableCreateCompanionBuilder,
          $$DeptActivitiesTableUpdateCompanionBuilder,
          (DeptActivity, $$DeptActivitiesTableReferences),
          DeptActivity,
          PrefetchHooks Function({bool departmentId})
        > {
  $$DeptActivitiesTableTableManager(
    _$AppDatabase db,
    $DeptActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeptActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeptActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeptActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attendance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeptActivitiesCompanion(
                id: id,
                departmentId: departmentId,
                title: title,
                titleAr: titleAr,
                description: description,
                date: date,
                status: status,
                attendance: attendance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String departmentId,
                required String title,
                Value<String> titleAr = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attendance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeptActivitiesCompanion.insert(
                id: id,
                departmentId: departmentId,
                title: title,
                titleAr: titleAr,
                description: description,
                date: date,
                status: status,
                attendance: attendance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeptActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (departmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.departmentId,
                                referencedTable: $$DeptActivitiesTableReferences
                                    ._departmentIdTable(db),
                                referencedColumn:
                                    $$DeptActivitiesTableReferences
                                        ._departmentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeptActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeptActivitiesTable,
      DeptActivity,
      $$DeptActivitiesTableFilterComposer,
      $$DeptActivitiesTableOrderingComposer,
      $$DeptActivitiesTableAnnotationComposer,
      $$DeptActivitiesTableCreateCompanionBuilder,
      $$DeptActivitiesTableUpdateCompanionBuilder,
      (DeptActivity, $$DeptActivitiesTableReferences),
      DeptActivity,
      PrefetchHooks Function({bool departmentId})
    >;
typedef $$ReportsTableCreateCompanionBuilder =
    ReportsCompanion Function({
      required String id,
      required String departmentId,
      required String title,
      Value<String> titleAr,
      Value<String> summary,
      Value<String> summaryAr,
      Value<String> date,
      Value<int> year,
      Value<String> type,
      Value<int> pages,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ReportsTableUpdateCompanionBuilder =
    ReportsCompanion Function({
      Value<String> id,
      Value<String> departmentId,
      Value<String> title,
      Value<String> titleAr,
      Value<String> summary,
      Value<String> summaryAr,
      Value<String> date,
      Value<int> year,
      Value<String> type,
      Value<int> pages,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReportsTableReferences
    extends BaseReferences<_$AppDatabase, $ReportsTable, Report> {
  $$ReportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DepartmentsTable _departmentIdTable(_$AppDatabase db) =>
      db.departments.createAlias('reports__department_id__departments__id');

  $$DepartmentsTableProcessedTableManager get departmentId {
    final $_column = $_itemColumn<String>('department_id')!;

    final manager = $$DepartmentsTableTableManager(
      $_db,
      $_db.departments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_departmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryAr => $composableBuilder(
    column: $table.summaryAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pages => $composableBuilder(
    column: $table.pages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DepartmentsTableFilterComposer get departmentId {
    final $$DepartmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableFilterComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryAr => $composableBuilder(
    column: $table.summaryAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pages => $composableBuilder(
    column: $table.pages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DepartmentsTableOrderingComposer get departmentId {
    final $$DepartmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableOrderingComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get summaryAr =>
      $composableBuilder(column: $table.summaryAr, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get pages =>
      $composableBuilder(column: $table.pages, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DepartmentsTableAnnotationComposer get departmentId {
    final $$DepartmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.departmentId,
      referencedTable: $db.departments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepartmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.departments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsTable,
          Report,
          $$ReportsTableFilterComposer,
          $$ReportsTableOrderingComposer,
          $$ReportsTableAnnotationComposer,
          $$ReportsTableCreateCompanionBuilder,
          $$ReportsTableUpdateCompanionBuilder,
          (Report, $$ReportsTableReferences),
          Report,
          PrefetchHooks Function({bool departmentId})
        > {
  $$ReportsTableTableManager(_$AppDatabase db, $ReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> summaryAr = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> pages = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion(
                id: id,
                departmentId: departmentId,
                title: title,
                titleAr: titleAr,
                summary: summary,
                summaryAr: summaryAr,
                date: date,
                year: year,
                type: type,
                pages: pages,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String departmentId,
                required String title,
                Value<String> titleAr = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> summaryAr = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> pages = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion.insert(
                id: id,
                departmentId: departmentId,
                title: title,
                titleAr: titleAr,
                summary: summary,
                summaryAr: summaryAr,
                date: date,
                year: year,
                type: type,
                pages: pages,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({departmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (departmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.departmentId,
                                referencedTable: $$ReportsTableReferences
                                    ._departmentIdTable(db),
                                referencedColumn: $$ReportsTableReferences
                                    ._departmentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsTable,
      Report,
      $$ReportsTableFilterComposer,
      $$ReportsTableOrderingComposer,
      $$ReportsTableAnnotationComposer,
      $$ReportsTableCreateCompanionBuilder,
      $$ReportsTableUpdateCompanionBuilder,
      (Report, $$ReportsTableReferences),
      Report,
      PrefetchHooks Function({bool departmentId})
    >;
typedef $$GalleryPhotosTableCreateCompanionBuilder =
    GalleryPhotosCompanion Function({
      required String id,
      required String title,
      Value<String> titleAr,
      Value<int> year,
      Value<String> event,
      Value<String> eventAr,
      Value<String> iconKey,
      Value<int> accent,
      Value<String> imagePath,
      Value<int> heightHint,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$GalleryPhotosTableUpdateCompanionBuilder =
    GalleryPhotosCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> titleAr,
      Value<int> year,
      Value<String> event,
      Value<String> eventAr,
      Value<String> iconKey,
      Value<int> accent,
      Value<String> imagePath,
      Value<int> heightHint,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$GalleryPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $GalleryPhotosTable> {
  $$GalleryPhotosTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventAr => $composableBuilder(
    column: $table.eventAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightHint => $composableBuilder(
    column: $table.heightHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GalleryPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $GalleryPhotosTable> {
  $$GalleryPhotosTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventAr => $composableBuilder(
    column: $table.eventAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightHint => $composableBuilder(
    column: $table.heightHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GalleryPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GalleryPhotosTable> {
  $$GalleryPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<String> get eventAr =>
      $composableBuilder(column: $table.eventAr, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get heightHint => $composableBuilder(
    column: $table.heightHint,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GalleryPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GalleryPhotosTable,
          GalleryPhoto,
          $$GalleryPhotosTableFilterComposer,
          $$GalleryPhotosTableOrderingComposer,
          $$GalleryPhotosTableAnnotationComposer,
          $$GalleryPhotosTableCreateCompanionBuilder,
          $$GalleryPhotosTableUpdateCompanionBuilder,
          (
            GalleryPhoto,
            BaseReferences<_$AppDatabase, $GalleryPhotosTable, GalleryPhoto>,
          ),
          GalleryPhoto,
          PrefetchHooks Function()
        > {
  $$GalleryPhotosTableTableManager(_$AppDatabase db, $GalleryPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GalleryPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GalleryPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GalleryPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> event = const Value.absent(),
                Value<String> eventAr = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> heightHint = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GalleryPhotosCompanion(
                id: id,
                title: title,
                titleAr: titleAr,
                year: year,
                event: event,
                eventAr: eventAr,
                iconKey: iconKey,
                accent: accent,
                imagePath: imagePath,
                heightHint: heightHint,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> titleAr = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> event = const Value.absent(),
                Value<String> eventAr = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> heightHint = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GalleryPhotosCompanion.insert(
                id: id,
                title: title,
                titleAr: titleAr,
                year: year,
                event: event,
                eventAr: eventAr,
                iconKey: iconKey,
                accent: accent,
                imagePath: imagePath,
                heightHint: heightHint,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GalleryPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GalleryPhotosTable,
      GalleryPhoto,
      $$GalleryPhotosTableFilterComposer,
      $$GalleryPhotosTableOrderingComposer,
      $$GalleryPhotosTableAnnotationComposer,
      $$GalleryPhotosTableCreateCompanionBuilder,
      $$GalleryPhotosTableUpdateCompanionBuilder,
      (
        GalleryPhoto,
        BaseReferences<_$AppDatabase, $GalleryPhotosTable, GalleryPhoto>,
      ),
      GalleryPhoto,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$LeadersTableTableManager get leaders =>
      $$LeadersTableTableManager(_db, _db.leaders);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$TarbiyaAreasTableTableManager get tarbiyaAreas =>
      $$TarbiyaAreasTableTableManager(_db, _db.tarbiyaAreas);
  $$ShubasTableTableManager get shubas =>
      $$ShubasTableTableManager(_db, _db.shubas);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$MemberChildrenTableTableManager get memberChildren =>
      $$MemberChildrenTableTableManager(_db, _db.memberChildren);
  $$MemberEducationTableTableManager get memberEducation =>
      $$MemberEducationTableTableManager(_db, _db.memberEducation);
  $$MemberActivitiesTableTableManager get memberActivities =>
      $$MemberActivitiesTableTableManager(_db, _db.memberActivities);
  $$MemberContributionsTableTableManager get memberContributions =>
      $$MemberContributionsTableTableManager(_db, _db.memberContributions);
  $$MemberTasedTableTableManager get memberTased =>
      $$MemberTasedTableTableManager(_db, _db.memberTased);
  $$MemberDonationsTableTableManager get memberDonations =>
      $$MemberDonationsTableTableManager(_db, _db.memberDonations);
  $$MemberRolesTableTableManager get memberRoles =>
      $$MemberRolesTableTableManager(_db, _db.memberRoles);
  $$DeptActivitiesTableTableManager get deptActivities =>
      $$DeptActivitiesTableTableManager(_db, _db.deptActivities);
  $$ReportsTableTableManager get reports =>
      $$ReportsTableTableManager(_db, _db.reports);
  $$GalleryPhotosTableTableManager get galleryPhotos =>
      $$GalleryPhotosTableTableManager(_db, _db.galleryPhotos);
}
