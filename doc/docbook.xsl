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
padding: 30mm 30mm 30mm 30mm; 
}
div {
margin-bottom: 5mm;
}
li {
margin-top: 2.5mm;
}
pre {
font-size:9pt;
}
td {
vertical-align: top
}
.heading {
font-size:20pt;
text-align: center;
margin-left: auto;
margin-right: auto;
}
.plaindiv {
margin-bottom: 0mm;
}
.version {
font-size:12pt;
text-align: center;
margin-left: auto;
margin-right: auto;
}
.h2 {
font-size:14pt;
}
.param, .access {
font-weight: bold;
margin-left: 15mm;
margin-top: 1.5mm;
margin-bottom: 1mm;
}
.text {
margin-left: 15mm;
margin-top: 0mm;
margin-bottom: 3mm;
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
margin-bottom: 0mm;
}
.table {
text-align: center;
}
.table>table, .table>table>thead>tr>th, .table>table>tbody>tr>td {
text-align: left;
border: 1px solid black;
border-collapse: collapse;
padding: 1mm 3mm 1mm 3mm;
}
.table>table>thead>tr>th {
background-color: #d0d0d0;
font-weight: bold;
}</xsl:variable>
    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                    <xsl:value-of select="$css" disable-output-escaping="yes"/>
                </style>
            </head>
            <body>
                <div class="page">
                    <div class="pages">
                        <xsl:apply-templates/>
                    </div>  
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="db:book">
        <div class='heading'><xsl:value-of select="db:info/db:author/db:orgname"/></div>
        <div class='heading'><xsl:value-of select="db:info/db:title"/></div>
        <div class='version'>Working Draft <xsl:value-of select="db:info/db:releaseinfo"/></div>
        <div class='version'><xsl:value-of select="db:info/db:pubdate"/></div>
        <div class='version'><img src="media/logo.png" style="width:60mm"/></div>
        <div><xsl:value-of select="db:info/db:legalnotice"/></div>
        <xsl:apply-templates select="db:chapter|db:appendix" />
    </xsl:template>

    <xsl:template match="db:info|db:title">
    </xsl:template>
    
<!-- Headings   -->
    <xsl:template match="db:chapter|db:section">
        <xsl:element name="div">
		  <h2>
		      <xsl:apply-templates select="@xml:id"/>
			  <xsl:apply-templates select="." mode="ref"/>
			  <xsl:value-of select="db:title"/>
		  </h2>
        </xsl:element>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="db:appendix">
        <xsl:apply-templates select="@xml:id"/>
        <xsl:element name="div">
            <xsl:apply-templates select="@xml:id"/>
            <xsl:attribute name="style">margin-top:30mm; text-align:center</xsl:attribute>
            <h2>Annex <xsl:number level="multiple" count="db:appendix" format="A.1 "/> <xsl:value-of select="db:title"/></h2>
        </xsl:element>    
        <xsl:apply-templates />
        <xsl:if test="@role='revhistory'">
            <div class='table'><table><thead>
                <tr>
                    <th>Rev.</th><th>Date</th><th>Author</th><th>Changes</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="/db:book/db:info/db:revhistory/db:revision">
                    <tr>
                        <td><xsl:value-of select="db:revnumber"/></td>
                        <td><xsl:value-of select="db:date"/></td>
                        <td><xsl:value-of select="db:author"/></td>
                        <td><xsl:value-of select="db:revremark"/></td>
                    </tr>
                </xsl:for-each>
            </tbody></table></div>
        </xsl:if>
    </xsl:template>
    
    <!-- Paragraph -->
    <xsl:template match="db:emphasis[@role='bold']">
        <b><xsl:value-of select="."/></b>
    </xsl:template>
    <xsl:template match="db:para[not(@role)]">
        <div><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="db:term[ancestor::db:variablelist[@role='op']]">
        <div class='op'><xsl:value-of select="."/>:</div>
    </xsl:template>

    <!-- Lists -->
    <xsl:template match="db:para[@role]">
        <xsl:element name="div">
            <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:variablelist[not(@role)]">
        <table><tbody>
            <xsl:for-each select="db:varlistentry">
                <tr>
                    <td class='param'><xsl:value-of select="db:term"/></td>
                    <td><xsl:apply-templates select="db:listitem"/></td>
                </tr>
            </xsl:for-each>
        </tbody></table>
    </xsl:template>
    
    <xsl:template match="db:itemizedlist">
        <ul>
            <xsl:for-each select="db:listitem">
				<li>
				    <xsl:apply-templates select="db:para" mode="plaindiv"/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="db:para" mode="plaindiv">
        <div class="plaindiv"><xsl:apply-templates/></div>
    </xsl:template>
    
