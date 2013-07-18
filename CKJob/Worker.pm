package CKJob::Worker;
use utf8;
use strict;
use warnings;
use Data::Dumper;
use JobDB::CKJob;
use YAML::Tiny;
use POSIX;
use Capture::Tiny 'capture_merged';

sub new {
	my ($class,$set) = @_;
	my $self = bless({},$class);

	$self->{sys_path} = "$ENV{CKJOB_BASE}/job_tmp";

	my $db_set = YAML::Tiny->read($set->{'db_set'});
	$self->{schema} = JobDB::CKJob->connect($db_set->[0]{dsn},$db_set->[0]{user},$db_set->[0]{pass},
		{
			mysql_enable_utf8 => 1
		}
	);

	return $self;
}

sub init {
	my ($self,$setting) = @_;

	$SIG{CHLD} = 'IGNORE';
	my $pid = fork();
	
	$self->{jobid} = $pid;

	if ($pid == 0) {

		# Child Process
		$self->{schema}->resultset('Job')->create(
			{
				name => $setting->{name},
				pid => $$,
				status => 1
			}
		)->update;

		$setting->{output_path} = $self->{sys_path}."/$$";
		mkdir $setting->{output_path},0777;

		open my $fh, '>', $setting->{output_path}."/execution.log";
		open my $fh2, '>', $setting->{output_path}."/err.log";
		open my $child_ot,">", $setting->{output_path}."/stdout.log";

		$setting->{log_handle} = $fh;
		$setting->{log_err_handle} = $fh2;

		print $child_ot capture_merged {
			eval {
				$self->work($setting);
			};
		};

		# Error Handle
		if ($@){
			open(EXCEPTION,">$setting->{output_path}/error.log");
			print EXCEPTION "$@";
			close EXCEPTION;
		}

		close $fh;
		close $fh2;
		close $child_ot;
		select STDOUT;

		exit 0;
	}

	return 0;
}

1;
