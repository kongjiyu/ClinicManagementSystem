package utils;

import com.google.gson.*;
import java.lang.reflect.Type;

public class MultiMapAdapter<K, V> implements JsonSerializer<MultiMap<K, V>>, JsonDeserializer<MultiMap<K, V>> {

    @Override
    public JsonElement serialize(MultiMap<K, V> src, Type typeOfSrc, JsonSerializationContext context) {
        JsonArray jsonArray = new JsonArray();

        // Serialize as an array of key-value pairs
        for (MultiMap.KeyValue<K, V> keyValue : src) {
            JsonObject pair = new JsonObject();
            pair.add("key", context.serialize(keyValue.key));
            pair.add("value", context.serialize(keyValue.value));
            jsonArray.add(pair);
        }

        return jsonArray;
    }

    @Override
    public MultiMap<K, V> deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
        MultiMap<K, V> multiMap = new MultiMap<>();

        if (json.isJsonArray()) {
            JsonArray jsonArray = json.getAsJsonArray();

            for (JsonElement element : jsonArray) {
                if (element.isJsonObject()) {
                    JsonObject pair = element.getAsJsonObject();

                    if (pair.has("key") && pair.has("value")) {
                        // Deserialize key and value using Object.class to avoid type casting
                        Object keyObj = context.deserialize(pair.get("key"), Object.class);
                        Object valueObj = context.deserialize(pair.get("value"), Object.class);

                        // Only add if both are not null
                        if (keyObj != null && valueObj != null) {
                            multiMap.put((K) keyObj, (V) valueObj);
                        }
                    }
                }
            }
        }

        return multiMap;
    }
}
