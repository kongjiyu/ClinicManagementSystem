package utils;

/**
 * Author: all members
 */

public interface MultiMapInterface<K, V> {
  void put(K key, V value);
  void putAll(K key, Iterable<V> values);
  boolean remove(K key, V value);
  boolean removeAll(K key);
  boolean containsKey(K key);
  boolean containsValue(K key, V value);
  int size();
  void clear();
  List<V> get(K key);
  ArraySet<K> keySet();
}
