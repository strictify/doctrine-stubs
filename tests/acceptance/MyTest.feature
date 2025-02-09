Feature: basics
  In order to test my plugin
  As a plugin developer
  I need to have tests

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true">
        <projectFiles>
          <directory name="."/>
        </projectFiles>
        <plugins>
          <pluginClass class="Strictify\DoctrineStubsPsalmPlugin\Plugin" />
        </plugins>
      </psalm>
      """
  Scenario: run without errors
    Given I have the following code
      """
      <?php
      echo atan(1);
      """
    When I run Psalm
    Then I see no errors

  Scenario: run with errors
    Given I have the following code
      """
      <?php
      echo atan("not a number");
      """
    When I run Psalm
    Then I see these errors
      | Type                  | Message                                                                             |
      | InvalidScalarArgument | /Argument 1 of atan expects float, but 'not a number' provided/ |
    And I see no other errors
