# $Id: parse.t 1969 2007-01-04 17:36:42Z comdog $

use File::Spec;
use Test::More 'no_plan';

use_ok( "HTML::SimpleLinkExtor" );
ok( defined &HTML::SimpleLinkExtor::relative_links, 
	"relative_links() is defined" );

my $file = 't/example2.html';
ok( -e $file, "Example file is there" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

{
my $p = HTML::SimpleLinkExtor->new;
ok( ref $p, "Made parser object" );
isa_ok( $p, 'HTML::SimpleLinkExtor' );
can_ok( $p, 'schemes' );

$p->parse_file( $file );

my @links = $p->relative_links;
my $links = $p->relative_links;

is( scalar @links, $links, "Found the right number of links" );
is( $links, 15, "Found the right number of links" );
}