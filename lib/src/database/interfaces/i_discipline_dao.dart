import '../models/discipline.dart';
import '../models/group.dart';

abstract interface class IDisciplineDao{
  Future<List<DisciplineModel>> getAll();
  Future<DisciplineModel?> getById(int id);
  Future<int> add (String name);
  Future<bool> exists(String name);
  Future<void>deleteDiscipline(int id);
  Future<List<GroupModel>> getAssignedGroups(int disciplineId);
}