<?php

namespace BeaconAPI\v4\ArkSA;
use BeaconAPI\v4\{Core, DatabaseObject, DatabaseObjectProperty, DatabaseSchema, DatabaseSearchParameters};
use BeaconCommon, BeaconRecordSet, DateTime, JsonSerializable;

class Color extends DatabaseObject implements JsonSerializable {
	protected int $colorId;
	protected string $label;
	protected string $code;
	protected int $lastUpdate;
	
	protected function __construct(BeaconRecordSet $row) {
		$this->colorId = intval($row->Field('color_id'));
		$this->label = $row->Field('color_name');
		$this->code = $row->Field('color_code');
		$this->lastUpdate = round($row->Field('last_update'));
	}
	
	public static function BuildDatabaseSchema(): DatabaseSchema {
		return new DatabaseSchema('arksa', 'colors', [
			New DatabaseObjectProperty('colorId', ['primaryKey' => true, 'columnName' => 'color_id']),
			New DatabaseObjectProperty('label', ['columnName' => 'color_name']),
			New DatabaseObjectProperty('code', ['columnName' => 'color_code']),
			New DatabaseObjectProperty('lastUpdate', ['columnName' => 'last_update', 'accessor' => 'EXTRACT(EPOCH FROM %%TABLE%%.%%COLUMN%%)', 'setter' => 'TO_TIMESTAMP(%%PLACEHOLDER%%)'])
		]);
	}
	
	protected static function BuildSearchParameters(DatabaseSearchParameters $parameters, array $filters, bool $isNested): void {
		$parameters->allowAll = true;
		
		$schema = static::DatabaseSchema();
		$parameters->AddFromFilter($schema, $filters, 'code');
		$parameters->AddFromFilter($schema, $filters, 'lastUpdate', '>');
	}
	
	public function jsonSerialize(): mixed {
		return [
			'colorId' => $this->colorId,
			'label' => $this->label,
			'code' => $this->code,
			'lastUpdate' => $this->lastUpdate
		];
	}
	
	public function ColorId(): int {
		return $this->colorId;
	}
	
	public function Label(): string {
		return $this->label;
	}
	
	public function Hex(): string {
		return $this->code;
	}
}

?>
