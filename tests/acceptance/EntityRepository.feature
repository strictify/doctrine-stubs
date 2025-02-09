Feature: basics
  In order to test my plugin
  As a plugin developer
  I need to have tests

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true"
        findUnusedCode="false"
        findUnusedVariablesAndParams="false">
        <projectFiles>
          <directory name="."/>
        </projectFiles>
        <issueHandlers>
            <Trace errorLevel="error"/>
        </issueHandlers>
        <plugins>
          <pluginClass class="Strictify\DoctrineStubsPsalmPlugin\Plugin" />
        </plugins>
      </psalm>
      """
  Scenario: findAll
    Given I have the following code
      """
      <?php
      use Doctrine\ORM\EntityRepository;

      /** @extends EntityRepository<Exception> */
      class UserRepository extends EntityRepository{}

      /** @psalm-var UserRepository $userRepository */

      $singleResult = $userRepository->find(42);
      /** @psalm-trace $singleResult */

      $results = $userRepository->findAll();
      /** @psalm-trace $results */

      $findByResults = $userRepository->findBy([]);
      /** @psalm-trace $findByResults */

      $findOneBy = $userRepository->findOneBy([]);
      /** @psalm-trace $findOneBy */

      $count = $userRepository->count();
      /** @psalm-trace $count */

      """
    When I run Psalm
    Then I see these errors
      | Type  | Message                       |
      | Trace | $singleResult: Exception\|null |
      | Trace | $results: list<Exception> |
      | Trace | $findByResults: list<Exception> |
      | Trace | $findOneBy: Exception\|null |
      | Trace | $count: int<0, max> |
    And I see no other errors
