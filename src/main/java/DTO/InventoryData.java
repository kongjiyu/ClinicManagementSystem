package DTO;

/**
 * Author: Oh Wan Ting
 * Pharmacy Module
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InventoryData {
    private String medicineId;
    private String medicineName;
    private int currentStock;
    private int reorderLevel;
    private double stockValue;
    private int pendingOrders;
    private int completedOrders;
    private String status;
}
