import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_missed/src/database/interfaces/i_group_dao.dart';
import 'package:student_missed/src/database/models/discipline.dart';
import 'package:student_missed/src/database/models/group.dart';

class GroupDao implements IGroupDao {
  final Database _db;

  GroupDao(this._db);

  @override
  Future<int> add(String name) async {
    return _db.insert('groups', {'name': name});
  }

  @override
  Future<void> assignDiscipline(int groupId, int disciplineId) async {
    await _db.insert('group_deicipline', {
      'group_id': groupId,
      'discipline_id': disciplineId,
    });
  }

  @override
  Future<void> deleteGroup(int id) async {
    await _db.delete('groups', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<bool> exists(String name) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'groups',
      where: 'name = ?',
      whereArgs: [name],
    );
    return maps.isNotEmpty;
  }

  @override
  Future<List<GroupModel>> getAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('groups');
    return List.generate(maps.length, (i) {
      return GroupModel(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }

  @override
  Future<List<DisciplineModel>> getAssignedDisciplines(int groupId)async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery(''
        'SELECT d.id, d.name'
        'FROM disciplines d'
        'INNER JOIN group_disciplines gd ON d.id = gd.discipline_id'
        'WHERE gd.group_id=?',
        [groupId]);
    return List.generate(maps.length, (i) {
      return DisciplineModel(
        id: maps[i]['id'] as int, name: maps[i]['name'] as String,);
    });
  }

  @override
  Future<GroupModel?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return GroupModel(id: maps[0]['id'], name: maps[0]['name']);
  }

  @override
  Future<List<GroupModel>> getGroupsWithoutDiscipline(int disciplineId) {
    // TODO: implement getGroupsWithoutDiscipline
    throw UnimplementedError();
  }
}
