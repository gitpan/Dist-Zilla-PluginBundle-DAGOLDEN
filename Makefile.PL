
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Dist::Zilla configuration the way DAGOLDEN does it",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::Exception" => "0.29",
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Dist-Zilla-PluginBundle-DAGOLDEN",
  "EXE_FILES" => [],
  "LICENSE" => "apache",
  "NAME" => "Dist::Zilla::PluginBundle::DAGOLDEN",
  "PREREQ_PM" => {
    "Dist::Zilla" => "4.3",
    "Dist::Zilla::Plugin::Bugtracker" => "1.102670",
    "Dist::Zilla::Plugin::CheckChangesHasContent" => 0,
    "Dist::Zilla::Plugin::CheckExtraTests" => 0,
    "Dist::Zilla::Plugin::CheckPrereqsIndexed" => "0.002",
    "Dist::Zilla::Plugin::CopyFilesFromBuild" => 0,
    "Dist::Zilla::Plugin::Git::NextVersion" => 0,
    "Dist::Zilla::Plugin::GithubMeta" => "0.10",
    "Dist::Zilla::Plugin::InsertCopyright" => "0.001",
    "Dist::Zilla::Plugin::MetaNoIndex" => 0,
    "Dist::Zilla::Plugin::MetaProvides::Package" => "1.14",
    "Dist::Zilla::Plugin::MinimumPerl" => 0,
    "Dist::Zilla::Plugin::OurPkgVersion" => "0.004",
    "Dist::Zilla::Plugin::PodWeaver" => 0,
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => "0.120051",
    "Dist::Zilla::Plugin::ReadmeFromPod" => 0,
    "Dist::Zilla::Plugin::TaskWeaver" => "0.101620",
    "Dist::Zilla::Plugin::Test::Compile" => 0,
    "Dist::Zilla::Plugin::Test::Perl::Critic" => 0,
    "Dist::Zilla::Plugin::Test::PodSpelling" => "2.001002",
    "Dist::Zilla::Plugin::Test::Portability" => 0,
    "Dist::Zilla::Plugin::Test::Version" => 0,
    "Dist::Zilla::PluginBundle::Filter" => 0,
    "Dist::Zilla::PluginBundle::Git" => "1.121010",
    "Dist::Zilla::Role::PluginBundle::Easy" => 0,
    "Moose" => "0.99",
    "Moose::Autobox" => 0,
    "Pod::Elemental::Transformer::List" => "0.101620",
    "Pod::Weaver" => "3.101635",
    "Pod::Weaver::Config::Assembler" => 0,
    "Pod::Weaver::Plugin::WikiDoc" => 0,
    "Pod::Weaver::Section::Support" => "1.001",
    "Pod::Wordlist::hanekomu" => "1.113620",
    "autodie" => "2.00",
    "namespace::autoclean" => "0.09",
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.031",
  "test" => {
    "TESTS" => "t/*.t"
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



