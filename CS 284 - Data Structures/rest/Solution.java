public class Solution {
    public int romanToInt(String s) {
        int count = 0;
        for (int i=0;i<s.length()-1;i++){
            switch(s){
                case "I":
                    System.out.println("pog");
                    count++;
                    break;
                case "V":
                    count+=5;
                    break;
                case "X":
                    count+=10;
                    break;
                case "L":
                    count+=50;
                    break;
            }
        }
        return count; 
    }
}
