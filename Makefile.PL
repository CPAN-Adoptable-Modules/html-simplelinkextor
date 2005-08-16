# $Id$
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";   
   
WriteMakefile(
    'NAME'         => 'HTML::SimpleLinkExtor',
    'VERSION_FROM' => 'SimpleLinkExtor.pm',
    'PREREQ_PM'    => { 
    	'HTML::LinkExtor' => '1.28',
		'URI'             => '1.09',
		},
		
	'MAN3PODS'     => {
		'SimpleLinkExtor.pm' => '$(INST_MAN3DIR)/HTML::SimpleLinkExtor.3',
		},
	
	'dist'         => {
		'COMPRESS'        => 'gzip -9f',
		'SUFFIX'          => 'gz',
		},

    clean  => { FILES    => q|HTML-SimpleLinkExtor-*| },

);
