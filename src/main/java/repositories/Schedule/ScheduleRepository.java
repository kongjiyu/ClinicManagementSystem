package repositories.Schedule;

import models.Schedule;
import java.time.LocalDate;
import utils.MultiMap;
import utils.List;

public interface ScheduleRepository {
  void create(Schedule schedule);
  void update(Schedule schedule);
  Schedule findById(String id);
  List<Schedule> findAll();
  List<Schedule> findByMonth(int year, int month);
  List<Schedule> findByStaffId(String staffId);
  void delete(String id);
  MultiMap<String, Schedule> groupByStaffID();
}
