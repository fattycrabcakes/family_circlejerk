#!/usr/bin/env perl

use lib qw(./lib);
use FamilyCircleJerk;
use Data::Dumper;
use Modern::Perl;
use Image::Magick;
use JerkCity::Schema;
use Getopt::Long;

my $db = JerkCity::Schema->connect("dbi:SQLite:dbname=db/jerkcity.db");
my $quotes = $db->resultset("Dialogue")->count;

my %opt;
GetOptions(\%opt,"iterations=i","output=s");

my $fcj = FamilyCircleJerk->new(ttf=>"assets/FreeSansBold.ttf",overlay=>"assets/overlay.png");
 for (my $i=0;$i<$opt{iterations};$i++) {
	my $text = $db->resultset("Dialogue")->search({},{rows=>1,offset=>int(rand($quotes))})->first;
	my $img = $fcj->render(text=>$text->speech);
	if ($img) {
		$img->Write(sprintf("$opt{output}/image-%d.jpg",$i));
	} else {
		#well, something has gone wrong.
		redo;
	}
}


