package repositories.Appointment;
import models.Appointment;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository {
  // Create
  void create(Appointment appointment);

  // Read
  Appointment findById(String appointmentID);
  List<Appointment> findByPatientId(String patientID);
  List<Appointment> findAll();
  List<Appointment> findByDate(LocalDate date); // For today's appointments

  // Update
  void update(Appointment appointment);              // General update (e.g. PUT)
  void reschedule(String appointmentID, LocalDateTime newTime); // Specifically for rescheduling

  // Status
  void updateStatus(String appointmentID, String newStatus);    // e.g. "Checked-in", "Cancelled"

  // Extra
  List<Appointment> findUpcomingByPatientId(String patientID);
}
