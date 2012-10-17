#!/bin/bash

xsl=$(dirname $(readlink -nf $0))/featuregraph.xsl
contentxml=$1
shift

tmpdir=$(mktemp -d)

if [ \! -r "$contentxml" ]
then
    echo "Trying to fetch ${contentxml}/content.jar" >&2
    if curl -\# -f -o "$tmpdir/content.jar" "${contentxml}/content.jar"
    then
	( cd "$tmpdir" && jar xf content.jar content.xml )
	contentxml="${tmpdir}/content.xml"
    else
	echo "Trying to fetch ${contentxml}/content.xml" >&2
	if curl -\# -f -o "$tmpdir/content.xml" "${contentxml}/content.xml"
	then
	   contentxml="${tmpdir}/content.xml"
       else
	   echo "Did not find a repository at $contentxml :-(" >&2
	   exit 1
       fi
    fi
fi

echo "Generating graph ..." >&2
saxon -xsl:$xsl -s:$contentxml | dot "$@"

rm -rf "$tmpdir"
