use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'         => 'HTML::SimpleLinkExtor',
    'VERSION_FROM' => 'SimpleLinkExtor.pm', # finds $VERSION
    'PREREQ_PM'    => { 'HTML::LinkExtor' => 1.28,
                        'URI'             => 1.09,
                      },
	'dist'          => {
	                   'COMPRESS'        => 'gzip -9f',
	                   'SUFFIX'          => 'gz',
	                   },


);
