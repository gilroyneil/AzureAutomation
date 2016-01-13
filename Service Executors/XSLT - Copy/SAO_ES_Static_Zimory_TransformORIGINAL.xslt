<!--
Author: Neil Gilroy
Filename: TestXSLT.xml
Input: farm config xml
Created: October 2011
Purpose: To Transform the XML Output of a Excel MAP to a customised version of the AutoSPInstaller schema.
-->
<xsl:stylesheet version="2.0" xmlns:zim="http://www.zimory.com/confserver/metadata/v1_0_0"   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" cdata-section-elements="text"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="csource">
    <xsl:param name="text" select="."/>
    <xsl:param name="type"/>
    <xsl:param name="separator" select="';'"/>

    
    <xsl:choose>
      <xsl:when test="not(contains($text, $separator))">

        <xsl:variable name="csourcevalue" select="normalize-space(substring-before($text,','))"></xsl:variable>
        <xsl:variable name="csourcescope" select="normalize-space(substring-after($text,','))"></xsl:variable>

        <![CDATA[<contentsource>]]>
        <![CDATA[<type>]]><xsl:value-of select="$type"/><![CDATA[</type>]]>
        <![CDATA[<values>]]><xsl:value-of select="$csourcevalue"/><![CDATA[</values>]]>
        <![CDATA[<depth>]]><xsl:value-of select="$csourcescope"/><![CDATA[</depth>]]>
        <![CDATA[</contentsource>]]>
        </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="csourcevalue" select="normalize-space(substring-before($text,','))"></xsl:variable>
        <xsl:variable name="csourcescope" select="normalize-space(substring-after($text,','))"></xsl:variable>

        <![CDATA[<contentsource>]]>
        <![CDATA[<type>]]><xsl:value-of select="$type"/><![CDATA[</type>]]>
        <![CDATA[<values>]]><xsl:value-of select="$csourcevalue"/><![CDATA[</values>]]>
        <![CDATA[<depth>]]><xsl:value-of select="normalize-space(substring-before($csourcescope, $separator))"/><![CDATA[</depth>]]>
        <![CDATA[</contentsource>]]>
        <xsl:call-template name="csource">
          <xsl:with-param name="text" select="substring-after($text, $separator)"/>
          <xsl:with-param name="type" select="$type"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="/zim:metadata">
    <![CDATA[
<farm>
  <deploymentserver>]]><xsl:value-of select="//customerandenvironmentsettings/deploymentserver"/><![CDATA[</deploymentserver>
  <mediaserver>]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[</mediaserver>
  <numberofusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_NUMBEROFUSERS']"/><![CDATA[</numberofusers>
  <purpose>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/><![CDATA[</purpose>
  
  
  <farmname>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SHORTCUSTOMERNAME']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/>_<xsl:value-of select="//customerandenvironmentsettings/farmnumber"/><![CDATA[</farmname>
  <farmnumber>]]><xsl:value-of select="//customerandenvironmentsettings/farmnumber"/><![CDATA[</farmnumber>
  <createdomain>No</createdomain>
  <joindomain>Yes</joindomain>
  <testaccountsOU>Test Search Accounts</testaccountsOU>
  <serviceaccountsOU>Enterprise Search Service Accounts</serviceaccountsOU>
  <restrictsitedefinitions>Yes</restrictsitedefinitions>
  <location>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[</location>
  <customer>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERNAME']"/><![CDATA[</customer>
  <customerabreviation>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SHORTCUSTOMERNAME']"/><![CDATA[</customerabreviation>
  <passphrase>1#]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SHORTCUSTOMERNAME']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/>_<xsl:value-of select="//customerandenvironmentsettings/farmnumber"/><![CDATA[#1</passphrase>
  <requireddocumentstorage>25</requireddocumentstorage>
  <amountofdocuments>100000</amountofdocuments>
  <totalcontentdbsize>29</totalcontentdbsize>
  <searchdbsize>11.769</searchdbsize>
  <otherdbsize>13.75</otherdbsize>  
  <amountindexeditems>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_AMOUNTINDEXEDITEMS']"/><![CDATA[</amountindexeditems>
  <contentdbmaxsize>400</contentdbmaxsize>
  <contentdbdefaultsize>5</contentdbdefaultsize>
  <numbercontentdbspersqlinstance>10</numbercontentdbspersqlinstance>
  <searchbackuppath>\\wfe1\SearchBackup</searchbackuppath>
  <securestoremasterkey>Sc0uting47_1</securestoremasterkey>
  <securestoreappkey>Sc0uting47_1</securestoreappkey>
  <blobcachelocation>E:\BlobCache\</blobcachelocation>
  <domaincreatesettings>
    <settings>
      <forestdomainname>es.com</forestdomainname>
      <netbios>es</netbios>
      <localadminpassword>Start123</localadminpassword>
      <safemodepassword>D1sabl3d231537</safemodepassword>
    </settings>
  </domaincreatesettings>
  <domainjoinsettings>
    <settings>
      <shortdomainame>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_DOMAINJOIN_SNAME']"/><![CDATA[</shortdomainame>
      <forestdomainname>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_DOMAINJOIN_FNAME']"/><![CDATA[</forestdomainname>
      <dcip>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_DC_IP_ADDRESS']"/><![CDATA[</dcip>
      <username>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_DOMAINJOIN_USERNAME']"/><![CDATA[</username>
      <password>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_DOMAINJOIN_PASSWORD']"/><![CDATA[</password>
      <localadminpassword>Start123</localadminpassword>
      <ou>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_DOMAINJOIN_OU']"/><![CDATA[</ou>
    </settings>
  </domainjoinsettings>
  <farmfederationsettings>
    <farmfederationsetting/>
    <farmfederationsetting/>
  </farmfederationsettings>
   <vmtemplates>
    <vmtemplate>
      <name>Virtual-S</name>
      <description>Small Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>4</cores>
      <ram>8192</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-M</name>
      <description>Medium Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>4</cores>
      <ram>8192</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-L</name>
      <description>Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>8</cores>
      <ram>16384</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XL</name>
      <description>Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>8</cores>
      <ram>32768</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XXL</name>
      <description>Super Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>8</cores>
      <ram>65536</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
  </vmtemplates>
 <servergroups>
  <servergroup>
      <name>WAC Server</name>
      <description>Webserver and CA</description>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>75</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Web Server Group 1</name>
      <description>Webserver and CA</description>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>75</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <pdrivevhdsize>10</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Application Server Group 1</name>
      <description>All non search Service Apps and SP Admin and APC</description>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>150</edrivevhdsize>
      <fdrivevhdsize>300</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
     <servergroup>
      <name>Application Server Group 2</name>
      <description>APC</description>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>75</edrivevhdsize>
      <fdrivevhdsize>300</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 1</name>
      <description>Index and QPC</description>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>150</edrivevhdsize>
      <fdrivevhdsize>500</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 2</name>
      <description>Index Server</description>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
     <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>75</edrivevhdsize>
      <fdrivevhdsize>500</fdrivevhdsize>
      <gdrivevhdsize>25</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 3</name>
      <description>Crawl and CPC</description>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>150</cdrivevhdsize>
      <edrivevhdsize>150</edrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>170</cdrivevhdsize>
      <edrivevhdsize>75</edrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize/>
      <idrivevhdsize/>
      <jdrivevhdsize/>
      <kdrivevhdsize></kdrivevhdsize>
      <ldrivevhdsize></ldrivevhdsize>
      <mdrivevhdsize></mdrivevhdsize>
      <ndrivevhdsize></ndrivevhdsize>
      <pdrivevhdsize>1</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>
    <servergroup>
      <name>Deploy Server</name>
      <description>A Server to install the farm from</description>
      <requirednumber>1</requirednumber>
      <orderednumber>1</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize/>
      <edrivevhdsize>100</edrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
  </servergroups>
  <quotatemplates>
    <quotatemplate>
      <name>250MB</name>
    </quotatemplate>
    <quotatemplate>
      <name>2GB</name>
    </quotatemplate>
    <quotatemplate>
      <name>5MB</name>
    </quotatemplate>
    <quotatemplate>
      <name>5GB</name>
    </quotatemplate>
    <quotatemplate>
      <name>10GB</name>
    </quotatemplate>
    <quotatemplate>
      <name>20GB</name>
    </quotatemplate>
    <quotatemplate>
      <name>50GB</name>
    </quotatemplate>
    <quotatemplate>
      <name>100GB</name>
    </quotatemplate>
    <quotatemplate>
      <name>200GB</name>
    </quotatemplate>
  </quotatemplates>
  <managedaccounts>
    <managedaccount>
     ]]><xsl:variable name="userdomainSPIA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_INSTALL_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPIA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_INSTALL_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPIA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_INSTALL_PASSWORD']"></xsl:variable><![CDATA[  
      <purpose>SharePoint Install Account</purpose>
      <domain>]]><xsl:value-of select="$userdomainSPIA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPIA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPIA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPIA"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sppermissions>Farm Admin</sppermissions>
      <sqlpermissions>dbcreator/securityadmin</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>Yes</logonlocally>
      <localadmin>Yes</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSPFA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_FARM_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPFA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_FARM_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPFA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_FARM_PASSWORD']"></xsl:variable><![CDATA[      
      <purpose>Farm Account</purpose>           
      <domain>]]><xsl:value-of select="$userdomainSPFA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPFA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPFA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPFA"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>dbcreator/securityadmin</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>Yes</logonlocally>
      <localadmin>Yes</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSPWA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_WEB_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPWA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_WEB_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPWA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_WEB_PASSWORD']"></xsl:variable><![CDATA[      
      <purpose>Web Applications account</purpose>
      <domain>]]><xsl:value-of select="$userdomainSPWA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPWA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPWA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPWA"/><![CDATA[</password>   
      <issharepointmanagedaccount>Yes</issharepointmanagedaccount>
      <sqlpermissions>dbo for each content db</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>No</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSPSA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_SERVICE_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPSA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_SERVICE_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPSA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_SERVICE_PASSWORD']"></xsl:variable><![CDATA[    
      <purpose>Service Applications account</purpose>
      <domain>]]><xsl:value-of select="$userdomainSPSA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPSA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPSA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPSA"/><![CDATA[</password>
      <issharepointmanagedaccount>Yes</issharepointmanagedaccount>
      <sqlpermissions>dbo for each content db</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>No</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSQL" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_SERVER_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSQL" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_SERVER_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSQL" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_SERVER_PASSWORD']"></xsl:variable><![CDATA[       
      <purpose>SQL Server Account</purpose>
       <domain>]]><xsl:value-of select="$userdomainSQL"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSQL"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSQL"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSQL"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>sysadmin*</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>Yes</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSQLA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_SRVA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSQLA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_SRVA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSQLA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_SRVA_PASSWORD']"></xsl:variable><![CDATA[   
      <purpose>SQL Server Agent Account</purpose>
            <domain>]]><xsl:value-of select="$userdomainSQLA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSQLA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSQLA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSQLA"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>n/a</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>Yes</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSQLI" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_INST_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSQLI" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_INST_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSQLI" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SQL_INST_PASSWORD']"></xsl:variable><![CDATA[   
      <purpose>SQL Server Install Account</purpose>
                <domain>]]><xsl:value-of select="$userdomainSQLI"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSQLI"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSQLI"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSQLI"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>dbcreator/securityadmin</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>Yes</logonlocally>
      <localadmin>Yes</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSPCA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CACHEA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPCA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CACHEA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPCA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CACHEA_PASSWORD']"></xsl:variable><![CDATA[   
      <purpose>Portal Super User Account</purpose>
      <domain>]]><xsl:value-of select="$userdomainSPCA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPCA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPCA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPCA"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>n/a</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>No</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainSPCR" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CACHER_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPCR" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CACHER_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPCR" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CACHER_PASSWORD']"></xsl:variable><![CDATA[   
      <purpose>Portal Super Reader Account</purpose>
      <domain>]]><xsl:value-of select="$userdomainSPCR"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPCR"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPCR"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPCR"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>n/a</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>No</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainCRAWL" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CRAWL_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameCRAWL" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CRAWL_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordCRAWL" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_CRAWL_PASSWORD']"></xsl:variable><![CDATA[ 
      <purpose>Search Crawl Account</purpose>
      <domain>]]><xsl:value-of select="$userdomainCRAWL"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameCRAWL"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameCRAWL"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordCRAWL"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>No</logonlocally>
      <localadmin>No</localadmin>
    </managedaccount>
    <managedaccount>
         ]]><xsl:variable name="userdomainTSYS" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_TSYSA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameTSYS" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_TSYSA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordTSYS" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_TSYSA_PASSWORD']"></xsl:variable><![CDATA[     
      <purpose>T-Systems Administrator Account</purpose>
    <domain>]]><xsl:value-of select="$userdomainTSYS"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameTSYS"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameTSYS"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordTSYS"/><![CDATA[</password>
      <issharepointmanagedaccount>No</issharepointmanagedaccount>
      <sqlpermissions>dbcreator/securityadmin</sqlpermissions>
      <adpermissions>Domain User</adpermissions>
      <logonlocally>Yes</logonlocally>
      <localadmin>Yes</localadmin>
    </managedaccount>
  </managedaccounts>
  <testuseraccounts>
    <!--<useraccount>
      <domain>tsi</domain>
      <username>bwilson</username>
      <displayname>Brian Wilson</displayname>
      <email>bwilson@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>dwilson</username>
      <displayname>Dennis Wilson</displayname>
      <email>dwilson@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>cwilson</username>
      <displayname>Carl Wilson</displayname>
      <email>cwilson@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>mlove</username>
      <displayname>Mike Love</displayname>
      <email>mlove@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>ajardine</username>
      <displayname>Al Jardine</displayname>
      <email>ajardine@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>ahitchcock</username>
      <displayname>Alfred Hitchcock</displayname>
      <email>ahitchcock@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>sconnery</username>
      <displayname>Sean Connery</displayname>
      <email>sconnery@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>rmoore</username>
      <displayname>Roger Moore</displayname>
      <email>rmoore@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>jennis</username>
      <displayname>Jessica Ennis</displayname>
      <email>jennis@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>
    <useraccount>
      <domain>tsi</domain>
      <username>glineker</username>
      <displayname>Gary Lineker</displayname>
      <email>glineker@tsi.com</email>
      <password>D1sabl3d281660</password>
      <createmysite>Yes</createmysite>
      <adgroup>Print Operators</adgroup>
    </useraccount>-->
    <useraccount/>
    <useraccount/>
  </testuseraccounts>
  <servers>
    <server/>
    <server/>
    <server/>
    <server/>
    <server/>
  </servers>
  <serveripaddresses>
    <serveripaddress/>
    <serveripaddress/>
    <serveripaddress/>
    <serveripaddress/>
  </serveripaddresses>
  <farmserviceextensions>
  ]]>
  <xsl:for-each select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='serviceextensions']/serviceextension">
      <xsl:if test="name!=''">
        <![CDATA[
        <serviceextention name="]]><xsl:value-of select="@name"/><![CDATA[" values="]]><xsl:value-of select="@values"/><![CDATA["/>]]>
  </xsl:if>
  </xsl:for-each>
    <![CDATA[    
  </farmserviceextensions>
  <sqlinstances>
    <sqlinstance>
      <name>ES</name>
      <instanceid>1</instanceid>
      <aliasname>SQLGEN_01_G1</aliasname>
      <ipaddress>192.168.0.89</ipaddress>
      <port>3625</port>
      <type>General</type>
    </sqlinstance>
  </sqlinstances>
  <webapplications>
    <webapplication>
      <name>Search</name>
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[</url>
      <serviceapplicationproxygroup>Default</serviceapplicationproxygroup>      
      <contentDBPrefix>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SHORTCUSTOMERNAME']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/>_<xsl:value-of select="//customerandenvironmentsettings/farmnumber"/><![CDATA[_Search_SPContent</contentDBPrefix>
      <numberContentDBs>1</numberContentDBs>
      <blobcachesize>1</blobcachesize>
      <sitetemplate>SRCHCEN#0</sitetemplate>
      <quota>5GB</quota>
      <defaultauthprovider>Claims-NTLM</defaultauthprovider>
      <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <searchcrawlzoneconfiguration>No</searchcrawlzoneconfiguration>
    </webapplication>
  </webapplications>
  <managedpaths>
    <managedpath>
      <webapplication>Search</webapplication>
      <path>userprofiles</path>
      <explicit>Yes</explicit>
    </managedpath>
    <managedpath>
      <webapplication>Search</webapplication>
      <path>personal</path>
      <explicit>No</explicit>
    </managedpath>
    <managedpath/>
    <managedpath/>
  </managedpaths>
  <sitecollections>
    <sitecollection>
      <webapplication>Search</webapplication>
      <name>Team Collab</name>
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/sites/teamcollab</url>
      <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>STS#0</sitetemplate>
      <quota>5GB</quota>
    </sitecollection>
    <sitecollection>
      <webapplication>Search</webapplication>
      <name>Users</name>
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/userprofiles</url>
         <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>SPSMSITEHOST#0</sitetemplate>
      <quota>5GB</quota>
    </sitecollection>
    <sitecollection/>
    <sitecollection/>
  </sitecollections>
  <webapplicationsettings>
    <webapplicationsetting>
      <webapplicationname>Search</webapplicationname>
      <settingname>MaximumFileSize</settingname>
      <settingvalue>100</settingvalue>
    </webapplicationsetting>
    <webapplicationsetting>
      <webapplicationname>Search</webapplicationname>
      <settingname>BrowserFileHandling</settingname>
      <settingvalue>Permissive</settingvalue>
    </webapplicationsetting>
    <webapplicationsetting>
      <webapplicationname>Search</webapplicationname>
      <settingname>AllowDesigner</settingname>
      <settingvalue>$true</settingvalue>
    </webapplicationsetting>
    <webapplicationsetting>
      <webapplicationname>Search</webapplicationname>
      <settingname>ShowURLStructure</settingname>
      <settingvalue>$true</settingvalue>
    </webapplicationsetting>
    <webapplicationsetting>
      <webapplicationname>Search</webapplicationname>
      <settingname>AllowRevertFromTemplate</settingname>
      <settingvalue>$false</settingvalue>
    </webapplicationsetting>
    <webapplicationsetting>
      <webapplicationname>Search</webapplicationname>
      <settingname>AllowMasterPageEditing</settingname>
      <settingvalue>$false</settingvalue>
    </webapplicationsetting>
  </webapplicationsettings>
  <serviceapplications>
    <serviceapplication>
      <name>Access Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Access Services 2010</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>App Management Service</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Business Data Connectivity Service</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Excel Services Application</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Machine Translation Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Managed Metadata Service</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Performance Point Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>PowerPoint Service Application</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Project Server Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Search Service Application</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Secure Store Service</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>State Service</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Microsoft SharePoint Foundation Subscription Settings Service Application</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>    
     <serviceapplication>
      <name>Usage and Health Data Collection</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>    
    <serviceapplication>
      <name>User Profile Service Application</name>
      <enable>Yes</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Visio Graphics Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Word Automation Services</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Word Viewing Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
    <serviceapplication>
      <name>Work Management Service</name>
      <enable>No</enable>
      <indefaultproxygroup>Yes</indefaultproxygroup>
      <consumeserviceapplication>No</consumeserviceapplication>
    </serviceapplication>
  </serviceapplications>
  <serviceapplicationsettings>
    <serviceapplicationsetting>
      <serviceapplicationname>Managed Metadata Service</serviceapplicationname>
      <settingname>TermStoreAdministrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</settingvalue>
    </serviceapplicationsetting>
    <serviceapplicationsetting>
      <serviceapplicationname>Managed Metadata Service</serviceapplicationname>
      <settingname>TermStoreAdministrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</settingvalue>
    </serviceapplicationsetting>
<serviceapplicationsetting>
      <serviceapplicationname>User Profile Service Application</serviceapplicationname>
    </serviceapplicationsetting>
    <serviceapplicationsetting>
      <serviceapplicationname>User Profile Service Application</serviceapplicationname>
      <settingname>MySiteNamingFormat</settingname>
      <settingvalue>2</settingvalue>
    </serviceapplicationsetting>
  </serviceapplicationsettings>
 <windowsfirewallsettings>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDP</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>16372</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>16373</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTPS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>16372</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>16373</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTPS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
      <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Web Server Group 1</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    
    
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDB</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
     <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
     <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
   

    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
   
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>

          <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
   
   
   
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDB</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
   <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
   
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>

          <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
   
   
   
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDB</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
   <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 2</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
   
   
   
   
   
   
   
   
   
   
   
   
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
   
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>

          <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
   
   
   
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDB</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
   <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 3</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
   
   
   
   
   
   
   
   
   
   
   
   
   
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>3625</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL SP-Search DB Instances</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>3625</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL SP-Search DB Instances</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>3626</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL SP-Content DB Instances</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>3626</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL SP-Content DB Instances</rulename>
    </windowsfirewallsetting>   
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>1434</incomingport>
      <action>Deny</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Block SQL Browser Port</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>5022</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Cluster</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>5022</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Cluster</rulename>
    </windowsfirewallsetting>
    
   
  </windowsfirewallsettings>
  <smtpservers>
    <smtpserver>
      <outgoingsmtp>smtp-tsi.com</outgoingsmtp>
      <senderaddress>sharepoint@tsi.com</senderaddress>
      <replytoemailaddress>sharepoint.no-reply@tsi.com</replytoemailaddress>
      <folderlocation>c:\inetpub\mailroot</folderlocation>
    </smtpserver>
  </smtpservers>
  <productversions>
    <productversion>
      <product>T-Systems Build Scripts</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\SPScripts</binary>
    </productversion>
    <productversion>
      <product>WSPs</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\RTM\SharePoint\WSPs</binary>
    </productversion>
    <productversion>
      <product>SharePoint Server</product>
      <install>Yes</install>
      <producttype>Server Product</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\RTM\SharePoint\Server Media</binary>
      <exe>setup.exe</exe>
      <license>N3MDM-DXR3H-JD7QH-QKKCR-BY2Y7</license>
    </productversion>
    <productversion>
			<product>SQL Server</product>
			<install>Yes</install>
			<producttype>Server Product</producttype>
			<version>2012</version>
			<binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\SQL Server 2012 Std</binary>
			<exe>setup.exe</exe>
		</productversion>
    <productversion>
      <product>Certificates</product>
      <install>Yes</install>
      <producttype>Build Script</producttype>
      <version>Certificates</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\SSL</binary>
      <license>d1sabl3d</license>
    </productversion>
    <productversion>
      <product>Spanish</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\Language Packs\Spanish</binary>
      <exe>setup.exe</exe>
    </productversion>


 <productversion>
      <product>German</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\Language Packs\German</binary>
      <exe>setup.exe</exe>
    </productversion>
 

 <productversion>
      <product>Japanese</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\Language Packs\Japanese</binary>
      <exe>setup.exe</exe>
    </productversion>


 <productversion>
      <product>French</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\Language Packs\French</binary>
      <exe>setup.exe</exe>
    </productversion>

   
    <productversion>
      <product>March 2013 PU</product>
      <install>Yes</install>
      <producttype>Cumulative Update</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\Cumulative Updates\Mar13</binary>
      <exe>ubersrvsp2013-kb2767999-fullfile-x64-glb.exe</exe>
    </productversion>

    <productversion>
      <product>April 2013 Cumulative Update</product>
      <install>Yes</install>
      <producttype>Cumulative Update</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\Solution Artifacts\Binary Package\Installation Media\Cumulative Updates\Apr13</binary>
      <exe>ubersrv2013-kb2726992-fullfile-x64-glb.exe</exe>
    </productversion>

  </productversions>


  <userprofileservicesettings>
  
   ]]><xsl:variable name="domainUPS" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_USERNAME'],'\'))"></xsl:variable>
  <xsl:variable name="usernameUPS" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_USERNAME'],'\'))"></xsl:variable>
  <xsl:variable name="passwordUPS" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_PASSWORD']"></xsl:variable><![CDATA[     
    <userprofileservicesetting>
      <connectorname>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_DOMAIN']"/><![CDATA[</connectorname>
      <forestname>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_FOREST']"/><![CDATA[</forestname>
      <ou>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_OU']"/><![CDATA[</ou>
      <importfilter>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROFILE_Filter']"/><![CDATA[</importfilter>
      <useraccount>]]><xsl:value-of select="$usernameUPS"/><![CDATA[</useraccount>
      <password>]]><xsl:value-of select="$passwordUPS"/><![CDATA[</password>
      <mysitehostlocation>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/userprofiles</mysitehostlocation>
      <mysitepersonalpath>personal</mysitepersonalpath>
    </userprofileservicesetting>
    <userprofileservicesetting/>
    <userprofileservicesetting/>
  </userprofileservicesettings>
  <allserviceextensions>
    <serviceextension>
      <name>Enhanced Query Processing</name>
    </serviceextension>
    <serviceextension>
      <name>Custom Query Suggestions</name>
    </serviceextension>
    <serviceextension>
      <name>Custom Rank Models</name>
    </serviceextension>
    <serviceextension>
      <name>Language Packs</name>
    </serviceextension>
    <serviceextension>
      <name>Result Sources</name>
    </serviceextension>
    <serviceextension>
      <name>eDiscovery Extensions</name>
    </serviceextension>
    <serviceextension>
      <name>Enterprise Connections</name>
    </serviceextension>
    <serviceextension>
      <name>Support for custom solutions</name>
    </serviceextension>
    <serviceextension>
      <name>Search Parts</name>
    </serviceextension>
    <serviceextension>
      <name>Reporting of key data</name>
    </serviceextension>
    <serviceextension>
      <name>Proactive patch management</name>
    </serviceextension>
    <serviceextension>
      <name>Proactive capacity management</name>
    </serviceextension>
    <serviceextension>
      <name>Application monitoring</name>
    </serviceextension>
    <serviceextension>
      <name>Disaster recovery</name>
    </serviceextension>
    <serviceextension>
      <name>Security Event Monitoring</name>
    </serviceextension>
    <serviceextension>
      <name>Full time support</name>
    </serviceextension>
    <serviceextension>
      <name>Data Center Location</name>
    </serviceextension>
    <serviceextension>
      <name>Business Service Desk</name>
    </serviceextension>
    <serviceextension>
      <name>License Management</name>
    </serviceextension>
    <serviceextension>
      <name>Patch/Release Management</name>
    </serviceextension>
  </allserviceextensions>
  <serviceapproxygroups>
    <serviceapproxygroup>
      <name>Partner</name>
    </serviceapproxygroup>
    <serviceapproxygroup>
      <name>Default</name>
    </serviceapproxygroup>
  </serviceapproxygroups>
  <searchsettings>
    <searchsetting>
      <numbercrawldbs>2</numbercrawldbs>
      <numberlinksdbs>1</numberlinksdbs>
      <numberanalyticsdbs>1</numberanalyticsdbs>
      <numberadmindbs>1</numberadmindbs>
      <numbercrawlcomponentsperserver>1</numbercrawlcomponentsperserver>
      <numberofindexpartitions>1</numberofindexpartitions>
      <numberqpccomponentsperserver>1</numberqpccomponentsperserver>
      <numbercpccomponentsperserver>1</numbercpccomponentsperserver>
      <numberapccomponentsperserver>1</numberapccomponentsperserver>
      <numberadmincomponentsperserver>1</numberadmincomponentsperserver>
      <indexlocation>c:\SharePointIndex</indexlocation>
      <queryindexlocation>G:\SharePointIndex</queryindexlocation>
      <searchproxy>]]><xsl:value-of select="normalize-space(//customerandenvironmentsettings/searchproxy)"/><![CDATA[</searchproxy>
      <searchcentreURL>]]><xsl:value-of select="normalize-space(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL'])"/><![CDATA[/pages</searchcentreURL>
      <searchproxyforfederated>Yes</searchproxyforfederated>
    </searchsetting>
  </searchsettings>
  <contentsources>
  ]]>
    <xsl:variable name="hostonlysearchcentreurl" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL'],'://'))"></xsl:variable>
    <![CDATA[
  <contentsource>
						  <type>SharePoint</type>
							<values>sps3s://]]><xsl:value-of select="$hostonlysearchcentreurl"/><![CDATA[</values>
              <depth>ThisLevel</depth>
  </contentsource>
  ]]>


    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_WEB']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_WEB']"/>
        <xsl:with-param name="type" select="'Web'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_FILE']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_FILE']"/>
        <xsl:with-param name="type" select="'File'"/>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_BUSINESS']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_BUSINESS']"/>
        <xsl:with-param name="type" select="'Business'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_SP']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CONTENT_SP']"/>
        <xsl:with-param name="type" select="'SharePoint'"/>
      </xsl:call-template>
    </xsl:if>
      
    <![CDATA[
  </contentsources>
  <defaultpermissionsspgroups>
    <!--<defaultpermissionspgroup>
      <groupname>Farm Administrators</groupname>
      <adobject>tsi\administrator</adobject>
    </defaultpermissionspgroup>-->
     <defaultpermissionspgroup>
      <groupname>Farm Administrators</groupname>
      <adobject>]]><xsl:value-of select="$userdomainTSYS"/>\<xsl:value-of select="$usernameTSYS"/><![CDATA[</adobject>
    </defaultpermissionspgroup>
  </defaultpermissionsspgroups>
  <defaultpermissionsuserpolicies>
    <defaultpermissionsuserpolicy>
      <policyname>Full Control</policyname>
      <adobject>tsi\rmoore</adobject>
      <webapplication>Search</webapplication>
      <zone>Default</zone>
    </defaultpermissionsuserpolicy>
    <defaultpermissionsuserpolicy/>
  </defaultpermissionsuserpolicies>
  <noncontentdbs>
    <noncontentdb>
      <db>ManagedMetadata_svc</db>
      <dbname>ES_PRO_DE_01_ManagedMetadata_svc</dbname>
      <dbnamenoprefix>ManagedMetadata_svc</dbnamenoprefix>
      <serviceapplicationname>Managed Metadata service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>Bdc_svc</db>
      <dbname>ES_PRO_DE_01_Bdc_svc</dbname>
      <dbnamenoprefix>Bdc_svc</dbnamenoprefix>
      <serviceapplicationname>Business Data Connectivity service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>SecureStore_svc</db>
      <dbname>ES_PRO_DE_01_SecureStore_svc</dbname>
      <dbnamenoprefix>SecureStore_svc</dbnamenoprefix>
      <serviceapplicationname>Secure store service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>State_svc</db>
      <dbname>ES_PRO_DE_01_State_svc</dbname>
      <dbnamenoprefix>State_svc</dbnamenoprefix>
      <serviceapplicationname>State Service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>Usage_svc</db>
      <dbname>ES_PRO_DE_01_Usage_svc</dbname>
      <dbnamenoprefix>Usage_svc</dbnamenoprefix>
      <serviceapplicationname>Usage and Health Data Collection Service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>    
     <noncontentdb>
      <db>SubscriptionSettings_svc</db>
      <dbname>ES_PRO_DE_01_SubscriptionSettings_svc</dbname>
      <dbnamenoprefix>SubscriptionSettings_svc</dbnamenoprefix>
      <serviceapplicationname>Microsoft SharePoint Foundation Subscription Settings Service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>SP_Config</db>
      <dbname>ES_PRO_DE_01_SP_Config</dbname>
      <dbnamenoprefix>SP_Config</dbnamenoprefix>
      <serviceapplicationname>Central Administration</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>CentralAdmin_Content</db>
      <dbname>ES_PRO_DE_01_CentralAdmin_Content</dbname>
      <dbnamenoprefix>CentralAdmin_Content</dbnamenoprefix>
      <serviceapplicationname>Central Administration</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    
    <noncontentdb>
      <db>UserProfileSocial_svc</db>
      <dbname>ES_PRO_DE_01_UserProfileSocial_svc</dbname>
      <dbnamenoprefix>UserProfileSocial_svc</dbnamenoprefix>
      <serviceapplicationname>User Profile service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>UserProfileSync_svc</db>
      <dbname>ES_PRO_DE_01_UserProfileSync_svc</dbname>
      <dbnamenoprefix>UserProfileSync_svc</dbnamenoprefix>
      <serviceapplicationname>User Profile service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>UserProfile_svc</db>
      <dbname>ES_PRO_DE_01_UserProfile_svc</dbname>
      <dbnamenoprefix>UserProfile_svc</dbnamenoprefix>
      <serviceapplicationname>User Profile service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>App_Management_svc</db>
      <dbname>ES_PRO_DE_01_App_Management_svc</dbname>
      <dbnamenoprefix>App_Management_svc</dbnamenoprefix>
      <serviceapplicationname>App Management Service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
    <noncontentdb>
      <db>Translation_svc</db>
      <dbname>ES_PRO_DE_01_Translation_svc</dbname>
      <dbnamenoprefix>Translation_svc</dbnamenoprefix>
      <serviceapplicationname>Machine Translation Service</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
   <!-- <noncontentdb>
      <db>Cache_Config</db>
      <dbname>ES_PRO_DE_01_Cache_Config</dbname>
      <dbnamenoprefix>Cache_Config</dbnamenoprefix>
      <serviceapplicationname>Distributed Cache Cluster</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>
-->

</noncontentdbs>
  <disablehealthrules>
    <rule>Accounts used by application pools or service identities are in the local machine Administrators group.</rule>
    <rule>Databases exist on servers running SharePoint Foundation.</rule>
    <rule>The paging file size should exceed the amount of physical RAM in the system.</rule>
    <rule>Missing server side dependencies.</rule>
    <rule>Verify that the Activity Feed Timer Job is enabled</rule>
    <rule>Built-in accounts are used as application pool or service identities.</rule>
    <rule>Verify each User Profile Service Application has an associated Search Service Connection</rule>
    <rule>Verify each User Profile Service Application has a My Site Host configured</rule>
    <rule>Database has large amounts of unused space.</rule>
    <rule>Drives are running out of free space.</rule>
    <rule>Drives are at risk of running out of free space.</rule>
    <rule>Verify that the critical User Profile Application and User Profile Proxy Application timer jobs are available and have not been mistakenly deleted.</rule>
    <rule>Some content databases are growing too large.</rule>
    <rule>The server farm account should not be used for other services.</rule>
    <rule>Validate the My Site Host and individual My Sites are on a dedicated Web application and separate URL domain.</rule>
    <rule>People search relevance is not optimized when the Active Directory has errors in the manager reporting structure.</rule>
	<rule>Outbound e-mail has not been configured.</rule>
  </disablehealthrules>
  <farmwsps>
    <farmwsp/>
    <farmwsp/>
  </farmwsps>
  <featureactivations>
    <featureactivation/>
    <featureactivation/>
  </featureactivations>

    <zimoryconfiguration>
      <baseurl>]]><xsl:value-of select="//zimorysettings/baseurl"/><![CDATA[</baseurl>
      <certificatepath>]]><xsl:value-of select="//zimorysettings/certificatepath"/><![CDATA[</certificatepath>
      <certificatepassword>]]><xsl:value-of select="//zimorysettings/certificatepassword"/><![CDATA[</certificatepassword>
      <hostentry>]]><xsl:value-of select="//zimorysettings/hostentry"/><![CDATA[</hostentry>
    </zimoryconfiguration>
    
<clusterconfiguration>
      <clusterip>]]><xsl:value-of select="//clustersettings/clusterip"/><![CDATA[</clusterip>
      <listenerip>]]><xsl:value-of select="//clustersettings/listenerip"/><![CDATA[</listenerip>
    </clusterconfiguration>



    <azureconfiguration>
      <jsonurl>]]><xsl:value-of select="//azuremobileservice/jsonurl"/><![CDATA[</jsonurl>
      <applicationkey>]]><xsl:value-of select="//azuremobileservice/applicationkey"/><![CDATA[</applicationkey>
      <registrationstable>]]><xsl:value-of select="//azuremobileservice/registrationstable"/><![CDATA[</registrationstable>
      <sessiontable>]]><xsl:value-of select="//azuremobileservice/sessiontable"/><![CDATA[</sessiontable>
      <sessiondetailtable>]]><xsl:value-of select="//azuremobileservice/sessiondetailtable"/><![CDATA[</sessiondetailtable>
      <customertable>]]><xsl:value-of select="//azuremobileservice/customertable"/><![CDATA[</customertable>
      <customerid>]]><xsl:value-of select="//azuremobileservice/customerid"/><![CDATA[</customerid>
      
    </azureconfiguration>
    


    </farm>
    
]]>

 
    
  </xsl:template>
</xsl:stylesheet>