import '../models/discipline.dart';
import '../models/group.dart';

abstract interface class IGroupDao{
  Future<List<GroupModel>> getAll();
  Future <GroupModel?> getById(int id);
  Future<int> add(String name);
  Future<bool> exists(String name);
  Future<void>deleteGroup(int id);
  Future<void>assignDiscipline(int groupId,int disciplineId);
  Future<List<GroupModel>> getGroupsWithoutDiscipline(int disciplineId);
  Future <List<DisciplineModel>> getAssignedDisciplines(int groupId);
}