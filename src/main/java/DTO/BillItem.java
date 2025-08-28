package DTO;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BillItem {
    private String itemName;
    private String description;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private String medicineID;
    private String dosageUnit;
}
