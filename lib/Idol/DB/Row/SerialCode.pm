package Idol::DB::Row::SerialCode;
use 5.016;
use strict;
use warnings;
use utf8;
use parent 'Idol::DB::Row';

use Amon2::Declare;
use Time::Piece::Plus;

sub vote_music {
    my ($self, $music) = @_;

    my $db = c->db;

    # music無かったら500返して良い気がした
    my $txn = $db->txn_scope; {
        $db->insert(
            'music_rank' => {
                serial_code => $self->code,
                music_id => $music->{id},
                created_at => localtime->strftime('%Y/%m/%d 00:00:00')
            }
        );
        $self->delete;
    } $txn->commit;
}

1;
