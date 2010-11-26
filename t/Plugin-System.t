use Test::More tests => 6;

BEGIN {
	use_ok('Action::Generic::Plugin::System');
}


my $obj = Action::Generic::Plugin::System->new(
	name => 'A System Action',
	params => $^O eq 'MSWin32' ? [qw(dir)] : [qw(ls)]
);

isa_ok( $obj, 'Action::Generic::Plugin::System' );

ok( $obj->run(), 'Run test');

my $res = $obj->_results;

is( $res->{type}, 'Action::Generic::Plugin::System', 'results type');
is( $res->{code}, '0', 'code result' );
is( $res->{was_run}, 1, 'was_run check' );

