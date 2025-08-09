package repositories.Schedule;

import models.Schedule;
import utils.List;


public interface ScheduleRepository {
  void create(Schedule schedule);
  void update(Schedule schedule);
  Schedule findById(String id);
  List<Schedule> findAll();
  List<Schedule> findByMonth(int year, int month);
  List<Schedule> findByStaffId(String staffId);
  void delete(String id);
}
