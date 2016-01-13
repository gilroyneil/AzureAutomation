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
  <farmtype>SQL</farmtype>
  
  <subscriptionID>TestSubscriptionID</subscriptionID>
  <backupstorageneeded>0</backupstorageneeded>
  <useCentralBackupLocation>]]><xsl:value-of select="//customerandenvironmentsettings/UseCentralBackupStore"/><![CDATA[</useCentralBackupLocation>
  <centralBackupLocation>]]><xsl:value-of select="//customeronboardingdata/BackupShare"/><![CDATA[</centralBackupLocation>
  <centralClusterLocation>]]><xsl:value-of select="//customeronboardingdata/QuorumShare"/><![CDATA[</centralClusterLocation>

  <makeADandDNSChanges_precreated>]]><xsl:value-of select="//clustersettings/precreated_es/makeADandDNSChanges"/><![CDATA[</makeADandDNSChanges_precreated>
  <startClusterIP>]]><xsl:value-of select="//clustersettings/dynamic/starting_clusterip"/><![CDATA[</startClusterIP>
  <startListenerIP>]]><xsl:value-of select="//clustersettings/dynamic/starting_listenerip"/><![CDATA[</startListenerIP>
  <createDNSObjects>]]><xsl:value-of select="//clustersettings/dynamic/createDNSObjects"/><![CDATA[</createDNSObjects>

  <useDynamicAlwaysOnSettings>]]><xsl:value-of select="//clustersettings/useDynamic"/><![CDATA[</useDynamicAlwaysOnSettings>
  <isHAInstall>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_HA']"/><![CDATA[</isHAInstall>
  <DBCreators>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[,]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</DBCreators>
  <InstanceSize>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_INSTANCE_SIZE']"/><![CDATA[</InstanceSize>
  <InstanceName>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_INSTANCE_NAME']"/><![CDATA[</InstanceName>
  <SQLPort>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_PORT']"/><![CDATA[</SQLPort>
  <AvailabilityGroupListnerName>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_AVG_LISTENER_NAME']"/><![CDATA[</AvailabilityGroupListnerName>
  <AvailabilityGroupPort>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_AVG_PORT']"/><![CDATA[</AvailabilityGroupPort>
  <TotalStorage>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_DB_STORAGE']"/><![CDATA[</TotalStorage>
  <doUseSmallSQLDBs>]]><xsl:value-of select="//customerandenvironmentsettings/useSmallDBPreSizingForDevInstalls"/><![CDATA[</doUseSmallSQLDBs>
  <doUseSmallDriveSizesForCIC>]]><xsl:value-of select="//customerandenvironmentsettings/doUseSmallDriveSizesForCIC"/><![CDATA[</doUseSmallDriveSizesForCIC>
  <doUse100GBFixedDriveSizes>]]><xsl:value-of select="//customerandenvironmentsettings/doUse100GBFixedDriveSizes"/><![CDATA[</doUse100GBFixedDriveSizes>

  <isWin2012>]]><xsl:value-of select="//customerandenvironmentsettings/isWin2012"/><![CDATA[</isWin2012>
  <isSP2013SP1>]]><xsl:value-of select="//customerandenvironmentsettings/isSP2013SP1"/><![CDATA[</isSP2013SP1>
    <servicequality>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SERVICEQUALITY']"/><![CDATA[</servicequality>
  <businessunit>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_BUSINESSUNIT']"/><![CDATA[</businessunit>
  <installSSRS>]]><xsl:if test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_INSTALL_SSRS'] = 'true'"><![CDATA[true]]></xsl:if><![CDATA[</installSSRS>
  
  <privateipwebapps>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PRIVATE_IP_WEBAPPS']"/><![CDATA[</privateipwebapps>
  <publicipwebapps>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PUBLIC_IP_WEBAPPS']"/><![CDATA[</publicipwebapps>
  

  <proxyserver>]]><xsl:value-of select="normalize-space(//customeronboardingdata/ProxyServer)"/><![CDATA[</proxyserver>
  <sslpassword>]]><xsl:value-of select="normalize-space(//customeronboardingdata/SSLPassword)"/><![CDATA[</sslpassword>
  <standardusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_STANDARD_USERS_AD_GROUP']"/><![CDATA[</standardusers>
  <enterpriseusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_ENTERPRISE_USERS_AD_GROUP']"/><![CDATA[</enterpriseusers>
  
  
  
  <devseat>]]><xsl:choose>
    <xsl:when test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE'] = 'DES'">True</xsl:when>
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
  <numberofusers>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_NUMBEROFUSERS']"/><![CDATA[</numberofusers>
  <purpose>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE']"/><![CDATA[</purpose>
    <mysitequota>5MB</mysitequota>
  
  <farmname>SPS_]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[1</farmname>
  <farmnumber>1</farmnumber>
    <createdomain>]]><xsl:choose>
    <xsl:when test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE'] = 'DES' and //customerandenvironmentsettings/devseatisdc = 'True'">Yes</xsl:when>
    <xsl:otherwise>No</xsl:otherwise>
  </xsl:choose><![CDATA[</createdomain>
    <joindomain>]]><xsl:choose>
    <xsl:when test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE'] = 'DES' and //customerandenvironmentsettings/devseatisdc = 'True'">No</xsl:when>
    <xsl:otherwise>Yes</xsl:otherwise>
  </xsl:choose><![CDATA[</joindomain>
  
  <testaccountsOU>Test Search Accounts</testaccountsOU>
  <serviceaccountsOU>Enterprise Search Service Accounts</serviceaccountsOU>
  <restrictsitedefinitions>Yes</restrictsitedefinitions>
  <location>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[</location>
  <customer>UNKNOWN</customer>
  <customerabreviation>UNK</customerabreviation>
  
  <passphrase>1#SPS_]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE']"/>_<xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LOCATION']"/><![CDATA[_1#1</passphrase>
  <requireddocumentstorage>25</requireddocumentstorage>
  <amountofdocuments>100000</amountofdocuments>
  <totalcontentdbsize>10</totalcontentdbsize>
  <searchdbsize>11.769</searchdbsize>
  <otherdbsize>13.75</otherdbsize>  
  
   <fixeddatagrowthsizeMB>0</fixeddatagrowthsizeMB>
 <fixedloggrowthsizeMB>0</fixedloggrowthsizeMB>
 
  <amountindexeditems>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_AMOUNTINDEXEDITEMS']"/><![CDATA[</amountindexeditems>
  <contentdbmaxsize>400</contentdbmaxsize>
  <sqlinstancemaxsizeGB>4000</sqlinstancemaxsizeGB>
  <BackupLocation>]]><xsl:value-of select="//customeronboardingdata/BackupLocation"/><![CDATA[</BackupLocation>
  <averagedocumentsizekb>250</averagedocumentsizekb> 
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
   <vmtemplates>

    <vmtemplate>
      <name>Virtual-S</name>
      <description>Small Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>2</cores>
      <ram>4096</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-M</name>
      <description>Medium Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>4</cores>
      <ram>8192</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-M-Optm</name>
      <description>Medium Virtual Machine memory optimized </description>
      <performanceunits>8</performanceunits>
      <cores>4</cores>
      <ram>16384</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-L</name>
      <description>Large Virtual Machine</description>
      <performanceunits>8</performanceunits>
      <cores>8</cores>
      <ram>16384</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
     <vmtemplate>
      <name>Virtual-L-Optm</name>
      <description>Large Virtual Machine memory optimized</description>
      <performanceunits>8</performanceunits>
      <cores>8</cores>
      <ram>32768</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XL</name>
      <description>Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>16</cores>
      <ram>32768</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
     <vmtemplate>
      <name>Virtual-XL-Optm</name>
      <description>Extra Large Virtual Machine memory optimized</description>
      <performanceunits>16</performanceunits>
      <cores>16</cores>
      <ram>65536</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XXL</name>
      <description>Super Extra Large Virtual Machine</description>
      <performanceunits>16</performanceunits>
      <cores>32</cores>
      <ram>65536</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
    <vmtemplate>
      <name>Virtual-XXL-Optm</name>
      <description>Super Extra Large Virtual Machine memory optimized</description>
      <performanceunits>32</performanceunits>
      <cores>32</cores>
      <ram>131072</ram>
      <externalip>Yes</externalip>
    </vmtemplate>
  </vmtemplates>
 <servergroups>
  


]]><xsl:choose>
    <xsl:when test="//customerandenvironmentsettings/doUseSmallDriveSizesForCIC = 'True'">
 <![CDATA[



      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
    <cdrivevhdsize>40</cdrivevhdsize>
      <edrivevhdsize>20</edrivevhdsize>
      <fdrivevhdsize>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_DB_STORAGE']"/><![CDATA[</fdrivevhdsize>     
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
      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
    <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
      <fdrivevhdsize>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_DB_STORAGE']"/><![CDATA[</fdrivevhdsize>
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
      <name>SQL Server for all DB Types</name>
      <description>SQL Server to host all data</description>
      <needsexternalip>No</needsexternalip>
      <requirednumber>2</requirednumber>
      <orderednumber>2</orderednumber>
      <vmtemplate>Virtual-L</vmtemplate>
    <cdrivevhdsize>100</cdrivevhdsize>
      <edrivevhdsize>100</edrivevhdsize>
     <fdrivevhdsize>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_DB_STORAGE']"/><![CDATA[</fdrivevhdsize>
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
      

  <managedaccounts>
    

  ]]>
    <!--[TB] SSRS-->
    <xsl:if test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_INSTALL_SSRS'] = 'true'">
    <![CDATA[
        
    ]]>
    </xsl:if>
    <![CDATA[

    <managedaccount>
     ]]><xsl:variable name="userdomainSPIA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-SP-Base']/zim:item[@name='_conf_SP_INSTALL_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSPIA" select="normalize-space(substring-after(//zim:set[@plugin='SQL-SP-Base']/zim:item[@name='_conf_SQL_INST_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSPIA" select="//zim:set[@plugin='SQL-SP-Base']/zim:item[@name='_conf_SQL_INST_PASSWORD']"></xsl:variable><![CDATA[  
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
         ]]><xsl:variable name="userdomainSQL" select="normalize-space(substring-before(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSQL" select="normalize-space(substring-after(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSQL" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_PASSWORD']"></xsl:variable><![CDATA[       
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
         ]]><xsl:variable name="userdomainSQLA" select="normalize-space(substring-before(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SRVA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSQLA" select="normalize-space(substring-after(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SRVA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSQLA" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SRVA_PASSWORD']"></xsl:variable><![CDATA[   
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
         ]]><xsl:variable name="userdomainSQLI" select="normalize-space(substring-before(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_INST_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameSQLI" select="normalize-space(substring-after(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_INST_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordSQLI" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_INST_PASSWORD']"></xsl:variable><![CDATA[   
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
   
    
    
    


    ]]><xsl:variable name="userdomainTSYS" select="normalize-space(substring-before(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SP_TSYSA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="usernameTSYS" select="normalize-space(substring-after(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SP_TSYSA_USERNAME'],'\'))"></xsl:variable>
    <xsl:variable name="passwordTSYS" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SP_TSYSA_PASSWORD']"></xsl:variable>
    
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
  <SQLServerAdminAccounts>
    <Admin1>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</Admin1>
    <Admin2>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</Admin2>
  </SQLServerAdminAccounts>
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
  <xsl:for-each select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='serviceextensions']/serviceextension">
      <xsl:if test="name!=''">
        <![CDATA[
        <serviceextention name="]]><xsl:value-of select="@name"/><![CDATA[" values="]]><xsl:value-of select="@values"/><![CDATA["/>]]>
  </xsl:if>
  </xsl:for-each>
    <![CDATA[    
  </farmserviceextensions>
  <sqlinstances>
    <sqlinstance>
      <name>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_INSTANCE_NAME']"/><![CDATA[</name>
      <instanceid>1</instanceid>
      <primary>True</primary>
      <aliasname>SQLGEN_01_G1</aliasname>
      <Collation>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_COLLATION']"/><![CDATA[</Collation>
      <ipaddress>172.16.0.145</ipaddress>
      <port>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_PORT']"/><![CDATA[</port>
      <AVGport>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_AVG_PORT']"/><![CDATA[</AVGport>
      <listenerport>5022</listenerport>
      <type>General</type>
      <alwaysonsettings/>
    </sqlinstance>       
  </sqlinstances>   
  <webapplications>
    <webapplication>
      <name>Search</name>
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[</url>
      <serviceapplicationproxygroup>Default</serviceapplicationproxygroup>      
      <contentDBPrefix>SPS_]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PURPOSE']"/>_<![CDATA[Search_SPContent</contentDBPrefix>
      <numberContentDBs>1</numberContentDBs>
      <contentDBMaxSize>10</contentDBMaxSize>
      <blobcachesize>1</blobcachesize>
      <sitetemplate>SRCHCEN#0</sitetemplate>
      <quota>5GB</quota>
      <defaultauthprovider>Claims-NTLM</defaultauthprovider>
      <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
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
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/sites/teamcollab</url>
      <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>STS#0</sitetemplate>
      <quota>5GB</quota>
    </sitecollection>
    <sitecollection>
      <webapplication>Search</webapplication>
      <name>Users</name>
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/userprofiles</url>
         <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
      <sitetemplate>SPSMSITEHOST#0</sitetemplate>
      <quota>5GB</quota>
    </sitecollection>
     <sitecollection>
      <webapplication>Search</webapplication>
      <name>EDiscovery Center Home</name>
      <url>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/ediscovery</url>
         <primarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</primarysitecollectionadmin>
      <secondarysitecollectionadmin>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</secondarysitecollectionadmin>
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
    <xsl:if test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_INSTALL_SSRS'] = 'true'">
    <![CDATA[
        <serviceapplication>
          <name>SQL Server Reporting Services</name>
          <enable>Yes</enable>
          <indefaultproxygroup>Yes</indefaultproxygroup>
          <consumeserviceapplication>No</consumeserviceapplication>
        </serviceapplication>
    ]]>
    </xsl:if>
    <![CDATA[

  </serviceapplications>
  <serviceapplicationsettings>
    <serviceapplicationsetting>
      <serviceapplicationname>Managed Metadata Service</serviceapplicationname>
      <settingname>TermStoreAdministrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</settingvalue>
    </serviceapplicationsetting>
    <serviceapplicationsetting>
      <serviceapplicationname>Managed Metadata Service</serviceapplicationname>
      <settingname>TermStoreAdministrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</settingvalue>
    </serviceapplicationsetting>
            <serviceapplicationsetting>
      <serviceapplicationname>Secure Store Service</serviceapplicationname>
      <settingname>Administrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN1']"/><![CDATA[</settingvalue>
    </serviceapplicationsetting>
    <serviceapplicationsetting>
      <serviceapplicationname>Secure Store Service</serviceapplicationname>
      <settingname>Administrator</settingname>
      <settingvalue>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CUSTOMERADMIN2']"/><![CDATA[</settingvalue>
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
      <incomingport>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_PORT']"/><![CDATA[</incomingport>
      <action>Allow</action>
      <direction>In</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL SP-Search DB Instances</rulename>
    </windowsfirewallsetting>
    <windowsfirewallsetting>
      <role>SQL Server for all DB Types</role>
      <incomingport>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_SERVER_PORT']"/><![CDATA[</incomingport>
      <action>Allow</action>
      <direction>Out</direction>
      <remoteip>any</remoteip>
      <protocol>TCP</protocol>
      <rulename>SQL SP-Search DB Instances</rulename>
    </windowsfirewallsetting>   
    
    ]]><xsl:choose>
      <xsl:when test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_HA'] = 'True' ">
        <![CDATA[<windowsfirewallsetting>
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
    </windowsfirewallsetting>]]></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose><![CDATA[
    
    
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
    
  </windowsfirewallsettings>
  <smtpservers>
    <smtpserver>
      <outgoingsmtp>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SMTP_OUTSERVER']"/><![CDATA[</outgoingsmtp>
      <senderaddress>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SMTP_ADDRESS']"/><![CDATA[</senderaddress>
      <replytoemailaddress>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SMTP_REPLYTO']"/><![CDATA[</replytoemailaddress>
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
			<product>SQL Server Dev</product>
			<install>No</install>
			<producttype>Server Product</producttype>
			<version>2012</version>
			<binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SQL Server 2012 Std</binary>
			<exe>setup.exe</exe>
      
		</productversion>
      
    <productversion>
			<product>SQL Server Std</product>
			<install>]]>
      <xsl:choose>
        <xsl:when test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SQL_LICENSE'] = 'STANDARD'">
          <![CDATA[Yes]]>
        </xsl:when>
        <xsl:otherwise>
          <![CDATA[No]]>
        </xsl:otherwise>
      </xsl:choose>

      <![CDATA[</install>
			<producttype>Server Product</producttype>
			<version>2012</version>
			<binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SQL Server 2012 Std</binary>
			<exe>setup.exe</exe>
      
		</productversion>
    
    <productversion>
      <product>SQL Server Ent</product> 
      <install>]]><xsl:choose>
        <xsl:when test="//zim:set[@plugin='SQO-SQL-Base']/zim:item[@name='_conf_SQL_LICENSE'] = 'ENTERPRISE'">
          <![CDATA[Yes]]>
        </xsl:when>
        <xsl:otherwise>
          <![CDATA[No]]>
        </xsl:otherwise>
      </xsl:choose>

      <![CDATA[</install>
      <producttype>Server Product</producttype>
      <version>2012</version>
      <binary>]]><xsl:value-of select="$mediapath" /><![CDATA[\SQL Server 2012 Ent</binary>
      <exe>setup.exe</exe>
     </productversion>
    ]]>
    <xsl:choose>
      <xsl:when test="not(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LANGUAGE_PACKS'])"></xsl:when>
      <xsl:when test="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LANGUAGE_PACKS'] = ''"></xsl:when>
      <xsl:when test="count(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']/zim:value) &gt; 0">
        <xsl:for-each select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_LANGUAGE_PACKS']/zim:value">
          <![CDATA[
    
      ]]>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <![CDATA[
    
      ]]>
      </xsl:otherwise>
    </xsl:choose>
    
      <![CDATA[
  </productversions>


  <userprofileservicesettings>
  
   ]]><xsl:variable name="domainUPS" select="normalize-space(substring-before(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_USERNAME'],'\'))"></xsl:variable>
  <xsl:variable name="usernameUPS" select="normalize-space(substring-after(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_USERNAME'],'\'))"></xsl:variable>
  <xsl:variable name="passwordUPS" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_PASSWORD']"></xsl:variable><![CDATA[     
    <userprofileservicesetting>
      <connectorname>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_DOMAIN']"/><![CDATA[</connectorname>
      <forestname>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_FOREST']"/><![CDATA[</forestname>
      <ou>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_OU']"/><![CDATA[</ou>
      <importfilter>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROFILE_Filter']"/><![CDATA[</importfilter>
      <useraccount>]]><xsl:value-of select="$usernameUPS"/><![CDATA[</useraccount>
      <password>]]><xsl:value-of select="$passwordUPS"/><![CDATA[</password>
      <mysitehostlocation>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL']"/><![CDATA[/userprofiles</mysitehostlocation>
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
      <searchproxy>]]><xsl:value-of select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_PROXY_SERVER']"/><![CDATA[</searchproxy>
      <searchcentreURL>]]><xsl:value-of select="normalize-space(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL'])"/><![CDATA[/pages</searchcentreURL>
      <searchproxyforfederated>Yes</searchproxyforfederated>
    </searchsetting>
  </searchsettings>
  <contentsources>
  ]]>
    <xsl:variable name="hostonlysearchcentreurl" select="normalize-space(substring-after(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_SEARCHCENTERURL'],'://'))"></xsl:variable>
    <![CDATA[
  <contentsource>
						  <type>SharePoint</type>
							<values>sps3s://]]><xsl:value-of select="$hostonlysearchcentreurl"/><![CDATA[</values>
              <depth>ThisLevel</depth>
  </contentsource>
  ]]>


    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_WEB']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_WEB']"/>
        <xsl:with-param name="type" select="'Web'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_FILE']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_FILE']"/>
        <xsl:with-param name="type" select="'File'"/>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_BUSINESS']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_BUSINESS']"/>
        <xsl:with-param name="type" select="'Business'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="normalize-space(//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_SP']) != ''">
      <xsl:call-template name="csource">
        <xsl:with-param name="text" select="//zim:set[@plugin='SAO-SQL-Base']/zim:item[@name='_conf_CONTENT_SP']"/>
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
    

    ]]>
   
    <![CDATA[
   
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
      <clusterips>]]><xsl:value-of select="//clustersettings/precreated_SQL/clusterips"/><![CDATA[</clusterips>
      <listenerips>]]><xsl:value-of select="//clustersettings/precreated_SQL/listenerips"/><![CDATA[</listenerips>
      
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
      <spbackupdaystokeepbackups>3</spbackupdaystokeepbackups>
      <backupdriveletter>N</backupdriveletter>

<sqlbackupfullsharename>Full Backups</sqlbackupfullsharename>
	<sqlbackupdiffsharename>Differential Backups</sqlbackupdiffsharename>
	<sqlbackuptlogsharename>Transaction Log Backups</sqlbackuptlogsharename>
	<sqlbackuptmreportsharename>Maintenance Reports</sqlbackuptmreportsharename>

<!-- This is a bit of a hack, but we need a sub folder for each instance as some servers host multiple instances -->
		<sqlbackupbaselocation>:\data\maintenance\[Instance Name]</sqlbackupbaselocation>
    
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