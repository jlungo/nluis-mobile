import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get mobileModulesJson => text().named('mobile_modules_json')();
  IntColumn get updatedAt => integer().named('updated_at')();
}

class AuthTokens extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accessToken => text().named('access_token')();
  TextColumn get refreshToken => text().named('refresh_token')();
  IntColumn get expiresAt => integer().named('expires_at')();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {key};
}
