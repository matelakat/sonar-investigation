package eu.lakat.sonarexample;

/**
 * Created by matelakat on 01/06/14.
 */
public class Utility {
    public void sayHello() {
        System.out.println("Hello");
    }

    public int sum(int num1, int num2) {
        return num1 + num2;
    }

    public boolean ratherComplicatedImplementation(String param) {
        if('a' == param.charAt(0)) {
            if('b' == param.charAt(1)) {
                return true;
            }
            if('c' == param.charAt(1)) {
                return true;
            }
        }
        return false;
    }
}
