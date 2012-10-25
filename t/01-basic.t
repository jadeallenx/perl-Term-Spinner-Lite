#!/usr/bin/perl

use strict;
use Test::More;
use Term::Spinner::Lite;

plan tests => 5;

my $s = Term::Spinner::Lite->new();
isa_ok($s, 'Term::Spinner::Lite', 'object created');

is($s->_spin_char_size, 4, "got 4 spin chars");

is_deeply($s->spin_chars, [ qw(- \ | /) ], "spin_chars match");

is($s->count, 0, "count is 0");

$s->next for 1 .. 10;
$s->done;

is($s->count, 10, "count is 10");
