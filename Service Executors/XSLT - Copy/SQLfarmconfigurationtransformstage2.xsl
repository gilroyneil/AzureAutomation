<!--
Author: Neil Gilroy
Filename: TestXSLT.xml
Input: farm config xml
Created: October 2011
Purpose: To Transform the XML Output of a Excel MAP to a customised version of the AutoSPInstaller schema.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:zim="http://www.zimory.com/confserver/metadata/v1_0_0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
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
    <![CDATA[<!---->
<Configuration Environment="**||Environment||**" Version="**||VersionNumber||**" UseIPAddresses="False">
    <!-- The Environment attribute above appears at the top of the installation transcript. It does not affect the installation -->
    <!-- The Install section controls what modifications are made to the Windows OS prior to installation and how the SharePoint installation is run -->
    <Install>
            <SubscriptionID>]]><xsl:value-of select="//subscriptionID"/><![CDATA[</SubscriptionID>
            <FarmType>]]><xsl:value-of select="//farmtype"/><![CDATA[</FarmType>  
            <IsHAInstall>]]><xsl:value-of select="/farm/isHAInstall"/><![CDATA[</IsHAInstall>  
            <InstanceSize>]]><xsl:value-of select="/farm/InstanceSize"/><![CDATA[</InstanceSize>  
            <InstanceName>]]><xsl:value-of select="/farm/InstanceName"/><![CDATA[</InstanceName> 
            <UseCentralBackupLocation>]]><xsl:value-of select="//useCentralBackupLocation"/><![CDATA[</UseCentralBackupLocation>
            <CentralBackupLocation>]]><xsl:value-of select="//centralBackupLocation"/><![CDATA[</CentralBackupLocation>
            <CentralClusterLocation>]]><xsl:value-of select="//centralClusterLocation"/><![CDATA[</CentralClusterLocation>
            <LocalMediaPath>e:\data\media</LocalMediaPath>
            <DeploymentServer>]]><xsl:value-of select="//deploymentserver"/><![CDATA[</DeploymentServer>  
            <MediaServer>]]><xsl:value-of select="//mediaserver"/><![CDATA[</MediaServer>   
           <Windows2012Install>True</Windows2012Install>
    <UseLocalAdminForStartupScripts>]]><xsl:value-of select="//uselocaladminaccountforstartupscripts"/><![CDATA[</UseLocalAdminForStartupScripts>  

    <CreateAllClusterElements>]]><xsl:value-of select="//createAllClusterElements"/><![CDATA[</CreateAllClusterElements>  

    
		<BuildAccount>]]><xsl:value-of select="//managedaccounts/managedaccount[purpose='SQL Server Install Account']/domain"/>\<xsl:value-of select="/farm/managedaccounts/managedaccount[purpose='SQL Server Install Account']/username"/><![CDATA[</BuildAccount>
    <BuildAccountPassword>]]><xsl:value-of select="/farm/managedaccounts/managedaccount[purpose='SQL Server Install Account']/password"/><![CDATA[</BuildAccountPassword>
		<TempFileLocationDuringInstall>E:\TempInstallFiles</TempFileLocationDuringInstall>

      
		<ProjServerConfigFile path="SetupConfigFiles\ProjSvrConfig.xml" name="ProjSvrConfig.xml"></ProjServerConfigFile>				
        
   
    <Sizing>
                <AmountOfUsers>]]><xsl:value-of select="//numberofusers"/><![CDATA[</AmountOfUsers>  
                <AmountIndexedItems>]]><xsl:value-of select="//amountindexeditems"/><![CDATA[</AmountIndexedItems>  
                <BackupStorageNeeded>]]><xsl:value-of select="//backupstorageneeded"/><![CDATA[</BackupStorageNeeded>
    </Sizing>
    </Install>
     ]]>
        <xsl:choose>
          <xsl:when test="/farm/createdomain = Yes">
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

    <!-- The Farm section contains basic farm-wide settings -->

    <Farm>    
 <!--NG This is the Farm Name (which is customer specific-->
        <FarmName>]]><xsl:value-of select="/farm/farmname"/><![CDATA[</FarmName> 
        <Purpose>]]><xsl:value-of select="/farm/purpose"/><![CDATA[</Purpose> 
        <CustomerName>]]><xsl:value-of select="/farm/customer"/><![CDATA[</CustomerName>    
        <CustomerNameShort>]]><xsl:value-of select="/farm/customerabreviation"/><![CDATA[</CustomerNameShort>    


        <CreateDomain>]]><xsl:value-of select="/farm/createdomain"/><![CDATA[</CreateDomain>
        <JoinDomain>]]><xsl:value-of select="/farm/joindomain"/><![CDATA[</JoinDomain>
        ]]>
    <![CDATA[
    <Database>]]>


    <!--Create the Aliases-->
    <![CDATA[
		<Aliases>]]><xsl:for-each select="/farm/sqlinstances/sqlinstance[name!='']">
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
      					<Port_AlwaysOn>]]><xsl:value-of select="AVGport"/><![CDATA[</Port_AlwaysOn>
					      
                <DefaultCollation>]]><xsl:value-of select="Collation"/><![CDATA[</DefaultCollation>
]]><xsl:choose>
        <xsl:when test="//doUseSmallDriveSizesForCIC = 'True'">
          <![CDATA[
          <DataDrive>f</DataDrive>
                <LogsDrive>f</LogsDrive>
                <TempDBDataDrive>f</TempDBDataDrive>
                <TempDBLogsDrive>f</TempDBLogsDrive>
                <SystemDBDrive>f</SystemDBDrive>
                <BackupDrive>n</BackupDrive>
                <BackupDrive>]]><xsl:value-of select="/farm/centralBackupLocation"/><![CDATA[</BackupDrive>
                <ClusterShareDrive>]]><xsl:value-of select="/farm/centralClusterLocation"/><![CDATA[</ClusterShareDrive>]]>
        </xsl:when>
        <xsl:otherwise>
          <![CDATA[
          <DataDrive>f</DataDrive>
                 <LogsDrive>f</LogsDrive>
                <TempDBDataDrive>f</TempDBDataDrive>
                <TempDBLogsDrive>f</TempDBLogsDrive>
                <SystemDBDrive>f</SystemDBDrive>
                <BackupDrive>]]><xsl:value-of select="/farm/centralBackupLocation"/><![CDATA[</BackupDrive>
                <ClusterShareDrive>]]><xsl:value-of select="/farm/centralClusterLocation"/><![CDATA[</ClusterShareDrive>]]>
        </xsl:otherwise>
      </xsl:choose><![CDATA[


                
	    <DBsToCreate></DBsToCreate>
          <DBCreators>]]><xsl:value-of select="/farm/DBCreators"/><![CDATA[</DBCreators>
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
		<ListenerName>]]><xsl:value-of select="/farm/AvailabilityGroupListnerName"/><![CDATA[</ListenerName>  
		<ListenerPort>]]><xsl:value-of select="/farm/AvailabilityGroupPort"/><![CDATA[</ListenerPort>  
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
      <Port>]]><xsl:value-of select="/farm/SQLPort"/><![CDATA[</Port>
      <TotalStorage>]]><xsl:value-of select="/farm/TotalStorage"/><![CDATA[</TotalStorage>
      <AlwaysOnSettings>
        <ListenerIPs>]]><xsl:value-of select="/farm/clusterconfiguration/listenerip"/><![CDATA[</ListenerIPs>
        <ClusterIPs>]]><xsl:value-of select="/farm/clusterconfiguration/clusterip"/><![CDATA[</ClusterIPs> 
        <ListenerName>]]><xsl:value-of select="/farm/clusterconfiguration/listenername"/><![CDATA[</ListenerName>
        <ListenerPort>]]><xsl:value-of select="/farm/AvailabilityGroupPort"/><![CDATA[</ListenerPort>
        <ClusterPort>5022</ClusterPort>
        <ClusterName>]]><xsl:value-of select="/farm/clusterconfiguration/clustername"/><![CDATA[</ClusterName>
        <AvailabilityGroupName>Default</AvailabilityGroupName>
        <AvailabilityGroupListnerName>]]><xsl:value-of select="/farm/AvailabilityGroupListnerName"/><![CDATA[</AvailabilityGroupListnerName>
        <ClusterQuoromShare>]]><xsl:value-of select="/farm/BackupLocation"/><![CDATA[</ClusterQuoromShare>
        <Node1SQLBackupShare>]]><xsl:value-of select="/farm/BackupLocation"/><![CDATA[</Node1SQLBackupShare>
        <EndpointName>ESAlwaysOn_Endpoint</EndpointName>
        <EndpointPort>5022</EndpointPort>      
      </AlwaysOnSettings>
		 
		  <FixedDataGrowthSizeMB>]]><xsl:value-of select="/farm/fixeddatagrowthsizeMB"/><![CDATA[</FixedDataGrowthSizeMB>
      <FixedLogGrowthSizeMB>]]><xsl:value-of select="/farm/fixedloggrowthsizeMB"/><![CDATA[</FixedLogGrowthSizeMB>
      
      
			<ContentDBInitialSizeMB>10000</ContentDBInitialSizeMB>
      <OtherDBInitialSizeMB>2000</OtherDBInitialSizeMB>
             <SearchAnalyticsDBInitialSizeMB>250000</SearchAnalyticsDBInitialSizeMB>

      <PercentageLogSizeOfDataSize>]]><xsl:value-of select="/farm/percentagelogsizeofdatasize"/><![CDATA[</PercentageLogSizeOfDataSize>
      <PercentageDataGrowthOfDataSize>25</PercentageDataGrowthOfDataSize>
      <PercentageLogGrowthOfLogSize>25</PercentageLogGrowthOfLogSize>
      
      

			    
			 <!-- Other settings from the Farm Configuration From DSC 2, leave in place for DSC 3. -->
			<RequiredDocumentStorage>]]><xsl:value-of select="/farm/requireddocumentstorage"/><![CDATA[</RequiredDocumentStorage>
			<AmountOfDocuments>]]><xsl:value-of select="/farm/amountofdocuments"/><![CDATA[</AmountOfDocuments>            
			<TotalContentDBSize>]]><xsl:value-of select="/farm/totalcontentdbsize"/><![CDATA[</TotalContentDBSize>
			<SearchDBSize>]]><xsl:value-of select="/farm/searchdbsize"/><![CDATA[</SearchDBSize>
			<OtherDBSize>]]><xsl:value-of select="/farm/otherdbsize"/><![CDATA[</OtherDBSize>  			 
			  
      <!-- <ContentDBMaxSize>]]><xsl:value-of select="/farm/contentdbmaxsize"/><![CDATA[</ContentDBMaxSize>
			<ContentDBDefaultSize>]]><xsl:value-of select="/farm/contentdbdefaultsize"/><![CDATA[</ContentDBDefaultSize>  			 
			<ContentDBsPerSQLInstance>]]><xsl:value-of select="/farm/numbercontentdbspersqlinstance"/><![CDATA[</ContentDBsPerSQLInstance>
      <SearchBackupUNC>]]><xsl:value-of select="/farm/searchbackuppath"/><![CDATA[</SearchBackupUNC>  -->  
      <SiteCollectionsPerContentDB max="160" warning="120"></SiteCollectionsPerContentDB>    
      <Backuplocation>]]><xsl:value-of select="/farm/BackupLocation"/><![CDATA[</Backuplocation>
		</OtherDatabaseSettings>
		
		<ContentDBs>]]>
					<!-- Create a variable to hold the number of SQL Instances -->
			<xsl:variable
					name="numContentInstances"
					select="count(/farm/sqlinstances/sqlinstance[type='Content SQL Server'])">
					</xsl:variable>	
					<![CDATA[<NumberOfContentSQLInstances>]]><xsl:value-of select="$numContentInstances"/><![CDATA[</NumberOfContentSQLInstances>]]>

    <xsl:variable
              name="numDBsPerInstance"
              select="/farm/numbercontentdbspersqlinstance">
    </xsl:variable>


    
			<![CDATA[			
		</ContentDBs>
		
    </Database>
            ]]>
    
    <![CDATA[       
<Servers>]]>
    <xsl:for-each select="/farm/servers/server">
      <xsl:variable
        name="serverName"
        select="name">
      </xsl:variable>
      <xsl:if test="name!=''">
        <![CDATA[
          <Server name="]]><xsl:value-of select="name"/><![CDATA[" SAMID="" vAppName="" ip="]]><xsl:value-of select="//serveripaddress[servername=$serverName]/serverip"/><![CDATA[" role="]]><xsl:value-of select="role"/><![CDATA[" addToDomain="]]><xsl:value-of select="addtodomain"/><![CDATA[" datacenter="]]><xsl:value-of select="datacenter"/><![CDATA[" appliance="]]><xsl:value-of select="appliance"/><![CDATA[" vmtemplate="]]><xsl:value-of select="deploymenttemplate"/><![CDATA[" />]]>
      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</Servers>
]]>


    <![CDATA[       
<ServerIPAddresses>]]>
    <xsl:for-each select="/farm/serveripaddresses/serveripaddress">
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
    <xsl:for-each select="/farm/vmtemplates/vmtemplate">
      <xsl:if test="name!=''">
        <![CDATA[
        <VMTemplate name="]]><xsl:value-of select="name"/><![CDATA[" description="]]><xsl:value-of select="description"/><![CDATA[" performanceunits="]]><xsl:value-of select="performanceunits"/><![CDATA[" cores="]]><xsl:value-of select="cores"/><![CDATA[" ram="]]><xsl:value-of select="ram"/><![CDATA[" externalip="]]><xsl:value-of select="externalip"/><![CDATA[" network="]]><xsl:value-of select="network"/><![CDATA["/>]]>

      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</VMTemplates>
]]>

 

    <![CDATA[       
<ServerGroupSettings>]]>
    <xsl:for-each select="/farm/servergroups/servergroup">
      <xsl:if test="name!=''">
        <![CDATA[
        <Server name="]]><xsl:value-of select="name"/><![CDATA[" description="]]><xsl:value-of select="description"/><![CDATA[" requiredNumber="]]><xsl:value-of select="requirednumber"/><![CDATA[" orderedNumber="]]><xsl:value-of select="orderednumber"/><![CDATA[" vmTemplate="]]><xsl:value-of select="vmtemplate"/><![CDATA[" cdrivevhdsizeGB="]]><xsl:value-of select="cdrivevhdsize"/><![CDATA[" edrivevhdsizeGB="]]><xsl:value-of select="edrivevhdsize"/><![CDATA[" fdrivevhdsizeGB="]]><xsl:value-of select="fdrivevhdsize"/><![CDATA[" nicservice="]]><xsl:value-of select="nicservice"/><![CDATA[" nicoperations="]]><xsl:value-of select="nicoperations"/><![CDATA[" nicbackup="]]><xsl:value-of select="nicbackup"/><![CDATA[" nicsqlreplication="]]><xsl:value-of select="nicsqlreplication"/><![CDATA[" nicdmzinternal="]]><xsl:value-of select="nicdmzinternal"/><![CDATA[" nicdmzexternal="]]><xsl:value-of select="nicdmzexternal"/><![CDATA["/>]]>
      </xsl:if>
    </xsl:for-each>

    <![CDATA[
</ServerGroupSettings>
]]>
        
        
    <![CDATA[
	<Logs>
      <ULSLogs Folder="E:\ULSLogs" />
      <IISLogs Folder="E:\IISLogs" />      			 
    </Logs>    
    ]]>



    
   <![CDATA[
	<ServiceAccountsOU>]]><xsl:value-of select="//serviceaccountsOU"/><![CDATA[</ServiceAccountsOU>
 ]]>
    <![CDATA[

 
 
<!-- These accounts are not SharePoint Managed accounts, insetad they are needed for things like SQL. -->
        <NonSharePointServiceAccounts>
         ]]>
    <xsl:for-each select="/farm/managedaccounts/managedaccount[issharepointmanagedaccount='No']">
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

