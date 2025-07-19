package models;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;


import java.time.*;
import java.util.List;

@Entity
@Table(name = "Staff")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Staff {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String staffID;

    private String firstName;

    private String lastName;

    private String gender;

    private LocalDate dateOfBirth;

    private String nationality;

    private String idType;

    private String idNumber;

    private String contactNumber;

    @Email
    private String email;

    private String address;

    private String position;

    private String medicalLicenseNumber;

    private String password;

    private LocalDate employmentDate;

    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Schedule> schedules;

    @OneToMany(mappedBy = "staff", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations;

    @OneToMany(mappedBy = "staff", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Order> orders;
}
