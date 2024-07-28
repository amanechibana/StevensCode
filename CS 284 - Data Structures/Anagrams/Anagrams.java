package anagrams;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.channels.IllegalSelectorException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * Anagrams is a class that will find all the anagrams given a text file with
 * words
 * 
 * 
 * @author Amane Chibana
 * @version 1
 * 
 * @pledge I pledge my honor that I have abided by the Stevens Honor System.
 */

public class Anagrams {
	final Integer[] primes = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29,
			31, 37, 41, 43, 47, 53, 59, 61, 67,
			71, 73, 79, 83, 89, 97, 101 };
	Map<Character, Integer> letterTable;
	Map<Long, ArrayList<String>> anagramTable;

	/**
	 * invoked by the constructor Anagrams and builds the hash table letterTable
	 * which consists of an alphabet corresponding to a prime number
	 * 
	 */
	public void buildLetterTable() {
		char[] alphabet = "abcdefghijklmnopqrstuvwxyz".toCharArray();
		letterTable = new HashMap<Character, Integer>();

		for (int i = 0; i < primes.length; i++) {
			letterTable.put(alphabet[i], primes[i]);
		}
	}

	/**
	 * Constructor for Anagram. Initializes anagramTable and sets up letter table
	 */
	Anagrams() {
		buildLetterTable();
		anagramTable = new HashMap<Long, ArrayList<String>>();
	}

	/**
	 * computes hash code of given string s with fundamental theorem of arithmetic
	 * string added to anagramTable with hashcode as key
	 * 
	 * @param s String that hash code will be computed for and added to
	 *          anagramTable.
	 */
	public void addWord(String s) {

		if (!(anagramTable.containsKey(myHashCode(s)))) {
			ArrayList<String> anaHashList = new ArrayList<String>();
			anaHashList.add(s);
			anagramTable.put(myHashCode(s), anaHashList);
		} else {
			anagramTable.get(myHashCode(s)).add(s);
		}
	}

	/**
	 * computes hash code of given string s with fundamental theorem of arithmetic
	 * throws IllegalStateException if string is empty
	 * 
	 * @param s String that hash code will be computed for
	 * @return long, hashcode value
	 */
	public long myHashCode(String s) {
		if (s.isEmpty()) {
			throw new IllegalStateException();
		}

		long count = 1;

		for (int i = 0; i < s.length(); i++) {
			count *= letterTable.get(s.charAt(i));
		}

		return count;
	}

	/**
	 * processes text file with words(dictionary)
	 * 
	 * @param s text file name
	 * @throws IOException if file is not found
	 */
	public void processFile(String s) throws IOException {
		FileInputStream fstream = new FileInputStream(s);
		BufferedReader br = new BufferedReader(new InputStreamReader(fstream));
		String strLine;
		while ((strLine = br.readLine()) != null) {
			this.addWord(strLine);
		}
		br.close();
	}

	/**
	 * return the entries in the anagramTable that have the largest number of
	 * anagrams
	 * 
	 * @return Arraylist of anagrams
	 */
	public ArrayList<Map.Entry<Long, ArrayList<String>>> getMaxEntries() {
		ArrayList<Map.Entry<Long, ArrayList<String>>> allEntries = new ArrayList<>();
		int anaMax = 0;

		for (Map.Entry<Long, ArrayList<String>> entry : anagramTable.entrySet()) {
			if (entry.getValue().size() > anaMax) {
				anaMax = entry.getValue().size();
				allEntries.clear();
				allEntries.add(entry);
			} else if (entry.getValue().size() == anaMax) {
				allEntries.add(entry);
			}
		}

		return allEntries;
	}

	/**
	 * read all the strings in a file, place them in the hash table of anagrams and
	 * then iterate over the hash table
	 * 
	 */
	public static void main(String[] args) {
		Anagrams a = new Anagrams();

		final long startTime = System.nanoTime();
		try {
			a.processFile("words_alpha.txt");
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		ArrayList<Map.Entry<Long, ArrayList<String>>> maxEntries = a.getMaxEntries();
		final long estimatedTime = System.nanoTime() - startTime;
		final double seconds = ((double) estimatedTime / 1000000000);
		System.out.println("Time: " + seconds);
		System.out.println("List of max anagrams: " + maxEntries);
	}
}
