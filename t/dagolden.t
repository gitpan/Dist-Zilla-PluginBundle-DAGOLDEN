use 5.008001;
use strict;
use warnings;
use Test::More 0.96;

use Test::DZil;

my $tzil = Builder->from_config(
  { dist_root => 'corpus/DZ1' },
);

ok($tzil->build, "build dist with \@DAGOLDEN");

done_testing;
#
# This file is part of Dist-Zilla-PluginBundle-DAGOLDEN
#
# This software is Copyright (c) 2013 by David Golden.
#
# This is free software, licensed under:
#
#   The Apache License, Version 2.0, January 2004
#
