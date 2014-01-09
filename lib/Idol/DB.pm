package Idol::DB;
use 5.016;
use strict;
use warnings;
use utf8;
use parent qw(Teng);

use Sub::Retry;
use String::Random;

# 適当
sub music_register {
    my $self = shift;

    $self->insert(
        'music' => {
            title => $self->_generate_serial_code,
        }
    );
}

sub serial_register {
    my $self = shift;

    $self->insert(
        'serial_code' => {
            code => $self->_generate_serial_code,
        }
    );
}

sub _generate_serial_code {
    my $self = shift;

    state $sr = String::Random->new;
    my $serial_code;
    $serial_code = retry 10, 0, sub {
        $sr->randregex('[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]{8}');
    }, sub {
        my $code = shift;
        return $self->single('serial_code', { code => $code }) ? 1 : 0;
    };

    die 'Generation of serial code failed because nothing' unless $serial_code;

    return $serial_code;
}

sub validate_serial_code {
    my ($self, $code) = @_;

    my $is_valid;
    my $serial_code = $self->single('serial_code', { code => $code });

    if (defined $serial_code) {
        $is_valid = 1;
    }
    else {
        $is_valid = 0;
    }

    +{
        is_valid => $is_valid,
        serial_code => $serial_code
    };
}

1;
