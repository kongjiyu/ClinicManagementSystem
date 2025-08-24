package DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import models.Appointment;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentWithPatientDTO {
    private String appointmentID;
    private String patientID;
    private String patientName;
    private String doctorID;
    private String doctorName;
    private LocalDateTime appointmentTime;
    private String status;
    private String description;
    
    public static AppointmentWithPatientDTO fromAppointment(Appointment appointment, String patientName, String doctorName) {
        return new AppointmentWithPatientDTO(
            appointment.getAppointmentID(),
            appointment.getPatientID(),
            patientName,
            null, // doctorID will be set separately
            doctorName,
            appointment.getAppointmentTime(),
            appointment.getStatus(),
            appointment.getDescription()
        );
    }
}
