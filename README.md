#simple-job-manager
A simple job management built on perl

## Install
1. Set database info in **db.yaml**
2. Set the folder of this project
```
export CKJOB_BASE="/home/lick/perl/simple-job-manager"
```
3. Finish

## Setup daemon
1. run the script to start monitoring job status
	```
	daemon.pl start
	```
	or you can stop this daemon by..
	```
	daemon.pl stop
	```

## Usage
1. Add Worker:
	```perl
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
	```

2. Submit job
	```perl
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
	```
