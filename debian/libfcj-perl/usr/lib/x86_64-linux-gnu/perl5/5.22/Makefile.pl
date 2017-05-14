use 5.008005;
use ExtUtils::MakeMaker 7.12; # for XSMULTI option


WriteMakefile(
  NAME           => 'FCJ',
  VERSION_FROM   => 'lib/FCJ.pm',
  PREREQ_PM      => {
	'ExtUtils::MakeMaker' => '7.12',
	'LWP::UserAgent'=>0,
    'Try::Tiny'=>0,
    'Image::Magick'=>0,
    'Web::Scraper'=>0,
	'URI'=>0,
    'Data::Dumper'=>0,
    'HTTP::Message'=>0,
	'FindBin'=>0,
	'File::Copy'=>0,
	'Test::More'=>0,
	'Term::ReadLine'=>0,
	'JSON::XS'=>0,
	'File::Type'=>0,
  },
  ABSTRACT_FROM  => 'lib/FCJ.pm',
  AUTHOR         => 'Fatty Crabcakes',
  CCFLAGS        => '',
  LIBS			=> ' -lopencv_imgproc -lopencv_core -lopencv_highgui',
  OPTIMIZE       => '-O3',
  LICENSE        => 'WTFPL',
  XSMULTI        => 1,
  TYPEMAPS		=>["lib/typemap"],
  #"EXE_FILES"	=>["bin/goatify"],
  dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
