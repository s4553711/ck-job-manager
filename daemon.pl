#!/usr/bin/perl
use Proc::Daemon;
my $arg = shift || die "Usage> daemon.pl [start|stop]\n";

if (lc($arg) eq 'start'){

	my $daemon = Proc::Daemon->new(
		work_dir     => "$ENV{CKJOB_BASE}/daemon",
		child_STDOUT => "$ENV{CKJOB_BASE}/daemon/daemon.out",
		child_STDERR => '+>>debug.txt',
		pid_file     => 'pid.txt',
		exec_command => "perl $ENV{CKJOB_BASE}/monitor.pl"
	);

	$daemon->Init();

} else {
	my $daemon = Proc::Daemon->new();
	open(FH,"$ENV{CKJOB_BASE}/daemon/pid.txt");
	my $pid = <FH>;
	close FH;
	$daemon->Kill_Daemon($pid);
}
