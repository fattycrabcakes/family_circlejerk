#!/usr/bin/env perl

use lib("./lib");
use Imgur::API;
use Data::Dumper;
use feature qw(say);

my $key = "3b3337683eefbb3";
my $secret = "5d609c05886502fe20ee106de74664fd7e85df23";

# Authorization: Client-ID YOUR_CLIENT_ID

my $imgur = Imgur::API->new(api_key=>"3b3337683eefbb3");

say Dumper($imgur->album->delete(album=>$ARGV[0]));
