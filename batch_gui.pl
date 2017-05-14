#!/usr/bin/perl
#
# Description
#

use feature ':5.14';
use strict;
use warnings;

use Gtk3 '-init';
use Glib 'TRUE', 'FALSE';

my $window = Gtk3::Window->new;
$window->set_title('Filter Results');
our @files = glob("out/*.*");

our $index = 0;
if ($ARGV[0]) {
	for (my $i=0;$i<scalar(@files);$i++) {
		if ($files[$i]=~/$ARGV[0]\.jpg/) {
			$index=$i;
			last;
		}
	}
}

$window->signal_connect( destroy => sub { Gtk3->main_quit } );

my $table = Gtk3::Grid->new;
$window->add($table);

my $sw = Gtk3::ScrolledWindow->new( undef, undef );
$sw->set_policy( 'automatic', 'automatic' );
$sw->set_shadow_type('in');
$sw->set_halign('fill');
$sw->set_valign('fill');
$sw->set_hexpand(TRUE);
$sw->set_vexpand(TRUE);
$table->attach($sw,0,0,1,1);

my $progress = Gtk3::ProgressBar->new;
$progress->set_orientation("horizontal");
$progress->set_inverted(FALSE);
$progress->set_text(undef);
$progress->set_show_text(FALSE);
$table->attach($progress,0,1,1,1);

$window->signal_connect( show => sub {
	go(0);
});

my $show_comic = 1;


my $img = Gtk3::Image->new_from_file("/usr/share/goatkcd/hello.jpg");
$sw->add($img);

$window->signal_connect( key_press_event => sub {
	my ($widger,$event) = @_;

	my $code = $event->key->{hardware_keycode};
	say $code;
	if ($code==113) {
		go(-1);

	}
	if ($code==114) {
		go(1);
    }
	if ($code==57) {
		my $r = splice(@files,$index,1);
		say $r;
		unlink($r);
		go(0);
	}
	if ($code==65) {
		my $r = splice(@files,$index,1);
        say $r;
		system("mv $r ./winners");
		go(0);
	}
});


sub go {
	my $i = shift;

	$index = $index+$i;
	if ($index<0) { $index = $#files; }
	if ($index>$#files) { $index = 0; }
	
	$img->set_from_file($files[$index]);
    $window->set_title($files[$index]);
}


$window->maximize();
$window->show_all;

Gtk3->main(sub { say STDERR "POOPIES"; });

# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public License
# as published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
