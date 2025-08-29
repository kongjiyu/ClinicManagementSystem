package utils;

/**
 * Author: all members
 */

public class ArraySet<T> implements SetInterface<T> {
    private Object[] elements;
    private int size;
    private static final int INITIAL_CAPACITY = 10;

    public ArraySet() {
        elements = new Object[INITIAL_CAPACITY];
        size = 0;
    }

    public boolean add(T element) {
        if (contains(element)) return false;
        ensureCapacity();
        elements[size++] = element;
        return true;
    }

    public boolean remove(T element) {
        for (int i = 0; i < size; i++) {
            if (equals(elements[i], element)) {
                for (int j = i; j < size - 1; j++) {
                    elements[j] = elements[j + 1];
                }
                elements[--size] = null;
                return true;
            }
        }
        return false;
    }

    public boolean contains(T element) {
        for (int i = 0; i < size; i++) {
            if (equals(elements[i], element)) return true;
        }
        return false;
    }

    public int size() {
        return size;
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public void clear() {
        for (int i = 0; i < size; i++) elements[i] = null;
        size = 0;
    }

    public Object[] toArray() {
        Object[] result = new Object[size];
        for (int i = 0; i < size; i++) result[i] = elements[i];
        return result;
    }

    private void ensureCapacity() {
        if (size >= elements.length) {
            Object[] newElements = new Object[elements.length * 2];
            for (int i = 0; i < elements.length; i++) newElements[i] = elements[i];
            elements = newElements;
        }
    }

    private boolean equals(Object a, Object b) {
        return (a == null && b == null) || (a != null && a.equals(b));
    }
}
