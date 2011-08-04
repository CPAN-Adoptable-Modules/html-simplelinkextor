use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.21";   
   
WriteMakefile
	(
    'NAME'         => 'HTML::SimpleLinkExtor',
	'ABSTRACT'     => 'Extract links from HTML',
    'VERSION_FROM' => 'lib/HTML/SimpleLinkExtor.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
   'PREREQ_PM'     => { 
    	'HTML::LinkExtor' => '1.28',
		'LWP::UserAgent'  => '0',
		'Test::Output'    => '0',
		'URI'             => '1.09',
		'URI::file'       => '0',
		},

	'EXE_FILES'    => [ 'scripts/linktractor' ],
	
	'dist'         => {
		'COMPRESS'        => 'gzip -9f',
		'SUFFIX'          => 'gz',
		},

  	'META_MERGE'   => {
		resources => {
			repository  => 'https://github.com/briandfoy/html-simplelinkextor'
			},
		},

    clean  => { FILES    => q|HTML-SimpleLinkExtor-*| },
	);
