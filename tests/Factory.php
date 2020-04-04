<?php

namespace Stopsopa\PaginatorTest;

class Factory
{
    public static function generateList($start, $end)
    {
        $tmp = [];

        for ( ; $start <= $end ; $start += 1 ) {

            $tmp[] = "i-$start";
        }

        return $tmp;
    }
}