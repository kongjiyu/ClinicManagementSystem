package repositories.Schedule;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Schedule;

import java.util.List;

@ApplicationScoped
@Transactional
public class ScheduleRepositoryImpl implements ScheduleRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public void save(Schedule schedule) {
    em.persist(schedule);
  }

  @Override
  public void update(Schedule schedule) {
    em.merge(schedule);
  }

  @Override
  public Schedule findById(String id) {
    return em.find(Schedule.class, id);
  }

  @Override
  public List<Schedule> findAll() {
    return em.createQuery("SELECT s FROM Schedule s", Schedule.class).getResultList();
  }

  @Override
  public List<Schedule> findByMonth(int year, int month) {
    return em.createQuery("SELECT s FROM Schedule s WHERE YEAR(s.date) = :year AND MONTH(s.date) = :month", Schedule.class)
             .setParameter("year", year)
             .setParameter("month", month)
             .getResultList();
  }

  @Override
  public List<Schedule> findByStaffId(String staffId) {
    return em.createQuery("SELECT s FROM Schedule s WHERE s.doctor.staffID = :staffId", Schedule.class)
             .setParameter("staffId", staffId)
             .getResultList();
  }

  @Override
  public void delete(String id) {
    Schedule schedule = em.find(Schedule.class, id);
    if (schedule != null) {
      em.remove(schedule);
    }
  }
}
