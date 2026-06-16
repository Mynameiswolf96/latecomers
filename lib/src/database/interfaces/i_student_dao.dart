import '../models/student.dart';

abstract interface class IStudentDao{
  Future<List<StudentModel>> getByGroupId(int groupId);
  Future<int>add(int groupId,String fullName);
  Future<void>deleteStudent(int id);
  Future<StudentModel?> getById(int id);
}