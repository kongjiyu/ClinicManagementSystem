package utils;

import java.util.*;
import java.util.function.Consumer;

public class List<T> implements ListInterface<T> {
  private Object[] elements;
  private int size;

  public List() {
    elements = new Object[10];
    size = 0;
  }

  public List(java.util.List<T> list) {
    elements = new Object[list.size()];
    size = 0;
    for (T item : list) {
      add(item);
    }
  }

  @Override
  public Iterator<T> iterator() {
    return new Iterator<T>() {
      private int index = 0;

      @Override
      public boolean hasNext() {
        return index < size;
      }

      @Override
      public T next() {
        if (!hasNext()) throw new NoSuchElementException();
        return (T) elements[index++];
      }
    };
  }

  @Override
  public void forEach(Consumer<? super T> action) {
    ListInterface.super.forEach(action);
  }

  @Override
  public Spliterator<T> spliterator() {
    return ListInterface.super.spliterator();
  }

  @Override
  public boolean add(T element) {
    if (size == elements.length) {
      elements = Arrays.copyOf(elements, elements.length * 2);
    }
    elements[size++] = element;
    return true;
  }

  @Override
  public void add(int index, T element) {

  }

  @Override
  public T get(int index) {
    if (index < 0 || index >= size) throw new IndexOutOfBoundsException();
    return (T) elements[index];
  }

  @Override
  public T set(int index, T element) {
    return null;
  }

  @Override
  public T remove(int index) {
    return null;
  }

  @Override
  public boolean remove(Object o) {
    return false;
  }

  @Override
  public boolean contains(Object o) {
    return false;
  }

  @Override
  public int size() {
    return size;
  }

  @Override
  public boolean isEmpty() {
    return size == 0;
  }

  @Override
  public void clear() {

  }

  @Override
  public boolean addAll(Iterable<? extends T> elements) {
    boolean modified = false;
    for (T item : elements) {
      if (add(item)) {
        modified = true;
      }
    }
    return modified;
  }

  @Override
  public boolean containsAll(Iterable<?> elements) {
    for (Object item : elements) {
      if (!contains(item)) {
        return false;
      }
    }
    return true;
  }
}
