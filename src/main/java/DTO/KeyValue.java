package DTO;

/**
 * Author: Kong Ji Yu
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeyValue<K, V> {
    private K key;
    private V value;
}
