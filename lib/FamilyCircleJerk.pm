package FamilyCircleJerk;

use strict;
our $VERSION="6.6.6";
our $ABSTRACT="Family Circlejerk";
use Web::Scraper;
use URI;
use LWP::Curl;
use Image::Magick;
use HTTP::Message;
use feature qw(say);
use XSLoader;
use Moo;
use Try::Tiny;
use Data::Dumper;
use DateTime;
XSLoader::load('FamilyCircleJerk', $VERSION);


has ttf=>(is=>'rw');
has overlay=>(is=>'rw');

sub info {
	my ($self,$img) = @_;

	my $val = $self->get($img);
	return $val;
}

sub render {
	my ($self,%args) = @_;

	$args{image}||=$self->random_image;
	my $overlay = Image::Magick->new();
	$overlay->Read($self->overlay);
	my $img = $self->load_image($args{image});
	$img->Set(magick=>"jpg");

	my $rect = $self->get("/tmp/family_circlejerk.jpg")->{entries}->[0];
	$img->Composite(image=>$overlay,compose=>"Atop",gravity=>"Northwest",x=>0,y=>0);
	return undef if (!$rect);

	my $max_width = $rect->{size}-$rect->{left};
	my $max_height = $img->Get("height")-($rect->{top}+$rect->{size});

	my $texty = $rect->{top}+$rect->{size}+10;

	$img->Draw(
		primitive=>"rectangle",
		fill=>"#ffffff",
		stroke=>"#00000000",
		points=>join(",",$rect->{left},$texty,$rect->{left}+$rect->{size},$img->Get("height"))
	);
	$img->Draw(
		primitive=>"circle",
		fill=>"#00000000",
		stroke=>"#000000",
		points=>join(",",$rect->{x},$rect->{y},$rect->{x}+$rect->{radius},$rect->{y}),
		strokewidth=>8
	);
	#$img->Draw(primitive=>"rectangle",fill=>"#00000000",stroke=>"#000000",points=>join(",",$rect->{x},$rect->{y},($rect->{x}-$rect->{left})+($rect->{radius}/2),$rect->{y}),strokewidth=>"4");

	

	my %params = (font=>$self->{ttf},text=>qq(“$args{text}”),style=>"Normal",pointsize=>32,fill=>"#000000D8", antialias=>"true");

	my ($width,$height,$ascender,$descender);
	my $continue=1;

	FITLOOP: while ($continue && $params{pointsize}>0) {
		 #Drops bowl of potato chips.... There has got to be a better way!
		($width,$height,$ascender,$descender) = ($img->QueryFontMetrics(%params))[4,5,2,3];
    	if ($width<$max_width && $height<$max_height) {
        	$continue=0;
    	} else {
        	$params{pointsize}-=4;
    	}
	}
	$img->Annotate(
		%params,
		x=>($rect->{left}+$max_width/2)-($width/2),
		y=>$texty+($max_height/4)#$img->Get("height")-$descender-($ascender/2)
	);
	return $img;
}

sub random_image {
	my ($self) = @_;

	my $date;
	while (!defined $date) {
		my $year = (localtime())[5]+1895;
		my $dt = DateTime->new(month=>int(rand(12))||1,day=>int(rand(28))||1,year=>int(rand(5))+$year);
		if ($dt->day_of_week!=7) {
			$date = lc($dt->strftime("%B-%e-%Y"));
			$date=~s/\ //;
		} 
	}

	my $ua = LWP::Curl->new();
	my $res;
	try {
    	$res = $ua->get("http://familycircus.com/comics/$date/");
	} catch {
		say STDERR "WHOOPS";
		
	};

	return undef if (!$res);

	my $img = scraper {
    	process "div.entry-content img",src=>'@src';
	}->scrape($res);

	return $img->{src};

}

sub load_image {
	my ($self,$path) = @_;
	
	my $img = Image::Magick->new();
	if (-f $path) {
		$img->ReadImage($path);
	} else {
		my $ua = LWP::Curl->new();
		my $res;
		try {
			$res = $ua->get($path);
		} catch {
			$img->Set(size=>'616x676');
			$img->Read('xc:white');
		};
		if ($res) {
			$img->BlobToImage($res);
		}
	}
	$img->Write("/tmp/family_circlejerk.jpg");
	return $img;
}

1;




