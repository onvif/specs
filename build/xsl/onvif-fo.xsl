<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY lcase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY ucase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
]> 
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:exsl="http://exslt.org/common"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  exclude-result-prefixes="exsl d xlink fox"
  version="1.0">

<!-- XSL Stylesheet prepared for ONVIF by:
     Bob Stayton
     Sagehill Enterprises
     bobs@sagehill.net

This stylesheet is a customization layer that runs on top of
the stock DocBook XSL stylesheets -->

<!-- $Id$ -->

<!-- Import the stock DocBook stylesheet -->
<xsl:import href="docbook-xsl/fo/docbook.xsl"/>

<!-- proper handling of white space in PDF output requires this
     to be set to "no" -->
<xsl:output indent="no"/>

<!--==============================================================-->
<!--  Parameter settings                                          -->
<!--==============================================================-->
<xsl:param name="fop1.extensions">1</xsl:param>
<xsl:param name="paper.type">A4</xsl:param>
<xsl:param name="page.margin.inner">20mm</xsl:param>
<xsl:param name="page.margin.outer">20mm</xsl:param>
<xsl:param name="page.margin.top">22mm</xsl:param>
<xsl:param name="page.margin.bottom">22mm</xsl:param>
<xsl:param name="body.margin.top">9mm</xsl:param>
<xsl:param name="body.margin.bottom">0mm</xsl:param>
<xsl:param name="double.sided" select="0"/>
<xsl:param name="alignment">justify</xsl:param>
<xsl:param name="body.start.indent">0pt</xsl:param>

<xsl:param name="body.font.family">Arial</xsl:param>
<xsl:param name="body.font.master">10</xsl:param>
<xsl:param name="body.font.size"><xsl:value-of select="concat($body.font.master, 'pt')"/></xsl:param>
<xsl:param name="title.font.family">Arial</xsl:param>
<xsl:param name="title.font.size">11pt</xsl:param>

<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="header.left.position">ONVIF&#x2122;</xsl:param>
<xsl:param name="header.rule" select="0"/>
<xsl:param name="footer.rule" select="0"/>
<xsl:param name="table.head.background.color">#B3B3B3</xsl:param>
<xsl:param name="toc.indent.width">12</xsl:param>
<xsl:param name="toc.section.depth">3</xsl:param>
<xsl:param name="autotoc.label.separator">
  <fo:leader leader-length="12pt"/>
</xsl:param>
<xsl:param name="book.titlepage.recto.image">media/logo.png</xsl:param>
<xsl:param name="itemizedlist.label.width">0.25in</xsl:param>
<xsl:param name="header.column.widths">8 1 8</xsl:param>

<xsl:param name="generate.toc">
book toc,title
</xsl:param>

<xsl:param name="formal.title.placement">
table before
procedure before
task before
figure after
example after
equation after
</xsl:param>

<xsl:param name="xref.with.number.and.title" select="0"/>

<xsl:param name="local.l10n.xml" select="document('')"/>
<l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
  <l:l10n language="en">
    <l:gentext key="tableofcontents" text="CONTENTS"/>
    <l:gentext key="appendix" text="Annex"/>
    <l:gentext key="version" text="Version"/>
    <l:gentext key="version.abbrev" text="Ver."/>
    <l:gentext key="revision.abbrev" text="Rev."/>
    <l:gentext key="date" text="Date"/>
    <l:gentext key="changes" text="Changes"/>
    <l:context name="title">
      <l:template name="table" text="Table %n: %t"/>
      <l:template name="figure" text="Figure %n: %t"/>
      <l:template name="example" text="Example %n: %t"/>
      <l:template name="equation" text="Equation %n: %t"/>
    </l:context>
    <l:context name="title-numbered">
      <l:template name="appendix" text="Annex %n: %t"/>
    </l:context>
    <l:context name="xref-number">
      <l:template name="section" text="%n"/>
      <l:template name="chapter" text="%n"/>
      <l:template name="appendix" text="Annex %n"/>
      <l:template name="table" text="Table %n"/>
      <l:template name="figure" text="Figure %n"/>
      <l:template name="example" text="Example %n"/>
      <l:template name="equation" text="Equation %n"/>
    </l:context>
    <l:context name="xref-number-and-title">
      <l:template name="section" text="%n"/>
      <l:template name="chapter" text="%n"/>
      <l:template name="appendix" text="%n"/>
      <l:template name="table" text="Table %n"/>
      <l:template name="figure" text="Figure %n"/>
      <l:template name="example" text="Example %n"/>
      <l:template name="equation" text="Equation %n"/>
    </l:context>
  </l:l10n>
