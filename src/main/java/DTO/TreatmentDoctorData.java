package DTO;

/**
 * Author: Kong Ji Yu
 * Doctor Module
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TreatmentDoctorData {
    private String doctorId;
    private String doctorName;
    private int totalTreatments;
    private int completedTreatments;
    private double successRate;
    private String topTreatmentType;
}
