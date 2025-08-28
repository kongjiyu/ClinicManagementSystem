package utils;

/**
 * Author: Kong Ji Yu
 */

public interface SetInterface<T> {
  boolean add(T element);
  boolean remove(T element);
  boolean contains(T element);
  int size();
  boolean isEmpty();
  void clear();
  Object[] toArray();
}
