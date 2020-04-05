[![Build Status](https://travis-ci.org/stopsopa/paginator-test.svg?branch=v0.0.0)](https://travis-ci.org/stopsopa/paginator-test)
[![Coverage Status](https://coveralls.io/repos/github/stopsopa/paginator-test/badge.svg?branch=v0.0.0)](https://coveralls.io/github/stopsopa/paginator-test?branch=v0.0.0)
[![Latest Stable Version](https://poser.pugx.org/stopsopa/paginator-test/v/stable)](https://packagist.org/packages/stopsopa/paginator-test)
[![License](https://poser.pugx.org/stopsopa/paginator-test/license)](https://packagist.org/packages/stopsopa/paginator-test)


# Table of Contents

<!-- toc -->
<!-- tocstop -->

_(TOC generated using [markdown-toc](https://github.com/jonschlinkert/markdown-toc))_


# Installation

    composer require stopsopa/paginator-test
    
# Usage

```php
<?php

use Stopsopa\PaginatorTest\Paginator;

require_once dirname(__FILE__).'/vendor/autoload.php';

$list = str_split('abcdefghijklmnopqrstuwxyz', 1);

$paginator = new Paginator(
    3, // per page
    // function to return length of the set
    function () use ($list) {
        return count($list);
    },
    // function to provide one page of elements from set
    function ($offset, $limit) use ($list) {
        return array_slice($list, $offset, $limit);
    },
    3 // how many buttons around current
);

$page = $paginator->getPage(3);

var_dump($page->elements());
//array(3) {
//      [0] => string(1) "g"
//      [1] => string(1) "h"
//      [2] => string(1) "i"
//}

var_dump($page->pages());
//array(3) {
//    [0] => array(2) {
//        'page' => int(2)
//        'current' => bool(false)
//    }
//    [1] => array(2) {
//        'page' => int(3)
//        'current' => bool(true)
//    }
//    [2] => array(2) {
//        'page' => int(4)
//        'current' => bool(false)
//    }
//}
```

see more: [test](tests/GeneralTest.php)    

# Dev notes

Just follow Makefile... it should be quite self explanatory
