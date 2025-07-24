package repositories.Appointment;
import models.Appointment;
import models.Consultation;
import utils.ArrayList;
import utils.MultiMap;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository {
  // Create
  void create(Appointment appointment);

  // Read
  Appointment findById(String id);

  MultiMap<String,Appointment> groupByPatientId();

  ArrayList<Appointment> findByPatientId(String patientID);
  ArrayList<Appointment> findAll();
  ArrayList<Appointment> findByDate(LocalDate date); // For today's appointments
  MultiMap<String, Appointment> groupByAvailability();


  // Update
  void update(Appointment appointment);              // General update (e.g. PUT)
  void reschedule(String appointmentID, LocalDateTime newTime); // Specifically for rescheduling

  // Status
  void updateStatus(String appointmentID, String newStatus);    // e.g. "Checked-in", "Cancelled"

  // Extra
  ArrayList<Appointment> findUpcomingByPatientId(String patientID);
}
