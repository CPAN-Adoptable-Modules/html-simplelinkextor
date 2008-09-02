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

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
use File::Spec;
use Test::More tests => keys( %attr ) + keys( %tags ) + 15;
use URI::file;

my $class = "HTML::SimpleLinkExtor";

use_ok( $class );

{
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
my $extor = $class->new;
isa_ok( $extor, $class );


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
{
my $file = File::Spec->catfile( qw(t example.html) );
ok( -e $file, "Example file is there" );

$extor->parse_file( $file );

my @links = $extor->links;
is( scalar @links, $total_links, "Found the right number of links" );
}

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

{
my $frame      = scalar @{ [$extor->frame ] };
my $iframe     = scalar @{ [$extor->iframe] };
my $all_frames = scalar @{ [$extor->frames] };
is( $all_frames, $frame + $iframe, "Combined frames count is right" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

$extor->clear_links;

{
my @links = $extor->links;
is( scalar @links, 0, "Found the no links after clear_links" );
}

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Try a good URL
{
my $file = File::Spec->rel2abs( 
	File::Spec->catfile( qw( t example.html ) )
	);
ok( -e $file, "File [$file] is there" );

my $url = URI::file->new( $file ); 

my $extor = HTML::SimpleLinkExtor->new;
isa_ok( $extor, $class );

my $rc = $extor->parse_url( $url );
ok( $rc, "parse_url returns true value for [$url]" );

my @links = $extor->links;
is( scalar @links, $total_links, "Found the right number of links" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Try a bad URL
{
my $file = File::Spec->rel2abs( 
	File::Spec->catfile( qw( t not_there.html ) )
	);

ok( ! -e $file, "File [$file] is not there" );

my $url = URI::file->new( $file ); 

my $extor = HTML::SimpleLinkExtor->new;
isa_ok( $extor, $class );

my $rc = $extor->parse_url( $url );
ok( ! $rc, "parse_url returns false value for [$url]" );

my @links = $extor->links;
is( scalar @links, 0, "Found no links in bad URL" );
}
