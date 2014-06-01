package eu.lakat.sonarexample;

/**
 * Created by matelakat on 01/06/14.
 */
public class RatherComplicatedClass {
    public boolean ratherComplicatedImplementation(String param) {
        if('a' == param.charAt(0)) {
            if('b' == param.charAt(1)) {
                return true;
            }
            if('c' == param.charAt(1)) {
                return true;
            }
            if('d' == param.charAt(1)) {
                return true;
            }
            if('e' == param.charAt(1)) {
                return true;
            }
        }
        return false;
    }
}
