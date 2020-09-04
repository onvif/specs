<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:db="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output encoding="UTF-8" indent="no" media-type="text/html" method="html" />
    
    <xsl:template match="/">
        <html>
            <head>
        <link rel="stylesheet" href="docbook-css/driver.css" type="text/css" />
            </head>
            <body>
        <xsl:apply-templates />
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="node()[not(self::db:mediaobject or self::db:inlinemediaobject or self::db:imageobject or self::db:imagedata or self::db:xref or self::db:uri or self::db:email or self::db:textobject)]|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template> 
    
    <xsl:template match="@xml:id">
        <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:inlinemediaobject | db:mediaobject">
        <xsl:element name="img" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="src"><xsl:value-of select="db:imageobject/db:imagedata/@fileref"/></xsl:attribute>
            <xsl:if test="db:textobject">
                <xsl:apply-templates select="db:textobject" />
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:textobject" />
    
    <xsl:template match="db:xref">
        <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="href">#<xsl:value-of select="@linkend"/></xsl:attribute>
            <xsl:value-of select="@xreflabel"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:uri">
        <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
            <xsl:attribute name="target">new</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:email">
        <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="href">mailto:<xsl:value-of select="."/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>