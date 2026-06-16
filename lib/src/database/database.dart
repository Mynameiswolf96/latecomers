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

class SqliteDatabase implements IDatabaseProvider{
  final Database _db;
  late final GroupDao _groupDao;
late final StudentDao _studentDao;
late final DisciplineDao _disciplineDao;
late final MissedClassDao _missedClassDao;
SqliteDatabase._(this._db){
  _groupDao=GroupDao(_db);
  _studentDao=StudentDao(_db);
  _disciplineDao=DisciplineDao(_db);
  _missedClassDao=MissedClassDao(_db);
}
static Future<SqliteDatabase> create(String dbPath)async{
  sqfliteFfiInit();
  databaseFactory=databaseFactoryFfi;
  final db=await openDatabase(dbPath,version: 1,onConfigure: (db)async{await db.execute('PRAGMA foreign_keys = ON');},onCreate: (db,version)async{
    await db.execute('''
    CREATE TABLE groups(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
    )
    ''');await db.execute('''
    CREATE TABLE students(
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    group_id INTEGER NOT NULL,
    FOREIGN KEY (group_key) REFERENCES groups (id)
    ON DELETE CASCADE
    )
   ''' );
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
  });
}

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  // TODO: implement disciplineDao
  IDisciplineDao get disciplineDao => throw UnimplementedError();

  @override
  // TODO: implement groupDao
  IGroupDao get groupDao => throw UnimplementedError();

  @override
  // TODO: implement missedClassDao
  IMissedClassDao get missedClassDao => throw UnimplementedError();

  @override
  // TODO: implement studentDao
  IStudentDao get studentDao => throw UnimplementedError();
}