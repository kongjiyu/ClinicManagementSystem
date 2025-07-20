package models;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "Supplier")
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Supplier {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String supplierId;

    private String supplierName;

    private String contactPerson;

    private String phoneNumber;

    @Email
    private String email;

    private String address;

    private String bankName;

    private String accountNumber;
}

