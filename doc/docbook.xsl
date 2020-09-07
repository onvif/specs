<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:db="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output encoding="UTF-8" indent="no" media-type="text/html" method="html" />
    
    <xsl:variable name="css">
body{
background-color: #d0d0d0;
} 
.page {
background-color: #ffffff;
font-family:Arial,Helvetica;
font-size:10pt;
width: 21cm;
text-align: center;
margin-left: auto;
margin-right: auto;
}
.pages {
text-align: left;
margin: 30mm 30mm 30mm 30mm; 
}
div {
margin-top: 5mm;
}
pre {
font-size:9pt;
}
.heading {
font-size:16pt;
font-weight: bold;
text-align: center;
margin-left: auto;
margin-right: auto;
}
.h2 {
font-size:14pt;
}
.param {
font-weight: bold;
margin-left: 15mm;
}
.text {
margin-left: 15mm;
margin-top: 0mm;
}
.reference {
margin-top: 0mm;
}
.figure {
font-weight: bold;
text-align: center;
}
.op {
text-transform: uppercase;
}
.table {
text-align: center;
}
.table>table, .table>table>thead>tr>th, .table>table>tbody>tr>td {
border: 1px solid black;
border-collapse: collapse;
margin: 3mm 3mm 3mm 3mm;
}    </xsl:variable>
    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                    <xsl:value-of select="$css" disable-output-escaping="yes"/>
                </style>
            </head>
            <body>
                <div class="page">
                    <div class="pages" width="210mm">
                        <xsl:apply-templates/>
                    </div>  
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="db:book">
        <div class='heading'><xsl:value-of select="db:info/db:author/db:orgname"/></div>
        <div class='heading'><xsl:value-of select="db:info/db:title"/></div>
        <div class='heading'><img src="media/logo.png" style="width:60mm"/></div>
        <div><xsl:value-of select="db:info/db:legalnotice"/></div>
        <xsl:apply-templates select="db:chapter|db:appendix" />
    </xsl:template>

    <xsl:template match="db:info|db:title">
    </xsl:template>
    
    <xsl:template match="db:chapter|db:section">
        <xsl:element name="div">
            <xsl:apply-templates select="@xml:id"/>
            <h2><xsl:number level="multiple" count="db:chapter|db:section" format="1.1 "/> <xsl:value-of select="db:title"/></h2>
        </xsl:element>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="db:appendix|db:seciont[ancestor::db:appendix]">
        <div style="margin-top:30mm"><h2><xsl:number level="multiple" count="db:appendix|db:section" format="A.1 "/> <xsl:value-of select="db:title"/></h2></div>
        <xsl:apply-templates select="db:para|db:section"/>
    </xsl:template>
    
    <xsl:template match="db:emphasis[@role='bold']">
        <b><xsl:value-of select="."/></b>
    </xsl:template>
    <xsl:template match="db:para[not(@role)]">
        <div><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="db:term[ancestor::db:variablelist[@role='op']]">
        <div class='op'><xsl:value-of select="."/>:</div>
    </xsl:template>

    <xsl:template match="db:para[@role]">
        <xsl:element name="div">
            <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
<!-- Tables -->    
    <xsl:template match="db:informaltable">
        <table>
            <xsl:apply-templates select="db:tgroup/db:tbody/db:row"/>
        </table>        
    </xsl:template>
    <xsl:template match="db:table">
        <div class="table">
            <table>
                <thead>
                <xsl:for-each select="db:tgroup/db:thead/db:row">
                    <tr>
                        <xsl:for-each select="db:entry">
                            <th><xsl:value-of select="."/></th>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
                </thead>
                <tbody>
                    <xsl:apply-templates select="db:tgroup/db:tbody/db:row"/>
                </tbody>
            </table>
        </div>
        <xsl:element name="div">
            <xsl:attribute name="class">figure</xsl:attribute>
            <xsl:apply-templates select="@xml:id"/>
            Table <xsl:number count="db:table" level="any" format="1"/>: <xsl:value-of select="db:title"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="db:row">
        <tr>
            <xsl:apply-templates select="db:entry"/>
        </tr>        
    </xsl:template>
    <xsl:template match="db:entry">
        <td>
            <xsl:apply-templates select="db:para" mode="plain"/>
        </td>        
    </xsl:template>
    <xsl:template match="db:para" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Figures-->
    <xsl:template match="db:figure">
        <div class="figure">
            <xsl:element name="img">
                <xsl:attribute name="src"><xsl:value-of select="db:mediaobject/db:imageobject/db:imagedata/@fileref"/></xsl:attribute>
                <xsl:attribute name="style">width:<xsl:value-of select="db:mediaobject/db:imageobject/db:imagedata/@contentwidth"/></xsl:attribute>
            </xsl:element>
        </div>
        <xsl:variable name="no"><xsl:number count="db:figure" format="1"/></xsl:variable>
        <xsl:variable name="id"><xsl:value-of select="@xml:id"/></xsl:variable>
        <div class="figure" id="$id">
            Figure <xsl:number count="db:figure" level="any" format="1"/>: <xsl:value-of select="db:title"/>
        </div>        
    </xsl:template>    

    <xsl:template match="@xml:id">
        <xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="db:inlinemediaobject">
        <xsl:element name="img">
            <xsl:attribute name="src"><xsl:value-of select="db:imageobject/db:imagedata/@fileref"/></xsl:attribute>
            <xsl:if test="db:textobject">
                <xsl:apply-templates select="db:textobject" />
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
 
    <xsl:template match="db:programlisting">
        <pre>
            <xsl:value-of select="."/>
        </pre>
    </xsl:template>
 
    <xsl:template match="db:xref">
        <xsl:variable name="id"><xsl:value-of select="@linkend"/></xsl:variable>
        <xsl:variable name="target" select="//*[@xml:id=$id]"/>
        <xsl:element name="a">
            <xsl:attribute name="href">#<xsl:copy-of select="$id"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="$target/@name='title'"><xsl:value-of select="$target"/></xsl:when>
                <xsl:when test="$target/db:title"><xsl:value-of select="$target/db:title"/></xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:link">
        <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
            <xsl:attribute name="target">new</xsl:attribute>
            <xsl:if test="not(text())"><xsl:value-of select="@xlink:href"/></xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>