package CS;
/*
 * @author Amane Chibana
 * @section CS 284 - D 
 * @pledge I pledge my honor that I have abided by the Stevens Honor System. 
 */

 public class BinaryNumber{
    private int data[];
    private int length;
    
    public BinaryNumber(int length){
        /**
         * constructor, creates binary number of length with zeros 
         */
        this.data = new int[length];
        this.length = length;
        
        for(int i=0; i<length;i++){
            data[i] = 0;
        }
    }

    public BinaryNumber(String str){
        /**
         * constructor, creates binary number based on string inputted
         */
        this.data = new int[str.length()];
        this.length = str.length();

        for(int i=0;i<str.length();i++){
            data[i] = Character.getNumericValue(str.charAt(i));
        }
    }

    public int getLength(){
        /**
         * returns length of binary number
         */
        return this.length;
    }

    public int getDigit(int index){
        /**
         * obtains a digit of binary number based on input, error thrown when improper index is inputted
         */
        try {
            return this.data[index]; 
        } catch (ArrayIndexOutOfBoundsException e) {
            throw new IndexOutOfBoundsException("Index out of range");
        }
    }

    public int[] getInnerArray() {
        /**
         * returns integer array representing binary number
         */
        return data;
    }

    public static int[] bwor(BinaryNumber bn1, BinaryNumber bn2) {
        /**
         * computes and returns the bitwise or of two numbers
         */
        if(bn1.length != bn2.length){
            throw new IllegalArgumentException("Bad input");
        }

        int[] intArray = new int[bn1.length];

        for(int i=0; i<bn1.length;i++){
            if(bn1.data[i]==1 || bn2.data[i] == 1){
                intArray[i] = 1;
            } 
         }
        return intArray;
    }

    public static int[] bwand(BinaryNumber bn1, BinaryNumber bn2) {
        /**
         * computes and returns the bitwise and of two numbers
         */
        if(bn1.length != bn2.length){
            throw new IllegalArgumentException("Bad input");
        }

        int[] intArray = new int[bn1.length];
        
        for(int i=0; i<bn1.length;i++){
            if(bn1.data[i]==1 && bn2.data[i] == 1){
                intArray[i] = 1;
            } 
         }
        return intArray;
    }

    public void bitShift(int direction, int amount){
        /**
         * operation that shifts all digits of binary number to the left or right depending on direction input and amount input
         */
        BinaryNumber shiftedArray = new BinaryNumber(this.length - (amount*direction));

        if(direction==1 && amount>0){
            for(int i=0; i<shiftedArray.length; i++){
                shiftedArray.data[i] = this.data[i];
            }
                
        }else if(direction==-1 && amount>0){
            for(int i=0; i<this.length; i++){
                shiftedArray.data[i] = this.data[i];
            }
        }

        this.length = this.length - (direction*amount);
        this.data = shiftedArray.data;
    }
    public void prepend(int amount){
        /**
         * helper function for add operation. adds zero's to front of inputted integer array based on input count
         */
        int[] newArr = new int[this.getLength()+amount];
        for(int i = this.getLength()+amount-1; i>amount-1;i--){
            newArr[i] = this.getDigit(i-amount);
        }
        this.data = newArr;
        this.length = newArr.length;
    }

    public void add(BinaryNumber aBinaryNumber){
        /**
         * operation that adds two binary numbers. binary number that recieves add will be modified by this operation
         */
        int carry = 0;
        int sum = 0;

        if(this.getLength()>aBinaryNumber.getLength()){
            aBinaryNumber.prepend(this.getLength()-aBinaryNumber.getLength());
        } else if(this.getLength()<aBinaryNumber.getLength()){
            this.prepend(aBinaryNumber.getLength()-this.getLength());
        }

        int[] temp1 = new int[this.getLength()];

        for(int i=this.length-1; i>=0; i--){
            sum = carry + this.getDigit(i) + aBinaryNumber.getDigit(i);
            if (sum == 0) {
                temp1[i] = 0;
                carry = 0;
            }
            else if(sum == 1) {
                temp1[i] = 1;
                carry = 0;
            }
            else if(sum == 2) {
                temp1[i] = 0;
                carry = 1;
            }
            else if(sum == 3) {
                temp1[i] = 1;
                carry = 1;
            }
        }
        if (carry == 1) {
            int[] temp2 = new int[this.getLength() + 1];
            temp2[0] = 1;
            for(int i = 0; i < temp1.length; i++) {
                temp2[i+1] = temp1[i];
            }
            this.data = temp2;
            this.length = temp2.length;
        }
        else {
            this.data = temp1;
            this.length = temp1.length;
        }

        }

    public String toString() {
        /**
         * returns the binary number as corresponding encoded string
         */
        String res = "";
        for(int i=0; i<this.length;i++){
            res +=data[i];
        }
        return res;
    }

    public int toDecimal() {
        /**
         * transforms binary number into decimal 
         */
        int total = 0;
        for(int i=0; i<=this.getLength()-1;i++){
           total+=(int)Math.pow(2*data[this.getLength()-i-1],i);
        }
        return total; 
    }
 }