</l:i18n>

<!--==============================================================-->
<!--  Attribute-sets                                              -->
<!--==============================================================-->
<xsl:attribute-set name="chapter.title.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
  <xsl:attribute name="line-height">12pt</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="space-before">11pt</xsl:attribute>
  <xsl:attribute name="space-after">10pt</xsl:attribute>
  <xsl:attribute name="letter-spacing">0.07em</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="appendix.title.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="line-height">15pt</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="space-before">14pt</xsl:attribute>
  <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
  <xsl:attribute name="space-after">12pt</xsl:attribute>
  <xsl:attribute name="letter-spacing">0.07em</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="preface.title.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="line-height">14pt</xsl:attribute>
  <xsl:attribute name="space-before">11pt</xsl:attribute>
  <xsl:attribute name="space-after">10pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="letter-spacing">0.07em</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  <xsl:attribute name="space-before">14pt</xsl:attribute>
  <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
  <xsl:attribute name="line-height">12pt</xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="space-before">11pt</xsl:attribute>
  <xsl:attribute name="space-after">10pt</xsl:attribute>
  <xsl:attribute name="letter-spacing">0.07em</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level3.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level4.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level5.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level6.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$title.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.cell.padding">
  <xsl:attribute name="padding-start">6pt</xsl:attribute>
  <xsl:attribute name="padding-end">6pt</xsl:attribute>
  <xsl:attribute name="padding-top">3pt</xsl:attribute>
  <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="formal.title.properties" use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.size"/>
  </xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="itemizedlist.properties">
  <xsl:attribute name="margin-left">0.25in</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.properties">
</xsl:attribute-set>

<xsl:attribute-set name="xref.properties">
  <xsl:attribute name="color">
    <xsl:choose>
      <xsl:when test="self::d:link[@xlink:href]">blue</xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="toc.title.properties">
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="space-after">12pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="chapter.toc.line.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="space-before">6pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.level1.toc.line.properties">
  <xsl:attribute name="space-before">6pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="figure.properties">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="informalfigure.properties">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-size">9pt</xsl:attribute>
</xsl:attribute-set>

<!-- zero spacing for @role="reference" -->
<xsl:attribute-set name="para.properties">
  <xsl:attribute name="space-before.optimum">
    <xsl:choose>
      <xsl:when test="@role='reference'">0pt</xsl:when>
      <xsl:when test="@role='text'">0pt</xsl:when>
      <xsl:otherwise>1em</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="space-before.minimum">
    <xsl:choose>
      <xsl:when test="@role='reference'">0pt</xsl:when>
      <xsl:when test="@role='text'">0pt</xsl:when>
      <xsl:otherwise>0.8em</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="space-before.maximum">
    <xsl:choose>
      <xsl:when test="@role='reference'">0pt</xsl:when>
      <xsl:when test="@role='text'">0pt</xsl:when>
      <xsl:otherwise>1.2em</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="font-weight">
    <xsl:choose>
      <xsl:when test="@role='access'">bold</xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<!-- titlepage attribute sets -->
