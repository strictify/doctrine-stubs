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
  Scenario: run without errors
    Given I have the following code
      """
      <?php
      use Doctrine\ORM\EntityRepository;

      /** @psalm-var EntityRepository<Exception> $userRepository */

      $qb = $userRepository->createQueryBuilder('o');

      $qb->select('o.name');
      /** @psalm-trace $qb */

      $query = $qb->getQuery();
      /** @psalm-trace $query */

      $results = $query->getResult();
      /** @psalm-trace $results */

      """
    When I run Psalm
    Then I see these errors
      | Type  | Message                       |
      | Trace | $qb: Doctrine\ORM\QueryBuilder<mixed> |
      | Trace | $query: Doctrine\ORM\Query<mixed> |
      | Trace | $results: list<mixed> |
    And I see no other errors
