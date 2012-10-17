<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs fn"
    xmlns:fn="http://thorstenvitt.de/functions/p2"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="repository">
        digraph <xsl:value-of select="fn:toName(@name)"/> {
            rankdir = TB
            node [ shape = none ]
            
            <!-- nodes: -->
            <xsl:for-each select=".//provided[@namespace='org.eclipse.equinox.p2.iu' and fn:useThisName(@name)]">
                <xsl:value-of select="fn:toName(@name)"/> [ label = &lt;<xsl:value-of select="fn:formatName(@name)"/> &lt;BR/&gt;
                &lt;FONT POINT-SIZE="10" COLOR="gray30"&gt;<xsl:value-of select="@version"/>&lt;/FONT&gt;
                &gt; ]
            </xsl:for-each>
                
            
            <!-- edges: -->            
            <xsl:for-each select=".//provided[@namespace='org.eclipse.equinox.p2.iu' and fn:useThisName(@name)]">
                <xsl:variable name="from" select="."/>
                <xsl:for-each select="../../requires/required[@namespace='org.eclipse.equinox.p2.iu' and fn:useThisName(@name)]">
                    <xsl:value-of select="fn:toName($from/@name)"/>
                    <xsl:text> -&gt; </xsl:text>
                    <xsl:value-of select="fn:toName(@name)"/> [ <xsl:choose>
                        <xsl:when test="fn:isFixedVersion(@range)">
                            style = solid, color = blue, label = "= <xsl:value-of select="replace(@range, '[\[(](.*),.*','$1')"/>"
                        </xsl:when>
                        <xsl:when test="@range = '0.0.0'">
                            style = dashed, color = gray
                        </xsl:when>
                        <xsl:otherwise>
                            style = dashed, color = black, label = "<xsl:value-of select="@range"/>"
                        </xsl:otherwise>
                    </xsl:choose> ]
                </xsl:for-each>
            </xsl:for-each>
        }
    </xsl:template>
    
    <xsl:function name="fn:toName" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:value-of select="replace(replace($in, '\.feature\.group$', '') , '[.: -]+', '_')"/>
    </xsl:function>
    
    <xsl:function name="fn:formatName" as="xs:string">
        <xsl:param name="name" as="xs:string"/>
        <xsl:value-of select="
            replace(replace($name, 'info.textgrid.lab.', 'itl.'),
                '.feature.group$', '')
            "/>
    </xsl:function>
    
    <xsl:function name="fn:isFixedVersion" as="xs:boolean">
        <xsl:param name="range" as="xs:string"/>
        <xsl:value-of select="matches($range, '[\[(](.*),\1[\])]', '!')"/>
    </xsl:function>
    
    <xsl:function name="fn:useThisName" as="xs:boolean">
        <xsl:param name="iu" as="xs:string"/>
        <xsl:value-of select="
            matches($iu, '(\.feature\.group|\.product)$') and
            not(ends-with($iu, '.sources.feature.group')) and
            not(starts-with($iu, 'org.eclipse'))            
            "/>
    </xsl:function>
    
    
</xsl:stylesheet>
