import '../models/academic_performance.dart';
import '../models/full_academic_performance.dart';

abstract interface class IMissedClassDao {
  Future<void> addMissedRecords(
    List<int> missedStudentsIds,
    int groupId,
    int disciplineId,
  );

  Future<void> addAllRecords(int groupId, int disciplineId, bool isMissed);

  Future<({String fullName, int missedCount, int totalCount})>
  getAcademicPerformance(int studentId, int disciplineId);

  Future<({int totalClasses, List<AcademicPerformanceModel> performances})>
  countMissedClasses(int groupId, int disciplineId);
  Future<List<FullAcademicPerformanceModel>>getMissedClassesWithDays(int groupId,int disciplineId);
}
