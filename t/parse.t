# $Id$

use Test::More tests => 15;

use_ok( "HTML::SimpleLinkExtor" );

my $file = 't/example.html';
ok( -e $file, "Example file is there" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
$test++;
my $p = new HTML::SimpleLinkExtor();
ok( ref $p, "Made parser object" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
$test++;
$p->parse_file( $file );
my @links = $p->links;

is( scalar @links, 23, "Found the right number of links" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
my @test = qw(
	href	     14
	background    1
	src           8
	
	base          1
	body          1
	a             7
	img           4
	area          6
	frame         3
	script        1
	);
	
while ( my $method = shift @test )
	{
	$test++;
	
	my $expected = shift @test;

	my @list = $p->$method();
	
	is( scalar @list, $expected, 
		"Found the right number of links for <$method>" );
	}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
use Data::Dumper;
#print STDERR Dumper( $p );

$p->clear_links;
#print STDERR Dumper( $p );
@links = $p->links;

is( scalar @links, 0, "Found the no links after clear_links" );