<xsl:attribute-set name="recto.titlepage.spacer.properties">
  <xsl:attribute name="height">180pt</xsl:attribute>
  <xsl:attribute name="border">0.1pt none red</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="recto.titlepage.orgname.properties">
  <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
  <xsl:attribute name="font-size">20pt</xsl:attribute>
  <xsl:attribute name="line-height">24pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="recto.titlepage.title.properties">
  <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
  <xsl:attribute name="font-size">20pt</xsl:attribute>
  <xsl:attribute name="line-height">24pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="space-before">0pt</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="recto.titlepage.version.properties">
  <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="line-height">12pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="space-before">24pt</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="recto.titlepage.date.properties">
  <xsl:attribute name="font-family"><xsl:value-of select="$title.fontset"/></xsl:attribute>
  <xsl:attribute name="font-size">10pt</xsl:attribute>
  <xsl:attribute name="line-height">12pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="space-before">12pt</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="recto.titlepage.logo.block.properties">
  <xsl:attribute name="space-before">24pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="recto.titlepage.logo.image.properties">
  <xsl:attribute name="content-width">132pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="varlistentry.op.properties">
  <xsl:attribute name="margin-{$direction.align.start}">0.5in</xsl:attribute>
  <xsl:attribute name="space-before">6pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="para.op.param.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="margin-{$direction.align.start}">-0.25in</xsl:attribute>
  <xsl:attribute name="space-before">6pt</xsl:attribute>
  <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="bullet.op.param.properties">
  <xsl:attribute name="font-weight">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="variablelist.term.properties">
  <xsl:attribute name="font-weight">
    <xsl:choose>
      <xsl:when test="ancestor::d:variablelist[1][@role = 'op']">normal</xsl:when>
      <xsl:otherwise>bold</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="book.titlepage.verso.style">
  <xsl:attribute name="hyphenate">false</xsl:attribute>
</xsl:attribute-set>
<!--==============================================================-->
<!--  Templates                                                   -->
<!--==============================================================-->
<!-- Chapters do not start a new page-sequence, so the first
     chapter must create the page sequence and include the following chapters -->
<xsl:template match="d:chapter[position() = 1]">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:call-template name="page.sequence">
    <xsl:with-param name="content">
      <fo:block id="{$id}">
        <xsl:call-template name="chapter.titlepage"/>
      </fo:block>

      <xsl:call-template name="make.component.tocs"/>

      <xsl:apply-templates/>

      <xsl:apply-templates mode="following.chapters" select="following-sibling::d:chapter"/>

    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:attribute-set name="chapter.properties">
</xsl:attribute-set>

<!-- no normal processing for following chapters in same page-sequence -->
<xsl:template match="d:chapter[position() != 1]">
</xsl:template>

<xsl:template match="d:chapter[position() != 1]" mode="following.chapters">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}" xsl:use-attribute-sets="chapter.properties">
    <xsl:call-template name="chapter.titlepage"/>

    <xsl:call-template name="make.component.tocs"/>

    <xsl:apply-templates/>
  </fo:block>
</xsl:template>
  
<xsl:template name="chapter.titlepage">
  <fo:block xsl:use-attribute-sets="chapter.title.properties">
    <xsl:apply-templates select="." mode="label.markup"/>
    <fo:leader leader-length="10pt"/>
    <xsl:apply-templates select="." mode="title.markup"/>
  </fo:block>
</xsl:template>

<xsl:template name="preface.titlepage">
  <fo:block xsl:use-attribute-sets="preface.title.properties">
    <xsl:apply-templates select="." mode="title.markup"/>
  </fo:block>
</xsl:template>

<xsl:template name="section.titlepage">
  <fo:block xsl:use-attribute-sets="section.title.properties">
    <xsl:apply-templates select="." mode="label.markup"/>
    <fo:leader leader-length="10pt"/>
    <xsl:apply-templates select="." mode="title.markup"/>
  </fo:block>
</xsl:template>

<xsl:template name="appendix.titlepage">
  <fo:block xsl:use-attribute-sets="appendix.title.properties">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key">appendix</xsl:with-param>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="." mode="label.markup"/>
    <xsl:text>.</xsl:text>
    <fo:block>
      <xsl:apply-templates select="." mode="title.markup"/>
    </fo:block>
  </fo:block>
</xsl:template>

<!-- set up header content -->
<xsl:template name="header.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

