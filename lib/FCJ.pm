package FCJ;

use strict;
our $VERSION="6.6.6";
our $ABSTRACT="Family Circle-Jerk";
use Web::Scraper;
use URI;
use LWP::UserAgent;
use Image::Magick;
use HTTP::Message;
use feature qw(say);

sub new {
	my ($class,%opt) = @_;

	return bless {
		ttf=>$opt{ttf},
		img=>$opt{img},
	},$class;
}

sub info {
	my ($self,$img) = @_;

	my $val = FCJ::Info::get($img);
	return $val;
}

sub render {
	my ($self,%opt) = @_;

	$opt{image}||=$self->random_image;
	my $img = $self->load_image($opt{image});

	my $rect = FCJ::Info::get("/tmp/fcj.png");
	return undef if (!scalar(@$rect));
	my $max_width = $rect->[2]-$rect->[0];
	my $max_height = $rect->[3] - $rect->[1];

	$img->Draw(primitive=>"rectangle",stroke=>"#00000000",fill=>"#ffffff",strokewidth=>1,points=>join(",",@$rect));

	my %params = (font=>$self->{ttf},text=>qq(“$opt{text}”),style=>"Normal",pointsize=>128,fill=>"#000000D8", antialias=>"true");

	my ($width,$height,$ascender);
	my $continue=1;

	FITLOOP: while ($continue && $params{pointsize}>0) {
		# Drops bowl of potato chips.... There has got to be a better way!
		($width,$height,$ascender) = ($img->QueryFontMetrics(%params))[4,5,2];
    	if ($width<$max_width && $height<$max_height) {
        	$continue=0;
    	} else {
        	$params{pointsize}-=4;
    	}
	}
	$img->Annotate(%params,x=>($rect->[0]+$max_width/2)-($width/2),y=>$rect->[1]+$ascender/2+($max_height/2));
	return $img;
}

sub random_image {
	my ($self,$opt) = @_;

	my $date = sprintf("%s-%d-%d",
		qw(january february march april may june july august september october november december)[int(rand(12))],
		int(rand(27))+1,
		int(rand(5))+2012
	);
	my $ua = LWP::UserAgent->new();
    $ua->agent('Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/4.0.202.0 Safari/532.0');
    my $res = $ua->get("http://familycircus.com/comics/$date",'Accept-Encoding'=>HTTP::Message::decodable);

	my $res = scraper {
    	process "div.entry-content img",src=>'@src';
	}->scrape($res->decoded_content);

	return $res->{src};

}

sub load_image {
	my ($self,$path) = @_;
	
	my $img = Image::Magick->new();
	if (-f $path) {
		$img->ReadImage($path);
	} else {
		my $ua = LWP::UserAgent->new();
		$ua->agent('Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Chrome/4.0.202.0 Safari/532.0');
		my $res = $ua->get($path,'Accept-Encoding'=>HTTP::Message::decodable);
		$img->BlobToImage($res->decoded_content);
	}
	$img->Write("/tmp/fcj.png");
	return $img;
}

1;




