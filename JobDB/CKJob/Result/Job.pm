package JobDB::CKJob::Result::Job;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('job');
__PACKAGE__->add_columns(qw/jobid name status pid insert_time/);
__PACKAGE__->set_primary_key('jobid');
