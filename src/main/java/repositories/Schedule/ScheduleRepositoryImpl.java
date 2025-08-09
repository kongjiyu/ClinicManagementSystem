package repositories.Schedule;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Schedule;
import utils.List;

import java.time.Month;
import java.util.ArrayList;
import java.util.Iterator;

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
    List<Schedule> results = new List<>();
    for (Schedule schedule : schedules) {
      if (schedule.getDate().getMonth() == Month.of(month) && schedule.getDate().getYear() == year) {
        results.add(schedule);
      }
    }
    return results;
  }

  @Override
  public List<Schedule> findByStaffId(String staffId) {
    List<Schedule> schedules = findAll();
    List<Schedule> results = new List<>();
    for (Schedule schedule : schedules) {
      if(schedule.getDoctorID().equals(staffId)) {
        results.add(schedule);
      }
    }
    return results;
  }

  @Override
  public void delete(String id) {
    Schedule schedule = em.find(Schedule.class, id);
    if (schedule != null) {
      em.remove(schedule);
    }
  }
}
