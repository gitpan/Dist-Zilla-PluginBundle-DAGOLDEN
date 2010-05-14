
use strict;
use warnings;

 BEGIN { require 5.006; } 

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Dist::Zilla configuration the way DAGOLDEN does it',
  'AUTHOR' => 'David Golden <dagolden@cpan.org>',
  'BUILD_REQUIRES' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'Test::Exception' => '0.29',
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Dist-Zilla-PluginBundle-DAGOLDEN',
  'EXE_FILES' => [],
  'LICENSE' => 'apache',
  'NAME' => 'Dist::Zilla::PluginBundle::DAGOLDEN',
  'PREREQ_PM' => {
    'Dist::Zilla' => '2.101040',
    'Dist::Zilla::Plugin::BumpVersionFromGit' => '0',
    'Dist::Zilla::Plugin::CheckChangesHasContent' => '0',
    'Dist::Zilla::Plugin::CheckExtraTests' => '0',
    'Dist::Zilla::Plugin::CompileTests' => '0',
    'Dist::Zilla::Plugin::MetaNoIndex' => '0',
    'Dist::Zilla::Plugin::MetaProvides::Package' => '0',
    'Dist::Zilla::Plugin::MinimumPerl' => '0',
    'Dist::Zilla::Plugin::PodSpellingTests' => '0',
    'Dist::Zilla::Plugin::PodWeaver' => '0',
    'Dist::Zilla::Plugin::PortabilityTests' => '0',
    'Dist::Zilla::Plugin::Prepender' => '0',
    'Dist::Zilla::Plugin::ReadmeFromPod' => '0',
    'Dist::Zilla::Plugin::Repository' => '0',
    'Dist::Zilla::Plugin::TaskWeaver' => '0',
    'Dist::Zilla::PluginBundle::Filter' => '0',
    'Dist::Zilla::PluginBundle::Git' => '0',
    'Dist::Zilla::Role::PluginBundle::Easy' => '0',
    'Moose' => '0.99',
    'Moose::Autobox' => '0',
    'autodie' => '2.00',
    'namespace::autoclean' => '0.09'
  },
  'VERSION' => '0.006',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM}; 
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod}; 
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



