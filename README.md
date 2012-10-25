# NAME

Term::Spinner::Lite - A spinner without so much Moose in it

# VERSION

version 0.01

# SYNOPSIS

    use Term::Spinner::Lite;

    my $s = Term::Spinner::Lite->new();

    $s->next() for 1 .. 100_000;
    $s->done();

This is a simple spinner, useful when you want to show some kind of activity 
during a long-running activity of non-determinant length.  It's loosely based
on the API from [Term::Spinner](http://search.cpan.org/perldoc?Term::Spinner).  Unlike [Term::Spinner](http://search.cpan.org/perldoc?Term::Spinner) though, this module
doesn't have any dependencies outside of modules shipped with Perl itself.

# ATTRIBUTES

## output\_handle

Gets or sets the handle where output will be written. Be default, uses STDERR.

## spin\_chars

Gets or sets the list of characters to cycle through. By default it uses the 
sequence "-" "\\" "|" "/".  This attribute must be set using an array ref, e.g.,

    [ qw( . o O o ) ]

This attribute will croak by an attempt to set itself using anything else.

# METHODS

## new()

The object constructor.  You may optionally set object attributes `spin_chars` or
`output_handle` in the parameter list.

## count()

Return the number of advances through the spin sequence.

## next()

Advance the spinner state to the next character in the spin sequence and output 
it to `output_handle`. 

## done()

Finish spinning, and clear the last character printed. If a true value is passed,
output a newline.

# AUTHOR

Mark Allen <mrallen1@yahoo.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
