use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

eval "use Test::Manifest";
unless( $@ )
   {
   * ExtUtils::MM_Any::test_via_harness = sub
	   {
	   my($self, $perl, $tests) = @_;

	   return qq|\t$perl "-MTest::Manifest" | .
				  qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
				  qq|'\$(INST_ARCHLIB)')"\n|;
	   }
   }
   
   
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
