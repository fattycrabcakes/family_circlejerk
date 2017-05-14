#!/usr/bin/env perl

use lib("./lib");
use Imgur::API;
use Data::Dumper;
use Image::Magick;
use feature qw(say);

my $key = "3b3337683eefbb3";
my $secret = "5d609c05886502fe20ee106de74664fd7e85df23";
my $refresh = "519c5aac0b543b47acaa0b9db508e34f3efabfc3";
my $access = "cf9dd9578a80b5b91c4030c638eab3887831a75a";

# Authorization: Client-ID YOUR_CLIENT_ID

my $imgur = Imgur::API->new(client_id=>"3b3337683eefbb3",client_secret=>$secret,access_token=>$access);

my $yams = $imgur->account->images(username=>'me');
say Dumper($yams);

