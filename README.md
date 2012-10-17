# p2 Feature Graph generator

A small rather hacky tool to generate a dependency graph from a p2 repository.

## Usage

featuregraph.xsl is a XSLT 2.0 stylesheet that will take a content.xml from a
p2 metadata repository and create a graphviz graph illustrating the
dependencies from that. The shell script is a launcher that will generate a
graph from a given content.xml; use `featuregraph.sh content.xml [Options to
dot]` to launch.

## Limitations 

* This is currently tailored towards [TextGrid](http://www.textgrid.de/) usage.
* Packages starting with `org.eclipse` will be left out from the graph.

## Requirements

* saxon
* dot
* curl and jar for the handling of remote repositories
