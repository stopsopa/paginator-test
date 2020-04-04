<?php

namespace Stopsopa\PaginatorTest;

use Stopsopa\PaginatorTest\Paginator;

use PHPUnit_Framework_TestCase;

class pagesTest extends PHPUnit_Framework_TestCase
{
    public function testMinEqualOne()
    {
        $list = Factory::generateList(1, 100);

        $p = new Paginator(3, function () use ($list) {
            return count($list);
        }, function ($offset, $limit) use ($list) {
            return array_slice($list, $offset, $limit);
        }, 5);

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
            [
                "page" => 4,
                "current" => false,
            ],
        ], $k->pages());
    }
    public function testMaxEqualLastPage()
    {
        $list = Factory::generateList(1, 10);

        $p = new Paginator(3, function () use ($list) {
            return count($list);
        }, function ($offset, $limit) use ($list) {
            return array_slice($list, $offset, $limit);
        }, 5);

        $k = $p->getPage(4);

        $this->assertSame([
            [
                "page" => 2,
                "current" => false,
            ],
            [
                "page" => 3,
                "current" => false,
            ],
            [
                "page" => 4,
                "current" => true,
            ],
        ], $k->pages());
    }
}