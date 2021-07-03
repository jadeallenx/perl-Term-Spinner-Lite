# NAME

Term::Spinner::Lite - A spinner without so much Moose in it

# VERSION

version 0.03

# SYNOPSIS

    use utf8;
    use 5.010;
    use Term::Spinner::Lite;
    my $s = Term::Spinner::Lite->new(
      delay => 100_000,
      spin_chars => ['◑', '◒', '◐', '◓'],
    );

    $s->next() for 1 .. 100_000;
    $s->done();

This is a simple spinner, useful when you want to show some kind of activity 
during a long-running activity of non-determinant length.  It's loosely based
on the API from [Term::Spinner](https://metacpan.org/pod/Term::Spinner).  Unlike [Term::Spinner](https://metacpan.org/pod/Term::Spinner) though, this module
doesn't have any dependencies outside of modules shipped with Perl itself.

# ATTRIBUTES

## output\_handle

Gets or sets the handle where output will be written. By default, uses STDERR.
You may pass an optional PerlIO encoding specification. By default it will use
":utf8" in case you want to use UTF8 characters in your spinner.

## spin\_chars

Gets or sets the list of characters to cycle through. By default it uses the 
sequence "-" "\\" "|" "/".  This attribute must be set using an array ref, e.g.,

    [ qw( . o O o ) ]

This attribute will croak by an attempt to set itself using anything else.

## delay

Gets or sets the delay between state changes in microseconds. (A good value 
for smooth spinning is 100000.) Defaults to 0.

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

# SEE ALSO

[Term::Spinner](https://metacpan.org/pod/Term::Spinner) is similar to this module, but depends on Moose,
and only had one release, in 2007.

[Term::Spinner::Color](https://metacpan.org/pod/Term::Spinner::Color) is similar to this module,
but only has core dependencies, and offers colour as well.

There are many modules for displaying a progress bar rather than a spinner.
[Term::ProgressBar](https://metacpan.org/pod/Term::ProgressBar) is well documented.
[Term::ProgressSpinner](https://metacpan.org/pod/Term::ProgressSpinner) displays a progress bar, using one of a range
of Unicode characters to render the bar.
Search for "progress" on MetaCPAN to see many more.

# AUTHOR

Mark Allen <mrallen1@yahoo.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
