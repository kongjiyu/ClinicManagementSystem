package models;

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

    private String doctorID;

    private LocalDate date;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private String shift;
}