<!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->

  <fo:block>

    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>

      <xsl:when test="$position='left'">
        <xsl:choose>
          <xsl:when test="/*/d:info/d:author/d:orgname">
            <xsl:apply-templates select="/*/d:info/d:author/d:orgname" mode="titlepage.mode"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$header.left.position"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$position='center'">
        <!-- endash -->
        <xsl:text>&#x2013;</xsl:text>
        <xsl:text> </xsl:text>
        <fo:page-number/>
        <xsl:text> </xsl:text>
        <xsl:text>&#x2013;</xsl:text>
      </xsl:when>

      <xsl:when test="$position='right'">
        <xsl:apply-templates select="/*" mode="titleabbrev.markup"/>
        <xsl:if test="/*/d:info/d:releaseinfo">
          <xsl:text> </xsl:text>
          <xsl:text>&#x2013;</xsl:text>
          <xsl:text> </xsl:text>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">version.abbrev</xsl:with-param>
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:value-of select="/*/d:info/d:releaseinfo"/>
        </xsl:if>
      </xsl:when>

    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- must customize this template to turn on page number on title page -->
<xsl:template name="header.table">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <!-- default is a single table style for all headers -->
  <!-- Customize it for different page classes or sequence location -->

  <xsl:variable name="column1">
    <xsl:choose>
      <xsl:when test="$double.sided = 0">1</xsl:when>
      <xsl:when test="$sequence = 'first' or $sequence = 'odd'">1</xsl:when>
      <xsl:otherwise>3</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="column3">
    <xsl:choose>
      <xsl:when test="$double.sided = 0">3</xsl:when>
      <xsl:when test="$sequence = 'first' or $sequence = 'odd'">3</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="candidate">
    <fo:table xsl:use-attribute-sets="header.table.properties">
      <xsl:call-template name="head.sep.rule">
        <xsl:with-param name="pageclass" select="$pageclass"/>
        <xsl:with-param name="sequence" select="$sequence"/>
        <xsl:with-param name="gentext-key" select="$gentext-key"/>
      </xsl:call-template>

      <fo:table-column column-number="1">
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:call-template name="header.footer.width">
            <xsl:with-param name="location">header</xsl:with-param>
            <xsl:with-param name="position" select="$column1"/>
            <xsl:with-param name="pageclass" select="$pageclass"/>
            <xsl:with-param name="sequence" select="$sequence"/>
            <xsl:with-param name="gentext-key" select="$gentext-key"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
      </fo:table-column>
      <fo:table-column column-number="2">
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:call-template name="header.footer.width">
            <xsl:with-param name="location">header</xsl:with-param>
            <xsl:with-param name="position" select="2"/>
            <xsl:with-param name="pageclass" select="$pageclass"/>
            <xsl:with-param name="sequence" select="$sequence"/>
            <xsl:with-param name="gentext-key" select="$gentext-key"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
      </fo:table-column>
      <fo:table-column column-number="3">
        <xsl:attribute name="column-width">
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:call-template name="header.footer.width">
            <xsl:with-param name="location">header</xsl:with-param>
            <xsl:with-param name="position" select="$column3"/>
            <xsl:with-param name="pageclass" select="$pageclass"/>
            <xsl:with-param name="sequence" select="$sequence"/>
            <xsl:with-param name="gentext-key" select="$gentext-key"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </xsl:attribute>
      </fo:table-column>

      <fo:table-body>
        <fo:table-row>
          <xsl:attribute name="block-progression-dimension.minimum">
            <xsl:value-of select="$header.table.height"/>
          </xsl:attribute>
          <fo:table-cell text-align="start"
                         display-align="before">
            <xsl:if test="$fop.extensions = 0">
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:call-template name="header.content">
                <xsl:with-param name="pageclass" select="$pageclass"/>
                <xsl:with-param name="sequence" select="$sequence"/>
                <xsl:with-param name="position" select="$direction.align.start"/>
                <xsl:with-param name="gentext-key" select="$gentext-key"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="center"
                         display-align="before">
            <xsl:if test="$fop.extensions = 0">
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:call-template name="header.content">
                <xsl:with-param name="pageclass" select="$pageclass"/>
                <xsl:with-param name="sequence" select="$sequence"/>
                <xsl:with-param name="position" select="'center'"/>
                <xsl:with-param name="gentext-key" select="$gentext-key"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell text-align="right"
                         display-align="before">
            <xsl:if test="$fop.extensions = 0">
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:if>
            <fo:block>
              <xsl:call-template name="header.content">
                <xsl:with-param name="pageclass" select="$pageclass"/>
                <xsl:with-param name="sequence" select="$sequence"/>
                <xsl:with-param name="position" select="$direction.align.end"/>
                <xsl:with-param name="gentext-key" select="$gentext-key"/>
              </xsl:call-template>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:variable>

  <!-- Really output a header? -->
  <xsl:choose>
    <xsl:when test="$sequence = 'blank' and $headers.on.blank.pages = 0">
      <!-- no output -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$candidate"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Current design has no footer content -->
