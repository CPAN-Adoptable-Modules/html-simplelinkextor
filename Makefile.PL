# $Id$
use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.14";   
   
WriteMakefile
	(
    'NAME'         => 'HTML::SimpleLinkExtor',
	'ABSTRACT'     => 'Extract links from HTML',
    'VERSION_FROM' => 'lib/SimpleLinkExtor.pm',
	'LICENSE'      => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
 	'PM'           => {
		'lib/SimpleLinkExtor.pm'=> '$(INST_LIBDIR)/SimpleLinkExtor.pm',
		},

   'PREREQ_PM'     => { 
    	'HTML::LinkExtor' => '1.28',
		'LWP::UserAgent'  => '0',
		'Test::Output'    => '0',
		'URI'             => '1.09',
		},
		
	'MAN3PODS'     => {
		'lib/SimpleLinkExtor.pm' => '$(INST_MAN3DIR)/HTML::SimpleLinkExtor.3',
		},

	'MAN1PODS'     => {
		'scripts/linktractor' => '$(INST_MAN1DIR)/linktractor.1',
		},

	'EXE_FILES'    => [ 'scripts/linktractor' ],
	
	'dist'         => {
		'COMPRESS'        => 'gzip -9f',
		'SUFFIX'          => 'gz',
		},

    clean  => { FILES    => q|HTML-SimpleLinkExtor-*| },
	);
