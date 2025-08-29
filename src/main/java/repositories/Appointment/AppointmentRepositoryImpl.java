package repositories.Appointment;

/**
 * Author: Chia Yu Xin
 * Consultation Module
 */

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import models.Appointment;

import java.lang.reflect.Array;
import java.time.LocalDate;
import java.time.LocalDateTime;
import utils.TimeUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import utils.List;
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
    List<Appointment>appointments=findAll();
    for(Appointment appointment:appointments){
      if(appointmentID.equals(appointment.getAppointmentID())){
        return appointment;
      }
    }
    return null;
  }

  @Override
  public MultiMap<String,Appointment> groupByPatientId(){
    List<Appointment> appointments = findAll();
    MultiMap<String,Appointment> patientAppointmentMap = new MultiMap<>();
    for(Appointment appointment : appointments){
      patientAppointmentMap.put(appointment.getPatientID(), appointment);
    }
    return patientAppointmentMap;
  }

  @Override
  public MultiMap<String,Appointment> groupByStatus(){
    List<Appointment> appointments = findAll();
    MultiMap<String,Appointment>statusAppointmentMap = new MultiMap<>();
    for(Appointment appointment : appointments){
      statusAppointmentMap.put(appointment.getStatus(), appointment);
    }
    return statusAppointmentMap;
  }

  @Override
  public List<Appointment> findByPatientId(String patientID) {
    MultiMap<String,Appointment> patientAppointmentMap = groupByPatientId();
    return patientAppointmentMap.get(patientID);
  }

  @Override
  public List<Appointment> findByStatus(String status) {
    MultiMap<String,Appointment> statusAppointmentMap = groupByStatus();
    return statusAppointmentMap.get(status);
  }

  @Override
  public List<Appointment> findAll() {
    return new List<>(em.createQuery("SELECT a FROM Appointment a", Appointment.class)
            .getResultList());
  }

  @Override
  public List<Appointment> findByDate(LocalDate date) {
    List<Appointment> appointments = findAll();
    List<Appointment> patientAppoinementList = new List<>();
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
  public void delete(String id) {
    em.remove(em.find(Appointment.class, id));
  }

  @Override
  public List<Appointment> findUpcomingByPatientId(String patientID) {
    List<Appointment> appointments = findAll();
    List<Appointment> patientAppoinementList = new List<>();
    LocalDate now = LocalDate.now();
    for(Appointment appointment : appointments){
      if (appointment.getAppointmentTime().toLocalDate().isAfter(now) ||
      appointment.getAppointmentTime().toLocalDate().equals(now)) {
        patientAppoinementList.add(appointment);
      }
    }
   return patientAppoinementList;
  }

  @Override
  public List<Appointment> findUpcoming() {
    List<Appointment> appointments = findAll();
    List<Appointment> upcomingAppointments = new List<>();
            LocalDateTime now = TimeUtils.nowMalaysia();
    
    for(Appointment appointment : appointments){
      if (appointment.getAppointmentTime().isAfter(now) ||
          appointment.getAppointmentTime().equals(now)) {
        upcomingAppointments.add(appointment);
      }
    }
    return upcomingAppointments;
  }
  
  // Sorting method implementations
  @Override
  public List<Appointment> findAllSortedByDateTime() {
    List<Appointment> appointments = findAll();
    return (List<Appointment>) appointments.sort((a, b) -> {
      if (a.getAppointmentTime() == null && b.getAppointmentTime() == null) return 0;
      if (a.getAppointmentTime() == null) return 1;
      if (b.getAppointmentTime() == null) return -1;
      return b.getAppointmentTime().compareTo(a.getAppointmentTime()); // Newest first
    });
  }
  
  @Override
  public List<Appointment> findTodayAppointmentsSorted() {
    List<Appointment> todayAppointments = findByDate(LocalDate.now());
    return (List<Appointment>) todayAppointments.sort((a, b) -> {
      if (a.getAppointmentTime() == null && b.getAppointmentTime() == null) return 0;
      if (a.getAppointmentTime() == null) return 1;
      if (b.getAppointmentTime() == null) return -1;
      return a.getAppointmentTime().compareTo(b.getAppointmentTime()); // Earliest first for today
    });
  }
  
  @Override
  public List<Appointment> findUpcomingSorted() {
    List<Appointment> upcomingAppointments = findUpcoming();
    return (List<Appointment>) upcomingAppointments.sort((a, b) -> {
      if (a.getAppointmentTime() == null && b.getAppointmentTime() == null) return 0;
      if (a.getAppointmentTime() == null) return 1;
      if (b.getAppointmentTime() == null) return -1;
      return a.getAppointmentTime().compareTo(b.getAppointmentTime()); // Earliest first
    });
  }
}

