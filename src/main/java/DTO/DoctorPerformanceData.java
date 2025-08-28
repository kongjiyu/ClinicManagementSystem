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
public class DoctorPerformanceData {
    private String doctorId;
    private String doctorName;
    private int consultations;
    private int diagnoses;
    private double diagnosisRate;
    private int treatments;
    private int experience;
    private String position;
    private String contactNumber;
    private String topDiagnosis;
}
