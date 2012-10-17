#!/bin/bash

xsl=$(dirname $(readlink -nf $0))/featuregraph.xsl
contentxml=$1
shift

saxon -xsl:$xsl -s:$contentxml | dot "$@"
