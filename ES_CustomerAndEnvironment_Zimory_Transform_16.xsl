
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>


  <xsl:template match="* | @*">
    <xsl:copy>
      <xsl:copy-of select = "."/>
      
      <customerandenvironmentsettings>    
<SPHive>16</SPHive>
<SSACloudIndex>False</SSACloudIndex>
<supportDevSeat>False</supportDevSeat>
<UseCentralBackupStore>True</UseCentralBackupStore>
<InstallBAIForESService>True</InstallBAIForESService> 
<doUseSmallDriveSizesForCIC>False</doUseSmallDriveSizesForCIC> <!--Should be True for CIC -->
<doUse100GBFixedDriveSizes>True</doUse100GBFixedDriveSizes> <!--Should be False for CIC -->
<isEMPDeployment>False</isEMPDeployment> 
<isWin2012>True</isWin2012>
        <windows2012Version>R1</windows2012Version>
        <isSP2013SP1>True</isSP2013SP1>
        <overrideSPSizingIndexItemCount></overrideSPSizingIndexItemCount> 
<createAllClusterElements>True</createAllClusterElements> 
	<useLocalAdministratorForStartupScripts>False</useLocalAdministratorForStartupScripts>
<localAdminPassword>D1sabl3d281660</localAdminPassword><!--Might be different for CIC -->
  	<useSmallDBPreSizingForDevInstalls>True</useSmallDBPreSizingForDevInstalls>
        <importservers>True</importservers>
	<preinstallspbinariesforhainbaseprovisioning>False</preinstallspbinariesforhainbaseprovisioning>
	<devseatisdc>True</devseatisdc>


<dev_vmrun_server_ip>10.0.1.65</dev_vmrun_server_ip>
           
          <deploymentserver>deploy2012</deploymentserver><!--Should be different for CIC -->
        <deploymentserverusername>Administrator</deploymentserverusername><!--Should be different for CIC -->
        <deploymentserverpassword>Start123</deploymentserverpassword><!--Should be different for CIC -->
	      <mediaserver>deploy2012</mediaserver><!--Should be different for CIC -->
        <mediaserverusername>Administrator</mediaserverusername><!--Should be different for CIC -->
        <mediaserverpassword>Start123</mediaserverpassword><!--Should be different for CIC -->

        <!-- [TB] 3.1.5 - support copying all media locally on each server -->
        <localmediapath>e:\data\media</localmediapath>


        <spscriptlocation>\\deploy2012\MediaShare\SP Scripts v3</spscriptlocation> <!--Should be different for CIC -->
        <sqlscriptlocation>\\deploy2012\MediaShare\SP Scripts v3</sqlscriptlocation><!--Should be different for CIC -->
       <htmlupdatefile>C:\inetpub\wwwroot\Status\update.html</htmlupdatefile>

        <htmladminpage>C:\inetpub\wwwroot\Zimory\adminpage.html</htmladminpage>
        <frontadminpage>C:\inetpub\wwwroot\Zimory\frontpage.html</frontadminpage>
        <htmlstatuspage>C:\inetpub\wwwroot\Zimory\index.html</htmlstatuspage>
	      <zimorysettings>
          <baseurl></baseurl>
          <certificatepath></certificatepath>
          <certificatepassword></certificatepassword>
          <hostentry></hostentry>
		    </zimorysettings>   



		<azuremobileservice>
			<proxy></proxy>
    		<jsonurl>https://ostech.azure-mobile.net/</jsonurl>
		<applicationkey>VioUAfsZEjYVDzPNlaluUPnKaesKEb13</applicationkey>
		<registrationstable>Log_Registration</registrationstable>
		<sessiontable>Log_Session</sessiontable>
		<sessiondetailtable>Log_Data</sessiondetailtable>
		<sessiondetailservertable>Log_Server_Data</sessiondetailservertable>
<customertable>Log_Customer</customertable>        
<customerid>2</customerid>        
	</azuremobileservice>

<clustersettings>
	<useDynamic>False</useDynamic>
  <precreated_es>	
    <clusterips>SQLGEN_01_G1^CLUSA;10.0.1.100/255.255.255.0|</clusterips>
    <listenerips>SQLGEN_01_G1^LISTA;10.0.1.110/255.255.255.0|</listenerips>    
	<makeADandDNSChanges>True</makeADandDNSChanges> <!--Only use this for DEV or vCloud PlayGround, never with a customer -->
  </precreated_es>
  <precreated_sp>
    <clusterips>SQLCON_01_C1^CLUSA;10.0.1.100/255.255.255.0|SQLOTH_01_C1^CLUSA;10.0.1.100/255.255.255.0|SQLSCH_01_C1^CLUSA;10.0.1.100/255.255.255.0|</clusterips>
    <listenerips>SQLCON_01_C1^LIST_CON;10.0.1.110/255.255.255.0|SQLOTH_01_C1^LIST_OTH;10.0.1.111/255.255.255.0|SQLSCH_01_C1^LISTA;10.0.1.112/255.255.255.0|</listenerips>    
	<makeADandDNSChanges>True</makeADandDNSChanges><!--Only use this for DEV or vCloud PlayGround, never with a customer -->
  </precreated_sp>

  <dynamic>
	    <starting_clusterip>10.0.1.100/255.255.255.0</starting_clusterip>
	    <starting_listenerip>10.0.1.110/255.255.255.0</starting_listenerip>
		<createDNSObjects>False</createDNSObjects>
	
  </dynamic>	
</clustersettings>

      </customerandenvironmentsettings>
    </xsl:copy>


    

  </xsl:template>



</xsl:stylesheet>
