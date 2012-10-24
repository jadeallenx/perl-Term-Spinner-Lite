use strict;
use warnings;
package Term::Spinner::Lite;

use 5.010;
use IO::Handle;
use Carp qw( croak );

sub new {
    my ($class, %args) = @_;

    my $self = bless \%args, $class;
}

sub output_handle {
    my $self = shift;
    my $handle = shift;

    if ( not $handle ) {
        if ( exists $self->{'output_handle'} ) {
            return $self->{'output_handle'};
        }
        $handle = \*STDERR;
    }

    $handle->autoflush(1);

    $self->{'output_handle'} = $handle;
}

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
    $self->{'spin_char_size'} = $#{$aref};
}

sub _clear {
    my $self = shift;

    print $self->output_handle(), "\010 \010";
}

sub count {
    my $self = shift;

    return 0 if not exists $self->{'count'};

    return $self->{'count'};
}

sub next {
    my $self = shift;

    state $pos;

    $self->_clear if $self->count;
    print $self->output_handle(), "${$self->spin_chars()}[$pos]";
    $pos = ($self->{'count'}++) % $self->{'spin_char_size'};
}

1;
