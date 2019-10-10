<?php 
include_once dirname(__File__) . '/system/autoload.php';
	
$bAdminPrivileges = true;

\Aurora\System\Api::Init($bAdminPrivileges);

$aOptions = getopt("p:");
if (!is_array($aOptions) || !isset($aOptions['p']))
{
	die("Password not specified\r\n");
}

$DbHost = 'localhost:/opt/afterlogic/tmp/mysql.sock';
$DbLogin = 'root';
$DbPassword = $aOptions['p'];
$DbName = 'afterlogic';

$oCoreDecorator = \Aurora\System\Api::GetModuleDecorator('Core');

if ($oCoreDecorator)
{
	$mResult = $oCoreDecorator->UpdateSettings($DbLogin, $DbPassword, $DbName, $DbHost);
	if (!$mResult)
	{
		die("Error on settings updating\r\n");
	}
	else
	{
		$mResult = $oCoreDecorator->CreateTables();
		if (!$mResult)
		{
			die("Error on tables creating\r\n");
		}
	}
}