<xsl:template name="footer.content">
  <fo:block/>
</xsl:template>

<!-- page numbering is arabic and continuous from the titlepage -->
<xsl:template name="initial.page.number">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="master-reference" select="''"/>

  <xsl:text>auto</xsl:text>
</xsl:template>

<!-- only arabic numbering -->
<xsl:template name="page.number.format">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="master-reference" select="''"/>

  <xsl:choose>
    <!-- use this condition to turn on roman numeral numbering -->
    <xsl:when test="false()">i</xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- table elements have cell borders, informaltables do not -->
<xsl:template name="calsTable">

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>

  <xsl:for-each select="d:tgroup">

    <fo:table xsl:use-attribute-sets="table.table.properties">
      <xsl:if test="$keep.together != ''">
        <xsl:attribute name="keep-together.within-column">
          <xsl:value-of select="$keep.together"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="ancestor-or-self::d:table">
          <xsl:call-template name="table.frame"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- no frame for informaltables -->
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="following-sibling::d:tgroup">
        <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
        <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
        <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="preceding-sibling::d:tgroup">
        <xsl:attribute name="border-top-width">0pt</xsl:attribute>
        <xsl:attribute name="border-top-style">none</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">0pt</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-before.minimum">0pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">0pt</xsl:attribute>
        <xsl:attribute name="space-before.maximum">0pt</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </fo:table>

    <xsl:for-each select="d:mediaobject|d:graphic">
      <xsl:apply-templates select="."/>
    </xsl:for-each>

  </xsl:for-each>

  <xsl:apply-templates select="d:caption"/>

</xsl:template>

<xsl:template name="border">
  <xsl:param name="side" select="'start'"/>

  <xsl:choose>
    <xsl:when test="ancestor::d:informaltable">
      <!-- no border -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="border-{$side}-width">
        <xsl:value-of select="$table.cell.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-{$side}-style">
        <xsl:value-of select="$table.cell.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-{$side}-color">
        <xsl:value-of select="$table.cell.border.color"/>
      </xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="table.row.properties">
  <xsl:choose>
    <xsl:when test="ancestor::d:table and ancestor::d:thead">
      <xsl:attribute name="background-color">
        <xsl:value-of select="$table.head.background.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- number tables continuously, not with chapter number prefix -->
<xsl:template match="d:figure|d:table|d:example" mode="label.markup">
  <xsl:variable name="pchap"
                select="(ancestor::d:appendix)[last()]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
	<xsl:when test="$prefix != ''">
		<xsl:apply-templates select="$pchap" mode="label.markup"/>
		<xsl:apply-templates select="$pchap" mode="intralabel.punctuation">
		  <xsl:with-param name="object" select="."/>
		</xsl:apply-templates>
	    <xsl:number format="1" from="d:chapter|d:appendix" level="any"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number format="1" from="d:book" level="any"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- customize different toc levels -->
