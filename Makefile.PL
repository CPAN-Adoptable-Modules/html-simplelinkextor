# $Id$
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";   
   
WriteMakefile(
    'NAME'         => 'HTML::SimpleLinkExtor',
    'VERSION_FROM' => 'SimpleLinkExtor.pm',
	'LICENSE'       => 'perl',
	'AUTHOR'       => 'brian d foy <bdfoy@cpan.org>',
	
    'PREREQ_PM'    => { 
    	'HTML::LinkExtor' => '1.28',
		'URI'             => '1.09',
		'LWP::Simple'     => '0',
		},
		
	'MAN3PODS'     => {
		'SimpleLinkExtor.pm' => '$(INST_MAN3DIR)/HTML::SimpleLinkExtor.3',
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
