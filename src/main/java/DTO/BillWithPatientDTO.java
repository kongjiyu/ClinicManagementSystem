package DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import utils.List;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BillWithPatientDTO {
    private String billID;
    private String consultationID;
    private String patientID;
    private String patientName;
    private String patientContact;
    private String patientEmail;
    private String doctorID;
    private String doctorName;
    private LocalDate consultationDate;
    private double totalAmount;
    private String paymentMethod;
    private List<BillItem> billItems;
}
