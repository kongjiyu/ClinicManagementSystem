package DTO;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderWithDetailsDTO {
    private String ordersID;
    private String medicineID;
    private String medicineName;
    private String supplierID;
    private String supplierName;
    private String staffID;
    private String staffName;
    private LocalDate orderDate;
    private String orderStatus;
    private double unitPrice;
    private int quantity;
    private double totalAmount;
    private LocalDate expiryDate;
    private int stock;
}