<xsl:template name="toc.line">
  <xsl:param name="toc-context" select="NOTANODE"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label.markup"/>
  </xsl:variable>

  <xsl:variable name="inline">
    <fo:inline keep-with-next.within-line="always">
      <fo:basic-link internal-destination="{$id}">
        <xsl:if test="self::d:appendix">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">appendix</xsl:with-param>
          </xsl:call-template>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="$label != ''">
          <xsl:copy-of select="$label"/>
          <xsl:copy-of select="$autotoc.label.separator"/>
        </xsl:if>
        <xsl:apply-templates select="." mode="titleabbrev.markup"/>
      </fo:basic-link>
    </fo:inline>
    <fo:inline keep-together.within-line="always">
      <fo:leader xsl:use-attribute-sets="toc.leader.properties">
        <xsl:choose>
          <xsl:when test="self::d:preface">
            <xsl:attribute name="leader-pattern">space</xsl:attribute>
          </xsl:when>
          <xsl:when test="self::d:chapter">
            <xsl:attribute name="leader-pattern">space</xsl:attribute>
          </xsl:when>
          <xsl:when test="self::d:appendix">
            <xsl:attribute name="leader-pattern">space</xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </fo:leader>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </fo:inline>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="self::d:preface">
      <fo:block xsl:use-attribute-sets="toc.line.properties chapter.toc.line.properties">
        <xsl:copy-of select="$inline"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::d:chapter or self::d:appendix">
      <fo:block xsl:use-attribute-sets="toc.line.properties chapter.toc.line.properties">
        <xsl:copy-of select="$inline"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::d:section and count(ancestor::d:section) = 0">
      <fo:block xsl:use-attribute-sets="toc.line.properties section.level1.toc.line.properties">
        <xsl:copy-of select="$inline"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block xsl:use-attribute-sets="toc.line.properties">
        <xsl:copy-of select="$inline"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="table.of.contents.titlepage">
  <fo:block xsl:use-attribute-sets="toc.title.properties">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key">tableofcontents</xsl:with-param>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template name="book.titlepage.recto">
  <fo:block-container xsl:use-attribute-sets="recto.titlepage.spacer.properties">
    <fo:block/>
  </fo:block-container>
  <fo:block xsl:use-attribute-sets="recto.titlepage.orgname.properties">
    <xsl:choose>
      <xsl:when test="/*/d:info/d:author/d:orgname">
        <xsl:apply-templates select="/*/d:info/d:author/d:orgname" mode="titlepage.mode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$header.left.position"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
  <fo:block xsl:use-attribute-sets="recto.titlepage.title.properties">
    <xsl:apply-templates select="/*" mode="title.markup"/>
  </fo:block>
  <xsl:if test="/*/d:info/d:releaseinfo">
    <fo:block xsl:use-attribute-sets="recto.titlepage.version.properties">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">version</xsl:with-param>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="/*/d:info/d:releaseinfo" mode="titlepage.mode"/>
    </fo:block>
  </xsl:if>
  <fo:block xsl:use-attribute-sets="recto.titlepage.date.properties">
      <xsl:value-of select="/*/d:info/d:pubdate"/> 
  </fo:block>
  <fo:block xsl:use-attribute-sets="recto.titlepage.logo.block.properties">
    <xsl:variable name="src">
      <xsl:call-template name="image.src">
        <xsl:with-param name="filename" select="$book.titlepage.recto.image"/>
      </xsl:call-template>
    </xsl:variable>
    <fo:external-graphic xsl:use-attribute-sets="recto.titlepage.logo.image.properties"
                         src="{$src}">
    </fo:external-graphic>
  </fo:block>
</xsl:template>

<xsl:template name="book.titlepage.verso">
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:copyright"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:copyright"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:bookinfo/d:legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.verso.auto.mode" select="d:info/d:legalnotice"/>
</xsl:template>

<!-- special format for variablelist with role='op' -->
<xsl:template match="d:variablelist[@role = 'op']">
  <xsl:apply-templates select="." mode="vl.as.blocks"/>
</xsl:template>

<xsl:template match="d:variablelist[@role='op']/d:varlistentry/d:term/text()" priority="1">
  <xsl:value-of select="translate(., &lcase;, &ucase;)"/>
</xsl:template>

