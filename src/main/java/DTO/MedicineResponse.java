package DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import models.Medicine;
import DTO.StockInfo;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MedicineResponse {
    private String medicineID;
    private String medicineName;
    private String description;
    private String unit;
    private int reorderLevel;
    private double sellingPrice;
    private int totalStock;
    private int availableStock;
    private int expiredStock;

    public MedicineResponse(Medicine medicine, StockInfo stockInfo) {
        this.medicineID = medicine.getMedicineID();
        this.medicineName = medicine.getMedicineName();
        this.description = medicine.getDescription();
        this.unit = medicine.getUnit();
        this.reorderLevel = medicine.getReorderLevel();
        this.sellingPrice = medicine.getSellingPrice();
        this.totalStock = stockInfo.getTotalStock();
        this.availableStock = stockInfo.getAvailableStock();
        this.expiredStock = stockInfo.getExpiredStock();
    }
}
