package utils;

import com.google.gson.*;
import java.lang.reflect.Type;

public class ListAdapter<T> implements JsonSerializer<utils.List<T>> {
    @Override
    public JsonElement serialize(utils.List<T> src, Type typeOfSrc, JsonSerializationContext context) {
        JsonObject obj = new JsonObject();
        JsonArray arr = new JsonArray();

        for (T item : src) {  // uses your iterator so no null padding
            arr.add(context.serialize(item));
        }

        obj.add("elements", arr);
        obj.addProperty("size", src.size());
        return obj;
    }
}
