<?php

namespace BeaconAPI\v4;
use BeaconCloudStorage, BeaconCommon, BeaconRecordSet, BeaconSearch, DateTime, Exception;

abstract class Project extends DatabaseObject implements \JsonSerializable {
	public const kPublishStatusPrivate = 'Private';
	public const kPublishStatusRequested = 'Requested';
	public const kPublishStatusApproved = 'Approved';
	public const kPublishStatusApprovedPrivate = 'Approved But Private';
	public const kPublishStatusDenied = 'Denied';
	
	protected $project_id = '';
	protected $game_id = '';
	protected $game_specific = [];
	protected $user_id = '';
	protected $owner_id = '';
	protected $title = '';
	protected $description = '';
	protected $console_safe = true;
	protected $last_update = null;
	protected $revision = 1;
	protected $download_count = 0;
	protected $published = self::kPublishStatusPrivate;
	protected $content = [];
	protected $storage_path = null;
	
	protected function __construct(BeaconRecordSet $row) {
		$this->project_id = $row->Field('project_id');
		$this->game_id = $row->Field('game_id');
		$this->title = $row->Field('title');
		$this->description = $row->Field('description');
		$this->revision = intval($row->Field('revision'));
		$this->download_count = intval($row->Field('download_count'));
		$this->last_update = new DateTime($row->Field('last_update'));
		$this->user_id = $row->Field('user_id');
		$this->owner_id = $row->Field('owner_id');
		$this->published = $row->Field('published');
		$this->console_safe = boolval($row->Field('console_safe'));
		$this->game_specific = json_decode($row->Field('game_specific'), true);
		$this->storage_path = $row->Field('storage_path');
	}
	
	public static function BuildDatabaseSchema(): DatabaseSchema {
		$schema = new DatabaseSchema('public', 'allowed_projects', [
			new DatabaseObjectProperty('project_id', ['primaryKey' => true]),
			new DatabaseObjectProperty('game_id'),
			new DatabaseObjectProperty('game_specific'),
			new DatabaseObjectProperty('user_id'),
			new DatabaseObjectProperty('owner_id'),
			new DatabaseObjectProperty('title'),
			new DatabaseObjectProperty('description'),
			new DatabaseObjectProperty('console_safe'),
			new DatabaseObjectProperty('last_update'),
			new DatabaseObjectProperty('revision'),
			new DatabaseObjectProperty('download_count'),
			new DatabaseObjectProperty('published'),
			new DatabaseObjectProperty('storage_path')
		]);
		$schema->SetWriteableTable('projects');
		return $schema;
	}
	
	protected static function NewInstance(BeaconRecordSet $rows): Project {
		$game_id = $rows->Field('game_id');
		switch ($game_id) {
		case 'Ark':
			return new Ark\Project($rows);
			break;
		default:
			throw new Exception('Unknown game ' . $game_id);
		}
	}
	
	public static function Fetch(string $uuid): ?DatabaseObject {
		$schema = static::DatabaseSchema();
		$user_id = Core::UserId();
		$database = BeaconCommon::Database();
			
		$sql = 'SELECT ' . $schema->SelectColumns() . ' FROM ' . $schema->FromClause() . ' WHERE ' . $schema->PrimaryAccessor() . ' = ' . $schema->PrimarySetter('$1');
		$values = [$uuid];
		if (is_null($user_id) === false) {
			$sql .= ' AND ' . $schema->Accessor('user_id') . ' = ' . $schema->Setter('user_id', '$2') . ';';
			$values[] = $user_id;
		} else {
			$sql .= ' AND ' . $schema->Accessor('user_id') . ' = ' . $schema->Accessor('owner_id') . ';';
		}
		
		$rows = $database->Query($sql, $values);
		if (is_null($rows) || $rows->RecordCount() !== 1) {
			return null;
		}
		return static::NewInstance($rows);
	}
	
