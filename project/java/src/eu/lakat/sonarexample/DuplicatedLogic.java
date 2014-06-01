package eu.lakat.sonarexample;

/**
 * Created by matelakat on 01/06/14.
 */
public class DuplicatedLogic {

    public boolean duplicateComplicatedImplementation(String otherParamRenamed) {
        if('a' == otherParamRenamed.charAt(0)) {
            if('b' == otherParamRenamed.charAt(1)) {
                return true;
            }
            if('c' == otherParamRenamed.charAt(1)) {
                return true;
            }
            if('d' == otherParamRenamed.charAt(1)) {
                return true;
            }
        }
        return false;
    }
}