<SQLServerAdminAccounts>
  <Admin1>]]><xsl:value-of select="/farm/SQLServerAdminAccounts/Admin1"/><![CDATA[</Admin1>
  <Admin2>]]><xsl:value-of select="/farm/SQLServerAdminAccounts/Admin2"/><![CDATA[</Admin2>
</SQLServerAdminAccounts>

<!-- These accounts are not service accounts, they are simply test user accounts-->
        <TestUserAccounts OU="]]><xsl:value-of select="//testaccountsOU"/><![CDATA[">
         ]]>
    <xsl:for-each select="/farm/testuseraccounts/useraccount">
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
 
 
        
        ]]>
    <![CDATA[</Farm>
    
    ]]>

    <![CDATA[
	<ProductVersions>
	]]>
    <xsl:for-each select="/farm/productversions/productversion">
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
	<xsl:for-each select="/farm/windowsfirewallsettings/windowsfirewallsetting">
				   <xsl:if test="role!=''">
					<![CDATA[		<FirewallConfiguration serverRole="]]><xsl:value-of select="role"/><![CDATA[" incomingPort="]]><xsl:value-of select="incomingport"/><![CDATA[" direction="]]><xsl:value-of select="direction"/><![CDATA[" remoteIP="]]><xsl:value-of select="remoteip"/><![CDATA[" protocol="]]><xsl:value-of select="protocol"/><![CDATA[" ruleName="]]><xsl:value-of select="rulename"/><![CDATA[" action="]]><xsl:value-of select="action"/><![CDATA["/>
				]]>
					</xsl:if>
			</xsl:for-each>						
