package utils;

/**
 * Author: Kong Ji Yu
 */

import java.util.Iterator; // allowed
import java.util.Comparator; // allowed

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

  @Override
  public ListInterface<T> sort(Comparator<T> comparator) {
    if (size <= 1) {
      return new List<>(this); // Return a copy of the list
    }
    
    // Create a copy of the current list
    List<T> sortedList = new List<>(this);
    
    // Perform merge sort on the copy
    mergeSort(sortedList.elements, 0, sortedList.size - 1, comparator);
    
    return sortedList;
  }
  
  /**
   * Recursive merge sort implementation
   * @param arr The array to sort
   * @param left Left boundary of the current segment
   * @param right Right boundary of the current segment
   * @param comparator Comparator to determine order
   */
  private void mergeSort(Object[] arr, int left, int right, Comparator<T> comparator) {
    if (left < right) {
      // Find the middle point
      int mid = left + (right - left) / 2;
      
      // Sort first and second halves
      mergeSort(arr, left, mid, comparator);
      mergeSort(arr, mid + 1, right, comparator);
      
      // Merge the sorted halves
      merge(arr, left, mid, right, comparator);
    }
  }
  
  /**
   * Merge two sorted subarrays
   * @param arr The array containing the subarrays
   * @param left Left boundary of the first subarray
   * @param mid Middle point (end of first subarray)
   * @param right Right boundary of the second subarray
   * @param comparator Comparator to determine order
   */
  private void merge(Object[] arr, int left, int mid, int right, Comparator<T> comparator) {
    // Find sizes of two subarrays to be merged
    int n1 = mid - left + 1;
    int n2 = right - mid;
    
    // Create temporary arrays
    Object[] leftArray = new Object[n1];
    Object[] rightArray = new Object[n2];
    
    // Copy data to temporary arrays
    for (int i = 0; i < n1; i++) {
      leftArray[i] = arr[left + i];
    }
    for (int j = 0; j < n2; j++) {
      rightArray[j] = arr[mid + 1 + j];
    }
    
    // Merge the temporary arrays back into arr[left..right]
    int i = 0, j = 0;
    int k = left;
    
    while (i < n1 && j < n2) {
      @SuppressWarnings("unchecked")
      T leftVal = (T) leftArray[i];
      @SuppressWarnings("unchecked")
      T rightVal = (T) rightArray[j];
      
      if (comparator.compare(leftVal, rightVal) <= 0) {
        arr[k] = leftArray[i];
        i++;
      } else {
        arr[k] = rightArray[j];
        j++;
      }
      k++;
    }
    
    // Copy remaining elements of leftArray[] if any
    while (i < n1) {
      arr[k] = leftArray[i];
      i++;
      k++;
    }
    
    // Copy remaining elements of rightArray[] if any
    while (j < n2) {
      arr[k] = rightArray[j];
      j++;
      k++;
    }
  }
}
