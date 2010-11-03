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
package Pod::Weaver::PluginBundle::DAGOLDEN;
BEGIN {
  $Pod::Weaver::PluginBundle::DAGOLDEN::VERSION = '0.013';
}
# ABSTRACT: DAGOLDEN's default Pod::Weaver config

use Pod::Weaver::Config::Assembler;
sub _exp { Pod::Weaver::Config::Assembler->expand_package($_[0]) }

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
    [ '@DAGOLDEN/Authors',   _exp('Authors'),   {} ],
    [ '@DAGOLDEN/Legal',     _exp('Legal'),     {} ],
    [ '@DAGOLDEN/List',      _exp('-Transformer'), { 'transformer' => 'List' } ],
  );

  return @plugins;
}

1;


__END__
=pod

=head1 NAME

Pod::Weaver::PluginBundle::DAGOLDEN - DAGOLDEN's default Pod::Weaver config

=head1 VERSION

version 0.013

=for Pod::Coverage mvp_bundle_config

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

