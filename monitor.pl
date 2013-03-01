#!/usr/bin/perl
#
# This files is used to monitor job status and update database
#
use lib $ENV{CKJOB_BASE};
use strict;
use warnings;
use YAML::Tiny;
use JobDB::CKJob;

while(1){
	# Iniailaization
	my $db_set = YAML::Tiny->read("$ENV{CKJOB_BASE}/db.yaml");
	my $schema = JobDB::CKJob->connect(
		$db_set->[0]{dsn},
		$db_set->[0]{user},
		$db_set->[0]{pass},
		{ mysql_enable_utf8 => 1 }
	);

	# Search running job with status == 1
	my $colls = $schema->resultset('Job')->search({status => 1});
	while(my $job = $colls->next){

		my $job_status = find_job_status($job->pid);

		if ($job_status == 0){
			$job->set_column('status',3);
			$job->update;
		}
	}

	sub find_job_status {
		my ($pid) = @_;
	
		my $return = `ps aux |grep $pid |grep -v grep`;
	
		return  length($return) >= 1 ? 1 : 0;
	}

	sleep(10);
}
