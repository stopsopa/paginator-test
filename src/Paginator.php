<?php

namespace Stopsopa\PaginatorTest;

class Paginator {

    protected $perPage;

    protected $counterCallback;

    protected $getPageCallback;

    protected $count;

    protected $buttons;

    public function __construct($perPage, $counterCallback, $getPageCallback, $buttons = 7)
    {
        if ( ! is_int($buttons) ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->getPage buttons is not an integer");
        }

        if ( $buttons < 3 ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->__construct buttons < 3");
        }

        $this->buttons = $buttons;

        if ( ! is_int($perPage) ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->getPage perPage is not an integer");
        }

        if ( $perPage < 1 ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->__construct perPage < 1");
        }

        $this->perPage          = $perPage;

        if ( ! is_callable($counterCallback) ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->__construct counterCallback is not callable");
        }

        $this->counterCallback  = $counterCallback;

        if ( ! is_callable($getPageCallback) ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->__construct getPageCallback is not callable");
        }

        $this->getPageCallback  = $getPageCallback;
    }
    public function getPage($pageOneIndexed)
    {
        if ( ! is_int($pageOneIndexed) ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->getPage pageOneIndexed is not an integer");
        }

        if ( $pageOneIndexed < 1 ) {

            throw new Exception("Stopsopa\PaginatorTest\Paginator->getPage pageOneIndexed < 1");
        }

        if ( is_null($this->count) ) {

            $this->count = ($this->counterCallback)();

            if ( ! is_int($this->count) ) {

                throw new Exception("Stopsopa\PaginatorTest\Paginator->getPage count is not an integer");
            }

            if ( $this->count < 0 ) {

                throw new Exception("Stopsopa\PaginatorTest\Paginator->getPage count is negative");
            }
        }

        $lastPage = intval(ceil($this->count / $this->perPage));

        if ($pageOneIndexed > $lastPage) {

            $pageOneIndexed = $lastPage;
        }

        $list = ($this->getPageCallback)(($pageOneIndexed - 1) * $this->perPage, $this->perPage);

        return new Page($list, $this->count, $this->perPage, $pageOneIndexed, $this->buttons);
    }
}