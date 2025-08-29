package DTO;

/**
 * Author: Oh Wan Ting
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
