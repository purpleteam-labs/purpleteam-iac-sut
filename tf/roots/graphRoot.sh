#!/bin/bash -x

# Run this script when ever you want to regenerate the graph files in each root.

readonly graphCommand="terraform graph | dot -Tsvg -Gratio=0.3 > graph.svg"
readonly scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $scriptDir/1_static/  && eval $graphCommand
cd $scriptDir/2_nw/      && eval $graphCommand
cd $scriptDir/3_contOrc/ && eval $graphCommand
cd $scriptDir/4_api/     && eval $graphCommand

