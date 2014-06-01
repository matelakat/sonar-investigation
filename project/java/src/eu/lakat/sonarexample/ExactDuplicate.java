package eu.lakat.sonarexample;

/**
 * Created by matelakat on 01/06/14.
 */
public class ExactDuplicate {
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

    public boolean ratherComplicatedImplementation2(String param) {
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
