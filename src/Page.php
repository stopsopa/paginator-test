<?php

namespace Stopsopa\PaginatorTest;

class Page {
    protected $list;
    protected $count;
    protected $perPage;
    protected $pageOneIndexed;
    protected $buttons;
    public function __construct($list, $count, $perPage, $pageOneIndexed, $buttons)
    {
        $this->list             = $list;

        $this->count            = $count;

        $this->perPage          = $perPage;

        $this->pageOneIndexed   = $pageOneIndexed;

        $this->buttons          = $buttons;
    }
    public function elements()
    {
        return $this->list;
    }
    public function currentPage($zeroIndexed = false)
    {
        if ($zeroIndexed) {

            return $this->pageOneIndexed - 1;
        }

        return $this->pageOneIndexed;
    }
    public function pages()
    {
        $lastPage = ceil($this->count / $this->perPage);

        $t = intval(ceil(($this->buttons - 1) / 2));

        $min = $this->pageOneIndexed - $t;

        if ($min < 1) {

            $min = 1;
        }

        $max = $this->pageOneIndexed + $t;

        if ($max > $lastPage) {

            $max = $lastPage;
        }

        $tmp = [];

        for ( $i = $min ; $i <= $max ; $i += 1 ) {

            $tmp[] = [
                "page" => $i,
                "current" => $i === $this->pageOneIndexed,
            ];
        }

        return $tmp;
    }
    public function totalElements()
    {
        return $this->count;
    }
    public function totalElementsOnCurrentPage()
    {
        return count($this->list);
    }
    public function totalElementsPerPage()
    {
        return $this->perPage;
    }
}