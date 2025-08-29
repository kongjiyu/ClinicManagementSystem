package DTO;

/**
 * Author: Kong Ji Yu
 * Consultation Module
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleAssignmentRequest {
    private String date;
    private String shift;
    private String doctorID1;
    private String doctorID2;
}