	protected static function BuildSearchParameters(DatabaseSearchParameters $parameters, array $filters): void {
		$schema = static::DatabaseSchema();
		$table = static::DatabaseSchema()->Table();
		
		$sort_column = 'last_update';
		$sort_direction = 'DESC';
		if (isset($filters['sort'])) {
			switch ($filters['sort']) {
			case 'download_count':
				$sort_column = 'download_count';
				break;
			case 'name':
				$sort_column = 'title';
				break;
			case 'console_safe':
				$sort_column = 'console_safe';
				break;
			case 'description':
				$sort_column = 'description';
				break;
			}
		}
		if (isset($filters['direction'])) {
			$sort_direction = (strtolower($filters['direction']) === 'desc' ? 'DESC' : 'ASC');
		}
		$parameters->orderBy = "{$table}.{$sort_column} {$sort_direction}";
		
		if (isset($filters['user_id']) && empty($filters['user_id']) === false) {
			$parameters->AddFromFilter($schema, $filters, 'user_id');
		} else {
			$user_id = Core::UserId();
			if (is_null($user_id) === false) {
				$parameters->clauses[] = $table . '.user_id = $' . $parameters->placeholder++;
				$parameters->values[] = $user_id;
			} else {
				$parameters->clauses[] = $table . '.user_id = owner_id';
			}
		}
		
		$parameters->AddFromFilter($schema, $filters, 'published');
		$parameters->AddFromFilter($schema, $filters, 'console_safe');
		
		if (isset($filters['search']) && empty($filters['search']) === false) {
			$search = new BeaconSearch();
			$results = $search->Search($filters['search'], null, 100, 'Document');
			if (count($results) > 0) {
				$ids = [];
				foreach ($results as $result) {
					$ids[] = $result['objectID'];
				}
				$parameters->clauses[] = $table . '.project_id = ANY($' . $parameters->placeholder++ . ')';
				$parameters->values[] = '{' . implode(',', $ids) . '}';
			} else {
				$parameters->clauses[] = "{$table}.project_id = '00000000-0000-0000-0000-000000000000'";
			}
		}
	}
	
	public function jsonSerialize(): mixed {
		return [
			'project_id' => $this->project_id,
			'game_id' => $this->game_id,
			'user_id' => $this->user_id,
			'owner_id' => $this->owner_id,
			'name' => $this->title,
			'description' => $this->description,
			'revision' => $this->revision,
			'download_count' => $this->download_count,
			'last_updated' => $this->last_update->format('Y-m-d H:i:sO'),
			'console_safe' => $this->console_safe,
			'published' => $this->published,
			'resource_url' => $this->ResourceURL()
		];
	}
		
	public function ProjectId(): string {
		return $this->project_id;
	}
	
	public function GameId(): string {
		return $this->game_id;
	}
	
	public function GameURLComponent(): string {
		switch ($this->game_id) {
		case 'Ark':
			return 'ark';
		}
	}
	
	public function UserId(): string {
		return $this->user_id;
	}
	
	public function OwnerId(): string {
		return $this->owner_id;
	}
	
	public function Title(): string {
		return $this->title;
	}
	
	public function Description(): string {
		return $this->description;
	}
	
	public function ConsoleSafe(): bool {
		return $this->console_safe;
	}
	
	public function LastUpdated(): DateTime {
		return $this->last_update;
	}
	
	public function Revision(): int {
		return $this->revision;
	}
	
	public function DownloadCount(): int {
		return $this->download_count;
	}
	
	public function IncrementDownloadCount(bool $autosave = true): void {
		$this->SetProperty('download_count', $this->download_count + 1);
		if ($autosave) {
			$this->Save();
		}
	}
	
	public function IsPublic(): bool {
		return $this->published == self::kPublishStatusApproved;
	}
	
	public function PublishStatus(): string {
		return $this->published;
	}
	
	public function SetPublishStatus(string $desired_status): void {
		$database = BeaconCommon::Database();
		$schema = static::DatabaseSchema();
		
		$results = $database->Query('SELECT published FROM ' . $schema->Table() . ' WHERE project_id = $1;', $this->project_id);
		$current_status = $results->Field('published');
		$new_status = $current_status;
		if ($desired_status == self::kPublishStatusRequested || $desired_status == self::kPublishStatusApproved) {
			if ($current_status == self::kPublishStatusApprovedPrivate) {
				$new_status = self::kPublishStatusApproved;
			} elseif ($current_status == self::kPublishStatusPrivate) {
				if (empty(trim($this->description))) {
					$new_status = self::kPublishStatusDenied;
				} else {
					$new_status = self::kPublishStatusRequested;
					$attachment = array(
						'title' => $this->title,
						'text' => $this->description,
						'fallback' => 'Unable to show response buttons.',
						'callback_id' => 'publish_document:' . $this->project_id,
						'actions' => [
							[
								'name' => 'status',
								'text' => 'Approve',
								'type' => 'button',
								'value' => self::kPublishStatusApproved,
								'confirm' => [
									'text' => 'Are you sure you want to approve this project?',
									'ok_text' => 'Approve'
								]
							],
							[
								'name' => 'status',
								'text' => 'Deny',
								'type' => 'button',
								'value' => self::kPublishStatusDenied,
								'confirm' => [
									'text' => 'Are you sure you want to reject this project?',
									'ok_text' => 'Deny'
								]
							]
						],
						'fields' => array()
					);
					
					$user = User::Fetch($this->user_id);
					if (is_null($user) === false) {
						if ($user->IsAnonymous()) {
							$username = 'Anonymous';
						} else {
							$username = $user->Username() . '#' . $user->Suffix();
						}
						$attachment['fields'][] = [
							'title' => 'Author',
							'value' => $username
						];
					}
					
					$obj = [
						'text' => 'Request to publish project',
						'attachments' => array($attachment)
					];
					BeaconCommon::PostSlackRaw(json_encode($obj));
				}
			}
		} else {
			if ($current_status == self::kPublishStatusApproved) {
				$new_status = self::kPublishStatusApprovedPrivate;
			} elseif ($current_status == self::kPublishStatusRequested) {
				$new_status = self::kPublishStatusPrivate;
			}
		}
		if ($new_status != $current_status) {
			$database->BeginTransaction();
			$database->Query('UPDATE ' . $schema->WriteableTable() . ' SET published = $2 WHERE project_id = $1;', $this->project_id, $new_status);
			$database->Commit();
		}
		$this->published = $new_status;
	}
	
