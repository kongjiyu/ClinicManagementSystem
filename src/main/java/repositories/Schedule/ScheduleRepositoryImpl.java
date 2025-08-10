package repositories.Schedule;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Schedule;
import utils.List;

import java.time.LocalDate;
import java.util.List;
import utils.ArrayList;
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
    return new ArrayList<>(em.createQuery("SELECT s FROM Schedule s", Schedule.class).getResultList());
  }

  @Override
  public ArrayList<Schedule> findByMonth(int year, int month) {
    ArrayList<Schedule> schedules = findAll();
    ArrayList<Schedule> monthResult = new ArrayList<>();

    for (Schedule schedule : schedules) {
      LocalDate date = schedule.getDate();
      if (date.getYear() == year && date.getMonthValue() == month) {
        monthResult.add(schedule);
      }
    }

    return monthResult;
  }


  @Override
  public ArrayList<Schedule> findByStaffId(String staffID) {
    MultiMap<String, Schedule> scheduleMap = groupByStaffID();
    return scheduleMap.get(staffID);
  }

  @Override
  public void delete(String id) {
    Schedule schedule = em.find(Schedule.class, id);
    if (schedule != null) {
      em.remove(schedule);
    }
  }

  public MultiMap<String, Schedule> groupByStaffID() {
    ArrayList<Schedule> schedules = findAll();
    MultiMap<String, Schedule> staffScheduleMap = new MultiMap<>();

    for (Schedule schedule : schedules) {
      String staffID = schedule.getDoctorID();
      staffScheduleMap.put(staffID, schedule);
    }

    return staffScheduleMap;
  }

}
