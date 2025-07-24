package repositories.Schedule;

import models.Schedule;
import java.time.LocalDate;
import utils.ArrayList;
import utils.MultiMap;

public interface ScheduleRepository {
  void save(Schedule schedule);
  void update(Schedule schedule);
  Schedule findById(String id);
  ArrayList<Schedule> findAll();
  ArrayList<Schedule> findByMonth(int year, int month);
  ArrayList<Schedule> findByStaffId(String staffId);
  void delete(String id);
  MultiMap<String, Schedule> groupByStaffID();
}
