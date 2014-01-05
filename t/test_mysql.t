use strict;
use warnings;
use utf8;
use Test::More;
use DBI;
use Test::mysqld;
use Idol;
use Data::Dumper;
use FindBin::libs;

BEGIN{ $ENV{PLACK_ENV} = 'test' };

my $c = Idol->bootstrap;

use_ok("Test::mysqld");

my $mysqld = Test::mysqld->new(
    my_cnf => {
        'skip-networking' =>'',
    }
) or plan skip_all => $Test::mysqld::errstr;

$ENV{TEST_DSN} = $mysqld->dsn;

my $sql = "$FindBin::Bin/../sql/mysql.sql";

system "mysql --socket $mysqld->{my_cnf}{socket} -uroot test < $sql";

done_testing;
