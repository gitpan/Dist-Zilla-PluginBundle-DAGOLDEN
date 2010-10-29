#
# This file is part of Dist-Zilla-PluginBundle-DAGOLDEN
#
# This software is Copyright (c) 2010 by David Golden.
#
# This is free software, licensed under:
#
#   The Apache License, Version 2.0, January 2004
#
use strict;
use warnings;
package Dist::Zilla::PluginBundle::DAGOLDEN;
BEGIN {
  $Dist::Zilla::PluginBundle::DAGOLDEN::VERSION = '0.012';
}
# ABSTRACT: Dist::Zilla configuration the way DAGOLDEN does it

# Dependencies
use autodie 2.00;
use Moose 0.99;
use Moose::Autobox;
use namespace::autoclean 0.09;

use Dist::Zilla 4.102341; # authordeps

use Dist::Zilla::PluginBundle::Filter ();
use Dist::Zilla::PluginBundle::Git ();

use Dist::Zilla::Plugin::Git::NextVersion ();
use Dist::Zilla::Plugin::CheckChangesHasContent ();
use Dist::Zilla::Plugin::CheckExtraTests ();
use Dist::Zilla::Plugin::CompileTests ();
use Dist::Zilla::Plugin::GithubMeta 0.10 ();
use Dist::Zilla::Plugin::MetaNoIndex ();
use Dist::Zilla::Plugin::MetaProvides::Package ();
use Dist::Zilla::Plugin::MinimumPerl ();
use Dist::Zilla::Plugin::PodSpellingTests ();
use Dist::Zilla::Plugin::PodWeaver ();
use Dist::Zilla::Plugin::TaskWeaver 0.101620 ();
use Dist::Zilla::Plugin::PortabilityTests ();
use Dist::Zilla::Plugin::Prepender ();
use Dist::Zilla::Plugin::ReadmeFromPod ();
use Dist::Zilla::Plugin::Repository 0.13 ();  # version 2 Meta Spec

use Pod::Weaver::Plugin::WikiDoc ();

with 'Dist::Zilla::Role::PluginBundle::Easy';

has fake_release => (
  is      => 'ro',
  isa     => 'Bool',
  lazy    => 1,
  default => sub { $_[0]->payload->{fake_release} },
);

has is_task => (
  is      => 'ro',
  isa     => 'Bool',
  lazy    => 1,
  default => sub { $_[0]->payload->{is_task} },
);

has auto_prereq => (
  is      => 'ro',
  isa     => 'Bool',
  lazy    => 1,
  default => sub {
    exists $_[0]->payload->{auto_prereq} ? $_[0]->payload->{auto_prereq} : 1
  },
);

has tag_format => (
  is      => 'ro',
  isa     => 'Str',
  lazy    => 1,
  default => sub {
    exists $_[0]->payload->{tag_format} ? $_[0]->payload->{tag_format} : 'release-%v',
  },
);

has version_regexp => (
  is      => 'ro',
  isa     => 'Str',
  lazy    => 1,
  default => sub {
    exists $_[0]->payload->{version_regexp} ? $_[0]->payload->{version_regexp} : '^release-(.+)$',
  },
);

has weaver_config => (
  is      => 'ro',
  isa     => 'Str',
  lazy    => 1,
  default => sub { $_[0]->payload->{weaver_config} || '@DAGOLDEN' },
);

has git_remote => (
  is      => 'ro',
  isa     => 'Str',
  lazy    => 1,
  default => sub {
    exists $_[0]->payload->{git_remote} ? $_[0]->payload->{git_remote} : 'origin',
  },
);


sub configure {
  my $self = shift;

  my @push_to = ('origin');
  push @push_to, $self->git_remote if $self->git_remote ne 'origin';

  $self->add_plugins (

  # version number
    [ 'Git::NextVersion' => { version_regexp => $self->version_regexp } ],

  # gather and prune
    'GatherDir',          # core
    'PruneCruft',         # core
    'ManifestSkip',       # core

  # file munging
    'PkgVersion',         # core
    'Prepender',
    ( $self->is_task
      ?  'TaskWeaver'
      : [ 'PodWeaver' => { config_plugin => $self->weaver_config } ]
    ),

  # generated distribution files
    'ReadmeFromPod',
    'License',            # core

  # generated t/ tests
    [ CompileTests => { fake_home => 1 } ],

  # generated xt/ tests
    'MetaTests',          # core
    'PodSyntaxTests',     # core
    'PodCoverageTests',   # core
#    'PodSpellingTests', # XXX disabled until stopwords and weaving fixed
    'PortabilityTests',

  # metadata
    'MinimumPerl',
    ( $self->auto_prereq ? 'AutoPrereqs' : () ),
    'MetaProvides::Package',
    [ Repository => { git_remote => $self->git_remote, github_http => 0 } ],
    # overrides Repository if github based
    [ GithubMeta => { remote => $self->git_remote } ],
    [ MetaNoIndex => { directory => [qw/t xt examples corpus/] } ],
    'MetaYAML',           # core
    'MetaJSON',           # core

  # build system
    'ExecDir',            # core
    'ShareDir',           # core
    'MakeMaker',          # core

  # manifest -- must come after all generated files
    'Manifest',           # core

  # before release
    'Git::Check',
    'CheckChangesHasContent',
    'CheckExtraTests',
    'TestRelease',        # core
    'ConfirmRelease',     # core

  # release
    ( $self->fake_release ? 'FakeRelease' : 'UploadToCPAN'),       # core

  # after release
  # Note -- NextRelease is here to get the ordering right with
  # git actions.  It is *also* a file munger that acts earlier

    [ 'Git::Commit' => 'Commit_Dirty_Files' ], # Changes and/or dist.ini
    [ 'Git::Tag' => { tag_format => $self->tag_format } ],

    # bumps Changes
    'NextRelease',        # core (also munges files)

    [ 'Git::Commit' => 'Commit_Changes' => { commit_msg => "bump Changes" } ],

    [ 'Git::Push' => { push_to => \@push_to } ],

  );

}

