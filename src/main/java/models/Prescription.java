package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

@Getter
@Setter
@Entity
@Table(name = "Prescription")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Prescription {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String prescriptionID;

    private String consultationID;

    private String medicineID;

    private String description;

    private int dosage;

    private String instruction;

    private int servingPerDay;

    private int quantityDispensed;

    private double price;

    private String dosageUnit;
}
