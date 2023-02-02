<?php

use BeaconAPI\v4\{APIResponse, Application, Core};

Core::Authorize('apps:write');

function handleRequest(array $context): APIResponse {
	$applicationId = $context['pathParameters']['applicationId'];
	$app = Application::Fetch($applicationId);
	if (is_null($app) || $app->UserId() !== Core::UserId()) {
		return APIResponse::NewJSONError('Application not found', null, 404);
	}
	
	try {
		$app->Delete();
		return APIResponse::NewNoContent();
	} catch (Exception $err) {
		return APIResponse::NewJSONError('Internal server error', null, 500);
	}
}

?>
