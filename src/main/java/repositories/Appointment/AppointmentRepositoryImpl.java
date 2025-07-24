package repositories.Appointment;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import models.Appointment;

import java.lang.reflect.Array;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import utils.ArrayList;
import utils.MultiMap;

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
    ArrayList<Appointment>appointments=findAll();
    for(Appointment appointment:appointments){
      if(appointmentID.equals(appointment.getAppointmentID())){
        return appointment;
      }
    }
    return null;
  }

  @Override
  public MultiMap<String,Appointment> groupByPatientId(){
    ArrayList<Appointment> appointments = findAll();
    MultiMap<String,Appointment> patientAppoinementMap = new MultiMap<>();
    for(Appointment appointment : appointments){
      patientAppoinementMap.put(appointment.getPatientID(), appointment);
    }
    return patientAppoinementMap;
  }

  @Override
  public ArrayList<Appointment> findByPatientId(String patientID) {
    MultiMap<String,Appointment> patientAppoinementMap = groupByPatientId();
    return patientAppoinementMap.get(patientID);
  }

  @Override
  public ArrayList<Appointment> findAll() {
    return new ArrayList<>(em.createQuery("SELECT a FROM Appointment a", Appointment.class)
            .getResultList());
  }

  @Override
  public ArrayList<Appointment> findByDate(LocalDate date) {
    ArrayList<Appointment> appointments = findAll();
    ArrayList<Appointment> patientAppoinementList = new ArrayList<>();
    for(Appointment appointment : appointments){
      if (appointment.getAppointmentTime().toLocalDate().equals(date)){
        patientAppoinementList.add(appointment);
      }
    }
   return patientAppoinementList;
  }

  @Override
  public MultiMap<String, Appointment> groupByAvailability() {
    return null;
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
  public ArrayList<Appointment> findUpcomingByPatientId(String patientID) {
    ArrayList<Appointment> appointments = findAll();
    ArrayList<Appointment> patientAppoinementList = new ArrayList<>();
    LocalDate now = LocalDate.now();
    for(Appointment appointment : appointments){
      if (appointment.getAppointmentTime().toLocalDate().isAfter(now) ||
      appointment.getAppointmentTime().toLocalDate().equals(now)) {
        patientAppoinementList.add(appointment);
      }
    }
   return patientAppoinementList;
  }
}
