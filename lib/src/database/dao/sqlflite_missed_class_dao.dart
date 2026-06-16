import 'dart:typed_data';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_missed/src/database/interfaces/i_missed_class_dao.dart';
import 'package:student_missed/src/database/models/academic_performance.dart';
import 'package:student_missed/src/database/models/full_academic_performance.dart';
import 'package:student_missed/src/database/models/missed_info.dart';

class MissedClassDao implements IMissedClassDao {
  final Database _db;

  MissedClassDao(this._db);

  @override
  Future<void> addAllRecords(
    int groupId,
    int disciplineId,
    bool isMissed,
  ) async {
    final now = DateTime.now();
    final batch = _db.batch();
    final List<Map<String, dynamic>> students = await _db.query(
      'students',
      where: 'group_id = ?',
      whereArgs: [groupId],
    );
    for (final student in students) {
      final studentId = student['id'] as int;
      batch.insert('missed_classes', {
        'student_id': studentId,
        'discipline_id': disciplineId,
        'day': now.toIso8601String(),
        'is_missed': isMissed ? 1 : 0,
      });
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> addMissedRecords(
    List<int> missedStudentsIds,
    int groupId,
    int disciplineId,
  ) async {
    final now = DateTime.now();
    final batch = _db.batch();
    final List<Map<String, dynamic>> students = await _db.query(
      'students',
      where: 'group_id = ?',
      whereArgs: [groupId],
    );
    for (final student in students) {
      final studentId = student['id'] as int;
      final isMissed = missedStudentsIds.contains(studentId);
      batch.insert('missed_classes', {
        'student_id': studentId,
        'discipline_id': disciplineId,
        'day': now.toIso8601String(),
        'is_missed': isMissed ? 1 : 0,
      });
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<({List<AcademicPerformanceModel> performances, int totalClasses})>
  countMissedClasses(int groupId, int disciplineId) async {
    final List<Map<String, dynamic>> totalResult = await _db.rawQuery(
      '''
    SELECT COUNT (DISTINCT day) as total_classes
    FROM missed_classes mc
    JOIN students s ON mc.student_id = s.id
    WHERE s.group_id = ? AND mc.discipline_id = ?
    ''',
      [groupId, disciplineId],
    );
    final totalClasses = totalResult[0]['total_classes'] as int? ?? 0;
    final List<Map<String, dynamic>> performanceResult = await _db.rawQuery(
      '''
    SELECT 
    s.full_name as student_name,
    SUM(CASE WHEN mc.is_missed = 1 THEN 1 ELSE 0 END)
    as number_of_passes
    FROM students s
    LEFT JOIN missed_classes mc ON s.id = mc.student_id
    AND mc.discipline_id=?
    WHERE s.group_id=?
    GROUP BY s.id
    ORDER BY s.full_name
    ''',
      [disciplineId, groupId],
    );
    final performances = performanceResult.map((row) {
      return AcademicPerformanceModel(
        studentName: row['student_name'] as String,
        numberOfPasses: row['number_of_passes'] as int? ?? 0,
      );
    }).toList();
    return (totalClasses: totalClasses, performances: performances);
  }

  @override
  Future<({String fullName, int missedCount, int totalCount})>
  getAcademicPerformance(int studentId, int disciplineId) async {
    final List<Map<String, dynamic>> result = await _db.rawQuery(
      '''
    SELECT
    s.full_name,
    SUM(CASE WHEN mc.is_missed = 1 THEN 1 ELSE 0 END
    as missed_count
    FROM students s
    LEFT JOIN missed_classes mc ON s.id = mc.student_id
    AND mc.discipline_id = ?
    WHERE s.id = ?
    GROUP BY s.id
    ''',
      [disciplineId, studentId],
    );
    if (result.isEmpty) {
      throw Exception('Student not found');
    }
    final row = result[0];
    return (
      fullName: row['full_name'] as String,
      missedCount: row['missed_count'] as int? ?? 0,
      totalCount: row['total_count'] as int? ?? 0,
    );
  }

  @override
  Future<List<FullAcademicPerformanceModel>> getMissedClassesWithDays(
    int groupId,
    int disciplineId,
  ) async {
    final List<Map<String, dynamic>> result = await _db.rawQuery(
      '''
    SELECT 
    s.id,
    s.full_name as student_name,
    mc.is_missed,
    mc.day
    FROM students s 
    LEFT JOIN missed_classes mc ON s.id=mc.studet_id
    AND mc.discipline_id=?
    WHERE s.group_id=?
    ORDER BY s.full_name, mc.day
    ''',
      [disciplineId, groupId],
    );
    final Map<int, FullAcademicPerformanceModel> studentMap = {};
    for (final row in result) {
      final studentId = row['id'] as int;
      final studentName = row['student_name'] as String;
      final isMissed = row['is_missed'] != null
          ? (row['is_missed'] as int) == 1
          : false;
      final dayStr = row['day'] as String?;
      if (!studentMap.containsKey(studentId)) {
        studentMap[studentId] = FullAcademicPerformanceModel(
          studentName: studentName,
          missedData: [],
        );
      }
      if (dayStr != null) {
        studentMap[studentId]!.missedData.add(
          MissedInfoModel(isMissed: isMissed, day: DateTime.parse(dayStr)),
        );
      }
    }
    return studentMap.values.toList();
  }
}