	public function PreloadContent($version_id = null): string {
		$content_key = (is_null($version_id) === true ? '' : $version_id);
		if (array_key_exists($content_key, $this->content) === true) {
			return $content_key;
		}
		
		$this->content[$content_key] = BeaconCloudStorage::GetFile($this->CloudStoragePath(), true, $version_id);
		return $content_key;
	}	
	
	public function Content(bool $compressed = false, bool $parsed = true, $version_id = null): string {
		try {
			$content_key = $this->PreloadContent($version_id);
		} catch (Exception $err) {
			return '';
		}
		
		$content = $this->content[$content_key];
		$compressed = $compressed && ($parsed == false);
		$is_compressed = BeaconCommon::IsCompressed($content);
		if ($is_compressed == true && $compressed == false) {
			$content = gzdecode($content);
		} elseif ($is_compressed == false && $compressed == true) {
			return gzencode($content);
		}
		if ($parsed) {
			return json_decode($content, true);
		} else {
			return $content;
		}
	}
	
	public function ResourceURL(): string {
		return Core::URL('projects/' . urlencode($this->project_id) . '?name=' . urlencode($this->title));
	}
	
	public function CloudStoragePath(): string {
		if (is_null($this->storage_path)) {
			$this->storage_path = '/Projects/' . strtolower($project_id) . '.beacon';
		}
		return $this->storage_path;
	}
	
	public static function SaveFromMultipart(User $user, string &$reason): bool {
		$required_vars = ['keys', 'title', 'uuid', 'version'];
		if (static::ValidateMultipart($required_vars, $reason) === false) {
			return false;
		}
		$missing_vars = [];
		foreach ($required_vars as $var) {
			if (isset($_POST[$var]) === false || empty($_POST[$var]) === true) {
				$missing_vars[] = $var;
			}
		}
		if (isset($_POST['description']) === false) {
			// description is allowed to be empty
			$missing_vars[] = 'description';
		}
		if (isset($_FILES['contents']) === false) {
			$missing_vars[] = 'contents';
			sort($missing_vars);
		}
		if (count($missing_vars) > 0) {
			$reason = 'The following parameters are missing: `' . implode('`, `', $missing_vars) . '`';
			return false;
		}
		
		$upload_status = $_FILES['contents']['error'];
		switch ($upload_status) {
		case UPLOAD_ERR_OK:
			break;
		case UPLOAD_ERR_NO_FILE:
			$reason = 'No file included.';
			break;
		case UPLOAD_ERR_INI_SIZE:
		case UPLOAD_ERR_FORM_SIZE:
			$reason = 'Exceeds maximum file size.';
			break;
		default:
			$reason = 'Other error ' . $upload_status . '.';
			break;
		}
		
		if (BeaconCommon::IsCompressed($_FILES['contents']['tmp_name'], true) === false) {
			$source = $_FILES['contents']['tmp_name'];
			$destination = $source . '.gz';
			if ($read_handle = fopen($source, 'rb')) {
				if ($write_handle = gzopen($destination, 'wb9')) {
					while (!feof($read_handle)) {
						gzwrite($write_handle, fread($read_handle, 524288));
					}
					gzclose($write_handle);
				} else {
					fclose($read_handle);
					$reason = 'Could not create compressed file.';
					return false;
				}
				fclose($read_handle);
			} else {
				$reason = 'Could not read uncompressed file.';
				return false;
			}
			unlink($source);
			rename($destination, $source);
		}
		
		$project = [
			'Version' => intval($_POST['version']),
			'Identifier' => $_POST['uuid'],
			'Title' => $_POST['title'],
			'Description' => $_POST['description']
		];
		$keys_members = explode(',', $_POST['keys']);
		$keys = [];
		foreach ($keys_members as $member) {
			$pos = strpos($member, ':');
			if ($pos === false) {
				$reason = 'Parameter `keys` expects a comma-separated list of key:value pairs.';
				return false;
			}
			$key = substr($member, 0, $pos);
			if (BeaconCommon::IsUUID($key) === false) {
				$reason = 'Key `' . $key . '` is not a v4 UUID.';
				return false;
			}
			$value = substr($member, $pos + 1);
			$keys[$key] = $value;
		}
		$project['EncryptionKeys'] = $keys;
		
		if (static::MultipartAddProjectValues($project, $reason) === false) {
			return false;
		}
		
		return self::SaveFromArray($project, $user, $_FILES['contents'], $reason);
	}
	
