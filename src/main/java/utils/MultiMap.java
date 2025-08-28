package utils;

/**
 * Author: Kong Ji Yu
 */

import java.util.Iterator;

public class MultiMap<K, V> implements MultiMapInterface<K, V>, Iterable<MultiMap.KeyValue<K, V>> {
  private List<Entry<K, List<V>>> map = new List<>();
  /** Lightweight pair exposed by the iterator() */
  public static class KeyValue<K, V> {
    public final K key;
    public final V value;
    public KeyValue(K key, V value) {
      this.key = key;
      this.value = value;
    }
  }

  private Entry<K, List<V>> findEntry(K key) {
    for (int i = 0; i < map.size(); i++) {
      Entry<K, List<V>> entry = map.get(i);
      if (entry.key.equals(key)) {
        return entry;
      }
    }
    return null;
  }

  @Override
  public void put(K key, V value) {
    Entry<K, List<V>> entry = findEntry(key);
    if (entry == null) {
      List<V> values = new List<>();
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
    Entry<K, List<V>> entry = findEntry(key);
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
    Entry<K, List<V>> entry = findEntry(key);
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
  public List<V> get(K key) {
    Entry<K, List<V>> entry = findEntry(key);
    if (entry != null) {
      return entry.value;
    }
    return new List<>();
  }

  @Override
  public ArraySet<K> keySet() {
    ArraySet<K> set = new ArraySet<>();
    for (int i = 0; i < map.size(); i++) {
      set.add(map.get(i).key);
    }
    return set;
  }

  /** Iterate over ALL (key,value) pairs in the multimap (outer to inner). */
  @Override
  public Iterator<KeyValue<K, V>> iterator() {
    return new AllPairsIterator();
  }

  /** Iterate over keys only (each key appears once). */
  public Iterator<K> keyIterator() {
    return new Iterator<K>() {
      private int index = 0;
      @Override public boolean hasNext() { return index < map.size(); }
      @Override public K next() { return map.get(index++).key; }
      @Override public void remove() { throw new UnsupportedOperationException(); }
    };
  }

  /** Iterate over values for a single key (returns empty iterator if key absent). */
  public Iterator<V> valuesIterator(K key) {
    Entry<K, List<V>> e = findEntry(key);
    final List<V> list = (e == null) ? new List<V>() : e.value;
    return new Iterator<V>() {
      private int i = 0;
      @Override public boolean hasNext() { return i < list.size(); }
      @Override public V next() { return list.get(i++); }
      @Override public void remove() { throw new UnsupportedOperationException(); }
    };
  }

  /** Iterate over all values across all keys (flattened). */
  public Iterator<V> valuesIterator() {
    return new Iterator<V>() {
      private int outer = 0;
      private int inner = 0;
      @Override public boolean hasNext() {
        while (outer < map.size()) {
          if (inner < map.get(outer).value.size()) return true;
          outer++; inner = 0;
        }
        return false;
      }
      @Override public V next() {
        V v = map.get(outer).value.get(inner++);
        // advance to next non-empty bucket on subsequent hasNext()
        return v;
      }
      @Override public void remove() { throw new UnsupportedOperationException(); }
    };
  }

  /** Internal iterator over all (key,value) pairs */
  private class AllPairsIterator implements Iterator<KeyValue<K, V>> {
    private int outer = 0;
    private int inner = 0;

    @Override
    public boolean hasNext() {
      // Skip empty value lists
      while (outer < map.size()) {
        if (inner < map.get(outer).value.size()) return true;
        outer++;
        inner = 0;
      }
      return false;
    }

    @Override
    public KeyValue<K, V> next() {
      Entry<K, List<V>> bucket = map.get(outer);
      V v = bucket.value.get(inner++);
      return new KeyValue<>(bucket.key, v);
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }
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
