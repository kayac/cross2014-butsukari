package Idol::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use FormValidator::Lite;

get '/' => sub {
    my $c = shift;

    my $page = $c->req->param('page') || 1;
    # rank順に取った方が良いかもだけどひとまずidでsort
    my ($music_list, $pager) = $c->db->search_with_pager(
        'music' => {},
        {
            order_by => 'id DESC',
            page => $page,
            rows => 20 # const定義したい
        }
    );

    $c->render('index.tx',
        {
            music_list => $music_list,
            pager => $pager
        }
    );
};

get '/vote/{music_id}' => sub {
    my ($c, $args) = @_;

    my $music_id = $args->{music_id};
    my $music = $c->db->single('music', { id => $music_id });

    $c->session->set('music' => $music->get_columns);
    $c->render('vote.tx', { music => $music });
};

post '/vote/{music_id}' => sub {
    my ($c, $args) = @_;

    my $music = $c->session->get('music');

    my $validator = FormValidator::Lite->new( $c->req );
    $validator->set_message(
        'serial_code.not_null' => 'シリアルコードを入力してください。',
        'serial_code.length' => 'シリアルコードは英数8文字で入力してください。',
    );
    my $res = $validator->check(
        serial_code => [ 'NOT_NULL', [qw/LENGTH 8/] ],
    );

    my @err_msgs;
    my $serial_code = $c->req->param('serial_code');

    if ($validator->has_error) {
        for my $msg ($validator->get_error_messages) {
            push @err_msgs, $msg;
        }
    }
    else {
        my $validate_result = $c->db->validate_serial_code($serial_code);

        if ($validate_result->{is_valid}) {
            $validate_result->{serial_code}->vote_music($music);
            return $c->redirect('/vote_complete');
        }
        else {
            push @err_msgs, '既に使用されてるか存在しないシリアルコードです。';
        }
    }

    return $c->render('vote.tx',
        {
            music => $music,
            err_msgs => \@err_msgs
        }
    );
};

get '/vote_complete' => sub {
    my $c = shift;

    my $music = $c->session->remove('music');

    $c->render('vote_complete.tx', { music => $music });
};

1;
