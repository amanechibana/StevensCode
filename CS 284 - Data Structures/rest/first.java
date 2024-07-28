public class first {
  public static void main(String[] args) {
    System.out.println("Hello World"); //WOWOWOOWOWO
    System.out.print("poggers");
    System.out.println(5*5);
    String name = "hugo";
    int num = 5;
    System.out.println(name);
    System.out.println(num);
    num = 15;
    System.out.println(num);
    final int myNum = 200; // cannot change value 
    System.out.println(myNum);
    int x = 5, y = 2, z =3;
    System.out.println(x+y+z);
    int a,b,c;
    a = b = c = 50;
    System.out.println(a+b+c);
    byte smol = 100;
    System.out.println(smol);
    char myVar1 = 65, myVar2 = 66, myVar3 = 67;
    System.out.println(myVar1);
    System.out.println(myVar2);
    System.out.println(myVar3);
    String txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    System.out.println("The length of the string is " + txt.length());
    String txt2 = "pog \"pog\"";
    System.out.println(txt2);
    System.out.println(Math.max(5, 10));
    int time = 20;
    if (time>18){
      System.out.println("yes");
    } else if(time<18){
      System.out.println("no");
    } else{
      System.out.println("yes!");
    }
    System.out.println((time<18) ? "POGPOG" : "BOGBOG");
    int day = 2 ;
    switch(day) {
      case 1:
        System.out.println("Hugos first day without a shower: doesnt smell bad yet");
        break;
      case 2:
        System.out.println("Hugos second day without a shower: he is starting to smell pretty bad. Shower reccomended");
        break;
      case 3:
        System.out.println("Hugos third day without a shower: He smells so bad he really really needs that shower");
        break;
      default:
        System.out.println("Either hugo has showered or he just smells so bad he killed the entire human race");
    }
    int f = 5;
    while(f<=10){
      System.out.println("hugos favorite number is " + f);
      f++;
    }
    int i = 0;
    do {
      System.out.println(i);
      i++;
    } while(i<5);

    for (int j = 0; j<5 ; j++){
      System.out.println(j);
    }
  String[] poggers = {"huigo","hugo2","hugo3","hugo"};
  for (String w: poggers){
    System.out.println(w);
  }
  int[] arrayOfNum = {10,20,30,40};
  System.out.println(arrayOfNum[1]);
  arrayOfNum[1] = 40;
  System.out.println(arrayOfNum[1]);
  System.out.println(arrayOfNum.length);

  for(int wow = 0; wow < poggers.length; wow++){
    System.out.println(poggers[wow]);
  }
  }
}

// this is a single line comment ledleledleleldeledleldel
/*I am a multiline comment.
 * look at me go.
 */