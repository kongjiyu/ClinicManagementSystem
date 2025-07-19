package repositories.Schedule;

import models.Schedule;
import java.time.LocalDate;
import java.util.List;

public interface ScheduleRepository {
  void save(Schedule schedule);
  void update(Schedule schedule);
  Schedule findById(String id);
  List<Schedule> findAll();
  List<Schedule> findByMonth(int year, int month);
  List<Schedule> findByStaffId(String staffId);
  void delete(String id);
}
