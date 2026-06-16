import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_missed/src/database/dao/sqlflite_discipline.dart';
import 'package:student_missed/src/database/dao/sqlflite_group_dao.dart';
import 'package:student_missed/src/database/dao/sqlflite_missed_class_dao.dart';
import 'package:student_missed/src/database/dao/sqlflite_student_dao.dart';
import 'package:student_missed/src/database/interfaces/i_database_provider.dart';
import 'package:student_missed/src/database/interfaces/i_discipline_dao.dart';
import 'package:student_missed/src/database/interfaces/i_group_dao.dart';
import 'package:student_missed/src/database/interfaces/i_missed_class_dao.dart';
import 'package:student_missed/src/database/interfaces/i_student_dao.dart';

class SqliteDatabase implements IDatabaseProvider {
  final Database _db;
  late final GroupDao _groupDao;
  late final StudentDao _studentDao;
  late final DisciplineDao _disciplineDao;
  late final MissedClassDao _missedClassDao;

  SqliteDatabase._(this._db){
    _groupDao = GroupDao(_db);
    _studentDao = StudentDao(_db);
    _disciplineDao = DisciplineDao(_db);
    _missedClassDao = MissedClassDao(_db);
  }

  static Future<SqliteDatabase> create(String dbPath) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await openDatabase(dbPath, version: 1, onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (db, version) async {
      await db.execute('''
    CREATE TABLE groups(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
    )
    ''');
      await db.execute('''
    CREATE TABLE students(
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    group_id INTEGER NOT NULL,
    FOREIGN KEY (group_key) REFERENCES groups (id)
    ON DELETE CASCADE
    )
   ''');
      await db.execute('''
    CREATE TABLE disciplines(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
    )
    ''');
      await db.execute('''
    CREATE TABLE missed_classes(
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    discipline_id INTEGER NOT NULL,
    day DATETIME NOT NULL,
    is_missed BOOLEAN NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students (id)
    ON DELETE CASCADE,
    FOREIGN (student_id) REFERENCES disciplines (id)
    ON DELETE CASCADE
    )
    ''');
      await db.execute('''
    CREATE TABLE group_disciplines(
    group_id INTEGER NOT NULL,
    discipline_id INTEGER NOT NULL,
    PRIMARY KEY (group_id, discipline_id),
    FOREIGN KEY (group_id) REFERENCES groups (id)
    ON DELETE CASCADE,
    FOREIGN KEY (discipline_id) REFERENCES disciplines (id)
    ON DELETE CASCADE
    )
  ''');
    }, );
    return SqliteDatabase._(db);
  }

  @override
  Future<void> close() async{
    _db.close();
  }

  @override
  // TODO: implement disciplineDao
  IDisciplineDao get disciplineDao => _disciplineDao;

  @override
  // TODO: implement groupDao
  IGroupDao get groupDao => _groupDao;

  @override
  // TODO: implement missedClassDao
  IMissedClassDao get missedClassDao => _missedClassDao;
  @override
  // TODO: implement studentDao
  IStudentDao get studentDao => _studentDao;
}