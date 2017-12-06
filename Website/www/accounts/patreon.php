<?php
	
require($_SERVER['SITE_ROOT'] . '/framework/loader.php');
define('PATREON_ID', 'fe103da2582ffa3a0ceafa7b66d3f0d5b04c02216f40384a9e6552dd94d51b52');

$database = BeaconCommon::Database();

if (isset($_GET['code']) && isset($_GET['state'])) {
	// request is being returned to us
	$code = $_GET['code'];
	$session_id_from_patreon = $_GET['state'];
	$session = BeaconSession::GetFromCookie();
	if (($session === null) || ($session->SessionID() != $session_id_from_patreon)) {
		echo "Session mismatch";
		exit;
	}
	
	$user_id = $session->UserID();
	$url = 'https://www.patreon.com/api/oauth2/token';
	$redirect_uri = BeaconCommon::AbsoluteURL('/accounts/patreon.php');
	$formdata = 'code=' . urlencode($code) . '&grant_type=authorization_code&client_id=' . urlencode(PATREON_ID) . '&client_secret=' . urlencode(BeaconCommon::GetGlobal('Patreon_Secret')) . '&redirect_uri=' . urlencode($redirect_uri);
	
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $url);
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl, CURLOPT_POST, 5);
	curl_setopt($curl, CURLOPT_POSTFIELDS, $formdata);
	$raw = curl_exec($curl);
	$status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
	curl_close($curl);
	
	$patreon_auth = json_decode($raw, true);
	if (($patreon_auth === null) || ($status !== 200)) {
		echo "Patreon rejected request for authorization";
		exit;
	}
	
	$access_token = $patreon_auth['access_token'];
	$refresh_token = $patreon_auth['refresh_token'];
	$token_expiration = new DateTime('@' . (time() + $patreon_auth['expires_in']));
	
	$database->BeginTransaction();
	$database->Query("INSERT INTO patreon_tokens (access_token, refresh_token, valid_until, user_id) VALUES ($1, $2, $3, $4);", $access_token, $refresh_token, $token_expiration->format('Y-m-d H:i:sO'), $session->UserID());
	$database->Commit();
	
	BeaconCommon::Redirect(BeaconCommon::AbsoluteURL('/accounts/patreon.php'));
	
	exit;
}

$session = BeaconSession::GetFromCookie();
if ($session !== null) {
	$results = $database->Query("SELECT access_token FROM patreon_tokens WHERE user_id = $1 AND valid_until > CURRENT_TIMESTAMP ORDER BY valid_until DESC LIMIT 1;", $session->UserID());
	if ($results->RecordCount() === 1) {
		// refresh profile
		$access_token = $results->Field('access_token');
		$saved = UpdateUserProfile($session->UserID(), $access_token);
		if ($saved) {
			echo "linked";
		} else {
			echo "some kind of error";
		}
	} else {
		// starting a patreon link
		$redirect_uri = BeaconCommon::AbsoluteURL('/accounts/patreon.php');
		BeaconCommon::Redirect('https://www.patreon.com/oauth2/authorize?response_type=code&client_id=' . urlencode(PATREON_ID) . '&redirect_uri=' . urlencode($redirect_uri) . '&state=' . urlencode($session->SessionID()), true);
	}
	exit;
}

echo "no session";
//BeaconCommon::Redirect(BeaconCommon::AbsoluteURL('/'), true);

function UpdateUserProfile(string $user_id, string $access_token) {
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, 'https://www.patreon.com/api/oauth2/api/current_user');
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($curl, CURLOPT_HTTPHEADER, array('Authorization: Bearer ' . $access_token));
	$raw = curl_exec($curl);
	$status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
	curl_close($curl);
	
	if ($status !== 200) {
		return false;
	}
	
	$userdata = json_decode($raw, true);
	$patreon_user_id = $userdata['data']['id'];
	$pledges = $userdata['data']['relationships']['pledges']['data'];
	
	$database = BeaconCommon::Database();
	$database->BeginTransaction();
	$database->Query("UPDATE users SET patreon_id = $2 WHERE user_id = $1;", $user_id, $patreon_user_id);
	$database->Commit();
	
	return true;
}

?>