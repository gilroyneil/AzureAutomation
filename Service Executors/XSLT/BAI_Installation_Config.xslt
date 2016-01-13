<!--
Author: Neil Gilroy
Filename: BAI_Installation_Config.xslt
Input:	Final XML from ES/SP
Created: August 2014
Purpose: To Transform the XML Output of a the final XML schema we use circa v3.3 to a BAI Insight XML Schema.
-->
<xsl:stylesheet version="2.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" cdata-section-elements="text"/>



<xsl:template match="Configuration">


  <![CDATA[
<root>
	<ImportServer>
	
  ]]><xsl:choose>
    <xsl:when test="count(/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server']) > 0">
      <xsl:for-each select="/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server']">        
        <![CDATA[
        <InstallImportServer>
          <ComputerName]]>><xsl:value-of select="@name"/><![CDATA[</ComputerName>
           <Domain>]]><xsl:value-of select="/Configuration/Domain"/><![CDATA[</Domain>
          <User>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/usernameonly"/><![CDATA[</User>
          <Password>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/Password"/><![CDATA[</Password>
          <InstallDir>E:\Apps\BA Insight\longitude Preview</InstallDir>
        </InstallImportServer>
        
         <ConfigureImportServer>
			    <ImportServerComputerName>]]><xsl:value-of select="@name"/><![CDATA[</ImportServerComputerName>
          ]]><xsl:choose>
          <xsl:when test="count(/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server']) > 0">
            <![CDATA[
			          <SQLComputerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/DBServerNoInstance"/><![CDATA[</SQLComputerName>
			          <SQLServerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/SQLAliasName"/><![CDATA[</SQLServerName>
          ]]>
          </xsl:when>
          <xsl:otherwise>
            <![CDATA[
                <SQLComputerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/DBServerNoInstance"/><![CDATA[</SQLComputerName>
			          <SQLServerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/SQLAliasName"/><![CDATA[</SQLServerName>      
              ]]>
          </xsl:otherwise>
        </xsl:choose><![CDATA[
			    <CreateNewDatabase>true</CreateNewDatabase>
			    <ConfigurationDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_Configuration</ConfigurationDatabaseName>
			    <PreviewCacheDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_PreviewCache</PreviewCacheDatabaseName>
			    <UserProfileDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_UserProfile</UserProfileDatabaseName>
			    <TransferFolder>\\]]><xsl:value-of select="@name"/><![CDATA[\LongitudeTransfer</TransferFolder>
		  </ConfigureImportServer>		
      
      
        ]]>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <![CDATA[
        <InstallImportServer>
          <ComputerName>]]><xsl:value-of select="/Configuration/Farm/Servers/Server[@role='Web Server Group 1'][1]/@name"/><![CDATA[</ComputerName>
          <Domain>]]><xsl:value-of select="/Configuration/Domain"/><![CDATA[</Domain>
          <User>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/usernameonly"/><![CDATA[</User>
          <Password>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/Password"/><![CDATA[</Password>
          <InstallDir>E:\Apps\BA Insight\longitude Preview</InstallDir>
        </InstallImportServer>
        
        <ConfigureImportServer>
			    <ImportServerComputerName>]]><xsl:value-of select="/Configuration/Farm/Servers/Server[@role='Web Server Group 1'][1]/@name"/><![CDATA[</ImportServerComputerName>
          ]]><xsl:choose>
            <xsl:when test="count(/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server']) > 0">             
          <![CDATA[
			          <SQLComputerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/DBServerNoInstance"/><![CDATA[</SQLComputerName>
			          <SQLServerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/SQLAliasName"/><![CDATA[</SQLServerName>
          ]]>
            </xsl:when>
            <xsl:otherwise>
              <![CDATA[
                <SQLComputerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/DBServerNoInstance"/><![CDATA[</SQLComputerName>
			          <SQLServerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/SQLAliasName"/><![CDATA[</SQLServerName>      
              ]]>
            </xsl:otherwise>
          </xsl:choose><![CDATA[
			    <CreateNewDatabase>true</CreateNewDatabase>
			    <ConfigurationDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_Configuration</ConfigurationDatabaseName>
			    <PreviewCacheDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_PreviewCache</PreviewCacheDatabaseName>
			    <UserProfileDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_UserProfile</UserProfileDatabaseName>
			    <TransferFolder>\\]]><xsl:value-of select="/Configuration/Farm/Servers/Server[@role='Web Server Group 1'][1]/@name"/><![CDATA[\LongitudeTransfer</TransferFolder>
		  </ConfigureImportServer>		
        ]]>      
    </xsl:otherwise>
  </xsl:choose><![CDATA[
		
	</ImportServer>
	
	<LongitudeComponents>
	
		<CreateTransferFolder>    
    
      <ComputerName>]]><xsl:choose>
      <xsl:when test="count(/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server']) > 0">
        <xsl:value-of select="/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server'][1]/@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/Configuration/Farm/Servers/Server[@role='Web Server Group 1'][1]/@name"/>      </xsl:otherwise>
    </xsl:choose><![CDATA[</ComputerName>
			<FolderPath>E:\Data\LongitudeTransfer</FolderPath>
			<UserToShareWith>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/username"/><![CDATA[</UserToShareWith>
			<FolderShareName>LongitudeTransfer</FolderShareName>
		</CreateTransferFolder>
	
		<DatabaseChanges>]]><xsl:choose>
      <xsl:when test="count(/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server']) > 0">
        <![CDATA[
			  <ComputerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/DBServerNoInstance"/><![CDATA[</ComputerName>
			  <SQLServerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/SQLAliasName"/><![CDATA[</SQLServerName>]]>
      </xsl:when>
      <xsl:otherwise>
        <![CDATA[
        <ComputerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/DBServerNoInstance"/><![CDATA[</SQLComputerName>
			  <SQLServerName>]]><xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/SQLAliasName"/><![CDATA[</SQLServerName>]]>
      </xsl:otherwise>
    </xsl:choose><![CDATA[
      <ConfigurationDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_Configuration</ConfigurationDatabaseName>
			<PreviewCacheDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_PreviewCache</PreviewCacheDatabaseName>
			<UserProfileDatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_UserProfile</UserProfileDatabaseName>	
			<UserToGivePermisions>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/username"/><![CDATA[</UserToGivePermisions>
		</DatabaseChanges>	

]]>
 <xsl:for-each select="//IndexServers/Server">        
<![CDATA[
        
		<InstallCEWS>
			<ComputerName>]]><xsl:value-of select="@Name"/><![CDATA[</ComputerName>			
			<InstallLocation>E:\Apps\BA Insight\Longitude Components</InstallLocation>			
			<CEWSUserName>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/username"/><![CDATA[</CEWSUserName>
			<CEWSPassword>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/Password"/><![CDATA[</CEWSPassword>
		</InstallCEWS>
		
		<ConfigureCEWS>
			<ComputerName>]]><xsl:value-of select="@Name"/><![CDATA[</ComputerName>
			<PreviewDataRepository>\\]]><xsl:value-of select="@Name"/><![CDATA[\LongitudeIncomingTemp</PreviewDataRepository>
			<BaseAddress>http://]]><xsl:value-of select="@Name"/><![CDATA[:1237/ContentProcessingService</BaseAddress>
		</ConfigureCEWS>
				
		<InstallFastProxy>
			<ComputerName>]]><xsl:value-of select="@Name"/><![CDATA[</ComputerName>
			<InstallLocation>E:\install\BA Insight\Longitude Components</InstallLocation>
			<FastProxyUserName>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/username"/><![CDATA[</FastProxyUserName>
			<FastProxyPassword>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/Password"/><![CDATA[</FastProxyPassword>
		</InstallFastProxy>
		
		<ConfigureFastProxy>
			<ComputerName>]]><xsl:value-of select="@Name"/><![CDATA[</ComputerName>
			<FastProxyTransferFolder>\\]]><xsl:choose>
        <xsl:when test="count(/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server']) > 0">
          <xsl:value-of select="/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server'][1]/@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/Configuration/Farm/Servers/Server[@role='Web Server Group 1'][1]/@name"/>
        </xsl:otherwise>
      </xsl:choose><![CDATA[\LongitudeTransfer</FastProxyTransferFolder>      
			<ConnectionString>Data Source=]]><xsl:choose>
        <xsl:when test="count(/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server']) > 0">          
			    <xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/SQLAliasName"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/SQLAliasName"/>
        </xsl:otherwise>
      </xsl:choose><![CDATA[;Initial Catalog="SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_Configuration";Integrated Security=True</ConnectionString>			 		
			<FastIncomingFolder>\\]]><xsl:value-of select="@Name"/><![CDATA[\LongitudeIncomingTemp</FastIncomingFolder>
		</ConfigureFastProxy>
		
		<CreatePreviewDataRepositoryFolder>
			<ComputerName>]]><xsl:value-of select="@Name"/><![CDATA[</ComputerName>			
			<FolderPath>E:\data\longitudeincomingtemp</FolderPath>			
			<UserToShareWith>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/username"/><![CDATA[</UserToShareWith>			
			<FolderShareName>LongitudeIncomingTemp</FolderShareName>
		</CreatePreviewDataRepositoryFolder>
           
		<SharepointEnrichmentConfig>
			<SearchServiceApplicationName>Search Service Application</SearchServiceApplicationName>
			<Endpoint>http://]]><xsl:value-of select="@Name"/><![CDATA[:1237/ContentProcessingService</Endpoint>
		</SharepointEnrichmentConfig>    
 ]]>
</xsl:for-each>
  <![CDATA[
		<InstallWSP>			
			<WSPStorage>E:\Apps\BA Insight\Longitude Components</WSPStorage>
		</InstallWSP>
		
		<CreateLongitudeServiceApplication>
			<SQLServerName>]]><xsl:choose>
      <xsl:when test="count(/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server']) > 0">
        <xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='Other SQL Server'][1]/SQLAliasName"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/Configuration/Farm/Database/Aliases/Alias[type='General'][1]/SQLAliasName"/>
      </xsl:otherwise>
    </xsl:choose><![CDATA[</SQLServerName>
			<ServiceApplicationName>LPSA</ServiceApplicationName>
			<ApplicationPoolName>LPSA</ApplicationPoolName>
			<DatabaseName>SPS_]]><xsl:value-of select="/Configuration/Farm/Purpose"/><![CDATA[_Longitude_Preview_Configuration</DatabaseName>
			<UserWithPermissions>]]><xsl:value-of select="/Configuration/Farm/NonSharePointServiceAccounts/NonSharePointServiceAccount[@CommonName = 'SharePointInstallAccount']/username"/><![CDATA[</UserWithPermissions>
			<PreviewServiceUrl>http://]]><xsl:choose>
        <xsl:when test="count(/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server']) > 0">
          <xsl:value-of select="/Configuration/Farm/Servers/Server[@role='BA Insight Preview Server'][1]/@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/Configuration/Farm/Servers/Server[@role='Web Server Group 1'][1]/@name"/>
        </xsl:otherwise>
      </xsl:choose><![CDATA[:1238/PreviewGeneratorService</PreviewServiceUrl>
		</CreateLongitudeServiceApplication>
		
	</LongitudeComponents>
</root>]]>

  </xsl:template>
</xsl:stylesheet>