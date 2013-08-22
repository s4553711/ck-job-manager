#simple-job-manager
A simple job management built on perl

## Prepare
Make sure you have installed module listed below:
1. local::lib
2. DBIx::Class
3. Proc::Daemon

## Install
1. Set database info in **db.yaml**
2. Set the folder of this project and enviromental variables

	```bash
	export CKJOB_BASE="/home/lick/perl/simple-job-manager"
    export PERL5LIB=$PERL5LIB:$CKJOB_BASE
	```

    Apply the chages
    ```bash
    source ~/.bashrc
    ```

3. Setup table in MYSQL

	```sql
	CREATE TABLE IF NOT EXISTS `job` (
	  `jobid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
	  `name` varchar(20) NOT NULL,
	  `status` tinyint(4) NOT NULL DEFAULT '1',
	  `pid` bigint(10) unsigned NOT NULL,
	  `insert_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	  KEY `jobid` (`jobid`),
	  KEY `pid` (`pid`)
	) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=15 ;
	```
4. Finish

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
