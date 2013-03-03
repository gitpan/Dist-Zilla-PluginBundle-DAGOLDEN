#!perl

use strict;
use warnings;

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use List::Util qw/max/;

my @modules = qw(
  Dist::Zilla
  Dist::Zilla::Plugin::AutoMetaResources
  Dist::Zilla::Plugin::CheckChangesHasContent
  Dist::Zilla::Plugin::CheckExtraTests
  Dist::Zilla::Plugin::CheckMetaResources
  Dist::Zilla::Plugin::CheckPrereqsIndexed
  Dist::Zilla::Plugin::ContributorsFromGit
  Dist::Zilla::Plugin::CopyFilesFromBuild
  Dist::Zilla::Plugin::Git::NextVersion
  Dist::Zilla::Plugin::InsertCopyright
  Dist::Zilla::Plugin::MetaNoIndex
  Dist::Zilla::Plugin::MetaProvides::Package
  Dist::Zilla::Plugin::MinimumPerl
  Dist::Zilla::Plugin::OurPkgVersion
  Dist::Zilla::Plugin::PodWeaver
  Dist::Zilla::Plugin::ReadmeAnyFromPod
  Dist::Zilla::Plugin::TaskWeaver
  Dist::Zilla::Plugin::Test::Compile
  Dist::Zilla::Plugin::Test::MinimumVersion
  Dist::Zilla::Plugin::Test::Perl::Critic
  Dist::Zilla::Plugin::Test::PodSpelling
  Dist::Zilla::Plugin::Test::Portability
  Dist::Zilla::Plugin::Test::ReportPrereqs
  Dist::Zilla::Plugin::Test::Version
  Dist::Zilla::PluginBundle::Filter
  Dist::Zilla::PluginBundle::Git
  Dist::Zilla::Role::PluginBundle::Config::Slicer
  Dist::Zilla::Role::PluginBundle::Easy
  ExtUtils::MakeMaker
  File::Find
  File::Spec::Functions
  File::Temp
  File::pushd
  List::Util
  Moose
  Moose::Autobox
  Path::Tiny
  Pod::Elemental::Transformer::List
  Pod::Weaver
  Pod::Weaver::Config::Assembler
  Pod::Weaver::Plugin::WikiDoc
  Pod::Weaver::Section::Contributors
  Pod::Weaver::Section::Support
  Pod::Wordlist::hanekomu
  Test::DZil
  Test::More
  Test::Portability::Files
  autodie
  namespace::autoclean
  perl
  strict
  warnings
);

# replace modules with dynamic results from MYMETA.json if we can
# (hide CPAN::Meta from prereq scanner)
my $cpan_meta = "CPAN::Meta";
if ( -f "MYMETA.json" && eval "require $cpan_meta" ) { ## no critic
  if ( my $meta = eval { CPAN::Meta->load_file("MYMETA.json") } ) {
    my $prereqs = $meta->prereqs;
    delete $prereqs->{develop};
    my %uniq = map {$_ => 1} map { keys %$_ } map { values %$_ } values %$prereqs;
    $uniq{$_} = 1 for @modules; # don't lose any static ones
    @modules = sort keys %uniq;
  }
}

my @reports = [qw/Version Module/];

for my $mod ( @modules ) {
  next if $mod eq 'perl';
  my $file = $mod;
  $file =~ s{::}{/}g;
  $file .= ".pm";
  my ($prefix) = grep { -e catfile($_, $file) } @INC;
  if ( $prefix ) {
    my $ver = MM->parse_version( catfile($prefix, $file) );
    $ver = "undef" unless defined $ver; # Newer MM should do this anyway
    push @reports, [$ver, $mod];
  }
  else {
    push @reports, ["missing", $mod];
  }
}

if ( @reports ) {
  my $vl = max map { length $_->[0] } @reports;
  my $ml = max map { length $_->[1] } @reports;
  splice @reports, 1, 0, ["-" x $vl, "-" x $ml];
  diag "Prerequisite Report:\n", map {sprintf("  %*s %*s\n",$vl,$_->[0],-$ml,$_->[1])} @reports;
}

pass;

# vim: ts=2 sts=2 sw=2 et:
