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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "consultationID", referencedColumnName = "consultationID")
    private Consultation consultation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "billID", referencedColumnName = "billID")
    private Bill bill;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicineID", referencedColumnName = "medicineID")
    private Medicine medicine;

    private String description;

    private int dosage;

    private int instruction;

    private int servingPerDay;

    private double price;

    private String dosageUnit;
}
