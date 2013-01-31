#!/usr/bin/perl
use lib "$ENV{CKJOB_BASE}";
use YAML::Tiny;
use CKWorker;

my $job = CKWorker->new();
$job->init(
	{
		name => 'test job'
	}
);
