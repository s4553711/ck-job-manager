#!/usr/bin/perl
package CKWorker;
use base qw( CKJob::Worker );
use CKJob::Worker;
use YAML::Tiny;

sub new {
	my $arg = shift;
	my $self = CKJob::Worker->new({ db_set => "$ENV{CKJOB_BASE}/db.yaml" });

	bless($self);
	return $self;
}

sub work {
	my ($class) = shift;
	my ($setting) = shift;
	
	sleep(10);
}

1;
