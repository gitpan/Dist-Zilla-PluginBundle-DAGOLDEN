use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.006002
use Test::Spelling 0.12;
use Pod::Wordlist;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib  ) );
__DATA__
ConfigSlicer
DAGOLDEN
DAGOLDEN's
GatherDir
PluginBundle
PluginRemover
PodCoverage
attr
ini
David
Golden
dagolden
Christian
Walde
walde
Eric
Johnson
eric
Karen
Etheridge
ether
Philippe
Bruhat
BooK
book
Sergey
Romanov
complefor
lib
Pod
Weaver
Dist
Zilla
