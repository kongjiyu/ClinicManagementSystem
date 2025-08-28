package DTO;

/**
 * Author: Yap Yu Xin
 * Consultation Module
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QueueItem {
    private String consultationId;
    private String patientName;
    private String patientId;
    private String status;
    private LocalDate consultationDate;
    private LocalDateTime checkInTime;
    private String waitingTime;
    private String invoiceID;
    private String billID;
    private int treatmentCount;
}
