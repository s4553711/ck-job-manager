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
	
	open STDERR, '>&', $setting->{log_err_handle};
	select $setting->{log_handle}; $| = 1;

	sleep(10);
	print "This is STDOUT in woker\n";
}

1;