<xsl:template match="d:variablelist[@role='op']/d:varlistentry" mode="vl.as.blocks" priority="1">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <fo:block id="{$id}" xsl:use-attribute-sets="variablelist.term.properties
                                               list.item.spacing"  
      keep-together.within-column="always" 
      keep-with-next.within-column="always">
    <xsl:apply-templates select="d:term"/>
    <xsl:text>:</xsl:text>
  </fo:block>

  <fo:block xsl:use-attribute-sets="varlistentry.op.properties">
    <xsl:apply-templates select="d:listitem"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:para[@role = 'param']">
  <fo:block xsl:use-attribute-sets="para.op.param.properties">
    <xsl:call-template name="anchor"/>
    <!-- formatted as bulleted list block -->
    <fo:list-block provisional-distance-between-starts="0.25in">
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
          <fo:block xsl:use-attribute-sets="bullet.op.param.properties">
            <xsl:call-template name="itemizedlist.label.markup">
              <xsl:with-param name="itemsymbol">disc</xsl:with-param>
            </xsl:call-template>
          </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
          <fo:block>
            <xsl:apply-templates/>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<!-- appendix with role="revhistory" will generate the Revision
     History table from the info metadata -->
<xsl:template match="d:appendix[@role = 'revhistory']">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:call-template name="page.sequence">
    <xsl:with-param name="content">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="component.titlepage.properties">
        <xsl:call-template name="appendix.titlepage"/>
      </fo:block>

      <fo:block xsl:use-attribute-sets="revhistory.properties">
        <xsl:call-template name="generate.revhistory"/>
      </fo:block>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:attribute-set name="revhistory.properties">
</xsl:attribute-set>

<xsl:template name="generate.revhistory">
  <xsl:choose>
    <xsl:when test="/*/d:info/d:revhistory">
      <xsl:apply-templates select="/*/d:info/d:revhistory"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>WARNING: appendix with @role="revhistory" but no revhistory element available.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:attribute-set name="revhistory.header.row.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="d:revhistory">
  <fo:table table-layout="fixed" xsl:use-attribute-sets="revhistory.table.properties">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="table.frame">
      <xsl:with-param name="frame">all</xsl:with-param>
    </xsl:call-template>
    <fo:table-column column-number="1" column-width="proportional-column-width(34)"/>
    <fo:table-column column-number="2" column-width="proportional-column-width(63)"/>
    <fo:table-column column-number="3" column-width="proportional-column-width(90)"/>
    <fo:table-column column-number="4" column-width="proportional-column-width(244)"/>
    <fo:table-header start-indent="0pt" end-indent="0pt">
      <fo:table-row xsl:use-attribute-sets="revhistory.header.row.properties">
        <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
          <fo:block>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">revision.abbrev</xsl:with-param>
          </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
          <fo:block>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">date</xsl:with-param>
          </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
          <fo:block>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">Editor</xsl:with-param>
          </xsl:call-template>
          </fo:block>
        </fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
          <fo:block>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">changes</xsl:with-param>
          </xsl:call-template>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </fo:table-header>
    <fo:table-body start-indent="0pt" end-indent="0pt">
      <xsl:apply-templates/>
    </fo:table-body>
  </fo:table>
</xsl:template>

<xsl:attribute-set name="revhistory.table.cell.properties" use-attribute-sets="table.cell.padding">
  <xsl:attribute name="border">0.2pt solid black</xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
  <xsl:attribute name="text-align">left</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="d:revhistory/d:revision">
  <xsl:variable name="revnumber" select="d:revnumber"/>
  <xsl:variable name="revdate"   select="d:date"/>
  <xsl:variable name="revauthor" select="d:authorinitials|d:author"/>
  <xsl:variable name="revremark" select="d:revremark|d:revdescription"/>
  <fo:table-row>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:call-template name="anchor"/>
        <xsl:apply-templates select="$revnumber[1]"/>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:apply-templates select="$revdate[1]"/>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:for-each select="$revauthor">
          <xsl:apply-templates select="."/>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:apply-templates select="$revremark[1]"/>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>

