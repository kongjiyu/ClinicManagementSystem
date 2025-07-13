package repositories.Appointment;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import models.Appointment;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;


@ApplicationScoped
@Transactional
public class AppointmentRepositoryImpl implements AppointmentRepository {
  @PersistenceContext
  private EntityManager em;

  @Override
  public void create(Appointment appointment) {
    em.persist(appointment);
  }

  @Override
  public Appointment findById(String appointmentID) {
    return em.find(Appointment.class, appointmentID);
  }

  @Override
  public List<Appointment> findByPatientId(String patientID) {
    TypedQuery<Appointment> query = em.createQuery(
        "SELECT a FROM Appointment a WHERE a.patientID = :patientID", Appointment.class);
    query.setParameter("patientID", patientID);
    return query.getResultList();
  }

  @Override
  public List<Appointment> findAll() {
    return em.createQuery("SELECT a FROM Appointment a", Appointment.class).getResultList();
  }

  @Override
  public List<Appointment> findByDate(LocalDate date) {
    return em.createQuery(
      "SELECT a FROM Appointment a WHERE a.appointmentDate = :date", Appointment.class)
      .setParameter("date", date)
      .getResultList();
  }

  @Override
  public void update(Appointment appointment) {
    em.merge(appointment);
  }

  @Override
  public void reschedule(String appointmentID, LocalDateTime newTime) {
    Appointment appointment = em.find(Appointment.class, appointmentID);
    if (appointment != null) {
      appointment.setAppointmentTime(newTime);
      em.merge(appointment);
    }
  }

  @Override
  public void updateStatus(String appointmentID, String newStatus) {
    Appointment appointment = em.find(Appointment.class, appointmentID);
    if (appointment != null) {
      appointment.setStatus(newStatus);
      em.merge(appointment);
    }
  }

  @Override
  public List<Appointment> findUpcomingByPatientId(String patientID) {
    return em.createQuery(
      "SELECT a FROM Appointment a WHERE a.patientID = :patientID AND a.appointmentDate >= :today", Appointment.class)
      .setParameter("patientID", patientID)
      .setParameter("today", java.time.LocalDate.now())
      .getResultList();
  }
}
