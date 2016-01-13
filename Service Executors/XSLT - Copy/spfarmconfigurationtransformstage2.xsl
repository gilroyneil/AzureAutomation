<!--
Author: Neil Gilroy
Filename: TestXSLT.xml
Input: farm config xml
Created: October 2011
Purpose: To Transform the XML Output of a Excel MAP to a customised version of the AutoSPInstaller schema.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" cdata-section-elements="text"/>


  <xsl:variable
					name="extCounter"
					select="1">
  </xsl:variable>


  <xsl:template name="for.loop.CDB">
    <xsl:param name="i" />
    <xsl:param name="instanceID" />
    <xsl:param name="currentInstanceCount" />
    <xsl:param name="maxContentDBsInInstance" />

    <xsl:param name="contentDBName" />
    <xsl:param name="instanceAliasPrefix" />
    <xsl:param name="instanceAliasSuffix" />
    <!--begin_: instanceAliasPrefix = SQL[TYPE]_INST[ID]_[P/M] -->

    <![CDATA[<ContentDBUpdated name="]]><xsl:value-of select="$contentDBName"/><![CDATA[" SQLInstance="]]><xsl:value-of select="$instanceAliasPrefix"/><xsl:value-of select="$instanceID"/>_<xsl:value-of select="$instanceAliasSuffix"/><![CDATA["/>]]>


    <!--begin_: RepeatTheLoopUntilFinished-->

    <xsl:call-template name="for.loop.CDB">
      <xsl:with-param name="i">
        <xsl:value-of select="$i + 1"/>
      </xsl:with-param>
      <xsl:with-param name="instanceID">


        <xsl:choose>
          <xsl:when test="$currentInstanceCount = $maxContentDBsInInstance">
            <xsl:value-of select="$instanceID + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$instanceID"/>
          </xsl:otherwise>
        </xsl:choose>


      </xsl:with-param>
      <xsl:with-param name="currentInstanceCount">
        <xsl:value-of select="$currentInstanceCount + 1"/>
      </xsl:with-param>
      <xsl:with-param name="maxContentDBsInInstance">
        <xsl:value-of select="$maxContentDBsInInstance"/>
      </xsl:with-param>

      <xsl:with-param name="contentDBName">
        <xsl:value-of select="$contentDBName"/>
      </xsl:with-param>
      <xsl:with-param name="instanceAliasPrefix">
        <xsl:value-of select="$instanceAliasPrefix"/>
      </xsl:with-param>
      <xsl:with-param name="instanceAliasSuffix">
        <xsl:value-of select="$instanceAliasSuffix"/>
      </xsl:with-param>
    </xsl:call-template>


  </xsl:template>

  <xsl:template match="farm">
   <![CDATA[
<Configuration Environment="**||Environment||**" Version="**||VersionNumber||**" Hive="15" UseIPAddresses="False">
    <!-- The Environment attribute above appears at the top of the installation transcript. It does not affect the installation -->
    <!-- The Install section controls what modifications are made to the Windows OS prior to installation and how the SharePoint installation is run -->
    <Install>

<LoadBalancer1IP></LoadBalancer1IP>
<LoadBalancer2IP></LoadBalancer2IP>
<SubscriptionID>]]><xsl:value-of select="//subscriptionID"/><![CDATA[</SubscriptionID>
  <UseCentralBackupLocation>]]><xsl:value-of select="//useCentralBackupLocation"/><![CDATA[</UseCentralBackupLocation>
  <CentralBackupLocation>]]><xsl:value-of select="//centralBackupLocation"/><![CDATA[</CentralBackupLocation>
  <CentralClusterLocation>]]><xsl:value-of select="//centralClusterLocation"/><![CDATA[</CentralClusterLocation>
<UseDynamicAlwaysOnSettings>]]><xsl:value-of select="//useDynamicAlwaysOnSettings"/><![CDATA[</UseDynamicAlwaysOnSettings>  

<IsHAInstall>]]><xsl:value-of select="//isHAInstall"/><![CDATA[</IsHAInstall>  
<DoInstallBAI>]]><xsl:value-of select="//doInstallBAI"/><![CDATA[</DoInstallBAI>  
            <DoUseSmallDBSizes>]]><xsl:value-of select="//doUseSmallSQLDBs"/><![CDATA[</DoUseSmallDBSizes>  
            <DoUseSmallDriveSizesForCIC>]]><xsl:value-of select="//doUseSmallDriveSizesForCIC"/><![CDATA[</DoUseSmallDriveSizesForCIC>  
            <DoUse100GBFixedDriveSizes>]]><xsl:value-of select="//doUse100GBFixedDriveSizes"/><![CDATA[</DoUse100GBFixedDriveSizes>  

            <FarmType>]]><xsl:value-of select="//farmtype"/><![CDATA[</FarmType>  
            <DevSeat>]]><xsl:value-of select="//devseat"/><![CDATA[</DevSeat>  
            <Windows2012Install>]]><xsl:value-of select="//isWin2012"/><![CDATA[</Windows2012Install>  
            <Windows2012Version>]]><xsl:value-of select="//windows2012Version"/><![CDATA[</Windows2012Version>  
            <DeploymentServer>]]><xsl:value-of select="//deploymentserver"/><![CDATA[</DeploymentServer> 
            <SP2013SP1Install>]]><xsl:value-of select="//isSP2013SP1"/><![CDATA[</SP2013SP1Install>  
            <ServiceQuality>]]><xsl:value-of select="//servicequality"/><![CDATA[</ServiceQuality> 
            
            <InstallSSRS>]]><xsl:value-of select="//installSSRS"/><![CDATA[</InstallSSRS>
            
            
            <MediaServer>]]><xsl:value-of select="//mediaserver"/><![CDATA[</MediaServer>   
            <MediaServerFullPath>]]><xsl:value-of select="//mediaserverfullpath"/><![CDATA[</MediaServerFullPath>   
            <LocalMediaPath>]]><xsl:value-of select="//localmediapath"/><![CDATA[</LocalMediaPath>   
           <LangPacksLocation>]]><xsl:value-of select="//langpackslocation"/><![CDATA[</LangPacksLocation>  
    <UseLocalAdminForStartupScripts>]]><xsl:value-of select="//uselocaladminaccountforstartupscripts"/><![CDATA[</UseLocalAdminForStartupScripts>  

    <CreateAllClusterElements>]]><xsl:value-of select="//createAllClusterElements"/><![CDATA[</CreateAllClusterElements>  

    
		<BuildAccount>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='SharePoint Install Account']/domain"/>\<xsl:value-of select="farm/managedaccounts/managedaccount[purpose='SharePoint Install Account']/username"/><![CDATA[</BuildAccount>
    <BuildAccountPassword>]]><xsl:value-of select="farm/managedaccounts/managedaccount[purpose='SharePoint Install Account']/password"/><![CDATA[</BuildAccountPassword>
		<TempFileLocationDuringInstall>E:\Data\TempInstallFiles</TempFileLocationDuringInstall>

        <SPConfigFile path="SetupConfigFiles\SPConfig.xml" name="SPConfig.xml"></SPConfigFile>
		<ProjServerConfigFile path="SetupConfigFiles\ProjSvrConfig.xml" name="ProjSvrConfig.xml"></ProjServerConfigFile>
		<OWAConfigFile path="SetupConfigFiles\OWAConfig.xml" name="OWAConfig.xml"></OWAConfigFile>

		<LanguagePackFoundationConfigFile path="SetupConfigFiles\LPFndConfig.xml" name="LPFndConfig.xml"></LanguagePackFoundationConfigFile>
		<LanguagePackServerConfigFile path="SetupConfigFiles\LPSvrConfig.xml" name="LPSvrConfig.xml"></LanguagePackServerConfigFile>


        <!-- If true, the SharePoint prerequisite installer will install from the \SharePoint\PrerequisiteInstallerFiles folder.
		     If false, the prerequisites will be downloaded during install. In order to use true you must obviously download all the prerequisites in advance.
			 You can use a script like http://autospinstaller.codeplex.com/releases/view/44442 to quickly accomplish this -->
        <OfflineInstall>true</OfflineInstall>
        <DisableUnneededServices>True</DisableUnneededServices>

    <Certificates>
      <CreateSelfSigned>True</CreateSelfSigned>
      <ImportDirectory>]]><xsl:value-of select="//productversions/productversion[product='Certificates']/binary"/><![CDATA[</ImportDirectory>
      <ImportPassword>]]><xsl:value-of select="//productversions/productversion[product='Certificates']/license"/><![CDATA[</ImportPassword>
    
    
    ]]>
    <xsl:choose>
      <xsl:when test="//productversions/productversion[product='Certificates']/nonStandardUserNameToAccessWith != ''">
        <![CDATA[<ImportUserName>]]><xsl:value-of select="//productversions/productversion[product='Certificates']/nonStandardUserNameToAccessWith"/><![CDATA[</ImportUserName>
	          <ImportUserPassword>]]><xsl:value-of select="//productversions/productversion[product='Certificates']/nonStandardPasswordToAccessWith"/><![CDATA[</ImportUserPassword>
          ]]>

      </xsl:when>
      <xsl:otherwise>
        <![CDATA[<ImportUserName>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='SharePoint Install Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='SharePoint Install Account']/username"/><![CDATA[</ImportUserName>
	          <ImportUserPassword>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='SharePoint Install Account']/password"/><![CDATA[</ImportUserPassword>
          ]]>

      </xsl:otherwise>
    </xsl:choose>


    <![CDATA[ 
    
   
    </Certificates>
    <Sizing>
                <AmountOfUsers>]]><xsl:value-of select="//numberofusers"/><![CDATA[</AmountOfUsers>  
                <AmountIndexedItems>]]><xsl:value-of select="//amountindexeditems"/><![CDATA[</AmountIndexedItems>      
                <DocumentStorage>]]><xsl:value-of select="//requireddocumentstorage"/><![CDATA[</DocumentStorage>   
                
                <MaxInstanceSizeGB>]]><xsl:value-of select="//sqlinstancemaxsizeGB"/><![CDATA[</MaxInstanceSizeGB>   
                <ContentDBMaxSizeGB>]]><xsl:value-of select="//contentdbmaxsize"/><![CDATA[</ContentDBMaxSizeGB>   
                <BackupStorageNeeded>]]><xsl:value-of select="//backupstorageneeded"/><![CDATA[</BackupStorageNeeded>   
                
                      
			<TotalContentDBStorageNeededinGB>]]><xsl:value-of select="farm/totalcontentdbsize"/><![CDATA[</TotalContentDBStorageNeededinGB>
			<TotalSearchDBStorageNeededinMB>]]><xsl:value-of select="farm/searchdbsize"/><![CDATA[</TotalSearchDBStorageNeededinMB>
			<TotalOtherDBStorageNeededinMB>]]><xsl:value-of select="farm/otherdbsize"/><![CDATA[</TotalOtherDBStorageNeededinMB>  			 			  
    </Sizing>
    </Install>
     ]]>
    <xsl:choose>
      <xsl:when test="farm/createdomain = 'Yes'">
        <![CDATA[<Domain>]]><xsl:value-of select="//domaincreatesettings/settings/netbios"/><![CDATA[</Domain>
	          <DomainFQDN>]]><xsl:value-of select="//domaincreatesettings/settings/forestdomainname"/><![CDATA[</DomainFQDN>
          ]]>

      </xsl:when>
      <xsl:otherwise>
        <![CDATA[<Domain>]]><xsl:value-of select="//domainjoinsettings/settings/shortdomainame"/><![CDATA[</Domain>
	          <DomainFQDN>]]><xsl:value-of select="//domainjoinsettings/settings/forestdomainname"/><![CDATA[</DomainFQDN>
          ]]>
      </xsl:otherwise>
    </xsl:choose>


    <![CDATA[ 
  
    <SubscriptionIDs/>
      
    <!-- The Farm section contains basic farm-wide settings -->

    <Farm>    
    
    <WebAppDomain>]]><xsl:value-of select="normalize-space(//webAppDomain)"/><![CDATA[</WebAppDomain>
  <WebAppDomainApps>]]><xsl:value-of select="normalize-space(//webAppDomainApps)"/><![CDATA[</WebAppDomainApps>
    
    
    
 <!--NG This is the Farm Name (which is customer specific-->
 <BusinessUnit>]]><xsl:value-of select="//businessunit"/><![CDATA[</BusinessUnit> 
        <PrivateIPWebApps>]]><xsl:value-of select="farm/privateipwebapps"/><![CDATA[</PrivateIPWebApps> 
        <PublicIPWebApps>]]><xsl:value-of select="farm/publicipwebapps"/><![CDATA[</PublicIPWebApps> 
        <ProxyServer>]]><xsl:value-of select="normalize-space(farm/proxyserver)"/><![CDATA[</ProxyServer>    
        <StandardUsers>]]><xsl:value-of select="farm/standardusers"/><![CDATA[</StandardUsers>    
<EnterpriseUsers>]]><xsl:value-of select="farm/enterpriseusers"/><![CDATA[</EnterpriseUsers>    

  
 
        <FarmName>]]><xsl:value-of select="farm/farmname"/><![CDATA[</FarmName> 
        <Purpose>]]><xsl:value-of select="farm/purpose"/><![CDATA[</Purpose> 
        <CustomerName>]]><xsl:value-of select="farm/customer"/><![CDATA[</CustomerName>    
        <CustomerNameShort>]]><xsl:value-of select="farm/customerabreviation"/><![CDATA[</CustomerNameShort>    


        <CreateDomain>]]><xsl:value-of select="farm/createdomain"/><![CDATA[</CreateDomain>
        <JoinDomain>]]><xsl:value-of select="farm/joindomain"/><![CDATA[</JoinDomain>


        <RestrictSiteDefinitions>]]><xsl:value-of select="farm/restrictsitedefinitions"/><![CDATA[</RestrictSiteDefinitions>



<BlobCacheLocation>]]><xsl:value-of select="farm/blobcachelocation"/><![CDATA[</BlobCacheLocation>  
        <!--NG This is the default quota template that we should use for mysites. We need to update the inbuilt 'Personal' quota template with the definition of this one which is elsewhere in this XML file.-->
        <DefaultMySitesQuotaTemplate>]]><xsl:value-of select="farm/mysitequota"/><![CDATA[</DefaultMySitesQuotaTemplate>    
        <!--Enter the passphase that will be used to join additional servers to the farm. This farm passphrase will also be used for the Secure Store service app-->
        <Passphrase>]]><xsl:value-of select="farm/passphrase"/><![CDATA[</Passphrase>
        <!-- The "Farm" account that will be used to run Central Administration and the timer service. If AddToLocalAdminsDuringSetup is true, it will be
		     added to the server's local administrators group for the duration of the execution of the script. This is required for some steps, such as
		     configuring the User Profile Synchronization service. If for some reason you need to leave the Farm account in the Administrators group after setup, set LeaveInLocalAdmins to true -->
        <Account AddToLocalAdminsDuringSetup="false" LeaveInLocalAdmins="false">
            <Username>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/domain"/>\<xsl:value-of select="farm/managedaccounts/managedaccount[purpose='Farm Account']/username"/><![CDATA[</Username>
            <Password>]]><xsl:value-of select="farm/managedaccounts/managedaccount[purpose='Farm Account']/password"/><![CDATA[</Password>
            <Email>]]><xsl:value-of select="farm/managedaccounts/managedaccount[purpose='Farm Account']/email"/><![CDATA[</Email>
        </Account>
        <!-- Which server(s) to provision CentralAdmin on. Specify "true" or a list of servers -->
         <CentralAdmin Provision="]]>          
        <xsl:value-of select="farm/servers/server[role='Web Server Group 1'][1]/name"/>     
    <![CDATA[">                
            <Port>8888</Port>
            <CentralAdminAuth>NTLM</CentralAdminAuth>
			<CentralAdminSSL Enable="False" />
        </CentralAdmin>
        ]]>
    <![CDATA[
    <Database>]]>


    <!--Create the Aliases-->
    <![CDATA[
		<Aliases>]]><xsl:for-each select="farm/sqlinstances/sqlinstance[name!='']">
      <xsl:variable
          name="witnessName"
          select="witness">
      </xsl:variable>
      <xsl:variable
    name="aliasName"
    select="aliasname">
      </xsl:variable>
      <xsl:variable
         name="instanceID"
         select="instanceid">
      </xsl:variable>
      <xsl:variable name="serverNameForAlias">

        <xsl:choose>
          <xsl:when test="principalserver = '' or not(principalserver)">
            <xsl:choose>

              <xsl:when test="type = 'Content SQL Server'">
                <xsl:choose>
                  <xsl:when test="count(//servers/server[role='SQL Server for Content DBs']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for Content DBs'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:when test="count(//servers/server[role='SQL Server for all DB Types']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for all DB Types'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="//servers/server[role='Web Server Group 1'][1]/name"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>

              <xsl:when test="type = 'Search SQL Server'">
                <xsl:choose>
                  <xsl:when test="count(//servers/server[role='SQL Server for Search and Other DBs']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for Search and Other DBs'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:when test="count(//servers/server[role='SQL Server for all DB Types']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for all DB Types'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="//servers/server[role='Web Server Group 1'][1]/name"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="type = 'Other SQL Server'">
                <xsl:choose>
                  <xsl:when test="count(//servers/server[role='SQL Server for Search and Other DBs']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for Search and Other DBs'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:when test="count(//servers/server[role='SQL Server for all DB Types']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for all DB Types'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="//servers/server[role='Web Server Group 1'][1]/name"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="type = 'General'">
                <xsl:choose>
                  <xsl:when test="count(//servers/server[role='SQL Server for all DB Types']) > 0">
                    <xsl:value-of select="//servers/server[role='SQL Server for all DB Types'][number($instanceID)]/name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="//servers/server[role='Web Server Group 1'][1]/name"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="principalserver"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:variable>

      <![CDATA[
				<Alias>
					 <type>]]><xsl:value-of select="type"/><![CDATA[</type>
          <isPrimary>]]><xsl:value-of select="primary"/><![CDATA[</isPrimary>]]>
      <![CDATA[<SQLAlias>]]><xsl:value-of select="aliasname"/><![CDATA[</SQLAlias>
      	  <SQLAliasName>]]><xsl:value-of select="aliasname"/><![CDATA[</SQLAliasName>
          <DBServerNoInstance>]]><xsl:value-of select="$serverNameForAlias"/><![CDATA[</DBServerNoInstance>
					<DBServer>]]><xsl:value-of select="$serverNameForAlias"/>\<xsl:value-of select="name"/><![CDATA[</DBServer>
					<IPAddress>]]><xsl:value-of select="ipaddress"/><![CDATA[</IPAddress>
      					<Port>]]><xsl:value-of select="port"/><![CDATA[</Port>


<DBServerNoInstance_AlwaysOn>]]><xsl:value-of select="$serverNameForAlias"/><![CDATA[</DBServerNoInstance_AlwaysOn>
					<DBServer_AlwaysOn>]]><xsl:value-of select="$serverNameForAlias"/>\<xsl:value-of select="name"/><![CDATA[</DBServer_AlwaysOn>
      					<Port_AlwaysOn>]]><xsl:value-of select="port"/><![CDATA[</Port_AlwaysOn>
					                      
                <DefaultCollation>]]><xsl:value-of select="Collation"/><![CDATA[</DefaultCollation>
]]><xsl:choose>
        <xsl:when test="//doUseSmallDriveSizesForCIC = 'True'"><![CDATA[
          <DataDrive>h</DataDrive>
		<DataDrive2>h</DataDrive2> 
                <LogsDrive>h</LogsDrive>
               <LogsDrive2>h</LogsDrive2>
                <TempDBDataDrive>h</TempDBDataDrive>
                <TempDBLogsDrive>h</TempDBLogsDrive>
                <SystemDBDrive>h</SystemDBDrive>
                <BackupDrive>h</BackupDrive>
		<ClusterShareDrive>n</ClusterShareDrive>]]>
        </xsl:when>
        <xsl:otherwise>
          <![CDATA[
          <DataDrive>h</DataDrive>
		<DataDrive2>h</DataDrive2>
                 <LogsDrive>h</LogsDrive>
               <LogsDrive2>h</LogsDrive2>
                <TempDBDataDrive>h</TempDBDataDrive>
                <TempDBLogsDrive>h</TempDBLogsDrive>
                <SystemDBDrive>h</SystemDBDrive>
                <BackupDrive>h</BackupDrive>
		<ClusterShareDrive>n</ClusterShareDrive>]]>
        </xsl:otherwise>
      </xsl:choose><![CDATA[


                
	    <DBsToCreate></DBsToCreate>
          <DBCreators></DBCreators>
    <AlwaysOnSettings>

      
        <ClusterIPs>]]><xsl:value-of select="//clusterconfiguration/updatedclusterconfiguration_cluster[alias=$aliasName]/ipandsubnet"/><![CDATA[</ClusterIPs>   
        <ClusterName>]]><xsl:value-of select="//clusterconfiguration/updatedclusterconfiguration_cluster[alias=$aliasName]/clustername"/><![CDATA[</ClusterName>        
        
        
        <ListenerIPs>]]><xsl:choose>
        <xsl:when test="count(//clusterconfiguration/updatedclusterconfiguration_listener[alias=$aliasName]) > 0">
          <xsl:value-of select="//clusterconfiguration/updatedclusterconfiguration_listener[alias=$aliasName]/ipandsubnet"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="//clusterconfiguration/updatedclusterconfiguration_listener[1]/ipandsubnet"/>
        </xsl:otherwise>
      </xsl:choose><![CDATA[</ListenerIPs>
        <ListenerName>]]><xsl:choose>
        <xsl:when test="count(//clusterconfiguration/updatedclusterconfiguration_listener[alias=$aliasName]) > 0">
          <xsl:value-of select="//clusterconfiguration/updatedclusterconfiguration_listener[alias=$aliasName]/listenername"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="//clusterconfiguration/updatedclusterconfiguration_listener[1]/listenername"/>
        </xsl:otherwise>
      </xsl:choose><![CDATA[</ListenerName>
        <ListenerPort>3626</ListenerPort>
        <ClusterPort>5022</ClusterPort>
        
        <AvailabilityGroupName>]]><xsl:value-of select="name"/><![CDATA[_Default</AvailabilityGroupName>
        <ClusterQuoromShare></ClusterQuoromShare>
        <Node1SQLBackupShare></Node1SQLBackupShare>
        <EndpointName>]]><xsl:value-of select="name"/><![CDATA[AlwaysOn_Endpoint</EndpointName>
        <EndpointPort>]]><xsl:value-of select="listenerport"/><![CDATA[</EndpointPort>      
      </AlwaysOnSettings>
      
				</Alias>]]>
    </xsl:for-each>
    <![CDATA[
      	</Aliases>
		<OtherDatabaseSettings>
    <BAIPreviewCacheMaxSizeMB>]]><xsl:value-of select="farm/baipreviewcachemaxsizeMB"/><![CDATA[</BAIPreviewCacheMaxSizeMB>	
		  <FixedDataGrowthSizeMB>]]><xsl:value-of select="farm/fixeddatagrowthsizeMB"/><![CDATA[</FixedDataGrowthSizeMB>
      <FixedLogGrowthSizeMB>]]><xsl:value-of select="farm/fixedloggrowthsizeMB"/><![CDATA[</FixedLogGrowthSizeMB>

      <ModifyADandDNSPreCreatedClusterElementsForHA>]]><xsl:value-of select="farm/makeADandDNSChanges_precreated"/><![CDATA[</ModifyADandDNSPreCreatedClusterElementsForHA>      
      <CreateDNSObjectsForHA>]]><xsl:value-of select="farm/createDNSObjects"/><![CDATA[</CreateDNSObjectsForHA>
      <StartClusterIPAddressRange>]]><xsl:value-of select="farm/startClusterIP"/><![CDATA[</StartClusterIPAddressRange>
      <StartListenerIPAddressRange>]]><xsl:value-of select="farm/startListenerIP"/><![CDATA[</StartListenerIPAddressRange>
      
      
			<ContentDBInitialSizeMB>10000</ContentDBInitialSizeMB>
      <OtherDBInitialSizeMB>2000</OtherDBInitialSizeMB>
             <SearchAnalyticsDBInitialSizeMB>250000</SearchAnalyticsDBInitialSizeMB>

      <PercentageLogSizeOfDataSize>]]><xsl:value-of select="farm/percentagelogsizeofdatasize"/><![CDATA[</PercentageLogSizeOfDataSize>
      <PercentageDataGrowthOfDataSize>25</PercentageDataGrowthOfDataSize>
      <PercentageLogGrowthOfLogSize>25</PercentageLogGrowthOfLogSize>
      
      

			    
			 <!-- Other settings from the Farm Configuration From DSC 2, leave in place for DSC 3. -->
			<RequiredDocumentStorage>]]><xsl:value-of select="farm/requireddocumentstorage"/><![CDATA[</RequiredDocumentStorage>
			<AmountOfDocuments>]]><xsl:value-of select="farm/amountofdocuments"/><![CDATA[</AmountOfDocuments>
      
      
			<TotalContentDBSize>]]><xsl:value-of select="farm/totalcontentdbsize"/><![CDATA[</TotalContentDBSize>
			<SearchDBSize>]]><xsl:value-of select="farm/searchdbsize"/><![CDATA[</SearchDBSize>
			<OtherDBSize>]]><xsl:value-of select="farm/otherdbsize"/><![CDATA[</OtherDBSize>  			 
			  
      <!-- <ContentDBMaxSize>]]><xsl:value-of select="farm/contentdbmaxsize"/><![CDATA[</ContentDBMaxSize>
			<ContentDBDefaultSize>]]><xsl:value-of select="farm/contentdbdefaultsize"/><![CDATA[</ContentDBDefaultSize>  			 
			<ContentDBsPerSQLInstance>]]><xsl:value-of select="farm/numbercontentdbspersqlinstance"/><![CDATA[</ContentDBsPerSQLInstance>
      <SearchBackupUNC>]]><xsl:value-of select="farm/searchbackuppath"/><![CDATA[</SearchBackupUNC>  -->  
      <SiteCollectionsPerContentDB max="160" warning="120"></SiteCollectionsPerContentDB>    
      
		</OtherDatabaseSettings>
		
		<ContentDBs>]]>
    <!-- Create a variable to hold the number of SQL Instances -->
    <xsl:variable
        name="numContentInstances"
        select="count(farm/sqlinstances/sqlinstance[type='Content SQL Server'])">
    </xsl:variable>
    <![CDATA[<NumberOfContentSQLInstances>]]><xsl:value-of select="$numContentInstances"/><![CDATA[</NumberOfContentSQLInstances>]]>

    <xsl:variable
              name="numDBsPerInstance"
              select="farm/numbercontentdbspersqlinstance">
    </xsl:variable>
    <xsl:variable
              name="instanceGBCounter"
              select="0">
    </xsl:variable>

    <xsl:for-each select="//ContentDB">



      <!--<xsl:call-template name="for.loop.CDB">
            <xsl:with-param name="i">1</xsl:with-param>
            <xsl:with-param name="instanceID">1</xsl:with-param>
            <xsl:with-param name="currentInstanceCount">1</xsl:with-param>
            <xsl:with-param name="maxContentDBsInInstance"><xsl:value-of select="//numbercontentdbspersqlinstance"/></xsl:with-param>            
            <xsl:with-param name="contentDBName">
              <xsl:value-of select="Name"/>
            </xsl:with-param>
            <xsl:with-param name="instanceAliasPrefix">prefix</xsl:with-param>
            <xsl:with-param name="instanceAliasSuffix">P</xsl:with-param>
          </xsl:call-template>-->


      <!--<xsl:value-of select="$instanceContentDBCount +1"></xsl:value-of>-->
      <!--          <![CDATA[<ContentDB type="WebApplication" name="]]><xsl:value-of select="Name"/><![CDATA[" WebApplication="]]><xsl:value-of select="WebApplication"/><![CDATA[" SQLAlias="SQLCON_]]><![CDATA[]]><xsl:if test="position() &gt; 0 and position() &lt; ($numDBsPerInstance + 1)">01</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 1) and position() &lt; (($numDBsPerInstance * 2) + 1)">02</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 2) and position() &lt; (($numDBsPerInstance * 3) + 1)">03</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 3) and position() &lt; (($numDBsPerInstance * 4) + 1)">04</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 4) and position() &lt; (($numDBsPerInstance * 5) + 1)">05</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 5) and position() &lt; (($numDBsPerInstance * 6) + 1)">06</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 6) and position() &lt; (($numDBsPerInstance * 7) + 1)">07</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 7) and position() &lt; (($numDBsPerInstance * 8) + 1)">08</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 8) and position() &lt; (($numDBsPerInstance * 9) + 1)">09</xsl:if><xsl:if test="position() &gt; ($numDBsPerInstance * 9) and position() &lt; (($numDBsPerInstance * 10) + 1)">10</xsl:if><![CDATA[_C1" SQLMirrorAlias="" MaxSizeGB="]]><xsl:value-of select="MaxSize"/><![CDATA[" />]]>-->
      <![CDATA[<ContentDB type="WebApplication" name="]]><xsl:value-of select="Name"/><![CDATA[" WebApplication="]]><xsl:value-of select="WebApplication"/><![CDATA[" SQLAlias="]]><xsl:value-of select="Alias"/><![CDATA[" SQLMirrorAlias="" MaxSizeGB="]]><xsl:value-of select="MaxSize"/><![CDATA[" />]]>

      <!--Currentcount:<xsl:value-of select="position()"></xsl:value-of>
          <xsl:if test="position() > 1 and (position() mod 10) = 1">
            1
            
          </xsl:if>
          <xsl:if test="position() > 10 and (position() mod 10) = 1">
            2

          </xsl:if>-->

    </xsl:for-each>

    <!--Add the OWA Content DBs-->
    <xsl:for-each select="//owasetting">
      <xsl:variable
          name="owaWebApp"
          select="webapplicationname">
      </xsl:variable>

      <![CDATA[<ContentDB type="OWA" name="]]><xsl:value-of select="contentdb"/><![CDATA[" WebApplication="]]><xsl:value-of select="webapplicationname"/><![CDATA[" SQLAlias="SQLCON_]]><xsl:value-of select="//farmnumber"/><![CDATA[_C]]><xsl:value-of select="$numContentInstances"/><![CDATA[_P"]]><![CDATA[ SQLMirrorAlias="SQLCON_]]><xsl:value-of select="//farmnumber"/><![CDATA[_C]]><xsl:value-of select="$numContentInstances"/><![CDATA[_M"/>]]>
    </xsl:for-each>
    <![CDATA[			
		</ContentDBs>
		
    </Database>
            ]]>
    <![CDATA[      
    <DistributedCacheCluster>
      <Size>Small</Size>
      <CacheHostServerRoles>
        <ServerRole>Web Server Group 1</ServerRole>        
      </CacheHostServerRoles>
      <CachePort>22233</CachePort>
      <ClusterPort>22234</ClusterPort>
      <ArbitrationPort>22235</ArbitrationPort>
      <ReplicationPort>22236</ReplicationPort>
            
    </DistributedCacheCluster>
]]>
    <![CDATA[       
<Servers>]]>
    <xsl:for-each select="farm/servers/server">
      <xsl:variable
        name="serverName"
        select="name">
      </xsl:variable>
      <xsl:if test="name!=''">
        <![CDATA[
          <Server name="]]><xsl:value-of select="name"/><![CDATA["  mRole='' tempName="]]><xsl:value-of select="name"/><![CDATA[" SAMID="" vAppName="" ip="]]><xsl:value-of select="//serveripaddress[servername=$serverName]/serverip"/><![CDATA[" role="]]><xsl:value-of select="role"/><![CDATA[" addToDomain="]]><xsl:value-of select="addtodomain"/><![CDATA[" datacenter="]]><xsl:value-of select="datacenter"/><![CDATA[" appliance="]]><xsl:value-of select="appliance"/><![CDATA[" vmtemplate="]]><xsl:value-of select="deploymenttemplate"/><![CDATA[" />]]>
      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</Servers>
]]>


    <![CDATA[       
<ServerIPAddresses>]]>
    <xsl:for-each select="farm/serveripaddresses/serveripaddress">
      <xsl:if test="servername!=''">
        <![CDATA[
        <Server name="]]><xsl:value-of select="servername"/><![CDATA[" serviceIP="]]><xsl:value-of select="serverip"/><![CDATA[" operationsIP="]]><xsl:value-of select="operationsip"/><![CDATA[" backupIP="]]><xsl:value-of select="backupip"/><![CDATA[" sqlreplicationIP="]]><xsl:value-of select="sqlreplicationip"/><![CDATA[" dmzinternalIP="]]><xsl:value-of select="dmzinternalip"/><![CDATA[" dmzexternalIP="]]><xsl:value-of select="dmzexternalip"/><![CDATA[" externalIP="" />]]>

      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</ServerIPAddresses>
]]>


    <![CDATA[       
<VMTemplates>]]>
    <xsl:for-each select="farm/vmtemplates/vmtemplate">
      <xsl:if test="name!=''">
        <![CDATA[
        <VMTemplate name="]]><xsl:value-of select="name"/><![CDATA[" description="]]><xsl:value-of select="description"/><![CDATA[" performanceunits="]]><xsl:value-of select="performanceunits"/><![CDATA[" cores="]]><xsl:value-of select="cores"/><![CDATA[" ram="]]><xsl:value-of select="ram"/><![CDATA[" network="]]><xsl:value-of select="network"/><![CDATA["/>]]>

      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</VMTemplates>
]]>



    <![CDATA[       
<ServerGroupSettings>]]>
    <xsl:for-each select="farm/servergroups/servergroup">
      <xsl:if test="name!=''">
        <![CDATA[
        <Server name="]]><xsl:value-of select="name"/><![CDATA[" description="]]><xsl:value-of select="description"/><![CDATA[" needsExternalIP="]]><xsl:value-of select="needsexternalip"/><![CDATA[" requiredNumber="]]><xsl:value-of select="requirednumber"/><![CDATA[" orderedNumber="]]><xsl:value-of select="orderednumber"/><![CDATA[" vmTemplate="]]><xsl:value-of select="vmtemplate"/><![CDATA[" cdrivevhdsizeGB="]]><xsl:value-of select="cdrivevhdsize"/><![CDATA[" edrivevhdsizeGB="]]><xsl:value-of select="edrivevhdsize"/><![CDATA[" fdrivevhdsizeGB="]]><xsl:value-of select="fdrivevhdsize"/><![CDATA[" gdrivevhdsizeGB="]]><xsl:value-of select="gdrivevhdsize"/><![CDATA[" hdrivevhdsizeGB="]]><xsl:value-of select="hdrivevhdsize"/><![CDATA[" idrivevhdsizeGB="]]><xsl:value-of select="idrivevhdsize"/><![CDATA[" jdrivevhdsizeGB="]]><xsl:value-of select="jdrivevhdsize"/><![CDATA[" kdrivevhdsizeGB="]]><xsl:value-of select="kdrivevhdsize"/><![CDATA[" ldrivevhdsizeGB="]]><xsl:value-of select="ldrivevhdsize"/><![CDATA[" mdrivevhdsizeGB="]]><xsl:value-of select="mdrivevhdsize"/><![CDATA[" ndrivevhdsizeGB="]]><xsl:value-of select="ndrivevhdsize"/><![CDATA[" pdrivevhdsizeGB="]]><xsl:value-of select="pdrivevhdsize"/><![CDATA[" nicservice="]]><xsl:value-of select="nicservice"/><![CDATA[" nicoperations="]]><xsl:value-of select="nicoperations"/><![CDATA[" nicbackup="]]><xsl:value-of select="nicbackup"/><![CDATA[" nicsqlreplication="]]><xsl:value-of select="nicsqlreplication"/><![CDATA[" nicdmzinternal="]]><xsl:value-of select="nicdmzinternal"/><![CDATA[" nicdmzexternal="]]><xsl:value-of select="nicdmzexternal"/><![CDATA["/>]]>
      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</ServerGroupSettings>
]]>




    <![CDATA[<!-- The Services section configures the core service instances & components that are part of SharePoint Foundation -->
    
    <Services>
 
        <SMTP Install="true" />
        <OutgoingEmail Configure="true">
            <SMTPServer>]]><xsl:value-of select="farm/smtpservers/smtpserver/outgoingsmtp"/><![CDATA[</SMTPServer>
			 <EmailAddress>]]><xsl:value-of select="farm/smtpservers/smtpserver/senderaddress"/><![CDATA[</EmailAddress>
			 <ReplyToEmail>]]><xsl:value-of select="farm/smtpservers/smtpserver/replytoemailaddress"/><![CDATA[</ReplyToEmail>			
       <IncomingDomain>]]><xsl:value-of select="farm/smtpservers/smtpserver/domain"/><![CDATA[</IncomingDomain>			
       <FolderLocation>]]><xsl:value-of select="farm/smtpservers/smtpserver/folderlocation"/><![CDATA[</FolderLocation>	
		</OutgoingEmail>
		<SPTracing RunAsServiceAccount="False" />


	 <Serverroles>
        <Serverrole name="Web Server Group 1"> 
        ]]>
    <xsl:choose>
      <xsl:when test="count(farm/servers/server[role='Web Server Group 2']) = 0 and count(farm/servers/server[role='Application Server Group 1']) = 0 and count(farm/servers/server[role='Search Server Group 1']) = 0 and count(farm/servers/server[role='Search Server Group 2']) = 0 and count(farm/servers/server[role='Search Server Group 3']) = 0 and count(farm/servers/server[role='Search Server Group 4']) = 0">
        <![CDATA[
            <!-- This is a farm which has only Web Group 1 servers, so we need to start ALL services on this server group-->            
 
            
                 
                     <Service Name="Microsoft SharePoint Foundation Web Application" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
                      <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
                      <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
                      
                      <Service Name="Central Administration" State="Start" Provision="true" ServiceInstanceType="Central Administration"/>
                      
                      
                      <Service Name="Application Discovery and Load Balancer Service" State="Start" Provision="true" ServiceInstanceType=""/>
                     
                      <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
      
		                  <Service Name="Search Query and Site Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>                      
                      <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>
                      
                      ]]>
        <xsl:choose>
          <xsl:when test="count(//serviceapplications/serviceapplication[enable='Yes']) > 7">
            <![CDATA[
                          <!-- SP Appliance-->
         
		                        <Service Name="Business Data Connectivity Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
                            <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
                            <Service Name="Document Conversions Launcher Service" State="Start" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
                            <Service Name="Document Conversions Load Balancer Service" State="Start" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
                            <Service Name="Excel Calculation Services" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
                            <Service Name="Managed Metadata Web Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
                            <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
                            
                            <Service Name="PerformancePoint Service" State="Start" Provision="true" ServiceInstanceType="PerformancePoint Service"/>
                            <Service Name="Project Application Service" State="Start" Provision="false" ServiceInstanceType="*Project*"/>
                            <Service Name="Secure Store Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
                            <Service Name="User Profile Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
                            <Service Name="User Profile Synchronisation Service" State="Stop" Provision="false" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
                            <Service Name="Visio Graphics Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
                            <Service Name="Word Automation Services" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>                      
                            <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>
		                        <Service Name="Access Database Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
                            <Service Name="Access Database Service 2010" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
        
          

                            <Service Name="App Management Service" State="Start" Provision="true" ServiceInstanceType="App Management Service" />
                            <Service Name="Machine Translation Service" State="Start" Provision="true" ServiceInstanceType="Machine Translation Service" />
                            <Service Name="Work Management Service" State="Start" Provision="true" ServiceInstanceType="Work Management Service" />
                            <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />


                      
                    ]]>
          </xsl:when>
          <xsl:otherwise>

            <![CDATA[
                      <!-- Search Appliance-->
		                      <Service Name="Business Data Connectivity Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
                          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
                          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
                          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
                          <Service Name="Excel Calculation Services" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
                          <Service Name="Managed Metadata Web Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
                          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
                          
                          <Service Name="PerformancePoint Service" State="Start" Provision="false" ServiceInstanceType="PerformancePoint Service"/>
                          <Service Name="Project Application Service" State="Start" Provision="false" ServiceInstanceType="*Project*"/>
                          <Service Name="Secure Store Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
                          <Service Name="User Profile Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
                          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
                          <Service Name="Visio Graphics Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
                          <Service Name="Word Automation Services" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>                      
                          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>
		                      <Service Name="Access Database Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
                          <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
        
          

                          <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                          <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                          <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                          <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />


                      
                  ]]>
          </xsl:otherwise>
        </xsl:choose>


      </xsl:when>
      <xsl:otherwise>
        <![CDATA[
              <!-- This is a farm which has more than just Web Group 1 servers, so we need lots of conditional logic to figure out which services to start-->
        
                      <Service Name="Microsoft SharePoint Foundation Web Application" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
                      <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
                      <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
                      <!--TODO - this is wrong but needed for temp testing-->
                      <!--Turn Off all Web Server Group 2 Services"-->
                      ]]>
        <!-- Dont start CA on Web Server Group 1 if we have Web Server Group 2 servers. -->
        <xsl:choose>
          <xsl:when test="count(farm/servers/server[role='Web Server Group 2']) > 0">
            <![CDATA[<Service Name="Central Administration" State="Stop" Provision="true" ServiceInstanceType="Central Administration"/>]]>
          </xsl:when>
          <xsl:otherwise>
            <![CDATA[<Service Name="Central Administration" State="Start" Provision="true" ServiceInstanceType="Central Administration"/>]]>
          </xsl:otherwise>
        </xsl:choose>
        <![CDATA[
                      <!--Turn Off all Application Server Group 1 Services"-->
                      <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
                       <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
                      <Service Name="Application Discovery and Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType=""/>
                      <Service Name="Business Data Connectivity Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
                      <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
                      <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
                      <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
                      <Service Name="Excel Calculation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
                      <Service Name="Managed Metadata Web Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
                      <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
                      <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
                      <Service Name="PerformancePoint Service" State="Stop" Provision="true" ServiceInstanceType="PerformancePoint Service"/>
                      <Service Name="Project Application Service" State="Stop" Provision="false" ServiceInstanceType="*Project*"/>
			
		<!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />


                      
                      ]]>
        <!--Fix for 1.4.4 - if there are no Search Group 1 Servers then we need to start the Search Query and Site Settings service (Query Processor) on Web Group 1."-->
        <xsl:choose>
          <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 1">
            <![CDATA[<Service Name="Search Query and Site Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>                      
]]>
          </xsl:when>
          <xsl:otherwise>
            <![CDATA[<Service Name="Search Query and Site Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>                      
]]>
          </xsl:otherwise>
        </xsl:choose>
        <![CDATA[
                   

		
                      
                      <Service Name="Secure Store Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
                      <Service Name="User Profile Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
                      <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
                      <Service Name="Visio Graphics Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
                      <Service Name="Word Automation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
                      <!--Turn Off all Application Server Group 2 Services"-->
                      <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>
                      <!--Turn Off all Application Search Server Group 1 + 2 Services unless there are no search servers in which case start the services."-->
                       ]]>
        <xsl:choose>
          <xsl:when test="count(farm/servers/server[role='Search Server Group 2']) > 0">
            <![CDATA[ 
                              <Service Name="SharePoint Server Search" State="Stop" Provision="true" ServiceInstanceType="SharePoint Server Search"/>
                              ]]>
          </xsl:when>
          <xsl:otherwise>
            <![CDATA[ 
                                <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>]]>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>



    <![CDATA[ 
                      
        </Serverrole>
      
<Serverrole name="Web Server Group 2">          
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application" />
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail" />
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service" />
          <Service Name="Central Administration" State="Start" Provision="true" ServiceInstanceType="Central Administration" />
          <!--Turn Off all Application Server Group 1 Services"-->
          <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance" />
          <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance" />
          <Service Name="Application Discovery and Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="" />
          <Service Name="Business Data Connectivity Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance" />
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service" />
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service" />
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service" />
          <Service Name="Excel Calculation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance" />
          <Service Name="Managed Metadata Web Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance" />
          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector" />
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service" />
          <Service Name="PerformancePoint Service" State="Stop" Provision="true" ServiceInstanceType="PerformancePoint Service" />
          <Service Name="Project Application Service" State="Stop" Provision="false" ServiceInstanceType="*Project*" />

          <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
          <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
          <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
          <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />
          <Service Name="Search Query and Site Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance" />
          <Service Name="Secure Store Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance" />
          <Service Name="User Profile Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance" />
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance" />
          <Service Name="Visio Graphics Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance" />
          <Service Name="Word Automation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance" />
          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance" />

          <Service Name="SharePoint Server Search" State="Stop" Provision="true" ServiceInstanceType="SharePoint Server Search" />
        </Serverrole>

        <Serverrole name="Application Server Group 1">
          <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
           <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
          <Service Name="Application Discovery and Load Balancer Service" State="Start" Provision="true" ServiceInstanceType=""/>
          <Service Name="Business Data Connectivity Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
          <Service Name="Excel Calculation Services" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
          <Service Name="Managed Metadata Web Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
          <Service Name="PerformancePoint Service" State="Start" Provision="false" ServiceInstanceType="PerformancePoint Service"/>
          <Service Name="Project Application Service" State="Start" Provision="false" ServiceInstanceType="*Project*"/>
           <!--New for 1.4 - Stop the Search Query And Site Settings service on App Group 1 via  request from Stefan-->
          <Service Name="Search Query and Site Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>
          <Service Name="Secure Store Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>          
          <Service Name="User Profile Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
          <Service Name="Visio Graphics Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
         <Service Name="Word Automation Services" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
       
          <!--Turn Off all Web Server Group 1 Services-->
          <!--New for v1.4 - Start the Web Application Service (this was a request from Simon Robinson)"-->
          <!--New for v3.4.0 - Ignore the comment above. DO not start the Web App service on App Group 1."-->
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Stop" Provision="false" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
          <!--Turn Off all Web Server Group 2 Services"-->
          <Service Name="Central Administration" State="Stop" Provision="true" ServiceInstanceType="Central Administration"/>
          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>
          <!--Turn Off all Application Server Group 2 Services"-->
          ]]>
    <![CDATA[
          
          
                    ]]>
    <xsl:choose>
      <xsl:when test="farm/farmtype = 'SP'">

        <![CDATA[
              <!--Fix for 3.1.0 and SP farms - start the Search service here so that the install works AND also is correct design for the smaller EMP 1.1 farms. We will inly install the Admin Component here.-->
            <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>
            
            
            
                    <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="true" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="true" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="true" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="true" ServiceInstanceType="Request Management" />
              
              ]]>
      </xsl:when>
      <xsl:otherwise>
        <![CDATA[
              
              <!--New for 2.7.X + - Enable Search on App Group 1-->
            <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>
            
            
            
                    <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="true" ServiceInstanceType="Request Management" />
              
              ]]>
      </xsl:otherwise>
    </xsl:choose>
    <![CDATA[
          
            
          
        </Serverrole>
      
        <Serverrole name="Application Server Group 2">
          <Service Name="Access Database Service" State="Stop" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
           <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
          <Service Name="Application Discovery and Load Balancer Service" State="false" Provision="true" ServiceInstanceType=""/>
          <Service Name="Business Data Connectivity Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="false" ServiceInstanceType="Claims to Windows Token Service"/>
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="false" ServiceInstanceType="Document Conversions Launcher Service"/>
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="false" ServiceInstanceType="Document Conversions Load Balancer Service"/>
          <Service Name="Excel Calculation Services" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
          <Service Name="Managed Metadata Web Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
          <Service Name="Lotus Notes Connector" State="Stop" Provision="false" ServiceInstanceType="Lotus Notes Connector"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Stop" Provision="false" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
          <Service Name="PerformancePoint Service" State="Start" Provision="false" ServiceInstanceType="PerformancePoint Service"/>
          <Service Name="Project Application Service" State="Start" Provision="false" ServiceInstanceType="*Project*"/>
           <!--New for 1.4 - Stop the Search Query And Site Settings service on App Group 1 via  request from Stefan-->
          <Service Name="Search Query and Site Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>
          <Service Name="Secure Store Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>          
          <Service Name="User Profile Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="false" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
          <Service Name="Visio Graphics Service" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
         <Service Name="Word Automation Services" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
       
          <!--Turn Off all Web Server Group 1 Services-->
          <!--New for v1.4 - Start the Web Application Service (this was a request from Simon Robinson)"-->
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Start" Provision="false" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Stop" Provision="false" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Stop" Provision="false" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
          <!--Turn Off all Web Server Group 2 Services"-->
          <Service Name="Central Administration" State="Stop" Provision="false" ServiceInstanceType="Central Administration"/>
          
          <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>
           <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>
          
                    <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="true" ServiceInstanceType="Request Management" />
          
        </Serverrole>
        
        <Serverrole name="Search Server Group 1">
          
          <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>

          <!--Turn Off all Web Server Group 1 Services"-->
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
          <!--Turn Off all Web Server Group 2 Services"-->
          <Service Name="Central Administration" State="Stop" Provision="true" ServiceInstanceType="Central Administration"/>
          <!--Turn Off all Application Server Group 1 Services"-->
          <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
           <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
          <Service Name="Application Discovery and Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType=""/>
          <Service Name="Business Data Connectivity Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
          <Service Name="Excel Calculation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
          <Service Name="Managed Metadata Web Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
          <Service Name="PerformancePoint Service" State="Stop" Provision="true" ServiceInstanceType="PerformancePoint Service"/>
          <Service Name="Project Application Service" State="Stop" Provision="false" ServiceInstanceType="*Project*"/>
          <Service Name="Search Query and Site Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>
          <Service Name="Secure Store Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="User Profile Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
          <Service Name="Visio Graphics Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
          <Service Name="Word Automation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
          <!--Turn Off all Application Server Group 2 Services"-->
          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>
          
           <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />
                      
                      
        </Serverrole>
        <Serverrole name="Search Server Group 2">
         
          <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>

          <!--Turn Off all Web Server Group 1 Services"-->
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
          <!--Turn Off all Web Server Group 2 Services"-->
          <Service Name="Central Administration" State="Stop" Provision="true" ServiceInstanceType="Central Administration"/>
          <!--Turn Off all Application Server Group 1 Services"-->
          <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
           <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
          <Service Name="Application Discovery and Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType=""/>
          <Service Name="Business Data Connectivity Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
          <Service Name="Excel Calculation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
          <Service Name="Managed Metadata Web Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
          <Service Name="PerformancePoint Service" State="Stop" Provision="true" ServiceInstanceType="PerformancePoint Service"/>
          <Service Name="Project Application Service" State="Stop" Provision="false" ServiceInstanceType="*Project*"/>
          <Service Name="Search Query and Site Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>
          <Service Name="Secure Store Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="User Profile Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
          <Service Name="Visio Graphics Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
         <Service Name="Word Automation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
          <!--Turn Off all Application Server Group 2 Services"-->
          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>


           <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />

        </Serverrole>
        
         <Serverrole name="Search Server Group 3">
         
          <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>

          <!--Turn Off all Web Server Group 1 Services"-->
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
          <!--Turn Off all Web Server Group 2 Services"-->
          <Service Name="Central Administration" State="Stop" Provision="true" ServiceInstanceType="Central Administration"/>
          <!--Turn Off all Application Server Group 1 Services"-->
          <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
           <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
          <Service Name="Application Discovery and Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType=""/>
          <Service Name="Business Data Connectivity Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
          <Service Name="Excel Calculation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
          <Service Name="Managed Metadata Web Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
          <Service Name="PerformancePoint Service" State="Stop" Provision="true" ServiceInstanceType="PerformancePoint Service"/>
          <Service Name="Project Application Service" State="Stop" Provision="false" ServiceInstanceType="*Project*"/>
          <Service Name="Search Query and Site Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>
          <Service Name="Secure Store Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="User Profile Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
          <Service Name="Visio Graphics Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
         <Service Name="Word Automation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
          <!--Turn Off all Application Server Group 2 Services"-->
          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>


           <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />

        </Serverrole>
         <Serverrole name="Search Server Group 4">
         
          <Service Name="SharePoint Server Search" State="Start" Provision="true" ServiceInstanceType="SharePoint Server Search"/>

          <!--Turn Off all Web Server Group 1 Services"-->
          <Service Name="Microsoft SharePoint Foundation Web Application" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Web Application"/>
          <Service Name="Microsoft SharePoint Foundation Incoming E-Mail" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Incoming E-Mail"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Workflow Timer Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Workflow Timer Service"/>
          <!--Turn Off all Web Server Group 2 Services"-->
          <Service Name="Central Administration" State="Stop" Provision="true" ServiceInstanceType="Central Administration"/>
          <!--Turn Off all Application Server Group 1 Services"-->
          <Service Name="Access Database Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
           <Service Name="Access Database Service 2010" State="Start" Provision="false" ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance"/>
          <Service Name="Application Discovery and Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType=""/>
          <Service Name="Business Data Connectivity Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="Claims to Windows Token Service" State="Stop" Provision="true" ServiceInstanceType="Claims to Windows Token Service"/>
          <Service Name="Document Conversions Launcher Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Launcher Service"/>
          <Service Name="Document Conversions Load Balancer Service" State="Stop" Provision="true" ServiceInstanceType="Document Conversions Load Balancer Service"/>
          <Service Name="Excel Calculation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance"/>
          <Service Name="Managed Metadata Web Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance"/>
          <Service Name="Lotus Notes Connector" State="Stop" Provision="true" ServiceInstanceType="Lotus Notes Connector"/>
          <Service Name="Microsoft SharePoint Foundation Subscription Settings Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft SharePoint Foundation Subscription Settings Service"/>
          <Service Name="PerformancePoint Service" State="Stop" Provision="true" ServiceInstanceType="PerformancePoint Service"/>
          <Service Name="Project Application Service" State="Stop" Provision="false" ServiceInstanceType="*Project*"/>
          <Service Name="Search Query and Site Settings Service" State="Start" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsServiceInstance"/>
          <Service Name="Secure Store Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"/>
          <Service Name="User Profile Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance"/>
          <Service Name="User Profile Synchronisation Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Server.Administration.ProfileSynchronizationServiceInstance"/>
          <Service Name="Visio Graphics Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance"/>
         <Service Name="Word Automation Services" State="Stop" Provision="true" ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance"/>
          <!--Turn Off all Application Server Group 2 Services"-->
          <Service Name="Microsoft SharePoint Foundation Sandboxed Code Service" State="Stop" Provision="true" ServiceInstanceType="Microsoft.SharePoint.Administration.SPUserCodeServiceInstance"/>


           <!-- O13 only - needs integrating into other server roles etc-->
                      <Service Name="App Management Service" State="Start" Provision="false" ServiceInstanceType="App Management Service" />
                      <Service Name="Machine Translation Service" State="Start" Provision="false" ServiceInstanceType="Machine Translation Service" />
                      <Service Name="Work Management Service" State="Start" Provision="false" ServiceInstanceType="Work Management Service" />
                      <Service Name="Request Management" State="Start" Provision="false" ServiceInstanceType="Request Management" />

        </Serverrole>
      </Serverroles>
    </Services>]]>


    <![CDATA[
	<Logs>
      <ULSLogs Folder="E:\data\ULSLogs" />
      <IISLogs Folder="E:\data\IISLogs" />
      <UsageLogs Folder="E:\data\UsageLogs" />
    </Logs>    
    ]]>



    <![CDATA[
    <QuotaTemplates>

 ]]>
    <xsl:for-each select="//quotatemplates/quotatemplate">
      <xsl:if test="name!=''">
        <![CDATA[
	<Quota
						    Name="]]><xsl:value-of select="name"/><![CDATA[" StorageMax="]]><xsl:value-of select="storagemax"/><![CDATA[" storageWarning="]]><xsl:value-of select="storagewarning"/><![CDATA[" usercodeMax="]]><xsl:value-of select="usercodemax"/><![CDATA[" usercodeWarning="]]><xsl:value-of select="usercodewarning"/><![CDATA[" />


		]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[  

    </QuotaTemplates>
    
    ]]>
    <![CDATA[


	<ServiceAccountsOU>]]><xsl:value-of select="//serviceaccountsOU"/><![CDATA[</ServiceAccountsOU>


 <!-- The ManagedAccounts section configures all accounts that will be added to SharePoint as managed accounts. -->
        <ManagedAccounts>
            <!-- The CommonName values should remain unchanged; you can add additional managed accounts, but script expects certain static values for these 4 managed accounts.
			     If you are creating additional web applications, use a new account for each web application with a new common name, unless you are creating a large number
			     of web applications, in which case the additional memory consumption this requires outweighs the security benefits. -->]]>
    <xsl:for-each select="farm/managedaccounts/managedaccount[issharepointmanagedaccount='Yes']">
      <xsl:if test="purpose!='Farm Account'">
        <![CDATA[
		         <ManagedAccount CommonName="]]><xsl:value-of select="translate( purpose, ' ', '')"/><![CDATA[">]]>
        <![CDATA[
                <username>]]><xsl:value-of select="domain"/>\<xsl:value-of select="username"/><![CDATA[</username>

<usernameonly>]]><xsl:value-of select="username"/><![CDATA[</usernameonly>

<displayname>]]><xsl:value-of select="displayname"/><![CDATA[</displayname>

                <Password>]]><xsl:value-of select="password"/><![CDATA[</Password> 
       <domainorforect>]]><xsl:value-of select="domainforest"/><![CDATA[</domainorforect>
      <PasswordRequired>]]><xsl:value-of select="passwordrequired"/><![CDATA[</PasswordRequired>
        <SQLPermissions>]]><xsl:value-of select="sqlpermissions"/><![CDATA[</SQLPermissions>
              <LogonLocally>]]><xsl:value-of select="logonlocally"/><![CDATA[</LogonLocally>
<LocalAdmin>]]><xsl:value-of select="localadmin"/><![CDATA[</LocalAdmin>
<ADPermissions>]]><xsl:value-of select="adpermissions"/><![CDATA[</ADPermissions>
            </ManagedAccount>]]>
      </xsl:if>
    </xsl:for-each>

    <![CDATA[
 </ManagedAccounts>
 
 
<!-- These accounts are not SharePoint Managed accounts, insetad they are needed for things like SQL. -->
        <NonSharePointServiceAccounts>
         ]]>
    <xsl:for-each select="farm/managedaccounts/managedaccount[issharepointmanagedaccount='No']">
      <![CDATA[
		         <NonSharePointServiceAccount CommonName="]]><xsl:value-of select="translate( purpose, ' ', '')"/><![CDATA[">]]>
      <![CDATA[
                <username>]]><xsl:value-of select="domain"/>\<xsl:value-of select="username"/><![CDATA[</username>
<usernameonly>]]><xsl:value-of select="username"/><![CDATA[</usernameonly>
<displayname>]]><xsl:value-of select="displayname"/><![CDATA[</displayname>
                <Password>]]><xsl:value-of select="password"/><![CDATA[</Password>    
             <domainorforect>]]><xsl:value-of select="domainforest"/><![CDATA[</domainorforect>
                     <PasswordRequired>]]><xsl:value-of select="passwordrequired"/><![CDATA[</PasswordRequired>      
<LocalAdmin>]]><xsl:value-of select="localadmin"/><![CDATA[</LocalAdmin>
<ADPermissions>]]><xsl:value-of select="adpermissions"/><![CDATA[</ADPermissions>
<SQLPermissions>]]><xsl:value-of select="sqlpermissions"/><![CDATA[</SQLPermissions>
                    <LogonLocally>]]><xsl:value-of select="logonlocally"/><![CDATA[</LogonLocally>
            </NonSharePointServiceAccount>]]>
    </xsl:for-each>

    <![CDATA[
 </NonSharePointServiceAccounts> 



<!-- These accounts are not service accounts, they are simply test user accounts-->
        <TestUserAccounts OU="]]><xsl:value-of select="//testaccountsOU"/><![CDATA[">
         ]]>
    <xsl:for-each select="farm/testuseraccounts/useraccount">
      <![CDATA[
		         <UserAccount CommonName="]]>Test Account_<xsl:value-of select="displayname"/><![CDATA[">]]>
      <![CDATA[
                <username>]]><xsl:value-of select="domain"/>\<xsl:value-of select="username"/><![CDATA[</username>
                <usernameonly>]]><xsl:value-of select="username"/><![CDATA[</usernameonly>
                <displayname>]]><xsl:value-of select="displayname"/><![CDATA[</displayname>
                <Password>]]><xsl:value-of select="password"/><![CDATA[</Password>           
                <CreateMySite>]]><xsl:value-of select="createmysite"/><![CDATA[</CreateMySite>
                <ADGroup>]]><xsl:value-of select="adgroup"/><![CDATA[</ADGroup>
            </UserAccount>]]>
    </xsl:for-each>

    <![CDATA[
 </TestUserAccounts> 
 
 
        <!-- The object cache accounts are user accounts that are given FullControl and FullRead privileges on WebApplications so items can be cached by ASP.Net to improve performance.
             These accounts should not have any special Active Directory privileges other than Domain User membership -->
        <ObjectCacheAccounts>
            <SuperUser>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Portal Super User Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Portal Super User Account']/username"/><![CDATA[</SuperUser>
            <SuperReader>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Portal Super Reader Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Portal Super Reader Account']/username"/><![CDATA[</SuperReader>
        </ObjectCacheAccounts>
        ]]>
    <![CDATA[</Farm>
    
    ]]>

    <![CDATA[
<!-- The WebApplications section configures the applications and sites that will be created. You can add additional <WebApplication> child tags to create extra web applications.
         The AddURLsToHOSTS flag will add all Alternate Access Mappings to the local server's HOSTS file and is useful if you are (for example):
         creating web apps whose URLs are not defined in DNS yet, a test farm, or if you are creating a DR farm, etc. -->
    <WebApplications AddURLsToHOSTS="false">
        <!-- Web application attributes are as follows:
			"MySiteHost" is the host web application for mysites.
			Any additional web applications that you create should have a type of your own choice such as "Other"
		name: Name of the web application
		applicationPool: Application pool name
		applicationPoolAccount: DOMAIN\USERNAME of the account under which the application pool runs. This should be a managed account.
		url: URL of the root site collection in the application pool. Do not include the port number, but do set http/https correctly.
		port: Port on which the web application runs.
		databaseName: Name of the first content database.
		useClaims: false = disable claims based authentication. true = enable claims based authentication.
		useBasicAuthentication: false = only accept Kerberos/NTLM claims. true = also accept Basic authentication claims. Has no effect if useClaims is false.
		useOnlineWebPartCatalog: false = disable use of the online webpart gallery on the web application. true (default) enable it. -->
		
		
		]]>
    <xsl:for-each select="farm/webapplications/webapplication[name != '']">
      <xsl:variable
      name="webAppName"
      select="name">
      </xsl:variable>
      <xsl:variable
      name="webAppUrl"
      select="url">
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="sitetemplate!='SPSMSITEHOST#0'">
          <![CDATA[
				<WebApplication type="Portal"
						]]>
          <![CDATA[name="]]><xsl:value-of select="name"/><![CDATA["
								applicationPool="]]><xsl:value-of select="name"/>AppPool<![CDATA["
								applicationPoolAccount="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Web Applications account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Web Applications account']/username"/><![CDATA["
								url="]]><xsl:value-of select="url"/><![CDATA["
								]]><xsl:choose>
            <xsl:when test="contains($webAppUrl,'https')">
              <![CDATA[port="443"]]>
            </xsl:when>
            <xsl:otherwise>
              <![CDATA[port="80"]]>
            </xsl:otherwise>
          </xsl:choose><![CDATA[
								AddURLToLocalIntranetZone="true"
								databaseName="]]><xsl:value-of select="contentDBPrefix"/>1<![CDATA["                      
								useClaims="true"
								useBasicAuthentication="false"
								useOnlineWebPartCatalog="false"
								defaultAuthProvider="]]><xsl:value-of select="defaultauthprovider"/><![CDATA["
								serviceApplicationProxyGroup="]]><xsl:value-of select="serviceapplicationproxygroup"/><![CDATA["								
								searchCenterURL="]]><xsl:value-of select="searchcenterurl"/><![CDATA["
								SetupSearchCrawlZone="]]><xsl:value-of select="searchcrawlzoneconfiguration"/><![CDATA["
								SearchCrawlZone="]]><xsl:value-of select="searchcrawlzoneinwebapp"/><![CDATA["
								AuthenticationProvider="]]><xsl:value-of select="authprovider"/><![CDATA["
								ExtendedURL="]]><xsl:value-of select="extendedurl"/><![CDATA["
								ExtendedName="]]><xsl:value-of select="extendedname"/><![CDATA["
								ExtendedPort="]]><xsl:value-of select="extendedport"/><![CDATA["
                BlobCacheSize="]]><xsl:value-of select="blobcachesize"/><![CDATA["
                PeoplePickerDefaultConfig="]]><xsl:value-of select="applydefaultpeoplepickerconfig"/><![CDATA[">
					<PropertyChanges>
					]]>
          <xsl:for-each select="//webapplicationsettings/webapplicationsetting[webapplicationname=$webAppName]">

            <![CDATA[<PropertyChange propertyName="]]><xsl:value-of select="settingname"/><![CDATA[" propertyValue="]]><xsl:value-of select="settingvalue"/><![CDATA["/>
							]]>
          </xsl:for-each>
          <![CDATA[
					</PropertyChanges>
					<ManagedPaths>						           
            	]]>
          <xsl:for-each select="//managedpaths/managedpath[webapplication=$webAppName]">

            <![CDATA[<ManagedPath relativeUrl="]]><xsl:value-of select="path"/><![CDATA[" explicit="]]><xsl:value-of select="explicit"/><![CDATA["/>
							]]>
          </xsl:for-each>
          <![CDATA[
            
					</ManagedPaths>
					<SiteCollections>						
						<SiteCollection siteUrl="]]><xsl:value-of select="url"/><![CDATA["
									   owner="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA["
									   name="]]><xsl:value-of select="name"/> Home<![CDATA["
										description="]]><xsl:value-of select="name"/> Home Site<![CDATA["                                
										SearchUrl="]]><xsl:value-of select="url"/>/search<![CDATA["
										CustomTemplate="false"
										Template="]]><xsl:value-of select="sitetemplate"/><![CDATA["
										LCID="1033"
										Locale="en-us"
										Time24="true"					                    				
                    PrimaryAdministrator="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA[" 
										SecondaryAdministrator="]]><xsl:value-of select="secondarysitecollectionadmin"/><![CDATA["
										QuotaTemplate="]]><xsl:value-of select="quota"/><![CDATA[">
                    
                    	</SiteCollection>
                      
                      
]]>


          <xsl:for-each select="//sitecollections/sitecollection[webapplication=$webAppName]">
            <xsl:if test="name!=''">


              <![CDATA[
                <SiteCollection siteUrl="]]><xsl:value-of select="url"/><![CDATA["
									         owner="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA["
									         name="]]><xsl:value-of select="name"/> Home<![CDATA["
										      description="]]><xsl:value-of select="name"/> Home Site<![CDATA["                                
										      SearchUrl="]]><xsl:value-of select="url"/>/search<![CDATA["
										      CustomTemplate="false"
										      Template="]]><xsl:value-of select="sitetemplate"/><![CDATA["
										      LCID="1033"
										      Locale="en-us"
										      Time24="true"					                    				
                          PrimaryAdministrator="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA[" 
										      SecondaryAdministrator="]]><xsl:value-of select="secondarysitecollectionadmin"/><![CDATA["
										      QuotaTemplate="]]><xsl:value-of select="quota"/><![CDATA["/>
                ]]>
            </xsl:if>

          </xsl:for-each>


          <![CDATA[
					
					</SiteCollections>
				</WebApplication>
				]]>

        </xsl:when>
        <xsl:otherwise>

          <![CDATA[
				<WebApplication type="MySiteHost"
						]]>
          <![CDATA[name="]]><xsl:value-of select="name"/><![CDATA["
								applicationPool="]]><xsl:value-of select="name"/>AppPool<![CDATA["
								applicationPoolAccount="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Web Applications account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Web Applications account']/username"/><![CDATA["
								url="]]><xsl:value-of select="url"/><![CDATA["
								]]><xsl:choose>
            <xsl:when test="contains($webAppUrl,'https')">
              <![CDATA[port="443"]]>
            </xsl:when>
            <xsl:otherwise>
              <![CDATA[port="80"]]>
            </xsl:otherwise>
          </xsl:choose><![CDATA[
								AddURLToLocalIntranetZone="true"
								databaseName="]]><xsl:value-of select="contentDBPrefix"/>1<![CDATA["                      
								useClaims="true"
								useBasicAuthentication="false"
								useOnlineWebPartCatalog="false"
								defaultAuthProvider="]]><xsl:value-of select="defaultauthprovider"/><![CDATA["
								serviceApplicationProxyGroup="]]><xsl:value-of select="serviceapplicationproxygroup"/><![CDATA["								
								searchCenterURL="]]><xsl:value-of select="searchcenterurl"/><![CDATA["
								SetupSearchCrawlZone="]]><xsl:value-of select="searchcrawlzoneconfiguration"/><![CDATA["
								SearchCrawlZone="]]><xsl:value-of select="searchcrawlzoneinwebapp"/><![CDATA["
								AuthenticationProvider="]]><xsl:value-of select="authprovider"/><![CDATA["
								ExtendedURL="]]><xsl:value-of select="extendedurl"/><![CDATA["
								ExtendedName="]]><xsl:value-of select="extendedname"/><![CDATA["
								ExtendedPort="]]><xsl:value-of select="extendedport"/><![CDATA["
                BlobCacheSize="]]><xsl:value-of select="blobcachesize"/><![CDATA["
                PeoplePickerDefaultConfig="]]><xsl:value-of select="applydefaultpeoplepickerconfig"/><![CDATA[">
					<PropertyChanges>
					]]>
          <xsl:for-each select="//webapplicationsettings/webapplicationsetting[webapplicationname=$webAppName]">
            <![CDATA[<PropertyChange propertyName="]]><xsl:value-of select="settingname"/><![CDATA[" propertyValue="]]><xsl:value-of select="settingvalue"/><![CDATA["/>
							]]>
          </xsl:for-each>
          <![CDATA[
					</PropertyChanges>
					<ManagedPaths>						           
            	]]>
          <xsl:for-each select="//managedpaths/managedpath[webapplication=$webAppName]">

            <![CDATA[<ManagedPath relativeUrl="]]><xsl:value-of select="path"/><![CDATA[" explicit="]]><xsl:value-of select="explicit"/><![CDATA["/>
							]]>
          </xsl:for-each>
          <![CDATA[
            
					</ManagedPaths>
					<SiteCollections>
						<SiteCollection siteUrl="]]><xsl:value-of select="url"/><![CDATA["
									  owner="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA["
									  name="]]><xsl:value-of select="name"/> Home<![CDATA["
										description="]]><xsl:value-of select="name"/> Home Site<![CDATA["                                
										searchCenterURL="]]><xsl:value-of select="searchcenterurl"/><![CDATA["
										CustomTemplate="false"
										Template="]]><xsl:value-of select="sitetemplate"/><![CDATA["
										LCID="1033"
										Locale="en-us"
										Time24="true"					
                    PrimaryAdministrator="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA[" 
										SecondaryAdministrator="]]><xsl:value-of select="secondarysitecollectionadmin"/><![CDATA["
										QuotaTemplate="]]><xsl:value-of select="quota"/><![CDATA[">
						</SiteCollection>
            
            ]]>


          <xsl:for-each select="//sitecollections/sitecollection[webapplication=$webAppName]">
            <xsl:if test="name!=''">

              <![CDATA[
                            <SiteCollection siteUrl="]]><xsl:value-of select="url"/><![CDATA["
									            owner="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA["
									            name="]]><xsl:value-of select="name"/> Home<![CDATA["
										        description="]]><xsl:value-of select="name"/> Home Site<![CDATA["                                
										        searchCenterURL="]]><xsl:value-of select="searchcenterurl"/><![CDATA["
										        CustomTemplate="false"
										        Template="]]><xsl:value-of select="sitetemplate"/><![CDATA["
										        LCID="1033"
										        Locale="en-us"
										        Time24="true"					                    				
                            PrimaryAdministrator="]]><xsl:value-of select="primarysitecollectionadmin"/><![CDATA[" 
										        SecondaryAdministrator="]]><xsl:value-of select="secondarysitecollectionadmin"/><![CDATA["
										        QuotaTemplate="]]><xsl:value-of select="quota"/><![CDATA["/>
                      ]]>
            </xsl:if>

          </xsl:for-each>
          <![CDATA[
					
        
					</SiteCollections>
				</WebApplication>
			]]>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:for-each>


    <![CDATA[   
    </WebApplications>]]>



    <![CDATA[
  <!-- Service App Proxy Groups - we need to create Proxy Groups
	 NG - We will use the New-SPServiceApplicationProxyGroup cmdlet to create these. -->
    <ServiceAppProxyGroups>
    ]]>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />


    <xsl:for-each select="farm/serviceapproxygroups/serviceapproxygroup[name != '']">
      <![CDATA[<ServiceAppProxyGroup name="]]><xsl:value-of select="name"/><![CDATA[">
				<GroupMembers>]]>

      <xsl:variable
        name="groupName"
        select="translate(name, $uppercase, $smallcase)">
      </xsl:variable>

      <![CDATA[<!--  NG - Use the Add-SPServiceApplicationProxyGroupMember cmdlet to create these member associations. -->]]>
      <xsl:for-each select="//serviceapplications/serviceapplication">
        <xsl:variable
       name="serviceAppName"
       select="name">
        </xsl:variable>
        <xsl:for-each select="*">
          <xsl:variable
          name="colName"
          select="local-name()">
          </xsl:variable>


          <xsl:if test="contains($colName, $groupName)">
            <![CDATA[
					  <GroupMember name="]]><xsl:value-of select="$serviceAppName"/><![CDATA[" enable="]]><xsl:value-of select="."/><![CDATA[" consume="]]><xsl:value-of select="."/><![CDATA["/>]]>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>


      <![CDATA[
				</GroupMembers>
			</ServiceAppProxyGroup>
			]]>
    </xsl:for-each>
    <![CDATA[
     </ServiceAppProxyGroups>
    ]]>




    <![CDATA[
  <!-- Service App Property Changes - we need to allow config to change Service Application properties
	 NG - Not ideal that this is in a loop here but would have required a lot of XSL-IFs otherwise as Service Apps are not delivered in a loop like Web Apps.. -->
    <ServiceAppPropertyChanges>				
    ]]>
    <xsl:for-each select="farm/serviceapplicationsettings/serviceapplicationsetting">
      <xsl:if test="serviceapplicationname!=''">
        <![CDATA[				<PropertyChange serviceApplicationName="]]><xsl:value-of select="serviceapplicationname"/><![CDATA[" propertyName="]]><xsl:value-of select="settingname"/><![CDATA[" propertyValue="]]><xsl:value-of select="translate(settingvalue, '&amp;', '&amp;')"/><![CDATA["/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
     </ServiceAppPropertyChanges>
    ]]>

    <![CDATA[
    <serviceapplicationpools>
      <applicationpool Identity="OtherServicePool">
        <name>SharePoint Service Host Pool</name>
        <managedaccount>ServiceApplicationsAccount</managedaccount>
      </applicationpool>
 ]]>
        <xsl:if test="farm/managedaccounts/managedaccount[issharepointmanagedaccount='Yes' and purpose='Reporting Services Service Application Account']">
        <![CDATA[
          <applicationpool Identity="SSRSServicePool">
            <name>Reporting Services Application Pool</name>
            <managedaccount>ReportingServicesServiceApplicationAccount</managedaccount>
          </applicationpool>
        ]]>
        </xsl:if>
        <![CDATA[
    </serviceapplicationpools>
 ]]>


    <![CDATA[
 <!-- The ServiceApps section configures service applications included in the standard SharePoint licence.
		Common Attributes:
		Provision: Whether/which servers to provision the service application on
		Name: Name of the application
		ProxyName: name of the application proxy 
		
		
		-->
    <ServiceApps>
    ]]>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Managed Metadata Service' and enable='Yes']">
      <![CDATA[
        <ManagedMetadataServiceApp Provision="true"
                                   Name="Managed Metadata Service"
                                   ProxyName="Managed Metadata Service"
                                   ServiceInstanceType="Microsoft.SharePoint.Taxonomy.MetadataWebServiceInstance">           
        </ManagedMetadataServiceApp>
        ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='User Profile Service Application' and enable='Yes']">
      <![CDATA[
      <!-- EnableNetBIOSDomainName should be set to true if the host portion of your DNS Domain name is different than your NetBIOS domain name.
			 StartProfileSync should be set to true to configure the User Profile Synchronization Service. NOTE: If this is set to TRUE in a multi-server
			 farm, you must run this script first on the machine that will run the profile synchronization service. If you are running SP2010 SP1, you can 
             specify the SyncConnectionAccount credentials and the script will attempt to create a default Sync connection using the new Add-SPProfileSyncConnection cmdlet
             
			NG - I have removed the  SyncConnectionAccount="DOMAIN\UPSync"
                               SyncConnectionAccountPassword="" >
                    attributes as we are creating connections seperately.
              -->
        <UserProfileServiceApp Provision="true"
                               Name="User Profile Service Application"
                               ProxyName="User Profile Service Application"
                               EnableNetBIOSDomainNames="false"
                               StartProfileSync="true"
                               ServiceInstanceType="Microsoft.Office.Server.Administration.UserProfileServiceInstance">                              
                                                              
							   <ProfileDB>SPS_]]><xsl:value-of select="//farm/purpose"/>_<![CDATA[UserProfile_svc</ProfileDB>
							   <SyncDB>SPS_]]><xsl:value-of select="//farm/purpose"/>_<![CDATA[UserProfileSync_svc</SyncDB>
							   <SocialDB>SPS_]]><xsl:value-of select="//farm/purpose"/>_<![CDATA[UserProfileSocial_svc</SocialDB>
							   <Connections>
							   ]]>
      <xsl:for-each select="farm/userprofileservicesettings/userprofileservicesetting">
        <xsl:if test="connectorname!=''">
          <![CDATA[				<Connection connectorName="]]><xsl:value-of select="connectorname"/><![CDATA[" forestName="]]><xsl:value-of select="forestname"/><![CDATA[" ou="]]><xsl:value-of select="ou"/><![CDATA[" importFilter="]]><xsl:value-of select="normalize-space(importfilter)"/><![CDATA[" useraccount="]]><xsl:value-of select="useraccount"/><![CDATA[" password="]]><xsl:value-of select="password"/><![CDATA[" mysitehost="]]><xsl:value-of select="mysitehostlocation"/><![CDATA[" mysitepersonalpath="]]><xsl:value-of select="mysitepersonalpath"/><![CDATA["/>
									]]>
        </xsl:if>
      </xsl:for-each>

      <![CDATA[
							   </Connections>
        </UserProfileServiceApp>
          ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='Search Service Application' and enable='Yes']">
      <![CDATA[
              <EnterpriseSearchService Provision="true"
                                       ContactEmail="admin@]]><xsl:value-of select="//domain"/><![CDATA[.de"
                                       ConnectionTimeout="60"
                                       AcknowledgementTimeout="60"                                       
                                       IgnoreSSLWarnings="false"
                                       InternetIdentity="Mozilla/4.0 (compatible; MSIE 4.01; Windows NT; MS Search 6.0 Robot)"                                       
                                       QueryIndexLocation="]]><xsl:value-of select="//searchsettings/searchsetting/queryindexlocation"/><![CDATA["
                                       PerformanceLevel="PartlyReduced"
                                       ContentAccessAccount="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Crawl Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Crawl Account']/username"/><![CDATA["
                                       ContentAccessAccountPWD="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Crawl Account']/password"/><![CDATA["
                                       ShareName="SearchShare">	
				<ProxySettings Address="]]><xsl:value-of select="normalize-space(//farm/proxyserver)"/><![CDATA[" UseForFederated="]]><xsl:value-of select="//searchsettings/searchsetting/searchproxyforfederated"/><![CDATA[" />							                           
                  <EnterpriseSearchServiceApplications>
                       
                      <EnterpriseSearchServiceApplication Name="Search Service Application"
                                                          SearchCentreURL="]]><xsl:value-of select="//searchsettings/searchsetting/searchcentreURL"/><![CDATA["
                                                          DatabaseServer="]]><xsl:choose>
        <xsl:when test="//farmtype = 'SP'">
          <xsl:value-of select="//sqlinstances/sqlinstance[type='Search SQL Server'][1]/aliasname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="//sqlinstances/sqlinstance[type='General']/aliasname"/>
        </xsl:otherwise>
      </xsl:choose><![CDATA["                                                          
                                                          FailoverDatabaseServer="]]><xsl:value-of select="//sqlinstances/sqlinstance[type='Search'][primaryormirror='Mirror']/aliasname"/><![CDATA["                        
                                                          Partitioned="false"
                                                          Partitions="]]><xsl:value-of select="round(number(//amountindexeditems) div number(10))"/><![CDATA["
                                                          SearchServiceApplicationType="Regular"
                                                          ContentAccessAccount="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Crawl Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Crawl Account']/username"/><![CDATA["
                                                          ContentAccessAccountPWD="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Crawl Account']/password"/><![CDATA[">
                          <ApplicationPool Name="SharePoint Enterprise Search Application Pool" Account="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Service Application account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Service Application account']/username"/><![CDATA[" Password="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Service Application account']/password"/><![CDATA[" />
                           
                           
                           <!--Change for v2.0 - Crawl, Query etc are all on App Group 1 Servers). -->
                           <!--Chnaged again for 2.7.1+-->
                          <CrawlServers>
                         ]]>
      <xsl:choose>
        <xsl:when test="count(farm/servers/server[role='Search Server Group 3']) > 0">
          <xsl:for-each select="farm/servers/server[role='Search Server Group 3']">
            <xsl:variable
              name="serverName"
              select="name">
            </xsl:variable>
            <xsl:if test="$serverName!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>

          <xsl:choose>
            <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 0">
              <xsl:for-each select="farm/servers/server[role='Search Server Group 1']">
                <xsl:variable
                    name="serverName"
                    select="name">
                </xsl:variable>
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="farm/servers/server[role='Web Server Group 1']">
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="name"/><![CDATA[" Core="]]><xsl:value-of select="datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>

      <![CDATA[                                           
                          </CrawlServers>
                          <!--Change for v2.0 - Crawl, Query etc are all on App Group 1 Servers). Query servers will host QPC and Site Settings Service. -->
                          <!--Chnaged again for 2.7.1+-->
                                                    <QueryProcessingServers>
                          ]]>

      <xsl:choose>
        <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 0">
          <xsl:for-each select="farm/servers/server[role='Search Server Group 1']">
            <xsl:variable
                name="serverName"
                select="name">
            </xsl:variable>
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="farm/servers/server[role='Web Server Group 1']">
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="name"/><![CDATA[" Core="]]><xsl:value-of select="datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>


      <![CDATA[
                          </QueryProcessingServers>
                          
                           <!--New for v2.0 - Index Servers are on Search1 and Search2. Notw that I dont think we need search2, we only need 1 role.. -->
                          <IndexServers>
                          ]]>

      <xsl:choose>
        <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 0">
          <xsl:for-each select="farm/servers/server[role='Search Server Group 1']">
            <xsl:variable
                  name="serverName"
                  select="name">
            </xsl:variable>
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>

          <xsl:for-each select="farm/servers/server[role='Search Server Group 2']">
            <xsl:variable
                  name="serverName"
                  select="name">
            </xsl:variable>
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>

        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="farm/servers/server[role='Web Server Group 1']">
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="name"/><![CDATA[" Core="]]><xsl:value-of select="datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>


      <![CDATA[
                          </IndexServers>
                         
                        
                          
                            <!--New for v2.0 - Analytics Processing Components.. -->
                          <AnalyticsProcessingServers>
                          ]]>


      <xsl:choose>
        <xsl:when test="count(farm/servers/server[role='Search Server Group 4']) > 0">
          <xsl:for-each select="farm/servers/server[role='Search Server Group 4']">
            <xsl:variable
                name="serverName"
                select="name">
            </xsl:variable>
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 0">
              <xsl:for-each select="farm/servers/server[role='Search Server Group 1']">
                <xsl:variable
                    name="serverName"
                    select="name">
                </xsl:variable>
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each>
             <!-- <xsl:for-each select="farm/servers/server[role='Application Server Group 2']">
                <xsl:variable
                    name="serverName"
                    select="name">
                </xsl:variable>
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each> -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="farm/servers/server[role='Web Server Group 1']">
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="name"/><![CDATA[" Core="]]><xsl:value-of select="datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>





      <![CDATA[
                          </AnalyticsProcessingServers>
                          
                          
                          
                        <ContentProcessingServers>
                          ]]>

      <xsl:choose>
        <xsl:when test="count(farm/servers/server[role='Search Server Group 3']) > 0">
          <xsl:for-each select="farm/servers/server[role='Search Server Group 3']">
            <xsl:variable
                name="serverName"
                select="name">
            </xsl:variable>
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>

          <xsl:choose>
            <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 0">
              <xsl:for-each select="farm/servers/server[role='Search Server Group 1']">
                <xsl:variable
                    name="serverName"
                    select="name">
                </xsl:variable>
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="farm/servers/server[role='Web Server Group 1']">
                <xsl:if test="name!=''">
                  <![CDATA[<Server Name="]]><xsl:value-of select="name"/><![CDATA[" Core="]]><xsl:value-of select="datacenter"/><![CDATA[" Processed="False"/>]]>
                </xsl:if>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>



      <![CDATA[
                          </ContentProcessingServers>
                          

                          
                          <AdminComponent>
                          ]]>

      <xsl:choose>
        <xsl:when test="count(farm/servers/server[role='Search Server Group 1']) > 0">
          <xsl:for-each select="farm/servers/server[role='Search Server Group 1']">
            <xsl:variable
                  name="serverName"
                  select="name">
            </xsl:variable>
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="$serverName"/><![CDATA[" Core="]]><xsl:value-of select="//servers/server[name=$serverName]/datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="farm/servers/server[role='Web Server Group 1']">
            <xsl:if test="name!=''">
              <![CDATA[<Server Name="]]><xsl:value-of select="name"/><![CDATA[" Core="]]><xsl:value-of select="datacenter"/><![CDATA[" Processed="False"/>]]>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

      <![CDATA[
                                                 <ApplicationPool Name="SharePoint Enterprise Search Application Pool" Account="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Service Application account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Search Service Application account']/username"/><![CDATA[" />
        
                          </AdminComponent>

                          <Proxy Name="Search Service Application" Partitioned="false">
                              <ProxyGroup Name="Default" />
                          </Proxy>                    
					      <QueryProcessingComponents 
										      numberOfQueryProcessingComponentsRequiredPerServer="]]><xsl:value-of select="//searchsettings/searchsetting/numberqpccomponentsperserver"/><![CDATA[" >										     
					      </QueryProcessingComponents>                    

					      <IndexComponents 
										      numberOfIndexComponentsRequiredPerServer="1" >										     
					      </IndexComponents>  

					      <ContentProcessingSettings
										      numberOfContentProcessingComponentsRequiredPerServer="]]><xsl:value-of select="//searchsettings/searchsetting/numbercpccomponentsperserver"/><![CDATA["										     
					                numberOfLinksDBsRequired="]]><xsl:value-of select="//searchsettings/searchsetting/numberlinksdbs"/><![CDATA[">
										     
                </ContentProcessingSettings> 
                
                
                <AnalyticsProcessingSettings 
										      numberOfAnalyticsProcessingComponentsRequiredPerServer="]]><xsl:value-of select="//searchsettings/searchsetting/numberapccomponentsperserver"/><![CDATA[" 
										      numberOfAnalticsDBsRequired="]]><xsl:value-of select="//searchsettings/searchsetting/numberanalyticsdbs"/><![CDATA[">
										     
					      </AnalyticsProcessingSettings>
                
                
                <AdminComponentSettings 
										      numberOfAdminComponentsRequiredPerServer="]]><xsl:value-of select="//searchsettings/searchsetting/numberadmincomponentsperserver"/><![CDATA[" 
										      numberOfAdminDBsRequired="]]><xsl:value-of select="//searchsettings/searchsetting/numberadmindbs"/><![CDATA[">
										     
					      </AdminComponentSettings>
                
                
                <CrawlSettings 
										      numberOfCrawlComponentsRequiredPerServer="]]><xsl:value-of select="//searchsettings/searchsetting/numbercrawlcomponentsperserver"/><![CDATA[" 
										      numberOfCrawlDBsRequired="]]><xsl:value-of select="//searchsettings/searchsetting/numbercrawldbs"/><![CDATA[">
										     
					      </CrawlSettings>                    
                      </EnterpriseSearchServiceApplication>
                  </EnterpriseSearchServiceApplications>
              </EnterpriseSearchService>
                 ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='State Service' and enable='Yes']">
      <![CDATA[
        <StateService Provision="true"
                      Name="State Service"
                      ProxyName="State Service">            
        </StateService>
        ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Web Analytics Service Application' and enable='Yes']">
      <![CDATA[
        <WebAnalyticsService Provision="true"
                             Name="Web Analytics Service Application"
                             ServiceInstanceType="Microsoft.Office.Server.WebAnalytics.Administration.WebAnalyticsWebServiceInstance">
            <ReportingDB>]]><xsl:value-of select="//farmname"/>_WebAnalyticsReporting_svc<![CDATA[</ReportingDB>
            <StagingDB>]]><xsl:value-of select="//farmname"/>_WebAnalyticsStaging_svc<![CDATA[</StagingDB>
        </WebAnalyticsService>
              ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Microsoft SharePoint Foundation Subscription Settings Service Application' and enable='Yes']">
      <![CDATA[
        <SubscriptionSettingsService Provision="true"
                        Name="Microsoft SharePoint Foundation Subscription Settings Service Application">                        
        </SubscriptionSettingsService>
        ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='Usage and Health Data Collection' and enable='Yes']">
      <![CDATA[
        <SPUsageService Provision="true"
                        Name="Usage and Health Data Collection Service Application">            
            <DaysRetained>31</DaysRetained>
        </SPUsageService>
        ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Secure Store Service' and enable='Yes']">
      <![CDATA[
        <SecureStoreService Provision="true"
                            Name="Secure Store Service"
                            ProxyName="Secure Store Service"                            
                            ServiceInstanceType="Microsoft.Office.SecureStoreService.Server.SecureStoreServiceInstance"
                            ApplicationKey="]]><xsl:value-of select="//securestoreappkey"/><![CDATA["
                            MasterKey="]]><xsl:value-of select="//securestoremasterkey"/><![CDATA["
                            >                                        
        </SecureStoreService>
               ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='InfoPath forms services' and enable='Yes']">
      <![CDATA[
        
        <InfoPathFormServices Provision="true" TODO="TODO">            
        </InfoPathFormServices>
        
            ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='Reporting Services' and enable='Yes']">
      <![CDATA[
        
        <ReportingServices Provision="true" TODO="TODO">            
        </ReportingServices>
        
            ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='Business Data Connectivity Service' and enable='Yes']">
      <![CDATA[
        
        <BusinessDataConnectivity Provision="true"
                                  Name="Business Data Connectivity Service"
                                  ProxyName="Business Data Connectivity Service"
                                  ServiceInstanceType="Microsoft.SharePoint.BusinessData.SharedService.BdcServiceInstance">           
        </BusinessDataConnectivity>
        
            ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Word Automation Services' and enable='Yes']">
      <![CDATA[
        
        <WordAutomationService Provision="true"
                               Name="Word Automation Services"
                               ProxyName="Word Automation Services"
                               ServiceInstanceType="Microsoft.Office.Word.Server.Service.WordServiceInstance">
        </WordAutomationService>
       
            ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Performance Point Service' and enable='Yes']">
      <![CDATA[
        
        <PerformancePointService Provision="true"
                               Name="Performance Point Service"
                               ProxyName="Performance Point Service"
                               ServiceInstanceType="PerformancePoint Service">
        </PerformancePointService>
       
            ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Machine Translation Service' and enable='Yes']">
      <![CDATA[
        
       <TranslationService Provision="true"
                               Name="Machine Translation Service"
                               ProxyName="Machine Translation Service"
                               ServiceInstanceType="Machine Translation Service">
        </TranslationService>

       
            ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Work Management Service' and enable='Yes']">
      <![CDATA[
        
       <WorkManagement Provision="true"
                               Name="Work Management Service"
                               ProxyName="Work Management Service"
                               ServiceInstanceType="Work Management Service">
        </WorkManagement>

       
            ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='App Management Service' and enable='Yes']">
      <![CDATA[
        
       <AppManagement Provision="true"
                               Name="App Management Service"
                               ProxyName="App Management Service"
                               ServiceInstanceType="App Management Service"
                               ]]><!-- [TB] Added app domain and prefix --><![CDATA[
                               AppDomain="]]><xsl:value-of select="farm/serviceapplications/serviceapplication[name='App Management Service']/AppDomain"/><![CDATA["
                               AppPrefix="]]><xsl:value-of select="farm/serviceapplications/serviceapplication[name='App Management Service']/AppPrefix"/><![CDATA[">
    			<ProxySettings Address="]]><xsl:value-of select="normalize-space(//farm/proxyserver)"/><![CDATA[" />							                           
        </AppManagement>

       
            ]]>
    </xsl:if>


  <!-- [TB] SSRS -->
    <xsl:if test="farm/serviceapplications/serviceapplication[name='SQL Server Reporting Services' and enable='Yes']">
      <![CDATA[
        
       <SSRS Provision="true"
                               Name="SQL Server Reporting Services Service"
                               ProxyName="SQL Server Reporting Services Service"
                               ServiceInstanceType="SQL Server Reporting Services Service">
        </SSRS>

       
            ]]>
    </xsl:if>

    <![CDATA[
    </ServiceApps>         
         ]]>


    <![CDATA[
<!-- The EnterpriseSeviceApps section configures services only available with an Enterprise licence.
		 Common Attributes:
		 UnattendedIDUser: DOMAIN\UserName of the unattended user account. This does not have to be SharePoint managed account, and the same account can be re-used for all services.
		 UnattendedIDPassword: Password of the unattended user account.	-->
    <EnterpriseServiceApps>
    ]]>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Excel Services Application' and enable='Yes']">
      <![CDATA[
        <ExcelServices Provision="true"
                       Name="Excel Services Application"
                       UnattendedIDUser="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/username"/><![CDATA["
                       UnattendedIDPassword="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/password"/><![CDATA["
                       ServiceInstanceType="Microsoft.Office.Excel.Server.MossHost.ExcelServerWebServiceInstance">   
        </ExcelServices>
        ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Visio Graphics Service' and enable='Yes']">
      <![CDATA[
        <VisioService Provision="true"
                      Name="Visio Graphics Service"
                      ProxyName="Visio Graphics Service"
                      UnattendedIDUser="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/domain"/>\<xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/username"/><![CDATA["
                      UnattendedIDPassword="]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='Farm Account']/password"/><![CDATA["
                      ServiceInstanceType="Microsoft.Office.Visio.Server.Administration.VisioGraphicsServiceInstance">                         
        </VisioService>
            ]]>
    </xsl:if>

    <xsl:if test="farm/serviceapplications/serviceapplication[name='Access Service' and enable='Yes']">
      <![CDATA[
        <AccessService Provision="true"
                       Name="Access Service"
                       ProxyName="Access Service"
                       ServiceInstanceType="Microsoft.Office.Access.Server.MossHost.AccessServerWebServiceInstance">   
        </AccessService>
                  ]]>
    </xsl:if>


    <xsl:if test="farm/serviceapplications/serviceapplication[name='Project Server Service' and enable='Yes']">
      <![CDATA[
      <!--TODO - we need our own XML and PowerShell script associated with it. It looks like the Service App only needs a App Pool account as the DBs are created when we create the site collection for PWA - which has other XML in this document.-->
        <ProjectServer Provision="true"
                       Name="Project Server Service"
                       ProxyName="Project Server Service"
                       ServiceInstanceType="Project Server PSI Service Application">
        </ProjectServer>
                  ]]>
    </xsl:if>


    <![CDATA[
    </EnterpriseServiceApps>         
         ]]>





    <![CDATA[
	<ProductVersions>
	]]>
    <xsl:for-each select="farm/productversions/productversion">
      <xsl:if test="product!=''">
        <![CDATA[		<ProductVersion product="]]><xsl:value-of select="product"/><![CDATA[" install="]]><xsl:value-of select="install"/><![CDATA[" producttype="]]><xsl:value-of select="producttype"/><![CDATA[" version="]]><xsl:value-of select="version"/><![CDATA[" binary="]]><xsl:value-of select="binary"/><![CDATA[" exe="]]><xsl:value-of select="exe"/><![CDATA[" license="]]><xsl:value-of select="license"/><![CDATA[" nonStandardUserNameToAccessWith="]]><![CDATA[" nonStandardPasswordToAccessWith="]]><![CDATA[" searchWildcardToKnowIfInstalledViaRegistrySearch="]]><xsl:value-of select="searchstringwildcardtoknowifalreadyinstalled"/><![CDATA["/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
	</ProductVersions>
]]>


    <![CDATA[
	<FirewallConfigurations>
	]]>
    <xsl:for-each select="farm/windowsfirewallsettings/windowsfirewallsetting">
      <xsl:if test="role!=''">
        <![CDATA[		<FirewallConfiguration serverRole="]]><xsl:value-of select="role"/><![CDATA[" incomingPort="]]><xsl:value-of select="incomingport"/><![CDATA[" direction="]]><xsl:value-of select="direction"/><![CDATA[" remoteIP="]]><xsl:value-of select="remoteip"/><![CDATA[" protocol="]]><xsl:value-of select="protocol"/><![CDATA[" ruleName="]]><xsl:value-of select="rulename"/><![CDATA[" action="]]><xsl:value-of select="action"/><![CDATA["/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
	</FirewallConfigurations>
]]>


    <![CDATA[
	<ADFSConfigurations>
	]]>
    <xsl:for-each select="farm/adfssettings/adfssetting">
      <xsl:if test="authprovidername!=''">
        <![CDATA[		<ADFSConfiguration providerName="]]><xsl:value-of select="authprovidername"/><![CDATA[" description="]]><xsl:value-of select="authproviderdescription"/><![CDATA[" lanClaimIdentifier="]]><xsl:value-of select="lanclaimidentifier"/><![CDATA[" lanRoleIdentifier="]]><xsl:value-of select="lanroleidentifier"/><![CDATA[" lanLogonUrl="]]><xsl:value-of select="lanlogonurl"/><![CDATA[" certificate="]]><xsl:value-of select="certificate"/><![CDATA[" rootCertificate="]]><xsl:value-of select="rootcertificate"/><![CDATA[" incomingClaimDisplayName="]]><xsl:value-of select="incomingclaimdisplayname"/><![CDATA[" incomingRoleDisplayName="]]><xsl:value-of select="incomingroledisplayname"/><![CDATA["]]>

        <![CDATA[/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
	</ADFSConfigurations>
]]>

    <!--New for 1.4 - ADFS Certificates (and changes above to ADFSConfiguration-->
    <![CDATA[
	<ADFSCertificates>
	]]>
    <xsl:for-each select="farm/adfscertificates/certificate">
      <xsl:sort select="order"/>
      <xsl:if test="path!=''">
        <![CDATA[		<Certificate order="]]><xsl:value-of select="order"/><![CDATA[" path="]]><xsl:value-of select="path"/><![CDATA[" file="]]><xsl:value-of select="file"/><![CDATA[" store="]]><xsl:value-of select="store"/>

        <![CDATA["/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
	</ADFSCertificates>
]]>

    <![CDATA[
 	<SQLNonContentDBs>
  ]]>
    <xsl:for-each select="farm/noncontentdbs/noncontentdb">
      <xsl:if test="dbname!=''">
        <![CDATA[
	<SQLNonContentDB
						    DBName="SPS_]]><xsl:value-of select="//farm/purpose"/>_<xsl:value-of select="dbnamenoprefix"/><![CDATA["
							ServiceApplication="]]><xsl:value-of select="serviceapplicationname"/><![CDATA["
              PreCreate="]]><xsl:value-of select="precreate"/><![CDATA["
							PrimaryAlias="]]><xsl:value-of select="primarysqlalias"/><![CDATA["
							AvailabilityGroup="]]><xsl:value-of select="availabilitygroup"/><![CDATA[">		
	</SQLNonContentDB>
]]>
      </xsl:if>
    </xsl:for-each>


    <![CDATA[
	      <SQLNonContentDB
						    DBName="SPS_]]><xsl:value-of select="//farm/purpose"/>_Search_svc<![CDATA["
							ServiceApplication="Search Service Application"
              PreCreate="No"
							PrimaryAlias="]]><xsl:choose>
      <xsl:when test="//farmtype = 'SP'">SQLSCH_01_C1</xsl:when>
      <xsl:otherwise>SQLGEN_01_G1</xsl:otherwise>
    </xsl:choose><![CDATA["
							AvailabilityGroup="Default">		
	      </SQLNonContentDB>
]]>

    <![CDATA[
   

    
      
    
    
	</SQLNonContentDBs>
]]>








    <![CDATA[               
<TimerJobs>
    <Disable>
      <TimerJob Name="mysitecleanup" />
      <TimerJob Name="job-diagnostics-blocking-query-provider" />
      <TimerJob Name="job-diagnostics-sql-dmv-provider" />
      <TimerJob Name="job-diagnostics-uls-provider" />
      <TimerJob Name="job-diagnostics-performance-counter-sql-provider" />
      <TimerJob Name="job-diagnostics-performance-counter-wfe-provider" />
      <TimerJob Name="job-diagnostics-event-log-provider" />
      <TimerJob Name="job-ceip-datacollection" />
      <TimerJob Name="job-diagnostics-sql-memory-provider" />
      <TimerJob Name="User Profile Service Application_ActivityFeedJob" />
      <TimerJob Name="User Profile Service Application_AudienceCompilationJob" />
    </Disable>
  </TimerJobs>
  
  
  <HealthRules>
    <Disable>]]>
    <xsl:for-each select="farm/disablehealthrules/rule">
      <xsl:if test="current()!=''">
        <![CDATA[<HealthRule Title="]]><xsl:value-of select="current()"/><![CDATA["></HealthRule>]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[  
    </Disable>
  </HealthRules>


  
  <FarmWSPs>
    <FarmWSP>]]>
    <xsl:for-each select="farm/farmwsps/farmwsp">
      <xsl:if test="file!=''">
        <![CDATA[		<FarmWSP File="]]><xsl:value-of select="file"/><![CDATA[" Action="]]><xsl:value-of select="action"/><![CDATA[" WebApplication="]]><xsl:value-of select="webapplication"/><![CDATA["/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[  
    </FarmWSP>
  </FarmWSPs>  
  
  
    <FeatureActivations>
    <FeatureActivation>]]>
    <xsl:for-each select="farm/featureactivations/featureactivation">
      <xsl:if test="name!=''">
        <![CDATA[		<FeatureActivation Name="]]><xsl:value-of select="name"/><![CDATA[" Scope="]]><xsl:value-of select="scope"/><![CDATA[" URL="]]><xsl:value-of select="url"/><![CDATA["/>
				]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[  
    </FeatureActivation>
  </FeatureActivations>
  
  
   
 	<DefaultPermissionsSPGroups>
  ]]>
    <xsl:for-each select="farm/defaultpermissionsspgroups/defaultpermissionspgroup">
      <xsl:if test="groupname!=''">
        <![CDATA[
	<DefaultPermissionsSPGroup
						    GroupName="]]><xsl:value-of select="groupname"/><![CDATA["
							ADObject="]]><xsl:value-of select="adobject"/><![CDATA["
							SiteCollectionURL="]]><xsl:value-of select="sitecollectionurl"/><![CDATA[">
							
	</DefaultPermissionsSPGroup>
]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
	</DefaultPermissionsSPGroups>



 	<DefaultPermissionsUserPolicies>
  ]]>
    <xsl:for-each select="farm/defaultpermissionsuserpolicies/defaultpermissionsuserpolicy">
      <xsl:if test="policyname!=''">
        <![CDATA[
	<DefaultPermissionsUserPolicy
						    PolicyName="]]><xsl:value-of select="policyname"/><![CDATA["
							ADObject="]]><xsl:value-of select="adobject"/><![CDATA["
							WebApplication="]]><xsl:value-of select="webapplication"/><![CDATA["
              Zone="]]><xsl:value-of select="zone"/><![CDATA[">
							
	</DefaultPermissionsUserPolicy>
]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
	</DefaultPermissionsUserPolicies>


 	<FarmFederationSettings>
  ]]>
    <xsl:for-each select="//farmfederationsettings/farmfederationsetting">
      <xsl:if test="pubrootcert!=''">
        <![CDATA[
	<FarmFederationSetting
						    CustomerEmail="]]><xsl:value-of select="customeremail"/><![CDATA["
							CustomerFileShare="]]><xsl:value-of select="customerfileshare"/><![CDATA["
							TSysEmail="]]><xsl:value-of select="tsysemail"/><![CDATA["
              TSysFileShare="]]><xsl:value-of select="tsysfileshare"/><![CDATA["/>
							

]]>
      </xsl:if>
    </xsl:for-each>
    <![CDATA[
    	</FarmFederationSettings>

    <ServiceApplicationsToConsume>
    ]]>
    <xsl:for-each select="//serviceapplications/serviceapplication">
      <xsl:if test="consumeserviceapplication!='No' and enable='Yes'">
        <![CDATA[

						    ServiceApplicationName="]]><xsl:value-of select="name"/><![CDATA[">
							
	
]]>
      </xsl:if>
    </xsl:for-each>


    <![CDATA[
</ServiceApplicationsToConsume>

    <ContentSources>
    ]]>
    <xsl:for-each select="//contentsources/contentsource">

      <xsl:if test="type!=''">
        <![CDATA[
	<ContentSource
						    Type="]]><xsl:value-of select="type"/><![CDATA["
							Values="]]><xsl:value-of select="values"/><![CDATA["
              CrawlDepth="]]><xsl:value-of select="normalize-space(depth)"/><![CDATA["/>
							

]]>
      </xsl:if>
    </xsl:for-each>


    <![CDATA[
</ContentSources>



    <DomainCreationSettings>
    ]]>
    <xsl:for-each select="//domaincreatesettings/settings">

      <xsl:if test="forestdomainname!=''">
        <![CDATA[
	<DomainCreationSetting
	
						    ForestAndDomainName="]]><xsl:value-of select="forestdomainname"/><![CDATA["
					    	NetBIOS="]]><xsl:value-of select="netbios"/><![CDATA["
						    LocalAdminPassword="]]><xsl:value-of select="localadminpassword"/><![CDATA["
						    SafeModePassword="]]><xsl:value-of select="safemodepassword"/><![CDATA["/>							
]]>
      </xsl:if>
    </xsl:for-each>


    <![CDATA[
</DomainCreationSettings>


    <DomainJoinSettings>
    ]]>
    <xsl:for-each select="//domainjoinsettings/settings">

      <xsl:if test="forestdomainname!=''">
        <![CDATA[
	<DomainJoinSetting
	
	
	              ShortDomainName="]]><xsl:value-of select="shortdomainame"/><![CDATA["
						    ForestAndDomainName="]]><xsl:value-of select="forestdomainname"/><![CDATA["
						    DCIPAddress="]]><xsl:value-of select="dcip"/><![CDATA["	
						    LocalAdminPassword="]]><xsl:value-of select="localadminpassword"/><![CDATA["
						    OU="]]><xsl:value-of select="ou"/><![CDATA["
					      UserName="]]><xsl:value-of select="username"/><![CDATA["
						    Password="]]><xsl:value-of select="password"/><![CDATA["/>
						    
]]>
      </xsl:if>
    </xsl:for-each>


    <![CDATA[
</DomainJoinSettings>


       
<AllServiceExtensions>]]>
    <xsl:for-each select="//allserviceextensions/serviceextension">
      <![CDATA[
      <ServiceExtension name="]]><xsl:value-of select="name"/><![CDATA["/>]]>
    </xsl:for-each>
    <![CDATA[
</AllServiceExtensions>

<FarmServiceExtensions>]]>
    <xsl:for-each select="//farmserviceextensions/serviceextension">
      <![CDATA[
      <ServiceExtension name="]]><xsl:value-of select="name"/><![CDATA[" values="]]><xsl:value-of select="values"/><![CDATA["/>]]>
    </xsl:for-each>
    <![CDATA[
</FarmServiceExtensions>

    <ZimoryConfiguration>
      <BaseURL>]]><xsl:value-of select="normalize-space(//zimoryconfiguration/baseurl)"/><![CDATA[</BaseURL>
      <CertificatePath>]]><xsl:value-of select="//zimoryconfiguration/certificatepath"/><![CDATA[</CertificatePath>
      <CertificatePassword>]]><xsl:value-of select="//zimoryconfiguration/certificatepassword"/><![CDATA[</CertificatePassword>
      <HostEntry>]]><xsl:value-of select="//zimoryconfiguration/hostentry"/><![CDATA[</HostEntry>
    </ZimoryConfiguration>
    
    <WACConfiguration>
      <SharePointIP>]]><xsl:value-of select="normalize-space(//wacconfiguration/sharepointip)"/><![CDATA[</SharePointIP>
      <EditingEnabled>]]><xsl:value-of select="//wacconfiguration/editingenabled"/><![CDATA[</EditingEnabled>
      <TranslationEnabled>]]><xsl:value-of select="//wacconfiguration/translationenabled"/><![CDATA[</TranslationEnabled>
     
    </WACConfiguration>
    


	<AzureMobileService>
    		<Proxy>]]><xsl:value-of select="normalize-space(//azureconfiguration/proxy)"/><![CDATA[</Proxy>
    		<JSONUrl>]]><xsl:value-of select="normalize-space(//azureconfiguration/jsonurl)"/><![CDATA[</JSONUrl>
		<ApplicationKey>]]><xsl:value-of select="normalize-space(//azureconfiguration/applicationkey)"/><![CDATA[</ApplicationKey>
		<RegistrationsTable>]]><xsl:value-of select="normalize-space(//azureconfiguration/registrationstable)"/><![CDATA[</RegistrationsTable>    
		<SessionTable>]]><xsl:value-of select="normalize-space(//azureconfiguration/sessiontable)"/><![CDATA[</SessionTable>
		<SessionDetailTable>]]><xsl:value-of select="normalize-space(//azureconfiguration/sessiondetailtable)"/><![CDATA[</SessionDetailTable>
    <CustomersTable>]]><xsl:value-of select="normalize-space(//azureconfiguration/customertable)"/><![CDATA[</CustomersTable>
    <CustomerID>]]><xsl:value-of select="normalize-space(//azureconfiguration/customerid)"/><![CDATA[</CustomerID>
<SessionDetailServerTable>]]><xsl:value-of select="normalize-space(//azureconfiguration/sessiondetailservertable)"/><![CDATA[</SessionDetailServerTable>        


	</AzureMobileService>    
  
  
	<SharePointBackup>  
        <ScriptPackageLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/spbackuppackagelocation)"/><![CDATA[</ScriptPackageLocation>
        <ScriptDestination>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/spbackupscriptdestination)"/><![CDATA[</ScriptDestination>
        <DaysToKeepBackups>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/spbackupdaystokeepbackups)"/><![CDATA[</DaysToKeepBackups>
]]>
      <xsl:choose>
        <xsl:when test="//useCentralBackupLocation = 'True'">
            <![CDATA[  
    		  <ShareName>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/spbackupfilessharename)"/><![CDATA[</ShareName>
          <ShareRootUNC>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><![CDATA[</ShareRootUNC>
          <BackupDriveLetter_Local></BackupDriveLetter_Local>]]>
          </xsl:when>
       <xsl:otherwise>
          <![CDATA[  
          <ShareName>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/spbackupfilessharename)"/><![CDATA[</ShareName>
          <BackupDriveLetter_Local>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/backupdriveletter)"/><![CDATA[</BackupDriveLetter_Local>]]>
        </xsl:otherwise>
      </xsl:choose>      
    <![CDATA[
	</SharePointBackup>    
    
    
    
    	<SQLMaintenance>
      
    		<ShareNameFullBackup>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupfullsharename)"/><![CDATA[</ShareNameFullBackup>
        <ShareNameDiffBackup>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdiffsharename)"/><![CDATA[</ShareNameDiffBackup>
        <ShareNameTLogsBackup>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackuptlogsharename)"/><![CDATA[</ShareNameTLogsBackup>
        <ShareNameMReportsBackup>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackuptmreportsharename)"/><![CDATA[</ShareNameMReportsBackup>

    ]]>
      <xsl:choose>
        <xsl:when test="//useCentralBackupLocation = 'True'">
          <![CDATA[  
    		     <ShareLocationDriveLetter></ShareLocationDriveLetter>      
            <BackupBaseLocation>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation_centralshare)"/><![CDATA[</BackupBaseLocation>
  		      <FullBackupLocation>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation_centralshare)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupfulllocation)"/><![CDATA[</FullBackupLocation>
            <DiffBackupLocation>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation_centralshare)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdifflocation)"/><![CDATA[</DiffBackupLocation>
            <TLogsBackupLocation>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation_centralshare)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackuptloglocation)"/><![CDATA[</TLogsBackupLocation>
            <MReportsLocation>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation_centralshare)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupmreportslocation)"/><![CDATA[</MReportsLocation>
            <SQLAgentJobsOutputLocation>]]><xsl:value-of select="normalize-space(//centralBackupLocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation_centralshare)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlagentjoblogging)"/><![CDATA[</SQLAgentJobsOutputLocation>
            ]]>
        </xsl:when>
        <xsl:otherwise>
          <![CDATA[  
            <ShareLocationDriveLetter>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><![CDATA[</ShareLocationDriveLetter>      
            <BackupBaseLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation)"/><![CDATA[</BackupBaseLocation>
  		      <FullBackupLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupfulllocation)"/><![CDATA[</FullBackupLocation>
            <DiffBackupLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdifflocation)"/><![CDATA[</DiffBackupLocation>
            <TLogsBackupLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackuptloglocation)"/><![CDATA[</TLogsBackupLocation>
            <MReportsLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupmreportslocation)"/><![CDATA[</MReportsLocation>
            <SQLAgentJobsOutputLocation>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdriveletter)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupbaselocation)"/><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlagentjoblogging)"/><![CDATA[</SQLAgentJobsOutputLocation>
            ]]>
        </xsl:otherwise>
      </xsl:choose>
      <![CDATA[
      
      <DaysToKeepBackups>]]><xsl:value-of select="normalize-space(//backupandmaintenancesettings/sqlbackupdaystokeepbackups)"/><![CDATA[</DaysToKeepBackups>
      <PlanTemplate>SAO SP Standard Maintenance_Template.dtsx</PlanTemplate>

       
      <Plans>]]>
          <xsl:for-each select="//backupandmaintenancesettings/plans/plan">
            <![CDATA[
            <Plan Name="]]><xsl:value-of select="name"/><![CDATA[" Description="]]><xsl:value-of select="description"/><![CDATA[" >
            <Schedules>]]>
            <xsl:for-each select="schedule">
              <![CDATA[
              <Schedule Type="]]><xsl:value-of select="scheduletype"/><![CDATA[" Hour="]]><xsl:value-of select="schedulehour"/><![CDATA["  Min="]]><xsl:value-of select="schedulemin"/><![CDATA["   DayOffset="]]><xsl:value-of select="scheduledayoffset"/><![CDATA[" />                
              ]]>            
            </xsl:for-each>
          <![CDATA[
          </Schedules>]]>          
          <![CDATA[          
            </Plan>]]>
          </xsl:for-each>
          <![CDATA[
      </Plans>


	</SQLMaintenance>    

    
</Configuration>
]]>
  </xsl:template>
</xsl:stylesheet>
