function getSemiUniqeGUIDHashForUserNames
{

    $guidhash = [guid]::NewGuid().GetHashCode()
    $guidhashstring = [string]$guidhash
    $guidhashstring = $guidhashstring.Replace("-", "n"); 
    $guidhashstring = $guidhashstring.Replace("_", "m"); 
    $guidhashstring = $guidhashstring.Replace("*", "o");  
    if ($guidhashstring.Length -gt 6)
    {
        $guidhashstring = $guidhashstring.Substring(0,5)
    }
    return $guidhashstring
}


$xmlConfigFile = "C:\Scripts\3.2.4\Service Executors\XML\ES\MergedCustomerOnBoardingTransformed_3.2.4_ES_JD.xml"

#ES or SP:
$ServiceAcronym = "ES"

#Load merged XML
[xml]$config = Get-Content $xmlConfigFile  -Encoding UTF8  
$ns = New-Object Xml.XmlNamespaceManager $config.NameTable
$ns.AddNamespace( "zim", "http://www.zimory.com/confserver/metadata/v1_0_0 metadata.xsd" )

#Get a semi unique GUID as part of username creation
$guidPartOfUserName = getSemiUniqeGUIDHashForUserNames      

#Domain Prefix
$domainPrefix = $config.metadata.customeronboardingdata.DomainShortName
$defaultPassword = "D1sabl3d281660"

#UserName format: [SP/ES]13-SVC-[GUID]-TYP
$userNamePrefix = $($domainPrefix + "\" + $ServiceAcronym + "13-SVC-" + $guidPartOfUserName + "-")



#Process Each ServiceAccountInOrder:

########################################################
#SP Install Account
$userName = $($userNamePrefix + "SPIN")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_INSTALL_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_INSTALL_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP Farm Account
$userName = $($userNamePrefix + "FARM")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_FARM_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_FARM_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP Web Account
$userName = $($userNamePrefix + "WEB")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_WEB_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_WEB_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP svc Account
$userName = $($userNamePrefix + "SVC")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_SERVICE_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_SERVICE_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP SSA Account
$userName = $($userNamePrefix + "SSA")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SSA_SP_SERVICE_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SSA_SP_SERVICE_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP Cache A Account
$userName = $($userNamePrefix + "CHCA")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_CACHEA_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_CACHEA_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP Cache R Account
$userName = $($userNamePrefix + "CHCR")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_CACHER_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_CACHER_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP Crawl Account
$userName = $($userNamePrefix + "CRWL")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_CRAWL_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_CRAWL_PASSWORD"}).innerText = $password
########################################################

########################################################
#SP TSYS Admin Account
$userName = $($userNamePrefix + "TSYS")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_TSYSA_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SP_TSYSA_PASSWORD"}).innerText = $password
########################################################

########################################################
#SQL INST Account
$userName = $($userNamePrefix + "SQIN")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SQL_INST_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SQL_INST_PASSWORD"}).innerText = $password
########################################################


########################################################
#SQL Service Account
$userName = $($userNamePrefix + "SQSV")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SQL_SERVER_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SQL_SERVER_PASSWORD"}).innerText = $password
########################################################



########################################################
#SQL Service Agent Account
$userName = $($userNamePrefix + "SQSA")
$password = $defaultPassword
#UpdateXML:
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SQL_SRVA_USERNAME"}).innerText = $userName
(($config.metadata.metadata.set | where {$_.plugin -eq $("SAO-" + $ServiceAcronym + "-Base")}).Item | where {$_.name -eq "_conf_SQL_SRVA_PASSWORD"}).innerText = $password
########################################################


$config.Save($xmlConfigFile)







