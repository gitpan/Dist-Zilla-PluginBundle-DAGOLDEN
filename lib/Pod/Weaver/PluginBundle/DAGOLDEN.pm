use strict;
use warnings;
package Pod::Weaver::PluginBundle::DAGOLDEN;
our $VERSION = '0.020'; # VERSION

use Pod::Weaver::Config::Assembler;

# Dependencies
use Pod::Weaver::Plugin::WikiDoc ();
use Pod::Elemental::Transformer::List 0.101620 ();
use Pod::Weaver::Section::Support 1.001 ();

sub _exp { Pod::Weaver::Config::Assembler->expand_package($_[0]) }

my $repo_intro = <<'END';
This is open source software.  The code repository is available for
public review and contribution under the terms of the license.
END

sub mvp_bundle_config {
  my @plugins;
  push @plugins, (
    [ '@DAGOLDEN/WikiDoc',     _exp('-WikiDoc'), {} ],
    [ '@DAGOLDEN/CorePrep',    _exp('@CorePrep'), {} ],
    [ '@DAGOLDEN/Name',        _exp('Name'),      {} ],
    [ '@DAGOLDEN/Version',     _exp('Version'),   {} ],

    [ '@DAGOLDEN/Prelude',     _exp('Region'),  { region_name => 'prelude'     } ],
    [ '@DAGOLDEN/Synopsis',    _exp('Generic'), { header      => 'SYNOPSIS'    } ],
    [ '@DAGOLDEN/Description', _exp('Generic'), { header      => 'DESCRIPTION' } ],
    [ '@DAGOLDEN/Overview',    _exp('Generic'), { header      => 'OVERVIEW'    } ],

    [ '@DAGOLDEN/Stability',   _exp('Generic'), { header      => 'STABILITY'   } ],
  );

  for my $plugin (
    [ 'Attributes', _exp('Collect'), { command => 'attr'   } ],
    [ 'Methods',    _exp('Collect'), { command => 'method' } ],
    [ 'Functions',  _exp('Collect'), { command => 'func'   } ],
  ) {
    $plugin->[2]{header} = uc $plugin->[0];
    push @plugins, $plugin;
  }

  push @plugins, (
    [ '@DAGOLDEN/Leftovers', _exp('Leftovers'), {} ],
    [ '@DAGOLDEN/postlude',  _exp('Region'),    { region_name => 'postlude' } ],
    [ '@DAGOLDEN/Support',   _exp('Support'),
      {
        perldoc => 0,
        websites => 'none',
        bugs => 'metadata',
        repository_link => 'both',
        repository_content => $repo_intro
      }
    ],
    [ '@DAGOLDEN/Authors',   _exp('Authors'),   {} ],
    [ '@DAGOLDEN/Legal',     _exp('Legal'),     {} ],
    [ '@DAGOLDEN/List',      _exp('-Transformer'), { 'transformer' => 'List' } ],
  );

  return @plugins;
}

# ABSTRACT: DAGOLDEN's default Pod::Weaver config
#
# This file is part of Dist-Zilla-PluginBundle-DAGOLDEN
#
# This software is Copyright (c) 2011 by David Golden.
#
# This is free software, licensed under:
#
#   The Apache License, Version 2.0, January 2004
#

1;



__END__
=pod

=head1 NAME

Pod::Weaver::PluginBundle::DAGOLDEN - DAGOLDEN's default Pod::Weaver config

=head1 VERSION

version 0.020

=head1 DESCRIPTION

This is a L<Pod::Weaver> PluginBundle.  It is roughly equivalent to the
following weaver.ini:

   [-WikiDoc]
 
   [@Default]
 
   [Support]
   perldoc = 0
   websites = none
   bugs = metadata
   repository_link = both
   repository_content = ...stuff...
 
   [-Transformer]
   transfomer = List

=for Pod::Coverage mvp_bundle_config

=head1 USAGE

This PluginBundle is used automatically with the CE<lt>@DAGOLDENE<gt> L<Dist::Zilla>
plugin bundle.

=head1 SEE ALSO

=over

=item *

L<Pod::Weaver>

=item *

L<Pod::Weaver::Plugin::WikiDoc>

=item *

L<Pod::Elemental::Transformer::List>

=item *

L<Dist::Zilla::Plugin::PodWeaver>

=back

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

