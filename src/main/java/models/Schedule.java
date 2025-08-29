package models;

/**
 * Author: Kong Ji Yu
 * Consultation Module
 */

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "Schedule")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Schedule {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String scheduleID;

    private String doctorID1; // First doctor

    private String doctorID2; // Second doctor (can be null)

    private LocalDate date;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private String shift;
}
