package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "Orders")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Order {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String ordersID;

    private String medicineID;

    private String supplierID;

    private String staffID;

    private LocalDate orderDate;

    private String orderStatus;

    private double unitPrice;

    private int quantity;

    private double totalAmount;

    private LocalDate expiryDate;

    private int stock;
}
