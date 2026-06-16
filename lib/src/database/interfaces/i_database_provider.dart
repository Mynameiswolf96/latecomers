import 'i_discipline_dao.dart';
import 'i_group_dao.dart';
import 'i_missed_class_dao.dart';
import 'i_student_dao.dart';

abstract interface class IDatabaseProvider{
  IGroupDao get groupDao;
  IStudentDao get studentDao;
  IDisciplineDao get disciplineDao;
  IMissedClassDao get missedClassDao;
  Future<void>close();

}