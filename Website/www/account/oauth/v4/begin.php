<?php

require(dirname(__FILE__, 5) . '/framework/loader.php');
header('Cache-Control: no-cache');

use BeaconAPI\v4\OAuth;

if (isset($_GET['provider']) === false) {
	http_response_code(400);
	echo '<h1>Error</h1>';
	echo '<p>Missing provider parameter</p>';
	exit;
}

$provider = OAuth::CleanupProvider($_GET['provider']);

$session = BeaconCommon::GetSession();
if (is_null($session)) {
	BeaconCommon::Redirect('/account/login/?return=' . urlencode($_SERVER['REQUEST_URI']));
}

$state = BeaconCommon::GenerateUUID();
$url = OAuth::Begin($provider, $state);
setcookie('beacon_oauth_state', $state, [
	'path' => '/account',
	'domain' => BeaconCommon::Domain(),
	'secure' => true,
	'httponly' => true,
	'samesite' => 'Lax'
]);

$url = OAuth::Begin($provider, $state);
BeaconCommon::Redirect($url);

?>
