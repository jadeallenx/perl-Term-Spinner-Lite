use strict;
use warnings;
package Term::Spinner::Lite;

# ABSTRACT: A spinner without so much Moose in it

use 5.010;
use IO::Handle;
use Time::HiRes qw(usleep);
use Carp qw( croak );

=encoding UTF-8

=head1 SYNOPSIS

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
on the API from L<Term::Spinner>.  Unlike L<Term::Spinner> though, this module
doesn't have any dependencies outside of modules shipped with Perl itself.

=cut

=method new()

The object constructor.  You may optionally set object attributes C<spin_chars> or
C<output_handle> in the parameter list.

=cut

sub new {
    my ($class, %args) = @_;

    my $self = bless \%args, $class;

    $self->_setup_signal_handler;

    return $self;
}

# We need to restore the cursor if the user hits Contol-C or a TERM signal
sub _setup_signal_handler {
    my $self = shift;

    $SIG{INT} = sub { $self->done; exit 0; };
    $SIG{TERM} = sub { $self->done; exit 0; };
}

=attr output_handle

Gets or sets the handle where output will be written. By default, uses STDERR.
You may pass an optional PerlIO encoding specification. By default it will use
":utf8" in case you want to use UTF8 characters in your spinner.

=cut

sub output_handle {
    my $self = shift;
    my $handle = shift;
    my $encoding = shift || ":utf8";

    if ( not $handle ) {
        if ( exists $self->{'output_handle'} ) {
            return $self->{'output_handle'};
        }
        $handle = \*STDERR;
    }

    binmode($handle, $encoding);
    $handle->autoflush(1);

    $self->{'output_handle'} = $handle;
}

=attr spin_chars

Gets or sets the list of characters to cycle through. By default it uses the 
sequence "-" "\" "|" "/".  This attribute must be set using an array ref, e.g.,
  
  [ qw( . o O o ) ]

This attribute will croak by an attempt to set itself using anything else.

=cut

sub spin_chars {
    my $self = shift;
    my $aref = shift;

    if ( not $aref ) {
        if ( exists $self->{'spin_chars'} ) {
            return $self->{'spin_chars'};
        }
        $aref = [ qw(- \ | /) ];
    }
        
    if ( ref($aref) ne 'ARRAY' ) {
        croak "spin_chars must be an array ref";
    }

    $self->{'spin_chars'} = $aref;
}

=attr delay

Gets or sets the delay between state changes in microseconds. (A good value 
for smooth spinning is 100000.) Defaults to 0.

=cut

sub delay {
    my $self = shift;
    my $microseconds = shift;

    if ( not $microseconds ) {
        if ( exists $self->{'delay'} ) {
            return $self->{'delay'};
        }
        $microseconds = 0;
    }

    $self->{'delay'} = $microseconds;
}

sub _clear {
    my $self = shift;

    print {$self->output_handle()} "\010 \010";
}

# https://github.com/verigak/progress/blob/master/progress/helpers.py#L19
sub _show_cursor {
    my $self = shift;

    print {$self->output_handle()} "\x1b[?25h";
}

# https://github.com/verigak/progress/blob/master/progress/helpers.py#L18
sub _hide_cursor {
    my $self = shift;

    print {$self->output_handle()} "\x1b[?25l";
}

sub _spin_char_size {
    my $self = shift;

    if ( exists $self->{'spin_char_size'} ) {
        return $self->{'spin_char_size'};
    }

    $self->{'spin_char_size'} = scalar @{ $self->spin_chars() };
}

=method count()

Return the number of advances through the spin sequence.

=cut

sub count {
    my $self = shift;

    return 0 if not exists $self->{'count'};

    return $self->{'count'};
}

=method next()

Advance the spinner state to the next character in the spin sequence and output 
it to C<output_handle>. 

=cut

sub next {
    my $self = shift;

    state $pos = 0;

    $self->_clear if $self->count;
    $self->_hide_cursor if not $pos;
    print {$self->output_handle()} "${$self->spin_chars()}[$pos]";
    $pos = ($self->{'count'}++) % $self->_spin_char_size();
    usleep($self->delay) if $self->delay;
}

=method done()

Finish spinning, and clear the last character printed. If a true value is passed,
output a newline.

=cut

sub done {
    my $self = shift;

    $self->_clear;
    $self->_show_cursor;
    print "\n" if $_[0];
}

1;