<!-- Tables -->    
    <xsl:template match="db:informaltable">
        <table>
            <xsl:apply-templates select="db:tgroup/db:tbody/db:row"/>
        </table>        
    </xsl:template>
    <xsl:template match="db:table">
        <xsl:element name="div">
            <xsl:attribute name="class">table</xsl:attribute>
            <xsl:apply-templates select="@xml:id"/>
            <xsl:element name="table">
                <xsl:element name="thead">
                    <xsl:apply-templates select="db:tgroup/db:thead/db:row"><xsl:with-param name="header" select="'1'"/></xsl:apply-templates>
                </xsl:element>
                <xsl:element name="tbody">
                    <xsl:apply-templates select="db:tgroup/db:tbody/db:row"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <xsl:element name="div">
            <xsl:attribute name="class">figure</xsl:attribute>
            Table <xsl:number count="db:table" level="any" format="1"/>: <xsl:value-of select="db:title"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="db:row">
        <xsl:param name="header"/>
        <tr>
            <xsl:apply-templates select="db:entry"><xsl:with-param name="header" select="$header"></xsl:with-param></xsl:apply-templates>
        </tr>        
    </xsl:template>
    <xsl:template match="db:entry">
        <xsl:param name="header"/>
        <xsl:variable name="cell"><xsl:choose>
            <xsl:when test="$header='1'">th</xsl:when>
            <xsl:otherwise>td</xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:element name="{$cell}">
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan"><xsl:value-of select="@morerows + 1"/></xsl:attribute>
            </xsl:if>
            <xsl:variable name="colspan" select="1 + number(substring(@nameend, 2)) - number(substring(@namest, 2))"/>
            <xsl:if test="$colspan > 1">
                <xsl:attribute name="colspan"><xsl:value-of select="$colspan"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@align">
                <xsl:attribute name="style"><xsl:value-of select="concat('text-align:', @align)"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="db:para" mode="plain"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:para" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="db:superscript">
		<sup>
			<xsl:apply-templates/>
		</sup>
    </xsl:template>
    
    <xsl:template match="db:emphasis[@role=bold]">
		<b>
			<xsl:apply-templates/>
		</b>
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
                <xsl:apply-templates select="@xml:id"/>
                <xsl:attribute name="src"><xsl:value-of select="db:mediaobject/db:imageobject/db:imagedata/@fileref"/></xsl:attribute>
                <xsl:attribute name="style">width:<xsl:value-of select="db:mediaobject/db:imageobject/db:imagedata/@contentwidth"/></xsl:attribute>
            </xsl:element>
        </div>
        <div class="figure">
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
            <xsl:apply-templates/>
        </pre>
    </xsl:template>

 <!-- References -->
    <xsl:template match="db:xref">
        <xsl:variable name="id"><xsl:value-of select="@linkend"/></xsl:variable>
        <xsl:variable name="target" select="//*[@xml:id=$id]"/>
        <xsl:element name="a">
            <xsl:attribute name="href">#<xsl:copy-of select="$id"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="name($target)='table'"><xsl:apply-templates mode="ref" select="$target"/></xsl:when>
                <xsl:when test="name($target)='figure'"><xsl:apply-templates mode="ref" select="$target"/></xsl:when>
                <xsl:otherwise> <xsl:apply-templates mode="ref" select="$target"/></xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="db:section|db:chapter|db:appendix" mode="ref">
        <xsl:choose>
            <xsl:when test="ancestor::db:appendix">
                <xsl:number level="multiple" count="db:appendix|db:section" format="A.1 "/> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:number level="multiple" count="db:chapter|db:section" format="1.1 "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="db:table" mode="ref">
        Table <xsl:number count="db:table" level="any" format="1"/>
    </xsl:template>
    
    <xsl:template match="db:figure" mode="ref">
        Figure <xsl:number count="db:figure" level="any" format="1"/>
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