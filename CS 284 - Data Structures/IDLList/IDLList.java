package IDLList;

import java.util.ArrayList;

/**
 * IDLList is a class that implements a double linked list with fast accessing
 * 
 * @author Amane Chibana
 * @version 1
 */

public class IDLList<E> {

    /** Inner class to create nodes with data, previous node and next node */
    private static class Node<E> {
        private E data;
        private Node<E> next;
        private Node<E> prev;

        /**
         * Constructor that creates node holding elem
         * 
         * @param elem
         */
        public Node(E elem) {
            this.data = elem;
            this.next = null;
            this.prev = null;
        }

        /**
         * Constructor that creates node holding elem with next as next and prev as prev
         * 
         * @param elem
         * @param prev
         * @param next
         */
        public Node(E elem, Node<E> prev, Node<E> next) {
            this.data = elem;
            this.prev = prev;
            this.next = next;
        }
    }

    private Node<E> head;
    private Node<E> tail;
    private int size;
    private ArrayList<Node<E>> indices;

    /** Constructor that creates empty double-linked */
    public IDLList() {
        indices = new ArrayList<Node<E>>();
        this.size = 0;
    }

    /**
     * Adds elem at position index
     * 
     * @param index the index where the node will be added
     * @param elem  the data in the node that will be added
     * @return the boolean true
     */
    public boolean add(int index, E elem) {
        if (this.size == 0) {
            return this.add(elem);
        }

        if (index == 0) {
            return this.add(elem);
        } else if (index == this.size - 1) {
            return this.append(elem);
        } else {
            Node<E> before = this.indices.get(index - 1);
            Node<E> after = this.indices.get(index);

            Node<E> addTemp = new Node<E>(elem, before, after);
            after.prev = addTemp;
            before.next = addTemp;
            this.indices.add(index, addTemp);
            this.size += 1;

            return true;
        }
    }

    /**
     * Adds elem at the head
     * 
     * @param elem the data in the node that will be added
     * @return the boolean true
     */
    public boolean add(E elem) {

        Node<E> temp = new Node<E>(elem);

        if (this.size == 0) {
            this.head = temp;
            this.tail = temp;
            this.indices.add(temp);
        } else {
            this.head.prev = temp;
            temp.next = this.head;
            this.head = temp;
            this.indices.add(0, temp);
        }

        this.size += 1;

        return true;
    }

    /**
     * Adds elem at the tail
     * 
     * @param elem the data in the node that will be added
     * @return the boolean true
     */
    public boolean append(E elem) {
        Node<E> temp = new Node<E>(elem);
        if (this.size == 0) {
            this.head = temp;
            this.tail = temp;
            this.indices.add(temp);
        } else {
            this.tail.next = temp;
            temp.prev = this.tail;
            this.tail = temp;
            this.indices.add(temp);
        }
        this.size += 1;
        return true;
    }

    /**
     * Returns the object at position index from head
     * 
     * @param index the index that will be returned
     * @return data in node at position index
     */
    public E get(int index) {
        return this.indices.get(index).data;
    }

    /**
     * Returns object at head
     * 
     * @return data in node at head
     */
    public E getHead() {
        return this.head.data;
    }

    /**
     * Returns object at tail
     * 
     * @return data in node at tail
     */
    public E getLast() {
        return this.tail.data;
    }

    /**
     * Returns list size
     * 
     * @return integer that represents size of list
     */
    public int size() {
        return this.size;
    }

    /**
     * Removes element at head
     * 
     * @exception IllegalStateException if remove is called when list is empty
     * @return the removed head
     */
    public E remove() {
        if (this.size == 0) {
            throw new IllegalStateException();
        } else if (this.size == 1) {
            E temp = getHead();
            this.indices.remove(0);
            this.head = null;
            this.tail = null;
            this.size -= 1;
            return temp;
        }
        E temp = getHead();
        this.indices.remove(0);
        this.head = this.indices.get(0);
        this.head.prev = null;
        this.size -= 1;
        return temp;
    }

    /**
     * Removes element at tail
     * 
     * @exception IllegalStateException if remove is called when list is empty
     * @return the removed tail
     */
    public E removeLast() {
        if (this.size == 0) {
            throw new IllegalStateException();
        } else if (this.size == 1) {
            E temp = getLast();
            this.indices.remove(0);
            this.head = null;
            this.tail = null;
            this.size -= 1;
            return temp;
        }
        E temp = getLast();
        this.indices.remove(this.size - 1);
        this.tail = this.indices.get(this.size - 2);
        this.tail.next = null;
        this.size -= 1;

        return temp;
    }

    /**
     * Removes element at index
     * 
     * @param index the index of the node that will be removed
     * @exception IllegalStateException if remove is called when list is
     *                                  empty or index outside of bounds
     * @return removed element
     */
    public E removeAt(int index) {

        if (this.size == 0 || index < 0 || index > (this.size - 1)) {
            throw new IllegalStateException();
        }

        if (index == 0) {
            return this.remove();
        } else if (index == this.size - 1) {
            return this.removeLast();
        } else {
            Node<E> Temp1 = this.indices.get(index - 1);
            Node<E> Temp2 = this.indices.get(index + 1);
            E tempRemoved = get(index);

            this.indices.remove(index);
            Temp1.next = Temp2;
            Temp2.prev = Temp1;
            this.size -= 1;

            return tempRemoved;
        }
    }

    /**
     * Removes the first occurence of elem in the list
     * 
     * @param elem The elem that looks to be deleted
     * @return the boolean true
     */
    public boolean remove(E elem) {
        for (int i = 0; i < this.size; i++) {
            if (this.indices.get(i).data == elem) {

                this.removeAt(i);
                return true;
            }
        }
        return false;
    }

    /** Presents string representation of list */
    public String toString() {
        if (this.size == 0) {
            return "";
        }
        String result = "[";
        for (int i = 0; i < this.size; i++) {
            result += this.indices.get(i).data + ", ";
        }

        return result.substring(0, result.length() - 2) + "]";
    }
}
