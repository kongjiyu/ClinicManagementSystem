package models;

/**
 * Author: Oh Wan Ting
 * Treatment Module
 */

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "Treatment")
public class Treatment {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String treatmentID;

    private String consultationID;  // Link to consultation
    private String patientID;

    private String treatmentType;   // e.g., "Surgery", "Physical Therapy", "Vaccination"
    private String treatmentName;   // e.g., "Appendectomy", "Flu Shot"
    private String description;
    private String treatmentProcedure;

    private LocalDateTime treatmentDate;
    private String status;          // "Scheduled", "In Progress", "Completed", "Cancelled"
    private String outcome;         // "Successful", "Failed", "Partial Success"

    private int duration;           // in minutes
    private String notes;
    private double price;           // treatment cost in RM
}
