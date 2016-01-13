<!--
Author: Neil Gilroy
Filename: TestXSLT.xml
Input: farm config xml
Created: October 2011
Purpose: To Transform the XML Output of a Excel MAP to a customised version of the AutoSPInstaller schema.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" cdata-section-elements="text"/>


  <xsl:template match="* | @*">
    <xsl:copy>
      <xsl:copy-of select = "."/>
      <ContentDBs>
        <xsl:for-each select="//webapplications/webapplication[name != '']">
          <xsl:sort select="numberContentDBs" data-type="number" order="descending"/>
          <xsl:call-template name="for.loop.CDB">
            <xsl:with-param name="i">1</xsl:with-param>

            <xsl:with-param name="count">
              <xsl:value-of select="numberContentDBs"/>
            </xsl:with-param>
            <xsl:with-param name="contentDBPrefix">
              <xsl:value-of select="contentDBPrefix"/>              
            </xsl:with-param>
            <xsl:with-param name="webAppName">
              <xsl:value-of select="name"/>
            </xsl:with-param>
            <xsl:with-param name="maxSize">
              <xsl:value-of select="contentDBMaxSize"/>
            </xsl:with-param>
          </xsl:call-template>


          <!--<xsl:value-of select="$instanceContentDBCount +1"></xsl:value-of>-->
        </xsl:for-each>
      </ContentDBs>
    </xsl:copy>
  </xsl:template>


  <xsl:template name="for.loop.CDB">
    <xsl:param name="i" />

    <xsl:param name="count" />
    <xsl:param name="contentDBPrefix" />
    <xsl:param name="webAppName" />
    <xsl:param name="maxSize" />

    <!--begin_: instanceAliasPrefix = SQL[TYPE]_INST[ID]_[P/M] -->
    <xsl:if test="$i &lt;= $count">
      <!--InstanceID:<xsl:value-of select="$instanceID"/>-->

      <ContentDB>
        <Name>
          <xsl:value-of select="$contentDBPrefix"/>
          <xsl:value-of select="$i"/>
        </Name>
        <WebApplication>
          <xsl:value-of select="$webAppName"/>
        </WebApplication>
        <MaxSize>
          <xsl:value-of select="$maxSize"/>
        </MaxSize>
        <Alias>          
        </Alias>
      </ContentDB>
    </xsl:if>

    <!--begin_: RepeatTheLoopUntilFinished-->
    <xsl:choose>
      <xsl:when test="$i &lt;= $count">

        <xsl:call-template name="for.loop.CDB">
          <xsl:with-param name="i">
            <xsl:value-of select="$i + 1"/>
          </xsl:with-param>

          <xsl:with-param name="count">
            <xsl:value-of select="$count"/>
          </xsl:with-param>
          <xsl:with-param name="contentDBPrefix">
            <xsl:value-of select="$contentDBPrefix"/>
          </xsl:with-param>
          <xsl:with-param name="webAppName">
            <xsl:value-of select="$webAppName"/>
          </xsl:with-param>
          <xsl:with-param name="maxSize">
            <xsl:value-of select="$maxSize"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


</xsl:stylesheet>
