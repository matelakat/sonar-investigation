package eu.lakat.sonarexample;


import org.junit.runners.JUnit4;
import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(JUnit4.class)
public class MainTest {
    @Test
    public void someStupidTest() {
        assertEquals(1, 1);
    }

    @Test
    public void testSum() {
        Main main = new Main();

        int result = main.sum(1, 2);

        assertEquals(3, result);
    }
}
