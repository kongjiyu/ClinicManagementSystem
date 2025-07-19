package utils;

public class MultiMap<K, V> implements MultiMapInterface<K, V> {
  private ArrayList<Entry<K, ArrayList<V>>> map = new ArrayList<>();

  private Entry<K, ArrayList<V>> findEntry(K key) {
    for (int i = 0; i < map.size(); i++) {
      Entry<K, ArrayList<V>> entry = map.get(i);
      if (entry.key.equals(key)) {
        return entry;
      }
    }
    return null;
  }

  @Override
  public void put(K key, V value) {
    Entry<K, ArrayList<V>> entry = findEntry(key);
    if (entry == null) {
      ArrayList<V> values = new ArrayList<>();
      values.add(value);
      map.add(new Entry<>(key, values));
    } else {
      entry.value.add(value);
    }
  }

  @Override
  public void putAll(K key, Iterable<V> values) {
    for (V value : values) {
      put(key, value);
    }
  }

  @Override
  public boolean remove(K key, V value) {
    Entry<K, ArrayList<V>> entry = findEntry(key);
    if (entry != null) {
      return entry.value.remove(value);
    }
    return false;
  }

  @Override
  public boolean removeAll(K key) {
    for (int i = 0; i < map.size(); i++) {
      if (map.get(i).key.equals(key)) {
        map.remove(i);
        return true;
      }
    }
    return false;
  }

  @Override
  public boolean containsKey(K key) {
    return findEntry(key) != null;
  }

  @Override
  public boolean containsValue(K key, V value) {
    Entry<K, ArrayList<V>> entry = findEntry(key);
    if (entry != null) {
      return entry.value.contains(value);
    }
    return false;
  }

  @Override
  public int size() {
    int count = 0;
    for (int i = 0; i < map.size(); i++) {
      count += map.get(i).value.size();
    }
    return count;
  }

  @Override
  public void clear() {
    map.clear();
  }

  @Override
  public ArrayList<V> get(K key) {
    Entry<K, ArrayList<V>> entry = findEntry(key);
    if (entry != null) {
      return entry.value;
    }
    return new ArrayList<>();
  }

  @Override
  public ArraySet<K> keySet() {
    ArraySet<K> set = new ArraySet<>();
    for (int i = 0; i < map.size(); i++) {
      set.add(map.get(i).key);
    }
    return set;
  }

  private static class Entry<K, V> {
    K key;
    V value;

    Entry(K key, V value) {
      this.key = key;
      this.value = value;
    }
  }
}