__PACKAGE__->meta->make_immutable;

1;



=pod

=head1 NAME

Dist::Zilla::PluginBundle::DAGOLDEN - Dist::Zilla configuration the way DAGOLDEN does it

=head1 VERSION

version 0.012

=head1 SYNOPSIS

   # in dist.ini
   [@DAGOLDEN]

=head1 DESCRIPTION

This is a L<Dist::Zilla> PluginBundle.  It is roughly equivalent to the
following dist.ini:

   ; version provider
   [Git::NextVersion]  ; get version from last release tag
   version_regexp = ^release-(.+)$
 
   ; choose files to include
   [GatherDir]         ; everything under top dir
   [PruneCruft]        ; default stuff to skip
   [ManifestSkip]      ; if -f MANIFEST.SKIP, skip those, too
 
   ; file modifications
   [PkgVersion]        ; add $VERSION = ... to all files
   [Prepender]         ; prepend a copyright statement to all files
   [PodWeaver]         ; generate Pod
   config_plugin = @DAGOLDEN ; my own plugin allows Pod::WikiDoc
 
   ; generated files
   [License]           ; boilerplate license
   [ReadmeFromPod]     ; from Pod (runs after PodWeaver)
 
   ; t tests
   [CompileTests]      ; make sure .pm files all compile
   fake_home = 1       ; fakes $ENV{HOME} just in case
 
   ; xt tests
   [MetaTests]         ; xt/release/meta-yaml.t
   [PodSyntaxTests]    ; xt/release/pod-syntax.t
   [PodCoverageTests]  ; xt/release/pod-coverage.t
   [PortabilityTests]  ; xt/release/portability.t (of file name)
 
   ; metadata
   [AutoPrereqs]       ; find prereqs from code
   [MinimumPerl]       ; determine minimum perl version
   [MetaProvides::Package] ; add 'provides' to META files
 
   [Repository]        ; set 'repository' in META
   git_remote = origin ;   - remote to choose
   github_http = 0     ;   - for github, use git:// not http://
 
   ; overrides [Repository] if repository is on github
   [GithubMeta]
   remote = origin     ; better than [Repository]; sets homepage, too
 
   [MetaNoIndex]       ; sets 'no_index' in META
   directory = t
   directory = xt
   directory = examples
   directory = corpus
 
   [MetaYAML]          ; generate META.yml (v1.4)
   [MetaJSON]          ; generate META.json (v2)
 
   ; build system
   [ExecDir]           ; include 'bin/*' as executables
   [ShareDir]          ; include 'share/' for File::ShareDir
   [MakeMaker]         ; create Makefile.PL
 
   ; manifest (after all generated files)
   [Manifest]          ; create MANIFEST
 
   ; before release
   [Git::Check]        ; ensure all files checked in
   [CheckChangesHasContent] ; ensure Changes has been updated
   [CheckExtraTests]   ; ensure xt/ tests pass
   [TestRelease]       ; ensure t/ tests pass
   [ConfirmRelease]    ; prompt before uploading
 
   ; releaser
   [UploadToCPAN]      ; uploads to CPAN
 
   ; after release
   [Git::Commit / Commit_Dirty_Files] ; commit Changes (as released)
 
   [Git::Tag]          ; tag repo with custom tag
   tag_format = release-%v
 
   ; NextRelease acts *during* pre-release to write $VERSION and
   ; timestamp to Changes and  *after* release to add a new {{$NEXT}}
   ; section, so to act at the right time after release, it must actually
   ; come after Commit_Dirty_Files but before Commit_Changes in the
   ; dist.ini.  It will still act during pre-release as usual
 
   [NextRelease]
 
   [Git::Commit / Commit_Changes] ; commit Changes (for new dev)
 
   [Git::Push]         ; push repo to remote
   push_to = origin

=for stopwords autoprereq dagolden fakerelease pluginbundle podweaver
taskweaver uploadtocpan dist ini

=for Pod::Coverage configure

=head1 USAGE

To use this PluginBundle, just add it to your dist.ini.  You can provide
the following options:

=over

=item *

C<<< is_task >>> -- this indicates whether TaskWeaver or PodWeaver should be used.
Default is 0.

=item *

C<<< auto_prereq >>> -- this indicates whether AutoPrereq should be used or not.
Default is 1.

=item *

C<<< tag_format >>> -- given to C<<< Git::Tag >>>.  Default is 'release-%v' to be more
robust than just the version number when parsing versions for
C<<< Git::NextVersion >>>

=item *

C<<< version_regexp >>> -- given to C<<< Git::NextVersion >>>.  Default
is '^release-(.+)$'

=item *

C<<< git_remote >>> -- given to C<<< Repository >>>.  Defaults to 'origin'.  If set to
something other than 'origin', it is also added as a C<<< push_to >>> argument for
C<<< Git::Push >>>

=item *

C<<< fake_release >>> -- swaps FakeRelease for UploadToCPAN. Mostly useful for
testing a dist.ini without risking a real release.

=item *

C<<< weaver_config >>> -- specifies a Pod::Weaver bundle.  Defaults to @DAGOLDEN.

=back

=head1 SEE ALSO

=over

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Plugin::PodWeaver>

=item *

L<Dist::Zilla::Plugin::TaskWeaver>

=back

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut


__END__



