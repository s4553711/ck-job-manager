#!/usr/bin/perl
use lib '/home/lick/perl/simple-job-manager';
use YAML::Tiny;
use CKWorker;

my $job = CKWorker->new();
$job->init(
	{
		name => 'test job'
	}
);
