package models;

/**
 * Author: Yap Yu Xin
 * Consultation Module
 */

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "Appointment")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Appointment {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String appointmentID;

    private String patientID;

    private LocalDateTime appointmentTime;

    private String status;

    private String description;

    private String reason;
}
