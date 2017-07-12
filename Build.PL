use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
	module_name    => 'FamilyCircleJerk',
   	license        => 'perl',
   	dist_author    => ['Fatty Crabcakes <johngaltatemyballs@gmail.com>'],
   	needs_compiler => 1,
   	configure_requires => {
   		'Config::AutoConf'   => '0.14',
   		'ExtUtils::CBuilder' => '0.27',
   		'ExtUtils::LibBuilder' => '0.01',
   		'Module::Build'      => '0.3603',
   	},
	requires => {
    	'LWP::Curl'=>0,
    	'Try::Tiny'=>0,
    	'Image::Magick'=>0,
    	'Web::Scraper'=>0,
    	'URI'=>0,
    	'HTTP::Message'=>0,
    	'FindBin'=>0,
    	'File::Copy'=>0,
    	'JSON::XS'=>0,
    	'File::Type'=>0,
	},
	'libdir'   => "./lib",
    extra_compiler_flags => '', # We're going to assume everyone is at least that modern
	extra_linker_flags=>[qw(-lopencv_imgproc -lopencv_core -lopencv_highgui)],
	config => { cc => 'gcc', ld => 'gcc' },
    include_dirs => [qw(src/)],
    c_source     => [qw(src/)],
);

$builder->create_build_script();

