package utils;

public interface ListInterface<T> extends Iterable<T> {
  boolean add(T element);
  void add(int index, T element);
  T get(int index);
  T set(int index, T element);
  T remove(int index);
  boolean remove(Object o);
  boolean contains(Object o);
  int size();
  boolean isEmpty();
  void clear();
  boolean addAll(Iterable<? extends T> elements);
  boolean containsAll(Iterable<?> elements);
}
