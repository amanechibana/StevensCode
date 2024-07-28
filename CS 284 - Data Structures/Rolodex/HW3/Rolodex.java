package HW3;

import java.util.ArrayList;

/**
 * Rolodex is an implementation of a rolodex using a double linked list
 * 
 * @author Amane Chibana
 * @version 1
 */

public class Rolodex {
	private Entry cursor;
	private final Entry[] index;

	// Constructor

	/**
	 * Constructor, makes Rolodex separators
	 */
	Rolodex() {
		char[] alphabet = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
				'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
		index = new Entry[26];

		for (int i = 0; i < alphabet.length; i++) {
			index[i] = new Separator(null, null, alphabet[i]);
		}
		;

		for (int i = 0; i < alphabet.length - 1; i++) {
			index[i].next = index[i + 1];
		}

		for (int i = 1; i < alphabet.length; i++) {
			index[i].prev = index[i - 1];
		}
		index[0].prev = index[25];
		index[25].next = index[0];

	}

	/**
	 * Determines whether there is a card for name
	 * 
	 * @param name name that is checked in rolodex
	 * @return true for in rolodex, otherwise false
	 */
	public Boolean contains(String name) {
		Entry curr = index[name.charAt(0) - 'A'].next;
		while (!curr.isSeparator()) {
			if (curr.getName() == name) {
				return true;
			} else if (curr.next == index[0]) {
				break;
			}
			curr = curr.next;
		}
		return false;
	}

	/**
	 * returns the size of the Rolodex
	 * 
	 * @return size of rolodex minus the separators
	 */
	public int size() {
		int retSize = 0;
		Entry curr = index[0];

		while (true) {
			retSize += curr.size();
			if (curr.next == index[0]) {
				break;
			}
			curr = curr.next;
		}

		return retSize;

	}

	/**
	 * returns an ArrayList with all the cellphones of name
	 * 
	 * @param name name for cellphone
	 * @return Arraylist with cellphones of name
	 */
	public ArrayList<String> lookup(String name) {
		Entry curr = index[name.charAt(0) - 'A'].next;
		ArrayList<String> out = new ArrayList<String>();
		while (!curr.isSeparator()) {
			if (curr.getName() == name) {
				Card curr2 = (Card) curr;
				out.add(curr2.getCell());
			}
			curr = curr.next;
		}
		if (out.size() == 0) {
			throw new IllegalStateException("lookup: name not found");
		}
		return out;
	}

	public String toString() {
		Entry current = index[0];

		StringBuilder b = new StringBuilder();
		while (current.next != index[0]) {
			b.append(current.toString() + "\n");
			current = current.next;
		}
		b.append(current.toString() + "\n");
		return b.toString();
	}

	/**
	 * adds a new card with the specified information to the Rolodex
	 * 
	 * @param name name being added
	 * @param cell cell being added
	 */
	public void addCard(String name, String cell) {
		Entry curr = index[name.charAt(0) - 'A'];

		while (!curr.next.isSeparator()) {
			curr = curr.next;
			Card curr2 = (Card) curr;

			if (curr.getName() == name && curr2.getCell() == cell) {
				throw new IllegalStateException("addCard: duplicate entry");
			}
		}

		curr = index[name.charAt(0) - 'A'];
		if (curr.next.isSeparator()) {
			Card x = new Card(curr, curr.next, name, cell);
			curr.next.prev = x;
			curr.next = x;
		} else if (contains(name)) {
			curr = curr.next;
			while (!curr.isSeparator()) {
				Card y = new Card(curr.prev, curr, name, cell);
				if (curr.getName() == name) {
					curr.prev.next = y;
					curr.prev = y;
					break;
				}
				curr = curr.next;
			}
		} else {
			while (!curr.next.isSeparator()) {
				curr = curr.next;
				if (name.charAt(0) == 'Z' && curr.next == index[0]) {
					Card x = new Card(curr, curr.next, name, cell);
					curr.next = x;
					break;
				}
				if (curr.next.isSeparator()) {
					if (curr.getName().compareTo(name) < 0) {
						Card x = new Card(curr, curr.next, name, cell);
						curr.next.prev = x;
						curr.next = x;
						break;
					}
					Card x = new Card(curr.prev, curr, name, cell);
					curr.prev.next = x;
					curr.prev = x;
					break;
				}
				if (curr.getName().compareTo(name) > 0) {
					Card x = new Card(curr, curr.next, name, cell);
					curr.next.prev = x;
					curr.next = x;
					break;
				}

			}
		}
	}

	/**
	 * removes the specified card
	 * 
	 * @param name name being removed
	 * @param cell cell being removed
	 */
	public void removeCard(String name, String cell) {
		Entry curr = index[name.charAt(0) - 'A'];

		int count = 0;

		while (!curr.next.isSeparator()) {
			curr = curr.next;
			Card curr2 = (Card) curr;

			if (curr.getName() == name && curr2.getCell() == cell) {
				count += 1;
			}
		}
		if (count == 0) {
			throw new IllegalArgumentException("removeCard: name does not exist");
		}
		if (this.contains(name) && count == 0) {
			throw new IllegalArgumentException("removeCard: cell for that name does not exist");
		}

		curr = index[name.charAt(0) - 'A'].next;

		while (!curr.isSeparator()) {
			Card curr2 = (Card) curr;
			if (curr.getName() == name && curr2.getCell() == cell) {
				curr.prev.next = curr.next;
				curr.next.prev = curr.prev;
			}
			curr = curr.next;
		}
	}

	/**
	 * removes all cards for name
	 * 
	 * @param name named being removed from rolodex
	 */
	public void removeAllCards(String name) {
		if (!this.contains(name)) {
			throw new IllegalArgumentException("removeAllCards: name does not exist");
		}
		Entry curr = index[name.charAt(0) - 'A'].next;
		while (!curr.isSeparator()) {
			if (curr.getName() == name) {
				curr.prev.next = curr.next;
				curr.next.prev = curr.prev;
			}
			curr = curr.next;
		}

	}

	// Cursor operations

	/**
	 * sets the cursor field to the separator for “A”.
	 */
	public void initializeCursor() {
		cursor = index[0];
	}

	/**
	 * moves cursor to the next separator.
	 */
	public void nextSeparator() {
		cursor = cursor.next;
		while (!cursor.isSeparator()) {
			cursor = cursor.next;
		}
	}

	/**
	 * moves cursor to the next entry,
	 */
	public void nextEntry() {
		cursor = cursor.next;
	}

	/**
	 * returns the string representation of the current entry pointed to by the
	 * cursor.
	 * 
	 * @return String representation of current cursor point
	 */
	public String currentEntryToString() {
		return cursor.toString();
	}

	public static void main(String[] args) {
		Rolodex r = new Rolodex();

		System.out.println(r);

		r.addCard("Chloe", "123");
		r.addCard("Chad", "23");
		r.addCard("Cris", "3");
		r.addCard("Cris", "4");
		r.addCard("Cris", "5");
		// r.addCard("Cris", "4");
		r.addCard("Maddie", "23");

		System.out.println(r);

		System.out.println(r.contains("Albert"));

		r.removeAllCards("Cris");

		System.out.println(r);

		r.removeAllCards("Chad");
		r.removeAllCards("Chloe");

		r.addCard("Chloe", "123");
		r.addCard("Chad", "23");
		r.addCard("Cris", "3");
		r.addCard("Cris", "4");

		System.out.println(r);

	}

}
