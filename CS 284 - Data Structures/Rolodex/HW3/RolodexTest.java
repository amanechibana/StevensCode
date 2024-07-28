package HW3;

import org.junit.*;
import static org.junit.Assert.*;
import static org.junit.Assert.assertTrue;
import java.util.ArrayList;

public class RolodexTest {
    // Tests contains()
    @Test
    public void testContains() {
        Rolodex r = new Rolodex();

        r.addCard("Chloe", "123");
        r.addCard("Chad", "23");
        r.addCard("Cris", "3");
        r.addCard("Cris", "4");
        r.addCard("Cris", "5");

        assertTrue(r.contains("Chloe"));
        assertTrue(r.contains("Cris"));
        assertFalse(r.contains("Bobert"));
        assertFalse(r.contains("Pedro"));
    }

    // Tests size()
    @Test
    public void testSize() {
        Rolodex r = new Rolodex();

        assertEquals(0, r.size());
        r.addCard("Chloe", "123");
        assertEquals(1, r.size());
        r.addCard("Chad", "23");
        assertEquals(2, r.size());
        r.addCard("Cris", "3");
        assertEquals(3, r.size());
        r.addCard("Cris", "4");
        assertEquals(4, r.size());
        r.addCard("Cris", "5");
        assertEquals(5, r.size());

    }

    // Tests lookup()
    @Test
    public void testLookUp() {
        Rolodex r = new Rolodex();

        r.addCard("Chloe", "123");
        r.addCard("Chad", "23");
        r.addCard("Cris", "3");
        r.addCard("Cris", "4");
        r.addCard("Cris", "5");

        ArrayList<String> test = new ArrayList<String>();
        test.add("5");
        test.add("4");
        test.add("3");
        assertEquals(test, r.lookup("Cris"));
    }

    // Tests addcard()
    @Test
    public void testAddCard() {
        Rolodex r = new Rolodex();

        r.addCard("John", "123");
        r.addCard("Pratt", "23");

        assertTrue(r.contains("John"));
        assertTrue(r.contains("Pratt"));

    }

    // Tests removecard()
    @Test
    public void testRemoveCard() {
        Rolodex r = new Rolodex();

        r.addCard("Chloe", "123");
        r.addCard("Chad", "23");
        r.addCard("Cris", "3");
        r.addCard("Cris", "4");
        r.addCard("Cris", "5");

        assertTrue(r.contains("Chloe"));
        assertTrue(r.contains("Cris"));

        r.removeCard("Chloe", "123");
        r.removeCard("Cris", "3");
        r.removeCard("Cris", "4");
        r.removeCard("Cris", "5");

        assertFalse(r.contains("Chloe"));
    }

    // Tests removeallcards()
    @Test
    public void testRemoveAllCards() {
        Rolodex r = new Rolodex();

        r.addCard("Chloe", "123");
        r.addCard("Chad", "23");
        r.addCard("Cris", "3");
        r.addCard("Cris", "4");
        r.addCard("Cris", "5");

        r.removeAllCards("Cris");

        assertFalse(r.contains("Cris"));

    }

    // Tests toString()
    @Test
    public void testToString() {
        Rolodex r = new Rolodex();

        r.addCard("Chloe", "123");
        r.addCard("Chad", "23");
        r.addCard("Cris", "3");
        r.addCard("Cris", "4");
        r.addCard("Cris", "5");
        r.addCard("Yea", "23");
        r.addCard("John", "23");
        r.addCard("Zack", "23");
        r.addCard("Hi", "23");
        r.addCard("Tom", "23");

        String s = "Separator A\nSeparator B\nSeparator C\nName: Chad, Cell: 23\nName: Chloe, Cell: 123\nName: Cris, Cell: 5\nName: Cris, Cell: 4\nName: Cris, Cell: 3\nSeparator D\nSeparator E\nSeparator F\nSeparator G\nSeparator H\nName: Hi, Cell: 23\nSeparator I\nSeparator J\nName: John, Cell: 23\nSeparator K\nSeparator L\nSeparator M\nSeparator N\nSeparator O\nSeparator P\nSeparator Q\nSeparator R\nSeparator S\nSeparator T\nName: Tom, Cell: 23\nSeparator U\nSeparator V\nSeparator W\nSeparator X\nSeparator Y\nName: Yea, Cell: 23\nSeparator Z\nName: Zack, Cell: 23\n";

        assertEquals(s, r.toString());
    }

    // Tests initializecursor
    @Test
    public void testInitializeCursor() {
        Rolodex r = new Rolodex();
        r.initializeCursor();
        assertEquals("Separator A", r.currentEntryToString());
    }

    // Tests nextseparator()
    @Test
    public void testNextSeparator() {
        Rolodex r = new Rolodex();
        r.addCard("Chloe", "123");
        r.addCard("Chad", "23");
        r.addCard("Cris", "3");
        r.addCard("Cris", "4");
        r.addCard("Cris", "5");

        r.initializeCursor();
        r.nextSeparator();
        assertEquals("Separator B", r.currentEntryToString());
        r.nextSeparator();
        assertEquals("Separator C", r.currentEntryToString());
        r.nextSeparator();
        assertEquals("Separator D", r.currentEntryToString());

    }

    // Tests nextentry()
    @Test
    public void testNextEntry() {
        Rolodex r = new Rolodex();
        r.addCard("Andrew", "123");
        r.addCard("Band", "4");
        r.addCard("Bobert", "5");

        r.initializeCursor();
        r.nextEntry();
        assertEquals("Name: Andrew, Cell: 123", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Separator B", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Name: Band, Cell: 4", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Name: Bobert, Cell: 5", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Separator C", r.currentEntryToString());
    }

    // Tests currententrytostring()
    @Test
    public void testCurrentEntryToString() {
        Rolodex r = new Rolodex();
        r.addCard("A", "1");
        r.addCard("B", "2");
        r.addCard("C", "3");

        r.initializeCursor();

        r.nextEntry();
        assertEquals("Name: A, Cell: 1", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Separator B", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Name: B, Cell: 2", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Separator C", r.currentEntryToString());
        r.nextEntry();
        assertEquals("Name: C, Cell: 3", r.currentEntryToString());

    }

}