package utils;
import com.google.gson.*;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {
  private static final DateTimeFormatter F = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
  @Override public JsonElement serialize(LocalDateTime src, Type t, JsonSerializationContext c) {
    return new JsonPrimitive(src.format(F));
  }
  @Override public LocalDateTime deserialize(JsonElement json, Type t, JsonDeserializationContext c)
  { return LocalDateTime.parse(json.getAsString(), F); }
}
