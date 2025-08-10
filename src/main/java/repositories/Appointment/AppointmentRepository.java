package repositories.Appointment;
import models.Appointment;
import models.Consultation;
import utils.List;
import utils.MultiMap;

import java.time.LocalDate;
import java.time.LocalDateTime;

public interface AppointmentRepository {
  // Create
  void create(Appointment appointment);

  // Read
  Appointment findById(String id);

  MultiMap<String,Appointment> groupByPatientId();
  MultiMap<String,Appointment> groupByStatus();

  List<Appointment> findByPatientId(String patientID);
  List<Appointment> findByStatus(String status);
  List<Appointment> findAll();
  List<Appointment> findByDate(LocalDate date); // For today's appointments
  MultiMap<String, Appointment> groupByAvailability();


  // Update
  void update(Appointment appointment);              // General update (e.g. PUT)
  void reschedule(String appointmentID, LocalDateTime newTime); // Specifically for rescheduling

  // Status
  void updateStatus(String appointmentID, String newStatus); // e.g. "Checked-in", "Cancelled"

  // Extra
  List<Appointment> findUpcomingByPatientId(String patientID);
}
