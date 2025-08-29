package repositories.Schedule;

/**
 * Author: Chia Yu Xin
 * Consultation Module
 */

import models.Schedule;
import java.time.LocalDate;
import java.time.LocalDateTime;
import utils.MultiMap;
import utils.List;

public interface ScheduleRepository {
  void create(Schedule schedule);
  void update(Schedule schedule);
  Schedule findById(String id);
  List<Schedule> findAll();
  List<Schedule> findByMonth(int year, int month);
  List<Schedule> findByStaffId(String staffId);
  Schedule findByDateAndTime(LocalDate date, LocalDateTime time);
  void delete(String id);
  MultiMap<String, Schedule> groupByStaffID();
}
