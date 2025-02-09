# psalm stubs for Doctrine

## Installation
Add this to your composer.json file

```json
"require-dev": {
    "strictify/doctrine-stubs": "dev-master"
},
"repositories": [
    {
        "type": "github",
        "url": "git@github.com:strictify/doctrine-stubs.git"
    }
],
```
Then run:
```text
composer req strictiy/doctrine-stubs --dev
vendor/bin/psalm-plugin enable strictiy/doctrine-stubs
```

## Quickstart

The most common Doctrine use is by using QueryBuilder, for example:

```php
/** @extends ServiceEntityRepository<User> */
class UserRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, User::class);
    }
    
    /** @return list<User> */
    public function findForPage(): array
    {
        return $this->createQueryBuilder('u')
            ->where('--some condition here--')
            ->getQuery()->getResult();
    }
} 
```

But this code will throw static analysis errors because `Query::getResult()` returns `mixed`. This package solves the above problem, with some limitations:

* You cannot use `EntityManager::getRepository` method, you must inject exact repository. It is a recommended approach anyway so it shouldn't be a problem anyway.
* You cannot use `QueryBuilder::select()` method. If you do, the results will fall back to `mixed`.
* This package **will** ignore `groupBy` and the type will be Query<User> and not Query<int|string, User>. This is intentional; there is no realistic use-case for knowing if the key is either `int` or `string`, so passing this key around is a chore.

## Example
```php
class MyService
{
    public function __construct(private UserRepository $repository) {}
    
    /**
    * Passes static analysis
     */
    public function typed(): void 
    {
        // QueryBuilder<User>
        $qb = $this->repository->createQueryBuilder('u'); 
        // Query<User>
        $query = $qb->getQuery(); 
        // list<User>
        $results = $query->getResult(); 
    }
    /**
     * Calling QueryBuilder::select() will use the default value of `mixed`
     */
    public function mixed(): void 
    {
        // QueryBuilder<User>
        $qb = $this->repository->createQueryBuilder('u'); 
        // QueryBuilder<mixed>
        $qb->select('u.name'); 
        // Query<mixed>
        $query = $qb->getQuery(); 
        // list<mixed>
        $results = $query->getResult(); 
    }
}
```
