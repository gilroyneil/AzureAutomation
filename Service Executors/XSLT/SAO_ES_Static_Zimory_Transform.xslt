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
  <farmtype>ES</farmtype>


<SPHive>]]><xsl:value-of select="//customerandenvironmentsettings/SPHive"/><![CDATA[</SPHive>
<SSACloudIndex>]]><xsl:value-of select="//customerandenvironmentsettings/SSACloudIndex"/><![CDATA[</SSACloudIndex>

  <webAppDomain>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[</webAppDomain>
  <webAppDomainApps></webAppDomainApps>
<subscriptionID>TestSubscriptionID</subscriptionID>
<useCentralBackupLocation>]]><xsl:value-of select="//customerandenvironmentsettings/UseCentralBackupStore"/><![CDATA[</useCentralBackupLocation>
<centralBackupLocation>]]><xsl:value-of select="//customeronboardingdata/BackupShare"/><![CDATA[</centralBackupLocation>
<centralClusterLocation>]]><xsl:value-of select="//customeronboardingdata/QuorumShare"/><![CDATA[</centralClusterLocation>

  <makeADandDNSChanges_precreated>]]><xsl:value-of select="//clustersettings/precreated_es/makeADandDNSChanges"/><![CDATA[</makeADandDNSChanges_precreated>
  <startClusterIP>]]><xsl:value-of select="//clustersettings/dynamic/starting_clusterip"/><![CDATA[</startClusterIP>
  <startListenerIP>]]><xsl:value-of select="//clustersettings/dynamic/starting_listenerip"/><![CDATA[</startListenerIP>
  <createDNSObjects>]]><xsl:value-of select="//clustersettings/dynamic/createDNSObjects"/><![CDATA[</createDNSObjects>

  <useDynamicAlwaysOnSettings>]]><xsl:value-of select="//clustersettings/useDynamic"/><![CDATA[</useDynamicAlwaysOnSettings>
  <isHAInstall>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_HA']"/><![CDATA[</isHAInstall>
  <doInstallBAI>]]><xsl:value-of select="//customerandenvironmentsettings/InstallBAIForESService"/><![CDATA[</doInstallBAI>
  <doUseSmallSQLDBs>]]><xsl:value-of select="//customerandenvironmentsettings/useSmallDBPreSizingForDevInstalls"/><![CDATA[</doUseSmallSQLDBs>
  <doUseSmallDriveSizesForCIC>]]><xsl:value-of select="//customerandenvironmentsettings/doUseSmallDriveSizesForCIC"/><![CDATA[</doUseSmallDriveSizesForCIC>
  <doUse100GBFixedDriveSizes>]]><xsl:value-of select="//customerandenvironmentsettings/doUse100GBFixedDriveSizes"/><![CDATA[</doUse100GBFixedDriveSizes>

  <isWin2012>]]><xsl:value-of select="//customerandenvironmentsettings/isWin2012"/><![CDATA[</isWin2012>
  <windows2012Version>]]><xsl:value-of select="//customerandenvironmentsettings/windows2012Version"/><![CDATA[</windows2012Version>
  <isSP2013SP1>]]><xsl:value-of select="//customerandenvironmentsettings/isSP2013SP1"/><![CDATA[</isSP2013SP1>
    <servicequality>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SERVICEQUALITY']"/><![CDATA[</servicequality>
  <businessunit>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_BUSINESSUNIT']"/><![CDATA[</businessunit>
  <!--NG 3.5.1 Make SSRS mandatory-->
  <installSSRS>true</installSSRS>
  
  <privateipwebapps>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PRIVATE_IP_WEBAPPS']"/><![CDATA[</privateipwebapps>
  <publicipwebapps>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PUBLIC_IP_WEBAPPS']"/><![CDATA[</publicipwebapps>
  

  <proxyserver>]]><xsl:value-of select="normalize-space(//customeronboardingdata/ProxyServer)"/><![CDATA[</proxyserver>
  <sslpassword>]]><xsl:value-of select="normalize-space(//customeronboardingdata/SSLPassword)"/><![CDATA[</sslpassword>
  <standardusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_STANDARD_USERS_AD_GROUP']"/><![CDATA[</standardusers>
  <enterpriseusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_ENTERPRISE_USERS_AD_GROUP']"/><![CDATA[</enterpriseusers>
  
  
  
  <devseat>]]><xsl:choose>
    <xsl:when test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE'] = 'DES' and //customerandenvironmentsettings/supportDevSeat = 'True'">True</xsl:when>
    <xsl:otherwise>False</xsl:otherwise>
  </xsl:choose><![CDATA[</devseat>
  <isemp>]]><xsl:value-of select="//customerandenvironmentsettings/isEMPDeployment"/><![CDATA[</isemp>
<overideIndexItemCountWithThisValue>0</overideIndexItemCountWithThisValue>
  <deploymentserver>]]><xsl:value-of select="//customerandenvironmentsettings/deploymentserver"/><![CDATA[</deploymentserver>
  <mediaserver>]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[</mediaserver>
  <localmediapath>]]><xsl:value-of select="//customerandenvironmentsettings/localmediapath"/><![CDATA[</localmediapath>
  <langpackslocation>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\MediaShare\Language Packs</langpackslocation>


  <createAllClusterElements>]]><xsl:value-of select="//customerandenvironmentsettings/createAllClusterElements"/><![CDATA[</createAllClusterElements>

  <uselocaladminaccountforstartupscripts>]]><xsl:value-of select="//customerandenvironmentsettings/useLocalAdministratorForStartupScripts"/><![CDATA[</uselocaladminaccountforstartupscripts>
  <numberofusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_NUMBEROFUSERS']"/><![CDATA[</numberofusers>
  <purpose>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/><![CDATA[</purpose>
    <mysitequota>5MB</mysitequota>
  
  <farmname>SPS_]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[1</farmname>
  <farmnumber>1</farmnumber>
    <createdomain>]]><xsl:choose>
    <xsl:when test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE'] = 'DES' and //customerandenvironmentsettings/devseatisdc = 'True' and //customerandenvironmentsettings/supportDevSeat = 'True'">Yes</xsl:when>
    <xsl:otherwise>No</xsl:otherwise>
  </xsl:choose><![CDATA[</createdomain>
    <joindomain>]]><xsl:choose>
    <xsl:when test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE'] = 'DES' and //customerandenvironmentsettings/devseatisdc = 'True' and //customerandenvironmentsettings/supportDevSeat = 'True'">No</xsl:when>
    <xsl:otherwise>Yes</xsl:otherwise>
  </xsl:choose><![CDATA[</joindomain>
  
  <testaccountsOU>Test Search Accounts</testaccountsOU>
  <serviceaccountsOU>Enterprise Search Service Accounts</serviceaccountsOU>
  <restrictsitedefinitions>Yes</restrictsitedefinitions>
  <location>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[</location>
  <customer>UNKNOWN</customer>
  <customerabreviation>UNK</customerabreviation>
  
  <passphrase>1#SPS_]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[_1#1</passphrase>
  <requireddocumentstorage>25</requireddocumentstorage>
  <amountofdocuments>100000</amountofdocuments>
  <totalcontentdbsize>10</totalcontentdbsize>
  <searchdbsize>11.769</searchdbsize>
  <otherdbsize>13.75</otherdbsize>  
  <backupstorageneeded>0</backupstorageneeded> 
  <baipreviewcachemaxsizeMB>1000</baipreviewcachemaxsizeMB> 
   <fixeddatagrowthsizeMB>0</fixeddatagrowthsizeMB>
 <fixedloggrowthsizeMB>0</fixedloggrowthsizeMB>
 
  <amountindexeditems>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_AMOUNTINDEXEDITEMS']"/><![CDATA[</amountindexeditems>
  <contentdbmaxsize>400</contentdbmaxsize>
  <sqlinstancemaxsizeGB>4000</sqlinstancemaxsizeGB>
  <averagedocumentsizekb>750</averagedocumentsizekb> 
  <contentdbdefaultsize>5</contentdbdefaultsize>
  <numbercontentdbspersqlinstance>10</numbercontentdbspersqlinstance>
  <searchbackuppath>\\wfe1\SearchBackup</searchbackuppath>
  <securestoremasterkey>Sc0uting47_1</securestoremasterkey>
  <securestoreappkey>Sc0uting47_1</securestoreappkey>
  <blobcachelocation>E:\Data\BlobCache\</blobcachelocation>
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
      <shortdomainame>]]><xsl:value-of select="//customeronboardingdata/DomainShortName"/><![CDATA[</shortdomainame>
      <forestdomainname>]]><xsl:value-of select="//customeronboardingdata/DomainFullName"/><![CDATA[</forestdomainname>
      <dcip>]]><xsl:value-of select="//customeronboardingdata/DC_IP"/><![CDATA[</dcip>
      <username>]]><xsl:value-of select="//customeronboardingdata/DomainJoinUserName"/><![CDATA[</username>
      <password>]]><xsl:value-of select="//customeronboardingdata/DomainJoinPassword"/><![CDATA[</password>
      <localadminpassword>]]><xsl:value-of select="//customerandenvironmentsettings/localAdminPassword"/><![CDATA[</localadminpassword>
      <ou>]]><xsl:value-of select="//customeronboardingdata/DomainJoinOU"/><![CDATA[</ou>
    </settings>
  </domainjoinsettings>
  <farmfederationsettings>
    <farmfederationsetting/>
    <farmfederationsetting/>
  </farmfederationsettings>
  
  
  
  

]]><xsl:choose>
    <xsl:when test="//customerandenvironmentsettings/doUseSmallDriveSizesForCIC = 'True'">
 <![CDATA[
 
  
   <vmtemplates>

    <vmtemplate>
      <name>Virtual-S</name>
      <description>Small Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>1</cores>
      <ram>4096</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-M</name>
      <description>Medium Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>2</cores>
      <ram>6144</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-L</name>
      <description>Large Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>1</cores>
      <ram>4096</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XL</name>
      <description>Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>1</cores>
      <ram>4096</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XXL</name>
      <description>Super Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>1</cores>
      <ram>4096</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
  </vmtemplates>
  
  
]]>
</xsl:when>
  <xsl:otherwise>
    <![CDATA[



   <vmtemplates>

    <vmtemplate>
      <name>Virtual-S</name>
      <description>Small Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>4</cores>
      <ram>8192</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-M</name>
      <description>Medium Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>4</cores>
      <ram>16384</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-L</name>
      <description>Large Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>4</cores>
      <ram>32768</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XL</name>
      <description>Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>8</cores>
      <ram>16384</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XXL</name>
      <description>Super Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>8</cores>
      <ram>32768</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
  </vmtemplates>


]]>
      </xsl:otherwise>
    
    </xsl:choose>
    <![CDATA[


 <servergroups>
  <servergroup>
      <name>WAC Server</name>
      <description>Webserver and CA</description>
      <requirednumber>2</requirednumber>
      <needsexternalip>No</needsexternalip>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize>160</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>


]]><xsl:choose>
    <xsl:when test="//customerandenvironmentsettings/doUseSmallDriveSizesForCIC = 'True'">
 <![CDATA[


<servergroup>
      <name>Web Server Group 1</name>
      <description>Webserver and CA</description>
      <needsexternalip>Yes</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
<servergroup>
      <name>Web Server Group 2</name>
      <description>Webserver and CA</description>
      <needsexternalip>Yes</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>60</edrivevhdsize>
     <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    
    <servergroup>
      <name>Application Server Group 1</name>
      <description>All non search Service Apps and SP Admin and APC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
     <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>    
      <fdrivevhdsize>1</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
     <servergroup>
      <name>Application Server Group 2</name>
      <description>APC DEPRECATED</description>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
     <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 1</name>
      <description>Index and QPC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
    <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>
      <fdrivevhdsize>20</fdrivevhdsize>    
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 2</name>
      <description>Index Server</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
   <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>
      <fdrivevhdsize>20</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 3</name>
      <description>Crawl and CPC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
     <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>  
<fdrivevhdsize>0</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    
    <servergroup>
      <name>Search Server Group 4</name>
      <description>APC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
     <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>  
<fdrivevhdsize>0</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    

  <servergroup>
      <name>BA Insight Preview Server</name>
      <description>Server that generates previews in search results</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
     <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>50</edrivevhdsize>  
<fdrivevhdsize>0</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize>0</hdrivevhdsize>
	<idrivevhdsize>0</idrivevhdsize>
	<jdrivevhdsize>0</jdrivevhdsize>
	<kdrivevhdsize>0</kdrivevhdsize>
	<ldrivevhdsize>0</ldrivevhdsize>
	<mdrivevhdsize>0</mdrivevhdsize>
 <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
<servergroup>
      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
    <cdrivevhdsize>81</cdrivevhdsize>
      <edrivevhdsize>30</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>120</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize>0</pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>

]]>
</xsl:when>
  <xsl:otherwise>
    <![CDATA[


]]><xsl:choose>
      <xsl:when test="//customerandenvironmentsettings/doUse100GBFixedDriveSizes = 'True'">
        <![CDATA[


<servergroup>
      <name>Web Server Group 1</name>
      <description>Webserver and CA</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize/>
      <idrivevhdsize/>
      <jdrivevhdsize/>
      <kdrivevhdsize/>
      <ldrivevhdsize/>
      <mdrivevhdsize/>
	<ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
	<servergroup>
      <name>Web Server Group 2</name>
      <description>CA and crawling</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>

    <servergroup>
      <name>Application Server Group 1</name>
      <description>All non search Service Apps and SP Admin and APC for small farms</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize> 
      <edrivevhdsize>100</edrivevhdsize>     
      <fdrivevhdsize>100</fdrivevhdsize>      
      <gdrivevhdsize>0</gdrivevhdsize>
      
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
     
    <servergroup>
      <name>Search Server Group 1</name>
      <description>Index and QPC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>100</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 2</name>
      <description>Index Server</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
     <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>100</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 3</name>
      <description>Crawl and CPC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
       <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
 <servergroup>
      <name>Search Server Group 4</name>
      <description>Admin and APC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>SQL Server for Content DBs</name>
      <description>SQL Server to host Content DBs</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>100</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>
<servergroup>
      <name>SQL Server for Search and Other DBs</name>
      <description>SQL Server to host Content DBs</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>  
     <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>100</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>

<servergroup>
      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
    <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>100</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>

]]>
      </xsl:when>
      <xsl:otherwise>
        <![CDATA[

<servergroup>
      <name>Web Server Group 1</name>
      <description>Webserver and CA</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
	<hdrivevhdsize/>
      <idrivevhdsize/>
      <jdrivevhdsize/>
      <kdrivevhdsize/>
      <ldrivevhdsize/>
      <mdrivevhdsize/>
	<ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
	<servergroup>
      <name>Web Server Group 2</name>
      <description>CA and crawling</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>200</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>

    <servergroup>
      <name>Application Server Group 1</name>
      <description>All non search Service Apps and SP Admin and APC for small farms</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-M</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize> 
      <edrivevhdsize>100</edrivevhdsize>     
      <fdrivevhdsize>10</fdrivevhdsize>      
      <gdrivevhdsize>0</gdrivevhdsize>
      
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
     
    <servergroup>
      <name>Search Server Group 1</name>
      <description>Index and QPC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>500</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 2</name>
      <description>Index Server</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
     <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>500</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>Search Server Group 3</name>
      <description>Crawl and CPC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-XL</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
       <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
 <servergroup>
      <name>Search Server Group 4</name>
      <description>Admin and APC</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>0</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-S</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>300</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
      <gdrivevhdsize>0</gdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
    </servergroup>
    <servergroup>
      <name>SQL Server for Content DBs</name>
      <description>SQL Server to host Content DBs</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>  
      <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>0</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>
<servergroup>
      <name>SQL Server for Search and Other DBs</name>
      <description>SQL Server to host Content DBs</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
      <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>  
    <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>0</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>

<servergroup>
      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
    <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>0</fdrivevhdsize>
    <gdrivevhdsize>0</gdrivevhdsize>
      <hdrivevhdsize>0</hdrivevhdsize>
      <idrivevhdsize>0</idrivevhdsize>
      <jdrivevhdsize>0</jdrivevhdsize>
      <kdrivevhdsize>0</kdrivevhdsize>
      <ldrivevhdsize>0</ldrivevhdsize>
      <mdrivevhdsize>0</mdrivevhdsize>
      <ndrivevhdsize>0</ndrivevhdsize>
      <pdrivevhdsize></pdrivevhdsize>
      <nicservice>x</nicservice>
      <nicoperations>x</nicoperations>
      <nicbackup>x</nicbackup>
      <nicsqlreplication>x</nicsqlreplication>
    </servergroup>

]]>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
    </xsl:choose>
    <![CDATA[


    
    <servergroup>
      <name>Deploy Server</name>
      <description>A Server to install the farm from</description>
      <needsexternalip>No</needsexternalip>
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
      <name>5MB</name>
	<storagemax>5</storagemax>
	<storagewarning>4</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>
</quotatemplate>


    <quotatemplate>
      <name>250MB</name>
	<storagemax>250</storagemax>
	<storagewarning>210</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>
</quotatemplate>

    <quotatemplate>
      <name>1GB</name>
	<storagemax>1000</storagemax>
	<storagewarning>800</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>
    </quotatemplate>


    <quotatemplate>
      <name>2GB</name>
	<storagemax>2000</storagemax>
	<storagewarning>1600</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>
    </quotatemplate>

    <quotatemplate>
      <name>5GB</name>
	<storagemax>5000</storagemax>
	<storagewarning>4000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>
    </quotatemplate>

    <quotatemplate>
      <name>10GB</name>
	<storagemax>10000</storagemax>
	<storagewarning>8000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>

    </quotatemplate>
    <quotatemplate>
      <name>20GB</name>
	<storagemax>20000</storagemax>
	<storagewarning>16000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>
    </quotatemplate>
    <quotatemplate>
      <name>50GB</name>
	<storagemax>50000</storagemax>
	<storagewarning>40000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>

    </quotatemplate>
    <quotatemplate>
      <name>100GB</name>
	<storagemax>100000</storagemax>
	<storagewarning>80000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>

    </quotatemplate>    
    <quotatemplate>
      <name>200GB</name>
	<storagemax>200000</storagemax>
	<storagewarning>160000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>

    </quotatemplate>    
    
    
     <quotatemplate>
      <name>400GB</name>
	<storagemax>400000</storagemax>
	<storagewarning>320000</storagewarning>
	<usercodemax>300</usercodemax>
	<usercodewarning>200</usercodewarning>

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

  ]]>
    <!--[TB] SSRS-->
    <!-- NG - 3.5.1 - Make SSRS mandatory and dont require CSA XML-->
   <!-- <xsl:if test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_INSTALL_SSRS'] = 'true'">-->
    <![CDATA[
        <managedaccount>
             ]]><xsl:variable name="userdomainSPSSRS" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_SERVICE_USERNAME'],'\'))"></xsl:variable>
        <xsl:variable name="usernameSPSSRS" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_SERVICE_USERNAME'],'\'))"></xsl:variable>
        <xsl:variable name="passwordSPSSRS" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_SERVICE_PASSWORD']"></xsl:variable><![CDATA[    
          <purpose>Reporting Services Service Application Account</purpose>
          <domain>]]><xsl:value-of select="$userdomainSPSSRS"/><![CDATA[</domain>
          <username>]]><xsl:value-of select="$usernameSPSSRS"/><![CDATA[</username>
          <displayname>]]><xsl:value-of select="$usernameSPSSRS"/><![CDATA[</displayname>
          <passwordrequired>Yes</passwordrequired>
          <password>]]><xsl:value-of select="$passwordSPSSRS"/><![CDATA[</password>
          <issharepointmanagedaccount>Yes</issharepointmanagedaccount>
          <sqlpermissions>dbo for each content db</sqlpermissions>
          <adpermissions>Domain User</adpermissions>
          <logonlocally>No</logonlocally>
          <localadmin>No</localadmin>
        </managedaccount>
    ]]>
   <!-- </xsl:if> -->
    <![CDATA[


 <managedaccount>
         ]]><xsl:variable name="userdomainSPSearchSA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SSA_SP_SERVICE_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPSearchSA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SSA_SP_SERVICE_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPSearchSA" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SSA_SP_SERVICE_PASSWORD']"></xsl:variable><![CDATA[    
      <purpose>Search Service Application account</purpose>
      <domain>]]><xsl:value-of select="$userdomainSPSearchSA"/><![CDATA[</domain>
      <username>]]><xsl:value-of select="$usernameSPSearchSA"/><![CDATA[</username>
      <displayname>]]><xsl:value-of select="$usernameSPSearchSA"/><![CDATA[</displayname>
      <passwordrequired>Yes</passwordrequired>
      <password>]]><xsl:value-of select="$passwordSPSearchSA"/><![CDATA[</password>
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
      <localadmin>No</localadmin>
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
      <localadmin>No</localadmin>
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
    


    ]]><xsl:variable name="userdomainTSYS" select="normalize-space(substring-before(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_TSYSA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameTSYS" select="normalize-space(substring-after(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_TSYSA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordTSYS" select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SP_TSYSA_PASSWORD']"></xsl:variable>
    
    <xsl:if test="$usernameTSYS != ''">
      <![CDATA[  
      
    <managedaccount>
        
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
    ]]>
          </xsl:if>

    <![CDATA[  
      
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
      <primary>True</primary>
      <aliasname>SQLGEN_01_G1</aliasname>
      <Collation>Latin1_General_CI_AS</Collation>
      <ipaddress>192.168.0.89</ipaddress>
      <port>3625</port>
      <listenerport>5022</listenerport>
      <type>General</type>
      <alwaysonsettings/>
    </sqlinstance>
  </sqlinstances>
  <webapplications>
    <webapplication>
      <name>Search</name>
      <url>https://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[</url>      
      <serviceapplicationproxygroup>Default</serviceapplicationproxygroup>      
      <contentDBPrefix>SPS_]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PURPOSE']"/>_<![CDATA[Search_SPContent</contentDBPrefix>
      <numberContentDBs>1</numberContentDBs>
      <contentDBMaxSize>10</contentDBMaxSize>
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
     <managedpath>
      <webapplication>Search</webapplication>
      <path>ediscovery</path>
      <explicit>Yes</explicit>
    </managedpath>
    <managedpath/>
    <managedpath/>
  </managedpaths>
  <sitecollections>
    <sitecollection>
      <webapplication>Search</webapplication>
      <name>Team Collab</name>
      <url>https://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[/sites/teamcollab</url>                
      <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>STS#0</sitetemplate>
      <quota>5GB</quota>
    </sitecollection>
    <sitecollection>
      <webapplication>Search</webapplication>
      <name>Users</name>
      <url>https://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[/userprofiles</url>          
         <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>SPSMSITEHOST#0</sitetemplate>
      <quota>5GB</quota>
    </sitecollection>
     <sitecollection>
      <webapplication>Search</webapplication>
      <name>EDiscovery Center Home</name>
      <url>https://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[/ediscovery</url>                
         <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>EDISC#0</sitetemplate>
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

]]>
    <!--[TB] SSRS-->
    <!-- NG 3.5.1 Make SSRS mandatory-->
    <!--<xsl:if test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_INSTALL_SSRS'] = 'true'">-->
    <![CDATA[
        <serviceapplication>
          <name>SQL Server Reporting Services</name>
          <enable>Yes</enable>
          <indefaultproxygroup>Yes</indefaultproxygroup>
          <consumeserviceapplication>No</consumeserviceapplication>
        </serviceapplication>
    ]]>
    <!--</xsl:if>-->
    <![CDATA[

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
      <serviceapplicationname>Secure Store Service</serviceapplicationname>
      <settingname>Administrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</settingvalue>
    </serviceapplicationsetting>
    <serviceapplicationsetting>
      <serviceapplicationname>Secure Store Service</serviceapplicationname>
      <settingname>Administrator</settingname>
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
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
    </windowsfirewallsetting>

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
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
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
      <role>Web Server Group 2</role>
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
    </windowsfirewallsetting>

    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDP</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>16372</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>16373</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTPS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>16372</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>16373</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Trend Micro HTTPS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
 <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
      <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Web Server Group 2</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    
    
    


    
<windowsfirewallsetting>
      <role>Application Server Group 1</role>
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
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
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
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
      <role>Application Server Group 2</role>
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDB</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>

<windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>


    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
     <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
     <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Application Server Group 2</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 


<windowsfirewallsetting>
      <role>Search Server Group 1</role>
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
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
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
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
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
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
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
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
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
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
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
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
      <role>Search Server Group 4</role>
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
   
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16500</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16501</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16502</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16503</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16504</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16505</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16506</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
        <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16507</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16508</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16509</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16510</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16511</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting> 
          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16512</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16513</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>  
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16514</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16515</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16516</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>   
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16517</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
         <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16518</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>
          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>16519</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Index Components Ports</rulename>
    </windowsfirewallsetting>

          <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting> 
<windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>808</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>WCF</rulename>
    </windowsfirewallsetting>   
   
   
   
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32843</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32844</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32845</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SharePoint Service Applications</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>32846</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Sandboxed Code</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>5725</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AD</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>LDAP Service</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>88</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>53</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>DNS</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>464</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>UDB</protocol>
      <rulename>Kerberos Change Password</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>25</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SMTP</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 135</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>137</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 137</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>138</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 138</rulename>
    </windowsfirewallsetting>
 <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>

    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>636</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>3268</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>3269</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>LDAP GC SSL</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>749</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Kerberos-Adm</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>750</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Kerberos-IV</rulename>
    </windowsfirewallsetting>
   <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22233</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
    <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22234</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting>  
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22235</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
       <windowsfirewallsetting>
      <role>Search Server Group 4</role>
      <incomingport>22236</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>AppFabric Caching</rulename>
    </windowsfirewallsetting> 
   
   
   
   
   <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>80</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Reporting Services Web Services HTTP</rulename>
    </windowsfirewallsetting>    
   <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>443</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Reporting Services Web Services HTTPS</rulename>
    </windowsfirewallsetting>         
   <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>4022</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Service Broker</rulename>
    </windowsfirewallsetting> 
   <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>2383</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Analysis Services</rulename>
    </windowsfirewallsetting> 
   <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>135</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>Integration Services</rulename>
    </windowsfirewallsetting> 
   
   <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>3389</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>RDP</rulename>
    </windowsfirewallsetting>

<windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>9389</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL ADWS</rulename>
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
     <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>445</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>Direct hosted SMB</rulename>
    </windowsfirewallsetting>
<windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>

    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>139</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP,UDP</protocol>
      <rulename>RPC 139</rulename>
    </windowsfirewallsetting>
   
  </windowsfirewallsettings>
  <smtpservers>
    <smtpserver>
      <outgoingsmtp>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SMTP_OUTSERVER']"/><![CDATA[</outgoingsmtp>
      <senderaddress>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SMTP_ADDRESS']"/><![CDATA[</senderaddress>
      <replytoemailaddress>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SMTP_REPLYTO']"/><![CDATA[</replytoemailaddress>
      <domain></domain>      
      <folderlocation>c:\inetpub\mailroot</folderlocation>
    </smtpserver>
  </smtpservers>
  <productversions>

  ]]>
  <!-- Decide where the media should come from - if we have provided a localmediapath value, assume it has been copied there, otherwise use the mediaserver share -->
  <xsl:variable name="mediapath">
    <xsl:choose>
      <xsl:when test="//customerandenvironmentsettings/localmediapath and not(//customerandenvironmentsettings/localmediapath = '')">
        <xsl:value-of select="//customerandenvironmentsettings/localmediapath" />
      </xsl:when>
      <xsl:otherwise>
        <![CDATA[\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\MediaShare]]>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <![CDATA[

    <productversion>
      <product>Windows 2012 Media</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Win2012Source</binary>
      <searchstringwildcardtoknowifalreadyinstalled>sharepoint server</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
<productversion>
      <product>SP Pre Install Hotfixes</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\MediaShare\Pre Install Hotfixes\SPHotfixes</binary>
      
    </productversion>
<productversion>
      <product>SQL Pre Install Hotfixes</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>\\]]><xsl:value-of select="//customerandenvironmentsettings/mediaserver"/><![CDATA[\MediaShare\Pre Install Hotfixes\SQLHotfixes</binary>
      
    </productversion>
    <productversion>
      <product>T-Systems Build Scripts</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SP Scripts v3</binary>
      
    </productversion>
    <productversion>
      <product>WSPs</product>
      <install>No</install>
      <producttype>Build Script</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SharePoint\WSPs</binary>
      
    </productversion>
       <productversion>
      <product>SharePoint Server</product>
      <install>Yes</install>
      <producttype>Server Product</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SharePoint\]]><xsl:choose>
      <xsl:when test="not(//customerandenvironmentsettings/isSP2013SP1) or //customerandenvironmentsettings/isSP2013SP1 = 'False'"><![CDATA[Server Media]]></xsl:when>
      <xsl:otherwise><![CDATA[Server Media SP1]]></xsl:otherwise>
    </xsl:choose><![CDATA[</binary>
      <exe>setup.exe</exe>
      <license>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LICENSE_SPKEY']"/><![CDATA[</license>
      <searchstringwildcardtoknowifalreadyinstalled>sharepoint server</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
    
    <productversion>
			<product>SQL Server Std</product>
			<install>Yes</install>
			<producttype>Server Product</producttype>
			<version>2012</version>
			<binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SQL Server 2012 Std</binary>
			<exe>setup.exe</exe>

		</productversion>
    
    
    <productversion>
			<product>SQL Server Ent</product>
			<install>Yes</install>
			<producttype>Server Product</producttype>
			<version>2012</version>
			<binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SQL Server 2012 Ent</binary>
			<exe>setup.exe</exe>
      
      
		</productversion>

    
    
    <productversion>
			<product>SQL Server Dev</product>
			<install>Yes</install>
			<producttype>Server Product</producttype>
			<version>2012</version>
			<binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SQL Server 2012 Dev</binary>
			<exe>setup.exe</exe>
      
      
		</productversion>

    <productversion>
      <product>Certificates</product>
      <install>Yes</install>
      <producttype>Build Script</producttype>
      <version>Certificates</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SSL</binary>
      <license>]]><xsl:value-of select="normalize-space(//customeronboardingdata/SSLPassword)"/><![CDATA[</license>      
    </productversion>]]>
    <xsl:choose>
      <xsl:when test="not(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS'])"></xsl:when>
      <xsl:when test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS'] = ''"></xsl:when>
      <xsl:when test="count(//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']/zim:value) &gt; 0">
        <xsl:for-each select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']/zim:value">
          <![CDATA[
    <productversion>
      <product>]]><xsl:value-of select="."/><![CDATA[</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Language Packs\]]><xsl:value-of select="."/><![CDATA[</binary>
      <exe>setup.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>Language Pack for SharePoint and Project Server 2013  - ]]><xsl:value-of select="."/><![CDATA[</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
      ]]>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <![CDATA[
    <productversion>
      <product>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']"/><![CDATA[</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Language Packs\]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']"/><![CDATA[</binary>
      <exe>setup.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>Language Pack for SharePoint and Project Server 2013  - ]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']"/><![CDATA[</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
      ]]>
      </xsl:otherwise>
    </xsl:choose>
    <![CDATA[

 <productversion>
      <product>Template</product>
      <install>No</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Language Packs\</binary>
      <exe>setup.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>Language Pack for SharePoint and Project Server 2013  - </searchstringwildcardtoknowifalreadyinstalled>
    </productversion>


   <productversion>
      <product>Spanish</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Language Packs\Spanish</binary>
      <exe>setup.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>Language Pack for SharePoint and Project Server 2013  - Spanish</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>


 <productversion>
      <product>German</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Language Packs\German</binary>
      <exe>setup.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>Language Pack for SharePoint and Project Server 2013  - German</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
 



 <productversion>
      <product>Japanese</product>
      <install>Yes</install>
      <producttype>Language Pack</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Language Packs\Japanese</binary>
      <exe>setup.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>Language Pack for SharePoint and Project Server 2013  - Japanese</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>


<productversion>
      <product>App Fabric CU 5</product>
      <install>Yes</install>
      <producttype>Cumulative Update</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Cumulative Updates\AppFabric_CU5</binary>
      <exe>AppFabric1.1-KB2932678-x64-ENU.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>KB2932678</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>


     ]]><xsl:if test="//customerandenvironmentsettings/InstallBAIForESService = 'True'">
      <![CDATA[
    <productversion>
      <product>BAI Longitude Search 5.1.14</product>
      <install>Yes</install>
      <producttype>BAI Longitude</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\BAI\LS5.1.14T</binary>
      <exe></exe>
      <searchstringwildcardtoknowifalreadyinstalled></searchstringwildcardtoknowifalreadyinstalled>
    </productversion>


	<productversion>
      <product>BAI Visual Refiners 2.3.14</product>
      <install>Yes</install>
      <producttype>BAI Longitude</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\BAI\VR2.3.14T</binary>
      <exe></exe>
      <searchstringwildcardtoknowifalreadyinstalled></searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
   
	<productversion>
      <product>BAI Connector Framework 3.1.4</product>
      <install>Yes</install>
      <producttype>BAI Longitude</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\BAI\CON3.1.4T</binary>
      <exe></exe>
      <searchstringwildcardtoknowifalreadyinstalled></searchstringwildcardtoknowifalreadyinstalled>
    </productversion>

    ]]>
    </xsl:if><![CDATA[

     ]]><xsl:if test="not(//customerandenvironmentsettings/isSP2013SP1) or //customerandenvironmentsettings/isSP2013SP1 = 'False'">
      <![CDATA[
    <productversion>
      <product>March 2013 PU</product>
      <install>Yes</install>
      <producttype>Cumulative Update</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Cumulative Updates\Mar13</binary>
      <exe>ubersrvsp2013-kb2767999-fullfile-x64-glb.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>KB2767999</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>

    <productversion>
      <product>Oct 2013 Cumulative Update</product>
      <install>Yes</install>
      <producttype>Cumulative Update</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Cumulative Updates\Oct13</binary>
      <exe>ubersrv2013-kb2825647-fullfile-x64-glb.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>KB2825647</searchstringwildcardtoknowifalreadyinstalled>
    </productversion>
    ]]>
    </xsl:if><![CDATA[




<productversion>
      <product>Sep 2015 Cumulative Update</product>
      <install>Yes</install>
      <producttype>Cumulative Update</producttype>
      <version>Default</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\Cumulative Updates\Sep15</binary>
      <exe>ubersrv2013-kb2986213-fullfile-x64-glb.exe</exe>
      <searchstringwildcardtoknowifalreadyinstalled>KB2986213</searchstringwildcardtoknowifalreadyinstalled>
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
      <mysitehostlocation>https://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[/userprofiles</mysitehostlocation>          
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
      <queryindexlocation>F:\data\SharePointIndex</queryindexlocation>
      <searchproxy>]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_PROXY_SERVER']"/><![CDATA[</searchproxy>      
      <searchcentreURL>https://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[/pages</searchcentreURL>          
      <searchproxyforfederated>Yes</searchproxyforfederated>
    </searchsetting>
  </searchsettings>
  <contentsources>
  ]]>
    
    <![CDATA[
  <contentsource>
						  <type>SharePoint</type>
							<values>sps3s://]]><xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/>.<xsl:value-of select="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_WEB_APP_DOMAIN']"/><![CDATA[</values>
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
<!--    <defaultpermissionsuserpolicy>
      <policyname>Full Control</policyname>
      <adobject>tsi\rmoore</adobject>
      <webapplication>Search</webapplication>
      <zone>Default</zone>
    </defaultpermissionsuserpolicy> -->
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

    ]]>
    <!--NG 3.5.1 Make SSRS mandatory-->
    <!--<xsl:if test="//zim:set[@plugin='SAO-ES-Base']/zim:item[@name='_conf_INSTALL_SSRS'] = 'true'"> -->
    <![CDATA[
     <noncontentdb>
      <db>ReportingServices_svc</db>
      <dbname>ES_PRO_DE_01_ReportingServices_svc</dbname>
      <dbnamenoprefix>ReportingServices_svc</dbnamenoprefix>
      <serviceapplicationname>Reporting Services</serviceapplicationname>
      <precreate>No</precreate>
      <primarysqlalias>SQLGEN_01_G1</primarysqlalias>
      <availabilitygroup>Default</availabilitygroup>
    </noncontentdb>]]>
    <!--</xsl:if> -->

    <![CDATA[
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
      <clusterips>]]><xsl:value-of select="//clustersettings/precreated_es/clusterips"/><![CDATA[</clusterips>
      <listenerips>]]><xsl:value-of select="//clustersettings/precreated_es/listenerips"/><![CDATA[</listenerips>
      
    </clusterconfiguration>



    <azureconfiguration>
      <proxy>]]><xsl:value-of select="//azuremobileservice/proxy"/><![CDATA[</proxy> 
     <jsonurl>]]><xsl:value-of select="//azuremobileservice/jsonurl"/><![CDATA[</jsonurl>
      <applicationkey>]]><xsl:value-of select="//azuremobileservice/applicationkey"/><![CDATA[</applicationkey>
      <registrationstable>]]><xsl:value-of select="//azuremobileservice/registrationstable"/><![CDATA[</registrationstable>
      <sessiontable>]]><xsl:value-of select="//azuremobileservice/sessiontable"/><![CDATA[</sessiontable>
      <sessiondetailtable>]]><xsl:value-of select="//azuremobileservice/sessiondetailtable"/><![CDATA[</sessiondetailtable>
      <customertable>]]><xsl:value-of select="//azuremobileservice/customertable"/><![CDATA[</customertable>
      <customerid>]]><xsl:value-of select="//azuremobileservice/customerid"/><![CDATA[</customerid>
       <sessiondetailservertable>]]><xsl:value-of select="//azuremobileservice/sessiondetailservertable"/><![CDATA[</sessiondetailservertable>

    </azureconfiguration>
    
    
        
<backupandmaintenancesettings>
      <spbackupfilessharename>FarmBackup</spbackupfilessharename>
      <spbackuppackagelocation>E:\data\Install\Packages\Backup And Maintainance</spbackuppackagelocation>
      <spbackupscriptdestination>E:\data\maintainance</spbackupscriptdestination>
      <spbackupdaystokeepbackups>30</spbackupdaystokeepbackups>
      <backupdriveletter>N</backupdriveletter>

<sqlbackupfullsharename>Full Backups</sqlbackupfullsharename>
	<sqlbackupdiffsharename>Differential Backups</sqlbackupdiffsharename>
	<sqlbackuptlogsharename>Transaction Log Backups</sqlbackuptlogsharename>
	<sqlbackuptmreportsharename>Maintenance Reports</sqlbackuptmreportsharename>

    <!-- This is a bit of a hack, but we need a sub folder for each instance as some servers host multiple instances -->
		<sqlbackupbaselocation>:\data\maintenance\[Instance Name]</sqlbackupbaselocation>
    <sqlbackupbaselocation_centralshare>\sqlmaintenance\[Instance Name]</sqlbackupbaselocation_centralshare>
    
		<sqlbackupfulllocation>\Full Backups</sqlbackupfulllocation>
		<sqlbackupdifflocation>\Differential Backups</sqlbackupdifflocation>
		<sqlbackuptloglocation>\Transaction Log Backups</sqlbackuptloglocation>
		<sqlbackupmreportslocation>\Maintenance Reports</sqlbackupmreportslocation>
    <sqlagentjoblogging>\Agent Jobs Output</sqlagentjoblogging>
	  <sqlbackupdriveletter>N</sqlbackupdriveletter>

		<sqlbackupdaystokeepbackups>30</sqlbackupdaystokeepbackups>

	
	<plans>
		<plan> 
			<name>Check Database Integrity</name>
			<description>Check Database Integrity</description>
			<schedule>
				<scheduletype>Daily</scheduletype>
				<schedulehour>0</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
		</plan>

		<plan> 
			<name>Reorganize Index</name>
			<description>Reorganize Index</description>
			<schedule>
				<scheduletype>WeeklyMonSat</scheduletype>							
				<schedulehour>0</schedulehour>
				<scheduledayoffset>0</scheduledayoffset>
				<schedulemin>10</schedulemin>
			</schedule>
		</plan>				

		<plan> 
			<name>Rebuild Index</name>
			<description>Rebuild Index</description>
			<schedule>
				<scheduletype>Weekly</scheduletype>							
				<schedulehour>0</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>10</schedulemin>
			</schedule>
		</plan>		



		<plan> 
			<name>Update Statistics</name>
			<description>Update Statistics</description>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>0</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>20</schedulemin>
			</schedule>
		</plan>	

		<plan> 
			<name>Clean Up History</name>
			<description>Clean Up History</description>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>0</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>30</schedulemin>
			</schedule>
		</plan>	


		<plan> 
			<name>Backup Database Full</name>
			<description>Backup Database Full</description>
			<schedule>
				<scheduletype>Weekly</scheduletype>							
				<schedulehour>1</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
		</plan>	

		<plan> 
			<name>Backup Database Differential</name>
			<description>Backup Database Differential</description>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>2</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>8</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>14</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>20</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
		</plan>	


		<plan> 
			<name>Backup Transaction Logs</name>
			<description>Backup Transaction Logs</description>
			<schedule>
				<scheduletype>Hourly</scheduletype>							
				<schedulehour>0</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
			
			
		</plan>	



		<plan> 
			<name>Maintenance Cleanup Task</name>
			<description>Maintenance Cleanup Task</description>
			<schedule>
				<scheduletype>Daily</scheduletype>							
				<schedulehour>5</schedulehour>
				<scheduledayoffset>1</scheduledayoffset>
				<schedulemin>0</schedulemin>
			</schedule>
			
			
		</plan>

	</plans>

    </backupandmaintenancesettings>


    </farm>
    
]]>

 
    
  </xsl:template>
</xsl:stylesheet>