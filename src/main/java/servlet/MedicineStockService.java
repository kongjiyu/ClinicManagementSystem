package servlet;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Medicine;
import models.Order;
import models.Prescription;
import repositories.Medicine.MedicineRepository;
import repositories.Order.OrderRepository;
import repositories.Prescription.PrescriptionRepository;

import java.time.LocalDate;
import utils.List;
import DTO.StockInfo;

@ApplicationScoped
public class MedicineStockService {

    @PersistenceContext
    private EntityManager em;

    @Inject
    private OrderRepository orderRepository;

    @Inject
    private MedicineRepository medicineRepository;

    @Inject
    private PrescriptionRepository prescriptionRepository;

    /**
     * Deduct medicine stock when consultation is paid
     * Uses FIFO method - deducts from oldest non-expired batches first
     */
    @Transactional
    public boolean deductMedicineStock(String consultationId) {
        try {
            // Get all prescriptions for this consultation
            List<Prescription> prescriptions = prescriptionRepository.findByConsultationId(consultationId);
            
            if (prescriptions.isEmpty()) {
                return true; // No prescriptions, nothing to deduct
            }

            boolean allDeductionsSuccessful = true;
            StringBuilder errorMessages = new StringBuilder();

            for (Prescription prescription : prescriptions) {
                String medicineId = prescription.getMedicineID();
                int requiredQuantity = prescription.getQuantityDispensed();

                System.out.println("DEBUG: Processing prescription for medicine " + medicineId + ", quantity: " + requiredQuantity);

                if (requiredQuantity <= 0) {
                    System.out.println("DEBUG: Skipping prescription with zero quantity");
                    continue; // Skip if no quantity to dispense
                }

                // Try to deduct from medicine batches using FIFO
                boolean deductionSuccess = deductFromBatches(medicineId, requiredQuantity);
                
                if (!deductionSuccess) {
                    allDeductionsSuccessful = false;
                    Medicine medicine = medicineRepository.findById(medicineId);
                    String medicineName = medicine != null ? medicine.getMedicineName() : medicineId;
                    errorMessages.append("Insufficient stock for ").append(medicineName)
                                .append(" (Required: ").append(requiredQuantity).append(")\n");
                }
            }

            if (!allDeductionsSuccessful) {
                throw new RuntimeException("Stock deduction failed:\n" + errorMessages.toString());
            }

            return true;

        } catch (Exception e) {
            throw new RuntimeException("Error deducting medicine stock: " + e.getMessage(), e);
        }
    }

    /**
     * Deduct medicine from batches using FIFO method
     */
    private boolean deductFromBatches(String medicineId, int requiredQuantity) {
        // Get all non-expired batches for this medicine, ordered by oldest first (FIFO)
        List<Order> batches = findNonExpiredBatchesByMedicineId(medicineId);
        
        System.out.println("DEBUG: Stock deduction for medicine " + medicineId + ", required: " + requiredQuantity);
        System.out.println("DEBUG: Found " + batches.size() + " batches");
        
        int remainingToDeduct = requiredQuantity;
        int totalAvailableStock = 0;

        // Calculate total available stock
        for (Order batch : batches) {
            totalAvailableStock += batch.getStock();
            System.out.println("DEBUG: Batch " + batch.getOrdersID() + " has stock: " + batch.getStock() + 
                             ", expiry: " + batch.getExpiryDate() + ", status: " + batch.getOrderStatus());
        }

        System.out.println("DEBUG: Total available stock: " + totalAvailableStock + ", required: " + requiredQuantity);

        // Check if we have enough stock
        if (totalAvailableStock < requiredQuantity) {
            System.out.println("DEBUG: Insufficient stock! Available: " + totalAvailableStock + ", Required: " + requiredQuantity);
            return false; // Insufficient stock
        }

        // Deduct from batches using FIFO
        for (Order batch : batches) {
            if (remainingToDeduct <= 0) {
                break;
            }

            int availableInBatch = batch.getStock();
            int toDeductFromBatch = Math.min(remainingToDeduct, availableInBatch);

            // Update batch stock
            batch.setStock(availableInBatch - toDeductFromBatch);
            orderRepository.update(batch);

            remainingToDeduct -= toDeductFromBatch;
        }

        return remainingToDeduct == 0;
    }



