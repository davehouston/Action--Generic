use inc::Module::Install;
  
  # Define metadata
name           'Action-Generic';
license        'perl';
all_from       'lib/Action/Generic.pm';
  
  # Specific dependencies
requires       'Moose'             => '0.98';
requires       'Module::Pluggable' => 0;
requires       'Template'          => '2.22';
requires       'Log::Dispatch'     => '2.26';
test_requires  'Test::More'  => '0.42';

WriteAll;
