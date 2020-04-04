<?php

namespace Stopsopa\PaginatorTest;

use PHPUnit_Framework_TestCase;

class PaginatorExceptionsTest extends PHPUnit_Framework_TestCase
{
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->getPage buttons is not an integer
     */
    public function testButtonString()
    {
        new Paginator(
            3,
            function () {},
            function () {},
            'notint'
        );
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->__construct buttons < 3
     */
    public function testButtonLt3()
    {
        new Paginator(
            3,
            function () {},
            function () {},
            2
        );
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->getPage perPage is not an integer
     */
    public function testPerPageString()
    {
        new Paginator(
            'perpagestr',
            function () {},
            function () {},
            3
        );
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->__construct perPage < 1
     */
    public function testPerPageLt1()
    {
        new Paginator(
            0,
            function () {},
            function () {},
            3
        );
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->__construct counterCallback is not callable
     */
    public function testCounterCallbackNotFn()
    {
        new Paginator(
            3,
            'notfn',
            function () {},
            3
        );
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->__construct getPageCallback is not callable
     */
    public function testGetPageCallbackNotFn()
    {
        new Paginator(
            3,
            function () {},
            'notfn',
            3
        );
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->getPage pageOneIndexed is not an integer
     */
    public function testGetPageNotInt()
    {
        $p = new Paginator(
            3,
            function () {},
            function () {},
            3
        );

        $p->getPage('not int');
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->getPage pageOneIndexed < 1
     */
    public function testGetPageLt1()
    {
        $p = new Paginator(
            3,
            function () {},
            function () {},
            3
        );

        $p->getPage(0);
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->getPage count is not an integer
     */
    public function testGetPage1()
    {
        $p = new Paginator(
            3,
            function () {},
            function () {},
            3
        );

        $p->getPage(1);
    }
    /**
     * @expectedException Stopsopa\PaginatorTest\Exception
     * @expectedExceptionCode 0
     * @expectedExceptionMessage Stopsopa\PaginatorTest\Paginator->getPage count is negative
     */
    public function testGetPage2()
    {
        $p = new Paginator(
            3,
            function () { return -1; },
            function () {},
            3
        );

        $p->getPage(1);
    }
}