	protected static function ValidateMultipart(array &$required_vars, string &$reason): bool {
		return true;
	}
	
	protected static function MultipartAddProjectValues(array &$project, string &$reason): bool {
		return true;
	}
	
	protected static function AddColumnValues(array $project, array &$row_values): bool {
		return true;
	}
	
	protected static function SaveFromArray(array $project, User $user, $contents, string &$reason): bool {
		$project_version = filter_var($project['Version'], FILTER_VALIDATE_INT);
		if ($project_version === false || $project_version < 2) {
			$reason = 'Version 1 projects are no longer not accepted.';
			return false;
		}
		
		$schema = static::DatabaseSchema();
		
		$database = BeaconCommon::Database();
		$project_id = $project['Identifier'];
		if (BeaconCommon::IsUUID($project_id) === false) {
			$reason = 'Project identifier is not a v4 UUID.';
			return false;
		}
		$title = isset($project['Title']) ? $project['Title'] : '';
		$description = isset($project['Description']) ? $project['Description'] : '';
		$game_id = isset($project['GameID']) ? $project['GameID'] : 'Ark';
		
		// check if the project already exists
		$results = $database->Query('SELECT project_id, storage_path FROM ' . $schema->Table() . ' WHERE project_id = $1;', $project_id);
		$new_project = $results->RecordCount() == 0;
		$storage_path = null;
		
		// confirm write permission of the project
		if ($new_project == false) {
			$storage_path = $results->Field('storage_path');
			
			$results = $database->Query('SELECT role, owner_id FROM ' . $schema->Table() . ' WHERE project_id = $1 AND user_id = $2;', $project_id, $user->UserId());
			if ($results->RecordCount() == 0) {
				$reason = 'Access denied for project ' . $project_id . '.';
				return false;
			}
			$role = $results->Field('role');
			$owner_id = $results->Field('owner_id');
		} else {
			$storage_path = static::CloudStoragePath($project_id);
			$role = 'Owner';
			$owner_id = $user->UserId();
		}
		
		$guest_ids_to_add = [];
		$guest_ids_to_remove = [];
		if (isset($project['EncryptionKeys']) && is_array($project['EncryptionKeys']) && BeaconCommon::IsAssoc($project['EncryptionKeys'])) {
			$encryption_keys = $project['EncryptionKeys'];
			$allowed_users_ids = array_keys($encryption_keys);
			
			$desired_guest_ids = [];
			foreach ($allowed_user_ids as $allowed_user_id) {
				if (strtolower($allowed_user_id) === strtolower($owner_id)) {
					continue;
				}
				
				$allowed_user = User::Fetch($allowed_user_id);
				if (is_null($allowed_user)) {
					continue;
				}
				
				$desired_guest_ids[] = $allowed_user->UserId();
			}
			
			$current_guest_ids = [];
			$results = $database->Query('SELECT user_id FROM ' . $schema->Schema() . '.guest_projects WHERE project_id = $1;', $project_id);
			while (!$results->EOF()) {
				$current_guest_ids[] = $results->Field('user_id');
				$results->MoveNext();
			}
			
			$guest_ids_to_add = array_diff($desired_guest_ids, $current_guest_ids);
			$guest_ids_to_remove = array_diff($current_guest_ids, $desired_guest_ids);
			
			if ($role !== 'Owner' && (count($guest_ids_to_add) > 0 || count($guest_ids_to_remove) > 0)) {
				$reason = 'Only the owner may add or remove users.';
				return false;
			}
		}
		
		if (BeaconCloudStorage::PutFile($storage_path, $contents) === false) {
			$reason = 'Unable to upload project to cloud storage platform.';
			return false;
		}
		
		try {
			$row_values = [
				'title' => $title,
				'description' => $description,
				'console_safe' => true,
				'game_specific' => '{}',
				'game_id' => $game_id
			];
			static::AddColumnValues($project, $row_values);
			
			$placeholder = 3;
			$values = [$project_id, $owner_id];
			
			$database->BeginTransaction();
			if ($new_project) {
				$columns = ['project_id', 'user_id', 'last_update', 'storage_path'];
				$values[] = $storage_path;
				$placeholders = ['$1', '$2', 'CURRENT_TIMESTAMP', '$3'];
				$placeholder++;
				foreach ($row_values as $column => $value) {
					$columns[] = $database->EscapeIdentifier($column);
					$values[] = $value;
					$placeholders[] = '$' . strval($placeholder);
					$placeholder++;
				}
				
				$database->Query('INSERT INTO ' . $schema->Table() . ' (' . implode(', ', $columns) . ') VALUES (' . implode(', ', $placeholders) . ');', $values);
			} else {
				$assignments = ['revision = revision + 1', 'last_update = CURRENT_TIMESTAMP', 'deleted = FALSE'];
				foreach ($row_values as $column => $value) {
					$assignments[] = $database->EscapeIdentifier($column) . ' = $' . strval($placeholder);
					$values[] = $value;
					$placeholder++;
				}
				
				$database->Query('UPDATE ' . $schema->Table() . ' SET ' . implode(', ', $assignments) . ' WHERE project_id = $1 AND user_id = $2;', $values);
			}
			foreach ($guest_ids_to_add as $guest_id) {
				$database->Query('INSERT INTO ' . $schema->Schema() . '.guest_projects (project_id, user_id) VALUES ($1, $2);', $project_id, $guest_id);
			}
			foreach ($guest_ids_to_remove as $guest_id) {
				$database->Query('DELETE FROM ' . $schema->Schema() . '.guest_projects WHERE project_id = $1 AND user_id = $2;', $project_id, $guest_id);
			}
			$database->Commit();
		} catch (Exception $err) {
			$reason = 'Database error: ' . $err->getMessage();
			return false;
		}
		
		return true;
	}
	
