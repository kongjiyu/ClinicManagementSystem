package utils;

/**
 * Author: all members
 */

import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.id.IdentifierGenerator;
import java.io.Serializable;
import java.time.ZoneId;
import java.util.stream.Stream;

public class PrefixIdGenerator implements IdentifierGenerator {

  @Override
  public Serializable generate(SharedSessionContractImplementor session, Object object) {
    String className = object.getClass().getSimpleName();
    String prefix = className.substring(0, 2).toUpperCase();

    // Determine the correct field name based on the entity class
    String fieldName = getFieldName(className);
    String query = String.format("SELECT e.%s FROM %s e ORDER BY e.%s DESC", fieldName, className, fieldName);

    try {
      Stream<String> ids = session.createQuery(query, String.class).stream();

      Long max = ids.map(id -> id.replaceAll("[^0-9]", ""))
        .filter(s -> !s.isEmpty())
        .mapToLong(Long::parseLong)
        .max()
        .orElse(0L);

      return prefix + String.format("%04d", max + 1);
    } catch (Exception e) {
      // If query fails, return a timestamp-based ID as fallback
      // Use Malaysia timezone for timestamp
      return prefix + System.currentTimeMillis();
    }
  }

  private String getFieldName(String className) {
    switch (className) {
      case "Bill":
        return "billID";
      case "Patient":
        return "patientID";
      case "Staff":
        return "staffID";
      case "Consultation":
        return "consultationID";
      case "Appointment":
        return "appointmentID";
      case "Medicine":
        return "medicineID";
      case "Prescription":
        return "prescriptionID";
      case "Orders":
        return "ordersID";
      case "Schedule":
        return "scheduleID";
      case "Supplier":
        return "supplierID";
      default:
        return "id"; // fallback
    }
  }
}
