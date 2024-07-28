package IDLList;

import org.junit.*;
import static org.junit.Assert.*;

public class IDLListTest {

    /** Tests public boolean add (int index, E elem) */
    @Test
    public void testAddE() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }

        Integer a = 100;
        Integer b = 300;
        test1.add(6, a);
        test1.add(3, b);

        assertEquals(a, test1.get(7));
        assertEquals(b, test1.get(3));
    }

    /** Tests public boolean add (E elem) */
    @Test
    public void testAdd() {
        IDLList<Integer> test1 = new IDLList<Integer>();
        IDLList<String> test2 = new IDLList<String>();

        test1.add(10);
        test2.add("Hello");

        Integer a = 10;
        String b = "Hello";

        assertEquals(a, test1.get(0));
        assertEquals(b, test2.get(0));
        assertEquals(test1.getHead(), test1.getLast());
        assertEquals(test2.getHead(), test2.getLast());

        test1.add(20);
        test2.add("Bonjour");

        Integer c = 20;
        String d = "Bonjour";

        assertEquals(c, test1.get(0));
        assertEquals(d, test2.get(0));
        assertNotEquals(test1.getHead(), test1.getLast());
        assertNotEquals(test2.getHead(), test2.getLast());
    }

    /** Tests public boolean append (E elem) */
    @Test
    public void testAppend() {
        IDLList<Integer> test1 = new IDLList<Integer>();
        IDLList<String> test2 = new IDLList<String>();

        test1.append(10);
        test2.append("Hello");

        Integer a = 10;
        String b = "Hello";

        assertEquals(a, test1.get(0));
        assertEquals(b, test2.get(0));
        assertEquals(test1.getHead(), test1.getLast());
        assertEquals(test2.getHead(), test2.getLast());

        test1.append(20);
        test2.append("Bonjour");

        Integer c = 20;
        String d = "Bonjour";

        assertEquals(c, test1.get(1));
        assertEquals(d, test2.get(1));
        assertNotEquals(test1.getHead(), test1.getLast());
        assertNotEquals(test2.getHead(), test2.getLast());
    }

    /** Tests public E get (int index) */
    @Test
    public void testGet() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }
        Integer a = 5;
        Integer b = 1;
        assertEquals(a, test1.get(4));
        assertEquals(b, test1.get(8));
    }

    /** Tests public E getHead () */
    @Test
    public void testGetHead() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }
        Integer a = 9;
        assertEquals(a, test1.getHead());
    }

    /** Tests public E getLast () */
    @Test
    public void testGetLast() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }
        Integer a = 0;
        assertEquals(a, test1.getLast());
    }

    /** Tests public int size() */
    @Test
    public void testSize() {
        IDLList<Integer> test1 = new IDLList<Integer>();
        IDLList<String> test2 = new IDLList<String>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }

        test2.add("Hello");
        test2.add("Bonjour");
        test2.add("Hallo");

        assertEquals(10, test1.size());
        assertEquals(3, test2.size());
    }

    /** Tests public E remove() */
    @Test
    public void testRemove() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }
        Integer a = 8;
        Integer b = 9;

        assertEquals(b, test1.get(0));

        test1.remove();

        assertEquals(a, test1.get(0));
    }

    /** Tests public E removeLast () */
    @Test
    public void testRemoveLast() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }

        Integer a = 1;
        Integer b = 0;

        assertEquals(b, test1.get(9));

        test1.removeLast();

        assertEquals(a, test1.get(8));
    }

    /** Tests public E removeAt (int index) */
    @Test
    public void testRemoveAt() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }
        Integer a = 7;
        Integer b = 6;
        Integer c = 5;
        Integer d = 4;

        assertEquals(a, test1.get(2));
        assertEquals(b, test1.get(3));
        assertEquals(c, test1.get(4));

        test1.removeAt(3);

        assertEquals(a, test1.get(2));
        assertEquals(c, test1.get(3));
        assertEquals(d, test1.get(4));
    }

    /** Tests public boolean remove (E elem) */
    @Test
    public void testRemoveE() {
        IDLList<Integer> test1 = new IDLList<Integer>();

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }

        test1.remove(123);
        assertFalse(test1.remove(123));

        Integer a = 3;
        test1.remove(4);

        assertEquals(a, test1.get(5));
    }

    /** Tests public String toString() */
    @Test
    public void testToString() {
        IDLList<Integer> test1 = new IDLList<Integer>();
        assertEquals("", test1.toString());

        for (int i = 0; i < 10; i++) {
            test1.add(i);
        }

        assertEquals("[9, 8, 7, 6, 5, 4, 3, 2, 1, 0]", test1.toString());
    }

}