package utils;
import com.google.gson.*;
import java.lang.reflect.Type;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class LocalTimeAdapter implements JsonSerializer<LocalTime>, JsonDeserializer<LocalTime> {
  private static final DateTimeFormatter F = DateTimeFormatter.ISO_LOCAL_TIME;
  @Override public JsonElement serialize(LocalTime src, Type t, JsonSerializationContext c) {
    return new JsonPrimitive(src.format(F));
  }
  @Override public LocalTime deserialize(JsonElement json, Type t, JsonDeserializationContext c)
  { return LocalTime.parse(json.getAsString(), F); }
}
