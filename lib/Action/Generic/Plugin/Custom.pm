package Action::Generic::Plugin::Custom;
use Moose;

has 'name' => (
	is => 'ro',
	required => 1,
	isa => 'Str'
);

has 'code' => (
	is => 'ro',
	required => 1,
	isa => 'CodeRef'
);

has '_results' => ( 
	is => 'rw',
	isa => 'HashRef'
);

sub run { 
	my( $self ) = @_;
	my $res = {};
	$res->{type} = ref $self;
	$res->{result} =  $self->code->();
	$res->{was_run} = 1;
	$self->_results( $res );
	
}
=head1 NAME

Action::Generic::Plugin::Custom - Run a custom bit of code

=head1 SYNOPSIS

Create an action:

 my $action = $controller->action( 
  type => 'Custom',
  name => 'A Custom Action',
  code => sub { print "Hello world!\n" }
 );

.. add it to the controller .. 

 $controller->add_actions( $action );

And later, it gets run..

 $controller->run();  # "Hello, world!\n" 

=head1 DESCRIPTION

The C<Custom> action allows for running of arbitrary code.  When
creating the action, a C<code> attribute must be supplied, and 
must be a CodeRef (in Moose terms).  

Should you wish to pass arguments to the CODEREF, you should
probably do it when creating the object.  Perhaps something like:

 my $foo = 'ba-nay-nay';

 my $action = $controller->action(
	name => 'An action, with parameters',
	type => 'Custom',
	code => sub { 
     print $foo, "\n";		
   }
 );

It's like scoping works, or something!

=head2 Attributes

=over 3

=item C<code>

A CODEREF containing the code to run.  In the results hashref, for this 
action, the return value of the coderef is captured and saved.  

It is possible that the code executed could do something like C<die> 
or something equally odd.  I'd not suggest it.

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
