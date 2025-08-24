package models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "Medicine")
public class Medicine {
    @Id
    @GeneratedValue(generator = "prefix_id")
    @GenericGenerator(name = "prefix_id", strategy = "utils.PrefixIdGenerator")
    private String medicineID;

    private String medicineName;

    private String description;

    // Note: totalStock is now calculated dynamically from Order batches
    // This field is kept for backward compatibility but should not be used
    @Transient // This makes it non-persistent
    private int totalStock;

    private int reorderLevel;

    private double sellingPrice;
}
