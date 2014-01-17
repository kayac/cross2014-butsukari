use 5.016;
use strict;
use warnings;
use FindBin::libs;
use Getopt::Long;

use Idol;

Idol->bootstrap;

my $count = 0;
GetOptions( '--count=i' => \$count );
print "$count * 1000回シリアルコードを発行します...";

my $db = Idol->context->db;
for (0...$count) {
    $db->serial_register;
}

print 'done';
