public class second {
    int pog = 5;

    static void myMethod() { //private mode that can be accesed through calling function 
        System.out.println("POGGERS POGGERS IM GONNA BUST AHHHHHH");
    }
    
    static void myMethod2(String fname, int pog){
        System.out.println(fname + " is gonna BUST " + pog + " times!!!");
    }

    static int myAddition(int x, int y){
        return x+y;
    }

    static double myAddition(double x, double y){
        return x+y;
    }

    public void myPublicMethod() {
        System.out.println("I can only be called with an object");
    }   

    //overloading a method. Same thing but different data type. SHITS WACK 
    public static void main(String[] args){
        myMethod();
        myMethod();
        myMethod();
        myMethod2("MR Poggers",5);
        System.out.println(myAddition(4,5));
        System.out.println(myAddition(4.1,5.23));
        second myObj = new second();
        second myObj2 = new second(); // can use ex when accesing class of another file. 
        System.out.println(myObj.pog);
        System.out.println(myObj2.pog); 
        myObj.pog = 25;
        System.out.println(myObj.pog);
        System.out.println(myObj2.pog); 
        second pub = new second();
        pub.myPublicMethod(); //cannot call method without object
    
    }
}
