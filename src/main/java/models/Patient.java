package models;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

@Getter
@Setter
@Entity
@Table(name = "Patient")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Patient {
  @Id
  @GeneratedValue(generator = "prefix_id")
  @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
  private String patientID;
  private String firstName;
  private String lastName;
  private String gender;
  private String dateOfBirth;
  private int age;
  private String nationality;
  private String idType;
  private String idNumber;
  private String studentId;
  private String staffId;
  private String contactNumber;
  @Email
  private String email;
  private String address;
  private String emergencyContactName;
  private String emergencyContactNumber;
  private String allergies;
  private char bloodType;
}
