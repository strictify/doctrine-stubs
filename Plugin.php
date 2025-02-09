<?php

namespace Strictify\DoctrineStubsPsalmPlugin;

use Generator;
use SimpleXMLElement;
use Psalm\Plugin\PluginEntryPointInterface;
use Psalm\Plugin\RegistrationInterface;

class Plugin implements PluginEntryPointInterface
{
    public function __invoke(RegistrationInterface $registration, ?SimpleXMLElement $config = null): void
    {
        foreach ($this->getStubFiles() as $file) {
            $registration->addStubFile($file);
        }

        // Psalm allows arbitrary content to be stored under you plugin entry in
        // its config file, psalm.xml, so your plugin users can put some configuration
        // values there. They will be provided to your plugin entry point in $config
        // parameter, as a SimpleXmlElement object. If there's no configuration present,
        // null will be passed instead.
    }

    /** @return Generator<string> */
    private function getStubFiles(): Generator
    {
        yield __DIR__ . '/stubs/AbstractQuery.stubphp';
        yield __DIR__ . '/stubs/Query.stubphp';
        yield __DIR__ . '/stubs/QueryBuilder.stubphp';
        yield __DIR__ . '/stubs/EntityRepository.stubphp';
        yield __DIR__ . '/stubs/ServiceEntityRepositoryProxy.stubphp';
    }
}
