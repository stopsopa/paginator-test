<?php

namespace Stopsopa\PaginatorTest;

use Stopsopa\PaginatorTest\Paginator;

use PHPUnit_Framework_TestCase;

class totalElementsPerPageTest extends PHPUnit_Framework_TestCase
{
    public function testGeneral()
    {
        $list = Factory::generateList(1, 100);

        $p = new Paginator(4, function () use ($list) {
            return count($list);
        }, function ($offset, $limit) use ($list) {
            return array_slice($list, $offset, $limit);
        }, 3);

        $k = $p->getPage(2);

        $this->assertSame(4, $k->totalElementsPerPage());
    }
}