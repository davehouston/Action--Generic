package Action::Generic::Plugin::Template;
use Moose;
use Template;

has 'config' => ( 
	is	=> 'rw',
	isa => 'HashRef',
	required => 1,
	default => sub { 
		{
			INCLUDE_PATH => '.',
			INTERPOLATE => 1,
			POST_CHOMP => 1,
			EVAL_PERL => 1
		}
	}
);

has 'tt' => ( 
	is => 'rw',
	isa => 'Template'
);	

has 'template' => ( 
	is => 'rw',
	required => 1,
	default => 'template.tt'
);

has 'stash' => (
	is	=> 'rw',
	isa => 'HashRef',
	required => 1,
	default => sub { {} }
);

has 'name' => (
	is => 'rw',
   isa => 'Str',
   required => 1 
);

has '_results' => ( 
	is => 'rw',
	isa => 'HashRef',
);

sub run { 
	my( $self ) = @_;
	my $output;
	my $t = Template->new( $self->config );
	my %vars = ( var1 => 'VAR 1 HERE' );
	$t->process( \$self->template, $self->stash, \$output );
	$self->_results({
		output => $output,
		was_run => 1,
		type => ref $self,
		error => $t->error
	});
	return $output;
}

=head1 NAME

Action::Generic::Plugin::Template - Render a Template::Toolkit 

=head1 SYNOPSIS

 my $temp = $controller->action(
  type => 'Template',
  name => 'A TT-generated something!',
  template => 'a_template.tt',
  stash => $stash,
  config => { INCLUDE_PATAH => '/foo/bar' } 
 );

=head1 DESCRIPTION

This action will use Template::Toolkit to render a template. 
The results of the render are returned by C<run()> as well as placed
in the "results" data structure under the key C<rendered>.  

=head2 Default Configuration

Some basic configuration is already done in the action for Template.  
They may be overriddenby with the 'config' parameter.  Bear in mind,
supplying your own config overwrites B<all> defaults.  Don't leave
anything out!

=over 3

=item template

Default is C<template.tt>.  This is the first parameter passed
to Template's C<process()> (see their documentation for what this
may be).

=item stash

Default is an empty hashref -- C><{}>.  This is the second parameter
passed to Template's C<process()>.

=item config

=over 3

=item INCLUDE_PATH 

Default is '.'

=item INTERPOLATE

Default is 1

=item POST_CHOMP

Default is 1

=item EVAL_PERL

Default is 1

=back

=back

=head2 Results

The rendered template is stored in the C<output> key of the results.

This should almost always be a scalar.  Unless you're doing something
funky.

=head1 SEE ALSO

L<Action::Generic>, L<Template>

=head1 LICENSE 

Copyright (c) 2010 Dave Houston.  All rights reserved.  

This program is free software; you can redistribute it and/or
 modify it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
