BEGIN {
our %tags = qw(	
	base          1
	body          1
	a             7
	img           5
	area          6
	frame         3
	script        1
	iframe        1
	);

our %attr = qw(
	href	     14
	background    1
	src          10
	);
	
our $total_links = 0;
foreach my $attr ( keys %attr ) { $total_links += $attr{$attr} };
}
###############################################################
###############################################################

use File::Spec;
use Test::More tests => keys( %attr ) + keys( %tags ) + 7 + 6;

my $class = "HTML::SimpleLinkExtor";

use_ok( $class );

{
my $file = 't/example.html';
ok( -e $file, "Example file is there" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
my $extor = $class->new;
isa_ok( $extor, $class );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
$extor->parse_file( $file );

my @links = $extor->links;
is( scalar @links, $total_links, "Found the right number of links" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
my @img = $extor->img;
like( $img[-1], qr/^http/, "Gecko link is relative" );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
foreach my $hash ( \%attr, \%tags )
	{
	foreach my $method ( keys %$hash )
		{
		my @list = $extor->$method();
		
		is( scalar @list, $hash->{$method}, 
			"Found the right number of links for <$method>" );
		}
	}

my $frame      = scalar @{ [$extor->frame ] };
my $iframe     = scalar @{ [$extor->iframe] };
my $all_frames = scalar @{ [$extor->frames] };
is( $all_frames, $frame + $iframe, "Combined frames count is right" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

$extor->clear_links;
@links = $extor->links;

is( scalar @links, 0, "Found the no links after clear_links" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Try a good URL
{
my $url = 'file://' . File::Spec->rel2abs( 't/example.html' );

my $extor = HTML::SimpleLinkExtor->new;
isa_ok( $extor, $class );

my $rc = $extor->parse_url( $url );
ok( $rc, 'parse_url returns true value' );

my @links = $extor->links;
is( scalar @links, $total_links, "Found the right number of links" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Try a bad URL
{
my $url = 'file://' . File::Spec->rel2abs( 't/not_there.html' );

my $extor = HTML::SimpleLinkExtor->new;
isa_ok( $extor, $class );

my $rc = $extor->parse_url( $url );
ok( ! $rc, 'parse_url returns false value' );

my @links = $extor->links;
is( scalar @links, 0, "Found no links in bad URL" );
}
