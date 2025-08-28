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
public class StockInfo {
    private int totalStock;
    private int availableStock;
    private int expiredStock;
}
