<?php

namespace BeaconAPI\v4\Ark;
use BeaconAPI\v4\{Core};
use BeaconCommon;

class Project extends \BeaconAPI\v4\Project {
	public function jsonSerialize(): mixed {
		$json = parent::jsonSerialize();
		$json['map_mask'] = $this->MapMask();
		$json['difficulty'] = $this->DifficultyValue();
		return $json;
	}
	
	public function MapMask(): int {
		return array_key_exists('map', $this->game_specific) ? intval($this->game_specific['map']) : 0;
	}
	
	public function DifficultyValue(): float {
		return array_key_exists('difficulty', $this->game_specific) ? floatval($this->game_specific['difficulty']) : 0;
		return $this->difficulty_value;
	}
	
	public function RequiredMods(bool $as_array): array|string {
		if (array_key_exists('mods', $this->game_specific)) {
			$mods = $this->game_specific['mods'];
			if ($as_array) {
				return $mods;
			} else {
				return implode(',', $mods);
			}
		} else {
			if ($as_array) {
				return [];
			} else {
				return '';
			}
		}
	}
	
	public function ImplementedConfigs(bool $as_array): array|string {
		if (array_key_exists('included_editors', $this->game_specific)) {
			$editors = $this->game_specific['included_editors'];
			if ($as_array) {
				return $editors;
			} else {
				return implode(',', $editors);
			}
		} else {
			if ($as_array) {
				return [];
			} else {
				return '';
			}
		}
	}
	
	public function ResourceURL(): string {
		return Core::URL('projects/' . urlencode($this->project_id) . '?name=' . urlencode($this->title));
	}
	
	protected static function ValidateMultipart(array &$required_vars, string &$reason): bool {
		if (parent::ValidateMultipart($required_vars, $reason) === false) {
			return false;
		}
		
		$required_vars[] = 'game_id';
		$required_vars[] = 'difficulty';
		$required_vars[] = 'editors';
		$required_vars[] = 'map';
		$required_vars[] = 'mods';
		
		return true;
	}
	
	protected static function MultipartAddProjectValues(array &$project, string &$reason): bool {
		if (parent::MultipartAddProjectValues($project, $reason) === false) {
			return false;
		}
		
		$project['GameID'] = $_POST['game_id'];
		
		$project['Map'] = intval($_POST['map']);
		$project['DifficultyValue'] = floatval($_POST['difficulty']);
		$project['EditorNames'] = array_unique(explode(',', $_POST['editors']));
		sort($project['EditorNames']);
		
		$mods_members = explode(',', $_POST['mods']);
		$mods = [];
		foreach ($mods_members as $mod_id) {
			if (BeaconCommon::IsUUID($mod_id) === false) {
				$reason = 'Mod UUID `' . $mod_id . '` is not a v4 UUID.';
				return false;
			}
			$mods[$mod_id] = true;
		}
		$project['ModSelections'] = $mods;
		
		return true;
	}
	
	protected static function AddColumnValues(array $project, array &$row_values): bool {
		if (parent::AddColumnValues($project, $row_values) === false) {
			return false;
		}
		
		$database = BeaconCommon::Database();
		
		$mod_ids = [];
		if (isset($project['ModSelections'])) {
			$console_safe = true;
			foreach ($project['ModSelections'] as $mod_id => $mod_enabled) {
				if ($mod_enabled) {
					$rows = $database->Query('SELECT mod_id, console_safe FROM ark.mods WHERE confirmed = TRUE AND mod_id = $1;', $mod_id);
					if ($rows->RecordCount() === 1) {
						$mod_ids[] = $mod_id;
						$console_safe = $console_safe && $rows->Field('console_safe');
					}
				}
			}
		} elseif (isset($project['ConsoleModsOnly'])) {
			$console_mods_only = $project['ConsoleModsOnly'];
			$rows = $database->Query('SELECT mod_id FROM ark.mods WHERE confirmed = TRUE AND console_safe = TRUE AND default_enabled = TRUE;');
			while (!$rows->EOF()) {
				$mod_ids[] = $rows->Field('mod_id');
				$rows->MoveNext();
			}
		} else {
			$console_safe = false;
		}
		
		$editor_names = [];
		foreach ($project['EditorNames'] as $editor_name) {
			if ($editor_name === 'Difficulty' || $editor_name === 'Metadata') {
				continue;
			}
			
			$editor_names[] = $editor_name;
		}
		$project['EditorNames'] = $editor_names;
		
		$row_values['game_specific'] = json_encode([
			'map' => isset($project['Map']) ? $project['Map'] : 4,
			'difficulty' => isset($project['DifficultyValue']) ? $project['DifficultyValue'] : 4,
			'mods' => $mod_ids,
			'included_editors' => $project['EditorNames']
		]);
		$row_values['console_safe'] = $console_safe;
		
		return true;
	}
}

?>
