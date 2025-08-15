package utils;

import java.util.Iterator; // allowed

public class List<T> implements ListInterface<T> {
  private Object[] elements;
  private int size;

  public List() {
    elements = new Object[10];
    size = 0;
  }

  // Copy constructor from any Iterable (works with our other ADTs too)
  public List(Iterable<? extends T> src) {
    elements = new Object[10];
    size = 0;
    for (Object item : src) {
      T val = (T) item;
      add(val);
    }
  }

  // --- Internal helpers ---
  private void ensureCapacity(int minCapacity) {
    if (elements.length >= minCapacity) return;
    int newCap = elements.length * 2;
    if (newCap < minCapacity) newCap = minCapacity;
    Object[] next = new Object[newCap];
    // manual copy (no Arrays.copyOf)
    for (int i = 0; i < size; i++) {
      next[i] = elements[i];
    }
    elements = next;
  }

  private void rangeCheckForAdd(int index) {
    if (index < 0 || index > size) {
      throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
    }
  }

  private void rangeCheck(int index) {
    if (index < 0 || index >= size) {
      throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
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
        if (!hasNext()) {
          // Avoid java.util.NoSuchElementException per requirement
          throw new IllegalStateException("No more elements");
        }
        T val = (T) elements[index++];
        return val;
      }
    };
  }

  @Override
  public boolean add(T element) {
    ensureCapacity(size + 1);
    elements[size++] = element;
    return true;
  }

  @Override
  public void add(int index, T element) {
    rangeCheckForAdd(index);
    ensureCapacity(size + 1);
    // shift right from size-1 down to index
    for (int i = size - 1; i >= index; i--) {
      elements[i + 1] = elements[i];
    }
    elements[index] = element;
    size++;
  }

  @Override
  public T get(int index) {
    rangeCheck(index);
    T val = (T) elements[index];
    return val;
  }

  @Override
  public T set(int index, T element) {
    rangeCheck(index);
    T old = (T) elements[index];
    elements[index] = element;
    return old;
  }

  @Override
  public T remove(int index) {
    rangeCheck(index);
    T old = (T) elements[index];
    // shift left from index+1 .. size-1
    for (int i = index; i < size - 1; i++) {
      elements[i] = elements[i + 1];
    }
    elements[size - 1] = null; // help GC
    size--;
    return old;
  }

  @Override
  public boolean remove(Object o) {
    // find first occurrence
    for (int i = 0; i < size; i++) {
      Object e = elements[i];
      if (o == null ? e == null : o.equals(e)) {
        // remove at i
        for (int j = i; j < size - 1; j++) {
          elements[j] = elements[j + 1];
        }
        elements[size - 1] = null;
        size--;
        return true;
      }
    }
    return false;
  }

  @Override
  public boolean contains(Object o) {
    for (int i = 0; i < size; i++) {
      Object e = elements[i];
      if (o == null ? e == null : o.equals(e)) {
        return true;
      }
    }
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
    for (int i = 0; i < size; i++) {
      elements[i] = null;
    }
    size = 0;
  }

  @Override
  public boolean addAll(Iterable<? extends T> src) {
    boolean modified = false;
    for (T item : src) {
      if (add(item)) modified = true;
    }
    return modified;
  }

  @Override
  public boolean containsAll(Iterable<?> src) {
    for (Object item : src) {
      if (!contains(item)) return false;
    }
    return true;
  }
}