<![CDATA[
	</FirewallConfigurations>
]]>


    <![CDATA[
 	<SQLNonContentDBs>
  ]]>
    <xsl:for-each select="/farm/noncontentdbs/noncontentdb">
        <xsl:if test="dbname!=''">
          <![CDATA[
	
]]>
      </xsl:if>
    </xsl:for-each>
   

    <![CDATA[
	      <SQLNonContentDB
						    DBName="SPS_]]><xsl:value-of select="/farm/purpose"/>_Search_svc<![CDATA["
							ServiceApplication="Search Service Application"
              PreCreate="No"
							PrimaryAlias="SQLGEN_01_G1"
							AvailabilityGroup="Default">		
	      </SQLNonContentDB>
]]>
    
    <![CDATA[
   
    
    <!--Logic for Search Servers goes here-->
    
      
    
    
	</SQLNonContentDBs>
]]>

<![CDATA[

   
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

    <ZimoryConfiguration>
      <BaseURL>]]><xsl:value-of select="normalize-space(//zimoryconfiguration/baseurl)"/><![CDATA[</BaseURL>
      <CertificatePath>]]><xsl:value-of select="//zimoryconfiguration/certificatepath"/><![CDATA[</CertificatePath>
      <CertificatePassword>]]><xsl:value-of select="//zimoryconfiguration/certificatepassword"/><![CDATA[</CertificatePassword>
      <HostEntry>]]><xsl:value-of select="//zimoryconfiguration/hostentry"/><![CDATA[</HostEntry>
    </ZimoryConfiguration>
    
    

   <SQLMaintenance>
        
        
    		<ShareNameFullBackup>"Full Backups"</ShareNameFullBackup>
        <ShareNameDiffBackup>"Differential Backups"</ShareNameDiffBackup>
        <ShareNameTLogsBackup>"Transaction Log Backups"</ShareNameTLogsBackup>
        <ShareNameMReportsBackup>"Maintenance Reports"</ShareNameMReportsBackup>

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
