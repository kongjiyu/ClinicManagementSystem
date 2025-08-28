package DTO;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PaymentMethodRequest {
    private String paymentMethod;
}