	public function Versions(): array {
		$versions = BeaconCloudStorage::VersionsForFile($this->storage_path);
		if ($versions === false) {
			return [];
		}
		$api_path = $this->ResourceURL();
		$api_query = '';
		$pos = strpos($api_path, '?');
		if ($pos !== false) {
			$api_query = substr($api_path, $pos + 1);
			$api_path = substr($api_path, 0, $pos);
		}
		if ($api_query !== '') {
			$api_query = '?' . $api_query;
		}
		for ($idx = 0; $idx < count($versions); $idx++) {
			$url = $this->ResourceURL();
			$versions[$idx]['resource_url'] = $api_path . '/versions/' . urlencode($versions[$idx]['version_id']) . $api_query;
		}
		return $versions;
	}
	
	public function Delete(): void {
		$database = BeaconCommon::Database();
		if ($this->user_id === $this->owner_id) {
			// Project owner. If there are other users, pick one to transfer ownership to.
			$rows = $database->Query('SELECT user_id FROM public.guest_projects WHERE project_id = $1;', $this->project_id);
			if ($rows->RecordCount() > 0) {
				$new_owner_id = $rows->Field('user_id');
				$database->BeginTransaction();
				$database->Query('UPDATE public.projects SET user_id = $2 WHERE project_id = $1;', $this->project_id, $new_owner_id);
				$database->Query('DELETE FROM public.guest_projects WHERE project_id = $1 AND user_id = $2;', $this->project_id, $new_owner_id);
				$database->Commit();
			} else {
				$database->BeginTransaction();
				$database->Query('UPDATE public.projects SET deleted = TRUE WHERE project_id = $1;', $this->project_id);
				$database->Commit();	
			}
		} else {
			// Project guest. Remove the user.
			$database->BeginTransaction();
			$database->Query('DELETE FROM public.guest_projects WHERE project_id = $1 AND user_id = $2;', $this->project_id, $this->user_id);
			$database->Commit();
		}
	}
}
	
?>
