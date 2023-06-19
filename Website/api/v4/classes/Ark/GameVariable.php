<?php

namespace BeaconAPI\v4\Ark;
use BeaconAPI\v4\{DatabaseObject, DatabaseObjectProperty, DatabaseSearchParameters, DatabaseSchema};
use BeaconRecordSet, JsonSerializable;

class GameVariable extends DatabaseObject implements JsonSerializable {
	protected string $key;
	protected string $value;

	public function __construct(BeaconRecordSet $row) {
		$this->key = $row->Field('key');
		$this->value = $row->Field('value');
	}
	
	public static function BuildDatabaseSchema(): DatabaseSchema {
		return new DatabaseSchema('ark', 'game_variables', [
			new DatabaseObjectProperty('key', ['primaryKey' => true]),
			new DatabaseObjectProperty('value'),
			new DatabaseObjectProperty('lastUpdate', ['columnName' => 'last_update', 'accessor' => "%%TABLE%%.%%COLUMN%% AT TIME ZONE 'UTC'"])
		]);
	}
	
	protected static function BuildSearchParameters(DatabaseSearchParameters $parameters, array $filters, bool $isNested): void {
		$schema = static::DatabaseSchema();
		$parameters->orderBy = $schema->Accessor('key');
		$parameters->allowAll = true;
		$parameters->AddFromFilter($schema, $filters, 'lastUpdate', '>');
	}

	public function jsonSerialize(): mixed {
		return [
			'key' => $this->key,
			'value' => $this->value
		];
	}
	
	public function Key(): string {
		return $this->key;
	}
	
	public function Value(): string {
		return $this->value;
	}
}

?>
