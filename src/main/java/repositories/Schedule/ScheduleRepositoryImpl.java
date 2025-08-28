package repositories.Schedule;

/**
 * Author: Yap Yu Xin
 * Consultation Module
 */

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Schedule;
import utils.List;

import java.time.LocalDate;
import java.time.LocalDateTime;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class ScheduleRepositoryImpl implements ScheduleRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public void create(Schedule schedule) {
    em.persist(schedule);
  }

  @Override
  public void update(Schedule schedule) {
    em.merge(schedule);
  }

  @Override
  public Schedule findById(String id) {
    List<Schedule> schedules = findAll();
    for (Schedule schedule : schedules) {
      if (schedule.getScheduleID().equals(id)) {
        return schedule;
      }
    }
    return null;
  }

  @Override
  public List<Schedule> findAll() {
    return new List<>(em.createQuery("SELECT s FROM Schedule s", Schedule.class).getResultList());
  }

  @Override
  public List<Schedule> findByMonth(int year, int month) {
    List<Schedule> schedules = findAll();
    List<Schedule> monthResult = new List<>();

    for (Schedule schedule : schedules) {
      LocalDate date = schedule.getDate();
      if (date.getYear() == year && date.getMonthValue() == month) {
        monthResult.add(schedule);
      }
    }

    return monthResult;
  }


  @Override
  public List<Schedule> findByStaffId(String staffID) {
    MultiMap<String, Schedule> scheduleMap = groupByStaffID();
    return scheduleMap.get(staffID);
  }

  @Override
  public Schedule findByDateAndTime(LocalDate date, LocalDateTime time) {
    List<Schedule> schedules = findAll();
    for (Schedule schedule : schedules) {
      if (schedule.getDate().equals(date) &&
          time.isAfter(schedule.getStartTime()) &&
          time.isBefore(schedule.getEndTime())) {
        return schedule;
      }
    }
    return null;
  }

  @Override
  public void delete(String id) {
    Schedule schedule = em.find(Schedule.class, id);
    if (schedule != null) {
      em.remove(schedule);
    }
  }

  public MultiMap<String, Schedule> groupByStaffID() {
    List<Schedule> schedules = findAll();
    MultiMap<String, Schedule> staffScheduleMap = new MultiMap<>();

    for (Schedule schedule : schedules) {
      // Add doctor 1 if exists
      if (schedule.getDoctorID1() != null && !schedule.getDoctorID1().trim().isEmpty()) {
        staffScheduleMap.put(schedule.getDoctorID1(), schedule);
      }
      // Add doctor 2 if exists
      if (schedule.getDoctorID2() != null && !schedule.getDoctorID2().trim().isEmpty()) {
        staffScheduleMap.put(schedule.getDoctorID2(), schedule);
      }
    }

    return staffScheduleMap;
  }

}
