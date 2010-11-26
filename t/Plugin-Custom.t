use Test::More tests => 6;

BEGIN {
	use_ok('Action::Generic::Plugin::Custom');
}


my $obj = Action::Generic::Plugin::Custom->new(
	name => 'A Custom Action',
	code => sub { return 'seven' }
);

isa_ok( $obj, 'Action::Generic::Plugin::Custom' );

ok( $obj->run(), 'Run test');

my $res = $obj->_results;

is( $res->{type}, 'Action::Generic::Plugin::Custom', 'results type');
is( $res->{result}, 'seven', 'code result' );
is( $res->{was_run}, 1, 'was_run check' );

