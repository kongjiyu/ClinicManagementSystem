package models;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.util.List;

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

    private double totalAmount;

    private String paymentMethod;
}
