package runners;

import com.intuit.karate.junit5.Karate;

class KarateTest {

    @Karate.Test
    Karate testLabs() {
        return Karate.run("classpath:features");
    }

    @Karate.Test
    Karate testExamples() {
        return Karate.run("classpath:examples");
    }
}
