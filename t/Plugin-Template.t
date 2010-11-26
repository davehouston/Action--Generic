use Test::More tests => 6;
BEGIN {
	use_ok('Action::Generic::Plugin::Template');
}


my $obj = Action::Generic::Plugin::Template->new(
	name => 'A templating Action',
	template => 'Here is var1: [% var1 %]!',
	stash => { var1 => 'VAR 1 HERE' }
);


isa_ok( $obj, 'Action::Generic::Plugin::Template' );

ok( $obj->run(), 'Run test');

my $res = $obj->_results;
is( $res->{type}, 'Action::Generic::Plugin::Template', 'results type');
is( $res->{output}, 'Here is var1: VAR 1 HERE!', 'rendered result' );
is( $res->{was_run}, 1, 'was_run check' );

