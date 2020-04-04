<?php

namespace Stopsopa\PaginatorTest;

use Stopsopa\PaginatorTest\Paginator;

use PHPUnit_Framework_TestCase;

class GeneralTest extends PHPUnit_Framework_TestCase
{
    public function testGeneral()
    {
        $list = Factory::generateList(1, 10);

        $p = new Paginator(3, function () use ($list) {
            return count($list);
        }, function ($offset, $limit) use ($list) {
            return array_slice($list, $offset, $limit);
        }, 3);

        $k = $p->getPage(2);

        $this->assertSame([
            [
                "page" => 1,
                "current" => false,
            ],
            [
                "page" => 2,
                "current" => true,
            ],
            [
                "page" => 3,
                "current" => false,
            ],
        ], $k->pages());
    }
    public function testGetPage100Case()
    {
        $p = new Paginator(
            3,
            function () { return 10; },
            function () {},
            3
        );

        $page = $p->getPage(100);

        $this->assertSame(4, $page->currentPage());
    }
}