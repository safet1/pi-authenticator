/*
  privacyIDEA Authenticator

  Authors: Timo Sturm <timo.sturm@netknights.it>

  Copyright (c) 2017-2019 NetKnights GmbH

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

//    final buttonFinder = find.byType(FloatingActionButton.toString());
    final buttonFinder = find.byType("FloatingActionButton");
    final addTokenButton = find.byValueKey("add_manually");

    test('click the button', () async {
      await driver.tap(buttonFinder);
      await Future.delayed(Duration(seconds: 10));
      await driver.tap(addTokenButton);
      await Future.delayed(Duration(seconds: 10));
    });

    test("Enter input", () async {
      await driver.tap(find.ancestor(
          of: find.text("Name"), matching: find.byType("TextFormField")));

      await driver.enterText("TestName");

      await driver.tap(find.ancestor(
          of: find.text("Secret"), matching: find.byType("TextFormField")));

      await driver.enterText("TestSecret");

      await driver.tap(find.byType("RaisedButton"));

      await Future.delayed(Duration(seconds: 20));
    });
  });
}
