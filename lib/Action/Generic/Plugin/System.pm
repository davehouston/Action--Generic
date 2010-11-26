package Action::Generic::Plugin::System;
use Moose;

has 'name' => (
	is => 'ro',
	required => 1,
	isa => 'Str'
);

has 'params' => ( 
	is	=> 'ro',
	isa => 'ArrayRef',
	required => 1
);

has '_results' => ( 
	is => 'rw',
	isa => 'HashRef'
);

sub run { 
	my( $self ) = @_;
	my $res = {};
	$res->{type} = ref $self;
	$res->{was_run} = 1;
	$res->{code} = system( @{$self->params} );
	$self->_results( $res );
}

=head1 NAME

Action::Generic::Plugin::System - Run a system command

=head1 SYNOPSIS

Create an action:

 my $action = $controller->action(
  type => 'System',
  name => 'A system action',
  params => [qw(ls -al ~)]
 );

Add it to a controller..

 $controller->add_actions( $action );

..and run it.

 $controller->run();  # doggieporn.avi, backdoorsluts9.mpeg

=head1 DESCRIPTION

The C<System> action allows executing of arbitrary system commands.
This is accomplished by passing an ARRAYREF to the C<params>
attribute, which is fed directly into Perl's C<system()> function.

The results of the C<system()> call are saved in the results hash
(as C<code>).  

=head2 Attributes

=over 3

=item C<params>

A hashref of parameters.  Is passed directly to C<system()>.  

The return value of the system call is captured.  

=back

=head1 LICENSE AND COPYING

This library is free software; you may redistribute and/or modify it
under the same terms as Perl itself.

=head1 BUGS

Probably.  Patches welcome!

=head1 AUTHOR

Dave Houston C<< <dhouston@cpan.org> >>, 2010

=cut
__PACKAGE__->meta->make_immutable;
