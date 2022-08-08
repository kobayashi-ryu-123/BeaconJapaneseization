<?php

namespace Ark;

class Creature extends \BeaconAPI\Ark\Creature {
	public function jsonSerialize(): mixed {
		$json = parent::jsonSerialize();
		$json['resource_url'] = \BeaconAPI::URL('creature/' . urlencode($this->ObjectID()));
		return $json;
	}
}

?>