<xsl:template name="itemizedlist.label.markup">
  <xsl:param name="itemsymbol" select="'disc'"/>

  <xsl:choose>
    <xsl:when test="$itemsymbol='none'"></xsl:when>
    <xsl:when test="$itemsymbol='disc'">
      <fo:inline font-size="12pt" font-weight="bold">&#x2022;</fo:inline>
    </xsl:when>
    <xsl:when test="$itemsymbol='bullet'">&#x2022;</xsl:when>
    <xsl:when test="$itemsymbol='endash'">&#x2013;</xsl:when>
    <xsl:when test="$itemsymbol='emdash'">&#x2014;</xsl:when>
    <xsl:when test="$itemsymbol='circle'">&#x25CB;</xsl:when>
    <xsl:when test="$itemsymbol='opencircle'">&#x25CB;</xsl:when>
    <xsl:when test="$itemsymbol='square'">&#x25AA;</xsl:when>
    <!-- Some of these may work in your XSL-FO processor and fonts -->
    <!--
    <xsl:when test="$itemsymbol='square'">&#x25A0;</xsl:when>
    <xsl:when test="$itemsymbol='box'">&#x25A0;</xsl:when>
    <xsl:when test="$itemsymbol='smallblacksquare'">&#x25AA;</xsl:when>
    <xsl:when test="$itemsymbol='whitesquare'">&#x25A1;</xsl:when>
    <xsl:when test="$itemsymbol='smallwhitesquare'">&#x25AB;</xsl:when>
    <xsl:when test="$itemsymbol='round'">&#x25CF;</xsl:when>
    <xsl:when test="$itemsymbol='blackcircle'">&#x25CF;</xsl:when>
    <xsl:when test="$itemsymbol='whitebullet'">&#x25E6;</xsl:when>
    <xsl:when test="$itemsymbol='triangle'">&#x2023;</xsl:when>
    <xsl:when test="$itemsymbol='point'">&#x203A;</xsl:when>
    <xsl:when test="$itemsymbol='hand'"><fo:inline 
                         font-family="Wingdings 2">A</fo:inline></xsl:when>
    -->
    <xsl:otherwise>&#x2022;</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- center tables with explicit widths -->
<xsl:template name="table.block">
  <xsl:param name="table.layout" select="NOTANODE"/>

  <xsl:variable name="width">
    <xsl:call-template name="table.width"/>
  </xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="param.placement"
                select="substring-after(normalize-space(
                   $formal.title.placement), concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>

  <xsl:variable name="table.with.footnotes">
    <xsl:copy-of select="$table.layout"/>
    <xsl:call-template name="table.footnote.block"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="self::d:table">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="table.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column">
            <xsl:value-of select="$keep.together"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$placement = 'before'">
          <xsl:call-template name="formal.object.heading">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="$width != '100%'">
            <!-- put inside a container table with proportional sides
                 to center it -->
            <fo:table width="100%" table-layout="fixed">
              <fo:table-column column-number="1" column-width="proportional-column-width(1)"/>
              <fo:table-column column-number="2" column-width="{$width}"/>
              <fo:table-column column-number="3" column-width="proportional-column-width(1)"/>
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                      <xsl:copy-of select="$table.with.footnotes"/>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell>
                    <fo:block>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$table.with.footnotes"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$placement != 'before'">
          <xsl:call-template name="formal.object.heading">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="informaltable.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column">
            <xsl:value-of select="$keep.together"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$table.layout"/>
        <xsl:call-template name="table.footnote.block"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Add EMF file format -->
<xsl:param name="graphic.notations">
  <!-- n.b. exactly one leading space, one trailing space, and one inter-word space -->
  <xsl:choose>
    <xsl:when test="$fop1.extensions != 0">
      <xsl:text> BMP GIF TIFF SVG PNG EPS JPG JPEG linespecific EMF </xsl:text>
    </xsl:when>
    <xsl:when test="$fop.extensions != 0">
      <xsl:text> BMP GIF TIFF SVG PNG EPS JPG JPEG linespecific </xsl:text>
    </xsl:when>
    <xsl:when test="$arbortext.extensions != 0">
      <xsl:text> PNG PDF JPG JPEG linespecific GIF GIF87a GIF89a TIFF BMP </xsl:text>
    </xsl:when>
    <xsl:when test="$xep.extensions != 0">
      <xsl:text> SVG PNG PDF JPG JPEG linespecific GIF GIF87a GIF89a TIFF BMP </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> PNG PDF JPG JPEG linespecific GIF GIF87a GIF89a TIFF BMP </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>
</xsl:stylesheet>
