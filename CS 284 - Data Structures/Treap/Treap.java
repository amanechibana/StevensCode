package Treap;

import java.util.Random;
import java.util.*;

/**
 * Treap is a class that implements a Binary search tree (BST) which
 * additionally maintains heap priorities
 * 
 * @author Amane Chibana
 * @version 1
 */

public class Treap<E extends Comparable<E>> {

    /** Inner class to create nodes with data, priority, left, and right */
    private static class Node<E> {
        public E data;
        public int priority;
        public Node<E> left;
        public Node<E> right;

        /**
         * Constructor that creates node with data and priority
         * 
         * @param data
         * @param priority
         */
        public Node(E data, int priority) {
            this.data = data;
            this.priority = priority;
            this.left = null;
            this.right = null;
        }

        /**
         * performs a right rotation returning a reference to the root of the result.
         * 
         * @return reference to the root
         */
        public Node<E> rotateRight() {
            Node<E> out = this.left;
            this.left = out.right;
            out.right = this;
            return out;
        }

        /**
         * performs a left rotation returning a reference to the root of the result.
         * 
         * @return reference to the root
         */
        public Node<E> rotateLeft() {
            Node<E> out = this.right;
            this.right = out.left;
            out.left = this;
            return out;
        }

    }

    private Random priorityGenerator;
    private Node<E> root;
    private HashSet<Integer> prioList;

    /**
     * Constructor that creates Treap
     */
    public Treap() {
        this.priorityGenerator = new Random();
        root = null;
        prioList = new HashSet<Integer>();
    }

    /**
     * Constructor that creates Treap and initializes priorityGenerator with
     * Random(seed)
     * 
     * @param seed value for Random()
     */
    public Treap(long seed) {
        this.priorityGenerator = new Random(seed);
        root = null;
        prioList = new HashSet<Integer>();
    }

    /**
     * Insert given key into tree, generates new random priority
     * 
     * @param key value for node
     * @return boolean
     */
    public boolean add(E key) {
        return add(key, priorityGenerator.nextInt());
    }

    /**
     * Helper function for add. Fixes heap of Tree
     * 
     * @param temp     Node reference that was added
     * @param key      Value of the node
     * @param priority of the node
     * @param stack    A stack containining all nodes that insert travelled through
     */
    public void reheap(Node<E> temp, E key, int priority, Stack<Node<E>> stack) {
        Node<E> x;
        Node<E> y;
        int comp;

        while (!(stack.empty())) {
            x = stack.pop();
            comp = x.data.compareTo(key);

            if (x.priority > priority) {
                break;
            }

            if (comp > 0 && x.priority < priority) {
                x.rotateRight();
                if (!(stack.empty())) {
                    y = stack.peek();
                    if (x.data.compareTo(y.data) > 0) {
                        y.right = temp;
                    } else {
                        y.left = temp;
                    }
                }
            } else if (comp < 0 && x.priority < priority) {
                x.rotateLeft();
                if (!(stack.empty())) {
                    y = stack.peek();
                    if (x.data.compareTo(y.data) > 0) {
                        y.right = temp;
                    } else {
                        y.left = temp;
                    }
                }
            }

            if (stack.empty()) {
                root = temp;
            }
        }
    }

    /**
     * Insert given key into tree, with given priority
     * 
     * @param key      for node to be inserted
     * @param priority for node to be inserted
     * @return boolean
     */
    public boolean add(E key, int priority) {
        Stack<Node<E>> stack = new Stack<Node<E>>();
        Node<E> temp = new Node<E>(key, priority);
        int comp;

        if (prioList.contains(priority)) {
            return false;
        }
        prioList.add(priority);

        if (root == null) {
            root = temp;
            return true;
        }

        Node<E> curr = root;

        while (curr != null) {
            comp = curr.data.compareTo(key);
            stack.push(curr);

            if (comp == 0) {
                return false;
            }

            if (comp > 0) {
                if (curr.left == null) {
                    curr.left = temp;
                    break;
                }
                curr = curr.left;
            }

            if (comp < 0) {
                if (curr.right == null) {
                    curr.right = temp;
                    break;
                }
                curr = curr.right;
            }
        }
        reheap(temp, key, priority, stack);

        return true;
    }

    /**
     * deletes the node with the given key from the treap
     * 
     * @param root of the Treap
     * @param key  data vaalue of the node to be removed
     * @return boolean
     */
    public boolean delete(E key) {
        if (root == null || !(find(key))) {
            return false;
        }
        return true;

    }

    /**
     * checks if there is a node with the given key in the treap
     * 
     * @param root of the Treap
     * @param key  data value of node to find
     * @return boolean
     */
    private boolean find(Node<E> root, E key) {
        if (root == null) {
            return false;
        }

        if (root.data.compareTo(key) == 0) {
            return true;
        }

        return find(root.left, key) || find(root.right, key);
    }

    /**
     * checks if there is a node with the given key in the treap
     * 
     * @param key data of node to find
     * @return boolean
     */
    public boolean find(E key) {
        return find(root, key);
    }

    /**
     * Generates a string representation of the Treap
     * 
     * @param current node reference
     * @param depth   inside the tree
     * @return String
     */
    private String toString(Node<E> current, int depth) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < depth; i++) {
            sb.append("-");
        }
        if (current == null) {
            sb.append("null\n");
        } else {
            sb.append("(key=" + current.data.toString() + ", " + "priority=" + current.priority + ")" + "\n");
            sb.append(toString(current.left, depth + 1));
            sb.append(toString(current.right, depth + 1));
        }
        return sb.toString();
    }

    public String toString() {
        return toString(root, 0);
    }

    public static void main(String[] args) {
        Treap<Integer> testTree = new Treap<Integer>();

        testTree.add(4, 19);
        testTree.add(2, 31);
        testTree.add(6, 70);
        testTree.add(1, 84);
        testTree.add(3, 12);
        testTree.add(5, 83);
        testTree.add(7, 26);
        System.out.println(testTree.toString());
    }

}
