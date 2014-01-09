use 5.016;
use strict;
use warnings;
use FindBin::libs;
use Getopt::Long;

use Idol;

Idol->bootstrap;

my $count = 0;
GetOptions( '--count=i' => \$count );
print "$count回楽曲データを発行します...";

my $db = Idol->context->db;
for (0...$count) {
    $db->music_register;
}

print 'done';
