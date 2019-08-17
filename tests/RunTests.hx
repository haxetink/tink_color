package ;

import tink.unit.*;
import tink.testrunner.*;

class RunTests {
  static function main() {  
    Runner.run(TestBatch.make([
      new Colors(),
    ])).handle(Runner.exit);
  }
}