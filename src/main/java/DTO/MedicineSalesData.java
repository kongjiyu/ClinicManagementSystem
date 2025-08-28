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
public class MedicineSalesData {
    private String medicineId;
    private String medicineName;
    private int quantitySold;
    private double revenue;
}