    /**
     * Check if there's sufficient stock for a prescription
     */
    public boolean checkStockAvailability(String medicineId, int requiredQuantity) {
        List<Order> batches = findNonExpiredBatchesByMedicineId(medicineId);
        
        int totalAvailableStock = 0;
        for (Order batch : batches) {
            totalAvailableStock += batch.getStock();
        }

        return totalAvailableStock >= requiredQuantity;
    }

    /**
     * Get available stock for a medicine (non-expired batches only)
     */
    public int getAvailableStock(String medicineId) {
        List<Order> batches = findNonExpiredBatchesByMedicineId(medicineId);
        
        int totalAvailableStock = 0;
        for (Order batch : batches) {
            totalAvailableStock += batch.getStock();
        }

        return totalAvailableStock;
    }

    /**
     * Calculate total stock for a medicine (all completed batches, including expired)
     * This is for display purposes only - use getAvailableStock() for actual availability
     */
    public int calculateTotalStock(String medicineId) {
        List<Order> allCompletedBatches = findActiveBatchesByMedicineId(medicineId);
        
        int totalStock = 0;
        for (Order batch : allCompletedBatches) {
            totalStock += batch.getStock();
        }

        return totalStock;
    }

    /**
     * Get detailed stock information for a medicine
     */
    public StockInfo getStockInfo(String medicineId) {
        List<Order> allCompletedBatches = findActiveBatchesByMedicineId(medicineId);
        List<Order> nonExpiredBatches = findNonExpiredBatchesByMedicineId(medicineId);
        
        int totalStock = 0;
        int availableStock = 0;
        int expiredStock = 0;
        
        for (Order batch : allCompletedBatches) {
            totalStock += batch.getStock();
        }
        
        for (Order batch : nonExpiredBatches) {
            availableStock += batch.getStock();
        }
        
        expiredStock = totalStock - availableStock;
        
        return new StockInfo(totalStock, availableStock, expiredStock);
    }

    /**
     * Find active batches by medicine ID (completed orders with stock > 0)
     */
    private List<Order> findActiveBatchesByMedicineId(String medicineId) {
        List<Order> allOrders = orderRepository.findAll();
        List<Order> activeBatches = new utils.List<>();
        
        for (Order order : allOrders) {
            if (order.getMedicineID().equals(medicineId) && 
                "Completed".equals(order.getOrderStatus()) && 
                order.getStock() > 0) {
                activeBatches.add(order);
            }
        }
        
        // Sort by order date (oldest first for FIFO)
        return sortOrdersByDate(activeBatches);
    }

    /**
     * Find non-expired batches by medicine ID
     */
    private List<Order> findNonExpiredBatchesByMedicineId(String medicineId) {
        LocalDate today = LocalDate.now();
        List<Order> allOrders = orderRepository.findAll();
        List<Order> nonExpiredBatches = new utils.List<>();
        
        for (Order order : allOrders) {
            if (order.getMedicineID().equals(medicineId) && 
                "Completed".equals(order.getOrderStatus()) && 
                order.getStock() > 0 && 
                order.getExpiryDate() != null &&
                order.getExpiryDate().isAfter(today)) {
                nonExpiredBatches.add(order);
            }
        }
        
        // Sort by order date (oldest first for FIFO)
        return sortOrdersByDate(nonExpiredBatches);
    }

    /**
     * Sort orders by order date (oldest first for FIFO)
     */
    private List<Order> sortOrdersByDate(List<Order> orders) {
        // Simple bubble sort for order date (oldest first)
        for (int i = 0; i < orders.size() - 1; i++) {
            for (int j = 0; j < orders.size() - i - 1; j++) {
                Order order1 = orders.get(j);
                Order order2 = orders.get(j + 1);
                
                if (order1.getOrderDate() != null && order2.getOrderDate() != null &&
                    order1.getOrderDate().isAfter(order2.getOrderDate())) {
                    // Swap orders
                    orders.set(j, order2);
                    orders.set(j + 1, order1);
                }
            }
        }
        
        return orders;
    }

}
