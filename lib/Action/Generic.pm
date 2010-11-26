package Action::Generic;
use Moose;
use Module::Pluggable require => 1;
use Carp;
use Log::Dispatch;
use Log::Dispatch::Screen;
use B::Deparse;
use 5.008001;

our $VERSION = '0.000004'; # 0.0.4

has '_action_list' => ( 
	is	=> 'rw',
	isa => 'ArrayRef',
	default => sub { [] } 
);

has 'quiet' => ( 
	is => 'rw',
	isa => 'Bool',
	default => 0
);

has 'log' => ( 
	is => 'rw',
	isa => 'Log::Dispatch',
	required => 1,
	default => sub { Log::Dispatch->new() }
);

has 'log_dispatch' => (
	is => 'rw',
	trigger => sub { 
		my( $self, $d ) = @_;
		$self->log->add( $d );
	}
);

sub BUILD { 
	my( $self ) = @_;
	my $d;
	if( $self->quiet ) { 
		$d = Log::Dispatch::Screen->new(
			name => 'Screen',
			min_level => 'warning',
			newline => 1
		);
	} else { 
		$d = Log::Dispatch::Screen->new(
			name => 'Screen',
			min_level => 'debug',
			newline => 1
		);
	}
	$self->log_dispatch( $d );
}


sub action { 
	my $self = shift;
	my %args = @_;
	$self->log->debug( "New action" );
	for( keys %args ) { 
		if( ref($args{$_} ) eq 'CODE' ) { 
			$self->log->debug( "'$_' => '" . 
				B::Deparse->new->coderef2text( $args{$_} )
			. "'");
		} else { 
			$self->log->debug( "'$_' => '" . $args{$_} .  "'" );
		}
	}

	for my $a ( $self->plugins ) {
		if( $a =~ /.*$args{type}/ ) {
			$self->log->debug( "Creating new action, '$a'" ); 
			my $action = $a->new( %args );
			return $action;
		}
	}
	# So it wasn't a plugin..
	my $a = $args{type};
	$self->log->debug( "Attempting to require(): '$a'");
	eval "require $a";
		
	unless( $@ ) { 
		my $action = $a->new( %args );
		$self->log->debug( "Creating new action, '$a'" );
		return $action;
	} else { 
		$self->log->error( "Failed to require() '$a': ", $@ );
	}
	return undef;

}

sub add_actions { 
	my( $self, @actions ) = @_;
	my $orig = $self->_action_list;
	for( @actions ) { 
		$self->log->debug( "Adding action: ",  $_->name );
		$self->log->debug( "\t( " . ref($_) . " )");
		push @$orig, $_;
	}
	$self->_action_list( $orig );
}

sub run { 
	my( $self ) = @_;
	for( @{$self->_action_list()} ) { 
		$self->log->debug( "Running action '" . $_->name . "'");
		$_->run() or croak;
	}
}

sub results { 
	my( $self ) = @_;
	return [ map { $_->_results } @{$self->_action_list} ];
}

1;
