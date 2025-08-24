package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "Consultation")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Consultation {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String consultationID;

    private String patientID;

    private String doctorID;

    private String staffID;

    private String billID;

    private String symptoms;

    private String diagnosis;

    private LocalDate consultationDate;

    private LocalDateTime checkInTime;

    private String status;

    private String mcID;

    private LocalDate startDate;

    private LocalDate endDate;

}
