package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "Order")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Order {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String orderID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medicineID", referencedColumnName = "medicineID")
    private Medicine medicine;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "supplierID", referencedColumnName = "supplierID")
    private Supplier supplier;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "staffID", referencedColumnName = "staffID")
    private Staff staff;

    private LocalDate orderDate;
    private String orderStatus;
    private double unitPrice;
    private int quantity;
    private double totalAmount;
    private LocalDate expiryDate;
    private int stock;
}
