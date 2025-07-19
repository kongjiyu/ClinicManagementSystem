package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patientID", referencedColumnName = "patientID")
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctorID", referencedColumnName = "staffID")
    private Staff doctor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "staffID", referencedColumnName = "staffID")
    private Staff staff;

    private String symptoms;

    private String diagnosis;

    private LocalDate consultationDate;

    private LocalDateTime checkInTime;

    private boolean isFollowUpRequired;

    private LocalDate followUpDate;

    private String status;

    private String mcID;

    private LocalDate startDate;

    private LocalDate endDate;

    @OneToMany(mappedBy = "consultation", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Prescription> prescriptions;
}
