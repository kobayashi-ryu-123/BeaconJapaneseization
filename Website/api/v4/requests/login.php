<?php

use BeaconAPI\v4\{Application, ApplicationAuthFlow, Response, Core};

function handleRequest(array $context): Response {
	if (BeaconCommon::HasAllKeys($_GET, 'client_id', 'redirect_uri', 'state', 'response_type', 'scope') === false) {
		return Response::NewJsonError('Missing parameters', null, 400);
	}
	
	if ($_GET['response_type'] !== 'code') {
		return Response::NewJsonError('Response type should be code', null, 400);
	}
	
	$application = Application::Fetch($_GET['client_id']);
	if (is_null($application)) {
		return Response::NewJsonError('Invalid client id', null, 400);
	}
	
	$redirect_uri = $_GET['redirect_uri'];
	$scopes = explode(' ', $_GET['scope']);
	$state = $_GET['state'];
	
	$flow = ApplicationAuthFlow::Create($application, $scopes, $redirect_uri, $state);
	if (is_null($flow)) {
		return Response::NewJsonError('Invalid scope or redirect_uri', null, 400);
	}
	
	$loginUrl = BeaconCommon::AbsoluteUrl('/account/login?flow_id=' . urlencode($flow->FlowId()));
	return Response::NewRedirect($loginUrl);
}

?>
