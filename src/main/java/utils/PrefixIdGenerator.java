package utils;

import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.id.IdentifierGenerator;
import java.io.Serializable;
import java.util.stream.Stream;

public class PrefixIdGenerator implements IdentifierGenerator {

  @Override
  public Serializable generate(SharedSessionContractImplementor session, Object object) {
    String className = object.getClass().getSimpleName();
    String prefix = className.substring(0, 2).toUpperCase();

    String query = String.format("SELECT e.id FROM %s e ORDER BY e.id DESC", className);

    Stream<String> ids = session.createQuery(query, String.class).stream();

    Long max = ids.map(id -> id.replaceAll("[^0-9]", ""))
      .filter(s -> !s.isEmpty())
      .mapToLong(Long::parseLong)
      .max()
      .orElse(0L);

    return prefix + String.format("%04d", max + 1);
  }
}
