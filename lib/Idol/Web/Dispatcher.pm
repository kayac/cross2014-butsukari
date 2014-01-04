package Idol::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use FormValidator::Lite;

get '/' => sub {
    my $c = shift;

    my @music_list = $c->db->search('music');

    $c->render('index.tx', { music_list => \@music_list });
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

    my $music;

    my $validator = FormValidator::Lite->new( $c->req );
    $validator->set_message(
        'serial_code.not_null' => 'not null',
        'serial_code.length' => 'invalid length',
    );
    my $res = $validator->check(
        serial_code => [ 'NOT_NULL', [qw/LENGTH 8/] ],
    );

    my @err_msgs;
    if ($validator->has_error) {
        for my $msg ($validator->get_error_messages) {
            push @err_msgs, $msg;
        }

        $music = $c->session->get('music');

        $c->render('vote.tx',
            {
                music => $music,
                err_msgs => \@err_msgs
            }
        );
    }
    else {
        $music = $c->session->get('music');
        $c->render('vote.tx', { music => $music });
    }
};

get '/vote/complete' => sub {
    my $c = shift;

    $c->redirect('/');
    my $music = $c->session->remove('music');

    $c->render('vote_complete.tx', { music => $music });
};

1;
