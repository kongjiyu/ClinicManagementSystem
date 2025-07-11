package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

@Getter
@Setter
@Entity
@Table(name = "Bill")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Bill {

    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String billID;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "prescriptionID", referencedColumnName = "prescriptionID")
    private Prescription prescription;

    private double totalAmount;
    private String paymentMethod;
}
