# $Id$
package HTML::SimpleLinkExtor;
use strict;

use subs qw();
use vars qw($VERSION @ISA %AUTO_METHODS $AUTOLOAD $DEBUG);

use AutoLoader;
use HTML::LinkExtor;
use URI;

$VERSION = sprintf "%d.%02d", q$Revision$ =~ m/ (\d+) \. (\d+) /xg;
$DEBUG   = 0;

@ISA = qw(HTML::LinkExtor);

%AUTO_METHODS = qw(
    background attribute
	href	attribute
	src		attribute

	a		tag
	area	tag
	base    tag
	body    tag
	img		tag
	frame	tag

	script	tag
	);

sub new
	{
	my $class = shift;
	my $base  = shift;

	my $self = new HTML::LinkExtor;
	bless $self, $class;

	$self->{'_SimpleLinkExtor_base'} = $base;

	return $self;
	}

sub links
	{
	my $self = shift;

	return map { $$_[2] } $self->_link_refs;
	}

sub AUTOLOAD
	{
	my $self = shift;
	my $method = $AUTOLOAD;

	$method =~ s/.*:://;
	print "AUTOLOAD: method is $method\n" if $DEBUG;

	return unless exists $AUTO_METHODS{$method};

	print "AUTOLOAD: calling _extract\n" if $DEBUG;
	$self->_extract( $method );
	}

sub _link_refs
	{
	my $self = shift;

	my @link_refs;
	if( ref $self->{'_SimpleLinkExtor_links'} )
		{
		@link_refs = @{$self->{'_SimpleLinkExtor_links'}};
		}
	else
		{
		@link_refs = $self->SUPER::links();
		$self->{'_SimpleLinkExtor_links'} = \@link_refs;
		}

	# defined() so that an empty string means "do not resolve"
	unless( defined $self->{'_SimpleLinkExtor_base'} )
		{
		my $count = -1;
		my $found =  0;
		foreach my $link ( @link_refs )
			{
			$count++;
			next unless $link->[0] eq 'base' and $link->[1] eq 'href';
			$found = 1;
			$self->{'_SimpleLinkExtor_base'} = $link->[-1];
			last;
			}

		#remove the BASE HREF link - Good idea, bad idea?
		#splice @link_refs, $count, 1, () if $found;
		}

	$self->_add_base(\@link_refs) if $self->{'_SimpleLinkExtor_base'};

	print "_link_refs: there are $#link_refs + 1 links\n" if $DEBUG;
	return @link_refs;
	}

sub _extract
	{
	my $self      = shift;
	my $method    = shift;

	my $position  = $AUTO_METHODS{$method} eq 'tag' ? 0 : 1;
	print "_extract: Position is $position\n" if $DEBUG;

	my @links = map  { $$_[2] }
	            grep { $_->[$position] eq $method }
	            $self->_link_refs;

	print "_extract: There are $#links + 1 links\n" if $DEBUG;
	return @links;
	}

sub _add_base
	{
	my $self      = shift;
	my $array_ref = shift;

	my $base      = $self->{'_SimpleLinkExtor_base'};

	foreach ( 0 .. $#{$array_ref} )
		{
		my $url = URI->new( ${$$array_ref[$_]}[-1] );
		next unless ref $url;
		${$$array_ref[$_]}[-1] = $url->abs($base);
		}
	}

1;
__END__
=head1 NAME

HTML::SimpleLinkExtor - Extract links from HTML

=head1 SYNOPSIS

	use HTML::SimpleLinkExtor;

	my $extor = HTML::SimpleLinkExtor->new();
	$extor->parse_file($filename);
	#--or--
	$extor->parse($html);

	#extract all of the links
	@all_links   = $extor->links;

	#extract the img links
	@img_srcs    = $extor->img;

	#extract the frame links
	@frame_srcs  = $extor->frame;

	#extract the hrefs
	@area_hrefs  = $extor->area;
	@a_hrefs     = $extor->a;
	@base_hrefs  = $extor->base;
	@hrefs       = $extor->href;

	#extract the body background link
	@body_bg     = $extor->body;
	@background  = $extor->background;

=head1 DESCRIPTION

This is a simple HTML link extractor designed for the person who
does not want to deal with the intricacies of C<HTML::Parser> or
the de-referencing needed to get links out of C<HTML::LinkExtor>.

You can extract all the links or some of the links (based on the
HTML tag name or attribute name). If a E<lt>BASE HREFE<gt> tag
is found, all of the relative URLs will be resolved according to
that reference.

This module is simply a subclass around C<HTML::LinkExtor>, so
it can only parse what that module can handle.  Invalid HTML
or XHTML may cause problems.

=over

=item $extor = HTML::SimpleLinkExtor->new()

Create the link extractor object.

=item $extor = HTML::SimpleLinkExtor->new($base)

Create the link extractor object and resolve the relative URLs
accoridng to the supplied base URL. The supplied base URL
overrides any other base URL found in the HTML.

=item $extor = HTML::SimpleLinkExtor->new('')

Create the link extractor object and do not resolve relative
links.

=item $extor->parse_file( $filename )

Parse the file for links.

=item $extor->parse( $data )

Parse the HTML in C<$data>.

=item $extor->links

Return a list of the links.

=item $extor->img

Return a list of the links from all the SRC attributes of the
IMG.

=item $extor->frame

Return a list of all the links from all the SRC attributes of
the FRAME.

=item $extor->src

Return a list of the links from all the SRC attributes of any
tag.

=item $extor->a

Return a list of the links from all the HREF attributes of the
A tags.

=item $extor->area

Return a list of the links from all the HREF attributes of the
AREA tags.

=item $extor->base

Return a list of the links from all the HREF attributes of the
BASE tags.  There should only be one.

=item $extor->href

Return a list of the links from all the HREF attributes of any
tag.

=item $extor->body, $extor->background

Return the link from the BODY tag's BACKGROUND attribute.

=item $extor->script

Return the link from the SCRIPT tag's SRC attribute

=back

=head1 TO DO

This module doesn't handle all of the HTML tags that might
have links.  If someone wants those, I'll add them, or you
can edit %AUTO_METHODS in the source.

=head1 CREDITS

Will Crain who identified a problem with IMG links that had
a USEMAP attribute.

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHORS

brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2004 brian d foy.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
