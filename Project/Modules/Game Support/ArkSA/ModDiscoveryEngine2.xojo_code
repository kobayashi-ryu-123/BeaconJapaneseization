#tag Class
Protected Class ModDiscoveryEngine2
	#tag Method, Flags = &h21
		Private Sub AddBlueprint(Blueprint As ArkSA.Blueprint)
		  Var ContentPackId As String = Blueprint.ContentPackId
		  Var Siblings() As ArkSA.Blueprint
		  If Self.mFoundBlueprints.HasKey(ContentPackId) Then
		    Siblings = Self.mFoundBlueprints.Value(ContentPackId)
		  Else
		    Self.mFoundBlueprints.Value(ContentPackId) = Siblings
		  End If
		  Siblings.Add(Blueprint.ImmutableVersion)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddTagsToPath(Path As String, ParamArray AdditionalTags() As String)
		  Self.AddTagsToPath(Path, AdditionalTags)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddTagsToPath(Path As String, AdditionalTags() As String)
		  Var Tags() As String
		  If Self.mTags.HasKey(Path) Then
		    Tags = Self.mTags.Value(Path)
		  Else
		    Self.mTags.Value(Path) = Tags
		  End If
		  
		  For Each Tag As String In AdditionalTags
		    If Tags.IndexOf(Tag) = -1 Then
		      Tags.Add(Tag)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddTagToPath(Path As String, Tag As String)
		  Self.AddTagsToPath(Path, Tag)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cancel()
		  Self.mCancelled = True
		  Self.StatusMessage = "Cancelling…"
		  
		  If (Self.mThread Is Nil) = False And Self.mThread.ThreadState = Thread.ThreadStates.Paused Then
		    Self.mThread.Resume
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ComputeBreedingStats(Properties As JSONMBS, Creature As ArkSA.MutableCreature) As Boolean
		  Try
		    Var IncubationTime As Integer
		    
		    Var bUseBabyGestation As Boolean = Properties.Lookup("bUseBabyGestation", False).BooleanValue
		    If bUseBabyGestation Then
		      Var BabyGestationSpeed As Double = Properties.Lookup("BabyGestationSpeed", 0.000035).DoubleValue
		      Var ExtraBabyGestationSpeedMultiplier As Double = Properties.Lookup("ExtraBabyGestationSpeedMultiplier", 1.0).DoubleValue
		      If BabyGestationSpeed = 0 Or ExtraBabyGestationSpeedMultiplier = 0 Then
		        Return False
		      End If
		      IncubationTime = Round(1 / BabyGestationSpeed / ExtraBabyGestationSpeedMultiplier)
		    Else
		      If Properties.HasChild("FertilizedEggItemsToSpawn") = False Or Properties.Child("FertilizedEggItemsToSpawn").Count = 0 Then
		        Return False
		      End If
		      
		      Var Egg As JSONMBS
		      Var EggsList As JSONMBS = Properties.Child("FertilizedEggItemsToSpawn")
		      If Properties.HasChild("FertilizedEggWeightsToSpawn") Then
		        // Find the best egg
		        Var EggWeights As JSONMBS = Properties.Child("FertilizedEggWeightsToSpawn")
		        Var MaxWeight As Double
		        Var BestIndex As Integer = -1
		        For Idx As Integer = 0 To EggWeights.LastRowIndex
		          If EggWeights.ValueAt(Idx).IsNull Or EggsList.LastRowIndex < Idx Then
		            Continue
		          End If
		          If EggWeights.ValueAt(Idx) > MaxWeight Then
		            BestIndex = Idx
		            MaxWeight = EggWeights.ValueAt(Idx)
		          End If
		        Next
		        If BestIndex > -1 THen
		          Egg = EggsList.ChildAt(BestIndex)
		        End If
		      Else
		        Egg = EggsList.ChildAt(0)
		      End If
		      If Egg Is Nil Or Egg.IsNull Then
		        Return False
		      End If
		      
		      Var EggPath As String = Self.NormalizePath(Egg.Value("ObjectPath"))
		      Var EggProperties As JSONMBS = Self.PropertiesForPath(EggPath)
		      Var EggLoseDurabilityPerSecond As Double = EggProperties.Lookup("EggLoseDurabilityPerSecond", 0.005556).DoubleValue
		      Var ExtraEggLoseDurabilityPerSecondMultiplier As Double = EggProperties.Lookup("ExtraEggLoseDurabilityPerSecondMultiplier", 1.0).DoubleValue
		      If EggLoseDurabilityPerSecond = 0 Or ExtraEggLoseDurabilityPerSecondMultiplier = 0 Then
		        Return False
		      End If
		      IncubationTime = Round(100 / EggLoseDurabilityPerSecond / ExtraEggLoseDurabilityPerSecondMultiplier)
		    End If
		    Var BabyAgeSpeed As Double = Properties.Lookup("BabyAgeSpeed", 0.000003).DoubleValue
		    Var ExtraBabyAgeSpeedMultiplier As Double = Properties.Lookup("ExtraBabyAgeSpeedMultiplier", 1.0).DoubleValue
		    If BabyAgeSpeed = 0 Or ExtraBabyAgeSpeedMultiplier = 0 Then
		      Return False
		    End If
		    
		    Creature.IncubationTime = IncubationTime
		    Creature.MatureTime = Round(1 / (BabyAgeSpeed * ExtraBabyAgeSpeedMultiplier))
		    Creature.MinMatingInterval = Properties.Lookup("NewFemaleMinTimeBetweenMating", 68400).IntegerValue
		    Creature.MaxMatingInterval = Properties.Lookup("NewFemaleMaxTimeBetweenMating", 172800).IntegerValue
		    
		    Return True
		  Catch Err As RuntimeException
		    Return False
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ContentPackIdForPath(Path As String) As String
		  Var PackageName As String = Path.NthField("/", 2)
		  Return Self.mContentPackIdsByPackage.Lookup(PackageName, Self.OfficialContentPackId)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateObjectId(Path As String, ContentPackId As String = "") As String
		  If ContentPackId.IsEmpty Then
		    ContentPackId = Self.ContentPackIdForPath(Path)
		  End If
		  Return Beacon.UUID.v5(ContentPackId + ":" + Path.Lowercase)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsAvailable() As Boolean
		  Return TargetWindows And UpdatesKit.MachineArchitecture = UpdatesKit.Architectures.x86_64
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mThread_Run(Sender As Beacon.Thread)
		  Self.mSuccess = False
		  
		  Self.mContentPackIdsByPackage = New Dictionary
		  Self.mPropertiesCache = New Dictionary
		  Self.mUnlockDetails = New Dictionary
		  Self.mItemPaths = New Dictionary
		  Self.mCreaturePaths = New Dictionary
		  Self.mLootPaths = New Dictionary
		  Self.mSpawnPaths = New Dictionary
		  Self.mTags = New Dictionary
		  Self.mPathsScanned = New Dictionary
		  Self.mContentPacks = New Dictionary
		  Self.mFoundBlueprints = New Dictionary
		  Self.mInventoryNames = New Dictionary
		  Self.mBossPaths = New Dictionary
		  
		  Var SteamRoot As FolderItem
		  Try
		    SteamRoot = New FolderItem(Preferences.ArkSADedicatedPath, FolderItem.PathModes.Native)
		  Catch Err As RuntimeException
		  End Try
		  If SteamRoot Is Nil Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Server root is nil. Check the path of your dedicated server files."))
		    Return
		  ElseIf SteamRoot.Exists = False Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Dedicated server files not found at " + SteamRoot.NativePath + "."))
		    Return
		  ElseIf SteamRoot.IsFolder = False Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Found the dedicated server files, but " + SteamRoot.NativePath + " is not a folder."))
		    Return
		  End If
		  
		  Var PaksFolder As FolderItem
		  Try
		    PaksFolder = SteamRoot.Child("ShooterGame").Child("Content").Child("Paks")
		  Catch Err As RuntimeException
		  End Try
		  If PaksFolder Is Nil Or PaksFolder.Exists = False Or PaksFolder.IsFolder = False Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Could not find " + SteamRoot.NativePath + Beacon.PathSeparator + "ShooterGame" + Beacon.PathSeparator + "Content" + Beacon.PathSeparator + "Paks folder."))
		    Return
		  End If
		  
		  Var DiscoveryRoot As FolderItem = SteamRoot.Child("Beacon Mod Discovery")
		  If Not DiscoveryRoot.CheckIsFolder Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Could not create Beacon Mod Discovery folder in " + SteamRoot.NativePath + "."))
		    Return
		  End If
		  
		  Var Sh As New Shell
		  Var RequiredLinks() As String = Array("global.ucas", "global.utoc", "ShooterGame-WindowsServer.pak", "ShooterGame-WindowsServer.ucas", "ShooterGame-WindowsServer.utoc")
		  For Each Filename As String In RequiredLinks
		    Try
		      Var DestinationFile As FolderItem = DiscoveryRoot.Child(Filename)
		      Var SourceFile As FolderItem = PaksFolder.Child(Filename)
		      If DestinationFile.Exists Then
		        DestinationFile.Remove
		      End If
		      
		      #if TargetWindows
		        Sh.Execute("mklink /H """ + DestinationFile.NativePath + """ """ + SourceFile.NativePath + """")
		      #elseif TargetLinux or TargetMacOS
		        Sh.Execute("ln " + SourceFile.ShellPath + " " + DestinationFile.ShellPath)
		      #endif
		    Catch Err As RuntimeException
		    End Try
		  Next
		  
		  Var ManifestPattern As New RegEx
		  ManifestPattern.SearchPattern = "^ShooterGame/Mods/([^/]+)/AssetRegistry\.bin\t.+$"
		  
		  Var ModIds() As String = Self.mSettings.ModIds
		  Var ModPackageNames As New Dictionary
		  Var ModInfos As New Dictionary
		  For Each ModId As String In ModIds
		    Var ModInfo As CurseForge.ModInfo = CurseForge.LookupMod(ModId)
		    If ModInfo Is Nil Then
		      Continue
		    End If
		    ModInfos.Value(ModId) = ModInfo
		    
		    Var ModFolder As FolderItem = DiscoveryRoot.Child(ModId)
		    If Not ModFolder.CheckIsFolder Then
		      App.Log("Could not create discovery folder for mod " + ModId)
		      Continue
		    End If
		    Var DownloadRequired As Boolean = True
		    Var InfoFile As FolderItem = ModFolder.Child("Mod.json")
		    If InfoFile.Exists Then
		      Var StoredInfo As New CurseForge.ModInfo(InfoFile)
		      If StoredInfo.LastUpdateString = ModInfo.LastUpdateString Then
		        // We already have this mod downloaded and it does not need updating
		        DownloadRequired = False
		      End If
		    End If
		    
		    If DownloadRequired Then
		      Self.StatusMessage = "Downloading mod " + ModInfo.ModName + "…"
		      Var Download As ArkSA.ModDownload = ArkSA.DownloadMod(ModInfo)
		      If Download Is Nil Then
		        Continue
		      End If
		      
		      Self.StatusMessage = "Extracting " + Download.Filename + "…"
		      Do
		        Var Entry As ArchiveEntryMBS = Download.NextHeader
		        If Entry Is Nil Then
		          Exit
		        End If
		        
		        If Entry.Filename <> "Manifest_UFSFiles_Win64.txt" Then
		          Select Case Entry.Filename.LastField(".")
		          Case "pak", "ucas", "utoc"
		          Else
		            Continue
		          End Select
		        End If
		        
		        Var TargetSize As UInt64 = Entry.Size
		        Var OutStream As BinaryStream = BinaryStream.Create(ModFolder.Child(Entry.Filename), True)
		        While OutStream.Length <> TargetSize
		          OutStream.Write(Download.ReadDataBlockMemory())
		        Wend
		        OutStream.Close
		      Loop
		      Download.CloseArchive()
		    End If
		    
		    Var ManifestFile As FolderItem = ModFolder.Child("Manifest_UFSFiles_Win64.txt")
		    Var ManifestStream As TextInputStream = TextInputStream.Open(ManifestFile)
		    Do Until ManifestStream.EndOfFile
		      Var ManifestLine As String = ManifestStream.ReadLine(Encodings.UTF8)
		      Var Matches As RegExMatch = ManifestPattern.Search(ManifestLine)
		      If (Matches Is Nil) = False Then
		        Var PackageName As String = Matches.SubExpressionString(1)
		        ModPackageNames.Value(ModId) = PackageName
		        Var ContentPackId As String = Self.mSettings.ContentPackId(ModId)
		        Self.mContentPackIdsByPackage.Value(PackageName) = ContentPackId
		        
		        Var Pack As New Beacon.MutableContentPack(ArkSA.Identifier, ModInfo.ModName, ContentPackId)
		        Pack.Marketplace = Beacon.MarketplaceCurseForge
		        Pack.MarketplaceId = ModId
		        Self.mContentPacks.Value(ContentPackId) = Pack
		        Exit
		      End If
		    Loop
		    ManifestStream.Close
		    
		    InfoFile.Write(ModInfo.ToString(True))
		  Next
		  
		  Var ExtractorRoot As FolderItem = App.ApplicationSupport.Child("ASA Extractor")
		  If Not ExtractorRoot.CheckIsFolder Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Could not create folder to the data extractor tool."))
		    Return
		  End If
		  
		  Var RequiredHashes As New Dictionary
		  RequiredHashes.Value("mod_data_extractor.exe") = "21b6a14c0e83161fffada4213e37c251"
		  RequiredHashes.Value("CUE4Parse-Natives.dll") = "cb4eec121a03a28426cd45051d770ea1"
		  RequiredHashes.Value("mod_data_extractor.pdb") = "6987a6cf575525eb0f0ea3f3b7c9be71"
		  Var ExtractorReady As Boolean = True
		  For Each Entry As DictionaryEntry In RequiredHashes
		    Var ExtractorFile As FolderItem = ExtractorRoot.Child(Entry.Key.StringValue)
		    If ExtractorFile.Exists = False Then
		      ExtractorReady = False
		      Exit
		    End If
		    Var CorrectHash As String = Entry.Value.StringValue
		    Var ComputedHash As String = MD5DigestMBS.HashFile(ExtractorFile, True)
		    If ComputedHash <> CorrectHash Then
		      ExtractorReady = False
		      Exit
		    End If
		  Next
		  
		  If ExtractorReady = False Then
		    Self.StatusMessage = "Downloading extraction tool…"
		    For Each Entry As DictionaryEntry In RequiredHashes
		      Var ExtractorFile As FolderItem = ExtractorRoot.Child(Entry.Key.StringValue)
		      If ExtractorFile.Exists Then
		        ExtractorFile.Remove
		      End If
		    Next
		    
		    Var DownloadSocket As New SimpleHTTP.SynchronousHTTPSocket
		    DownloadSocket.Send("GET", "https://updates.usebeacon.app/tools/arksa_data_extractor/v9.zip")
		    If DownloadSocket.HTTPStatusCode <> 200 Then
		      Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Failed to download extractor tool."))
		      Return
		    End If
		    
		    Var Archive As New ArchiveReaderMBS
		    Archive.SupportFilterAll
		    Archive.SupportFormatAll
		    If Not Archive.OpenData(DownloadSocket.LastContent) Then
		      Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Could not open extractor tool archive: " + Archive.ErrorString))
		      Return
		    End If
		    
		    Do
		      Var Entry As ArchiveEntryMBS = Archive.NextHeader
		      If Entry Is Nil Then
		        Exit
		      End If
		      
		      If RequiredHashes.HasKey(Entry.Filename) = False Then
		        Continue
		      End If
		      
		      Var TargetSize As UInt64 = Entry.Size
		      Var TargetFile As FolderItem = ExtractorRoot.Child(Entry.Filename)
		      Var OutStream As BinaryStream = BinaryStream.Create(TargetFile, True)
		      Var Offset As Int64
		      While OutStream.Length <> TargetSize
		        OutStream.Write(Archive.ReadDataBlockMemory(Offset))
		      Wend
		      OutStream.Close
		      
		      Var CorrectHash As String = RequiredHashes.Value(Entry.Filename)
		      Var ComputedHash As String = MD5DigestMBS.HashFile(TargetFile, True)
		      If ComputedHash <> CorrectHash Then
		        TargetFile.Remove
		        Archive.Close
		        Archive = Nil
		        Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Downloaded extractor tool file " + Entry.Filename + " did not pass integrity check."))
		        Return
		      End If
		    Loop
		    Archive.Close
		    Archive = Nil
		  End If
		  
		  Var BlacklistLines() As String
		  BlacklistLines.Add("Engine/")
		  BlacklistLines.Add("ShooterGame/Content/")
		  BlacklistLines.Add("ShooterGame/Plugins/")
		  BlacklistLines.Add("ShooterGame/AssetRegistry\.bin")
		  
		  Var BlacklistFile As FolderItem = ExtractorRoot.Child("blacklist.txt")
		  Var CurrentLines() As String
		  If BlacklistFile.Exists Then
		    Var InStream As TextInputStream = TextInputStream.Open(BlacklistFile)
		    CurrentLines = InStream.ReadAll(Encodings.UTF8).ReplaceLineEndings(EndOfLine).Split(EndOfLine)
		    InStream.Close
		  End If
		  
		  For Each Line As String In BlacklistLines
		    If CurrentLines.IndexOf(Line) = -1 Then
		      CurrentLines.Add(Line)
		    End If
		  Next
		  CurrentLines.Sort
		  
		  Var BlacklistStream As TextOutputStream = TextOutputStream.Create(BlacklistFile)
		  BlacklistStream.Write(String.FromArray(CurrentLines, EndOfLine))
		  BlacklistStream.Close
		  
		  Var OutputFolder As FolderItem = ExtractorRoot.Child("Output")
		  If Not OutputFolder.CheckIsFolder Then
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Could not create extraction output folder."))
		    Return
		  End If
		  
		  Self.StatusMessage = "Extracting mod data…"
		  Var InputPath As String = DiscoveryRoot.NativePath
		  If InputPath.EndsWith("\") Then
		    InputPath = InputPath.Left(InputPath.Length - 1)
		  End If
		  Var OutputPath As String = OutputFolder.NativePath
		  If OutputPath.EndsWith("\") Then
		    OutputPath = OutputPath.Left(OutputPath.Length - 1)
		  End If
		  Var Targets() As String
		  For Each Entry As DictionaryEntry In ModPackageNames
		    Targets.Add("ShooterGame/Mods/" + Entry.Value.StringValue + "/")
		  Next
		  Var Command As String = "cd /d """ + ExtractorRoot.NativePath + """ && .\mod_data_extractor.exe --input """ + InputPath + """ --output """ + OutputPath + """ --badfile """ + BlacklistFile.NativePath + """ --file-types ""uasset"" ""umap"" ""bin"" --targets """ + String.FromArray(Targets, """ """) + """"
		  Var ExtractorShell As New Shell
		  ExtractorShell.ExecuteMode = Shell.ExecuteModes.Interactive
		  ExtractorShell.TimeOut = -1
		  ExtractorShell.Execute(Command)
		  While ExtractorShell.IsRunning
		    Sender.Sleep(10)
		  Wend
		  
		  Self.mRoot = OutputFolder
		  For Each ModId As String In ModIds
		    Var PackageName As String = ModPackageNames.Value(ModId)
		    
		    Try
		      Var ModInfo As CurseForge.ModInfo = ModInfos.Value(ModId)
		      Self.StatusMessage = "Planning blueprints for " + ModInfo.ModName + "…"
		      Self.ScanMod(ModId, PackageName)
		    Catch Err As RuntimeException
		      App.Log("Unhandled exception scanning mod " + PackageName + " (" + ModId + ")")
		      Continue
		    End Try
		  Next
		  
		  If Self.mItemPaths.KeyCount > 0 Then
		    Self.StatusMessage = "Building items…"
		    For Each Entry As DictionaryEntry In Self.mItemPaths
		      Var ItemPath As String = Entry.Key
		      Self.SyncItem(ItemPath)
		    Next
		  End If
		  
		  If Self.mCreaturePaths.KeyCount > 0 Then
		    Self.StatusMessage = "Building creatures…"
		    For Each Entry As DictionaryEntry In Self.mCreaturePaths
		      Var CreaturePath As String = Entry.Key
		      Self.SyncCreature(CreaturePath)
		    Next
		  End If
		  
		  If Self.mLootPaths.KeyCount > 0 Then
		    Self.StatusMessage = "Building loot drops…"
		    For Each Entry As DictionaryEntry In Self.mLootPaths
		      Var DropPath As String = Entry.Key
		      Self.SyncLootDrop(DropPath)
		    Next
		  End If
		  
		  If Self.mSpawnPaths.KeyCount > 0 Then
		    Self.StatusMessage = "Building spawn points…"
		    For Each Entry As DictionaryEntry In Self.mSpawnPaths
		      Var SpawnPath As String = Entry.Key
		      Self.SyncSpawnContainer(SpawnPath)
		    Next
		  End If
		  
		  For Each Entry As DictionaryEntry In Self.mContentPacks
		    Var ContentPackId As String = Entry.Key
		    Var Pack As Beacon.ContentPack = Entry.Value
		    Var Blueprints() As ArkSA.Blueprint
		    If Self.mFoundBlueprints.HasKey(ContentPackId) Then
		      Blueprints = Self.mFoundBlueprints.Value(ContentPackId)
		    End If
		    RaiseEvent ContentPackDiscovered(Pack, Blueprints)
		  Next
		  
		  Self.mSuccess = True
		  Sender.AddUserInterfaceUpdate(New Dictionary("Finished" : True))
		  
		  Exception TopLevelException As RuntimeException
		    App.Log(TopLevelException, CurrentMethodName, "Running the discovery thread")
		    Sender.AddUserInterfaceUpdate(New Dictionary("Finished": True, "Error": True, "Message": "Unhandled exception in discover thread.", "Exception": TopLevelException))
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub mThread_UserInterfaceUpdate(Sender As Beacon.Thread, Updates() As Dictionary)
		  #Pragma Unused Sender
		  
		  For Each Update As Dictionary In Updates
		    If Update.HasKey("Event") Then
		      Select Case Update.Value("Event").StringValue
		      Case "StatusUpdated"
		        RaiseEvent StatusUpdated
		      End Select
		    End If
		    
		    Var Error As Boolean = Update.Lookup("Error", False).BooleanValue
		    Var Finished As Boolean = Error Or Update.Lookup("Finished", False).BooleanValue
		    If Error Then
		      Var ErrorMessage As String = Update.Lookup("Message", "").StringValue
		      RaiseEvent Error(ErrorMessage)
		    End If
		    If Finished Then
		      Self.mActiveInstance = Nil
		      RaiseEvent Finished()
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function NormalizePath(Path As String) As String
		  If Path.IsEmpty Then
		    Return Path
		  End If
		  
		  Var Components() As String = Path.Split("/")
		  Var LastComponent As String = Components(Components.LastIndex)
		  Components.RemoveAt(Components.LastIndex)
		  
		  If LastComponent.EndsWith("_C") Then
		    LastComponent = LastComponent.Left(LastComponent.Length - 2)
		  End If
		  
		  Var ClassString As String
		  If LastComponent.Contains(".") Then
		    Var Parts() As String = LastComponent.Split(".")
		    Components.Add(Parts(0))
		    If Parts(1).IsNumeric Then
		      ClassString = Parts(0)
		    Else
		      ClassString = Parts(1)
		    End If
		  Else
		    Components.Add(LastComponent)
		    ClassString = LastComponent
		  End If
		  
		  Return String.FromArray(Components, "/") + "." + ClassString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PropertiesForPath(Path As String) As JSONMBS
		  If Self.mPropertiesCache.HasKey(Path) Then
		    Return Self.mPropertiesCache.Value(Path)
		  End If
		  
		  Var PathComponents() As String = Path.Split("/")
		  PathComponents.RemoveAt(0) // empty string before leading slash
		  
		  Var File As FolderItem = Self.mRoot.Child("ShooterGame")
		  If PathComponents(0) = "Game" Then
		    File = File.Child("Content")
		  Else
		    File = File.Child("Mods").Child(PathComponents(0)).Child("Content")
		  End If
		  PathComponents.RemoveAt(0) // remove the package name
		  Var ClassString As String = PathComponents(PathComponents.LastIndex).NthField(".", 1)
		  PathComponents(PathComponents.LastIndex) = ClassString + ".json"
		  
		  For Each Component As String In PathComponents
		    Var Child As FolderItem = File.Child(Component)
		    If Child Is Nil Or Child.Exists = False Then
		      Return Nil
		    End If
		    File = Child
		  Next
		  
		  Var Stream As TextInputStream = TextInputStream.Open(File)
		  Var Parsed As New JSONMBS(Stream.ReadAll(Encodings.UTF8))
		  Stream.Close
		  
		  Var EntryPoint As JSONMBS
		  Var FallbackEntry As JSONMBS
		  For Idx As Integer = 0 To Parsed.LastRowIndex
		    Var Child As JSONMBS = Parsed.ChildAt(Idx)
		    If Child.Value("Type") = "BlueprintGeneratedClass" Or Child.Value("Type") = "WidgetBlueprintGeneratedClass" Then
		      EntryPoint = Child
		      Exit For Idx
		    ElseIf (FallbackEntry Is Nil) And Child.Value("Name") = ClassString And Child.HasKey("Properties") Then
		      FallbackEntry = Child.Child("Properties")
		    End If
		  Next
		  
		  If EntryPoint Is Nil Then
		    Self.mPropertiesCache.Value(Path) = FallbackEntry
		    Return FallbackEntry
		  End If
		  
		  Var DefaultPath As String = EntryPoint.Child("ClassDefaultObject").Value("ObjectPath")
		  Var DefaultIndex As Integer = Integer.FromString(DefaultPath.LastField("."), Locale.Raw)
		  Var DefaultObject As JSONMBS = Parsed.ChildAt(DefaultIndex)
		  Var DefaultProperties As JSONMBS = DefaultObject.Child("Properties")
		  DefaultProperties.Value("X-Beacon-Self") = Self.NormalizePath(DefaultPath)
		  If EntryPoint.HasChild("Super") Then
		    Var SuperPath As String = Self.NormalizePath(EntryPoint.Child("Super").Value("ObjectPath"))
		    DefaultProperties.Value("X-Beacon-Super") = SuperPath
		  End If
		  
		  Var ChildPaths As JSONMBS = EntryPoint.Query("$.ChildProperties[*].PropertyClass.ObjectPath")
		  Var Children As New JSONMBS
		  For Idx As Integer = 0 To ChildPaths.LastRowIndex
		    Var ChildPath As String = Self.NormalizePath(ChildPaths.ValueAt(Idx))
		    Var ChildClassString As String = ChildPath.LastField(".") + "_C"
		    Var ChildObjects As JSONMBS = Parsed.Query("$[?(@.Type == """ + ChildClassString + """)]")
		    For ChildIdx As Integer = 0 To ChildObjects.LastRowIndex
		      Children.Add(ChildObjects.ChildAt(ChildIdx))
		    Next
		  Next
		  
		  ChildPaths = EntryPoint.Query("$.Children[*].ObjectPath")
		  For Idx As Integer = 0 To ChildPaths.LastRowIndex
		    Var ChildPath As String = ChildPaths.ValueAt(Idx)
		    Var ChildOffset As Integer = Integer.FromString(ChildPath.LastField("."))
		    Var Child As JSONMBS = Parsed.ChildAt(ChildOffset)
		    Children.Add(Child)
		  Next
		  
		  If Children.Count > 0 Then
		    DefaultProperties.Child("X-Beacon-Children") = Children
		  End If
		  
		  Self.mPropertiesCache.Value(Path) = DefaultProperties
		  Return DefaultProperties
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanCreature(Path As String, IsBoss As Boolean, ParamArray AdditionalTags() As String)
		  Self.ScanCreature(Path, IsBoss, AdditionalTags)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanCreature(Path As String, IsBoss As Boolean, AdditionalTags() As String)
		  Self.AddTagsToPath(Path, AdditionalTags)
		  
		  If Self.mPathsScanned.HasKey(Path) Then
		    Return
		  End If
		  Self.mPathsScanned.Value(Path) = True
		  
		  Var Properties As JSONMBS = Self.PropertiesForPath(Path)
		  If Properties Is Nil Then
		    Return
		  End If
		  
		  Self.mCreaturePaths.Value(Path) = True
		  If IsBoss Then
		    Self.mBossPaths.Value(Path) = True
		  End If
		  
		  // If killing the creature grants items, those should be directly associated.
		  Var GrantItemPaths As JSONMBS = Properties.Query("$.DeathGiveItemClasses[*].ObjectPath")
		  For Idx As Integer = 0 To GrantItemPaths.LastRowIndex
		    Var ItemPath As String = Self.NormalizePath(GrantItemPaths.ValueAt(Idx))
		    Self.ScanItem(ItemPath, "reward")
		  Next
		  
		  // If killing the creature unlocks items, scan them but don't associate them
		  Var UnlockItemPaths As JSONMBS = Properties.Query("$.DeathGiveEngramClasses[*].ObjectPath")
		  For Idx As Integer = 0 To UnlockItemPaths.LastRowIndex
		    Var ItemPath As String = Self.NormalizePath(UnlockItemPaths.ValueAt(Idx))
		    Self.ScanItem(ItemPath)
		  Next
		  
		  // Make sure dino drop inventories are found.
		  Var Label As String = Properties.Lookup("DescriptiveName", "").StringValue.ReplaceLineEndings(" ")
		  If Label.IsEmpty Then
		    Label = ArkSA.LabelFromClassString(Path.NthField(".", 2))
		  End If
		  Var Inventories As JSONMBS = Properties.Query("$.DeathInventoryTemplates.AssociatedObjects[*].ObjectPath")
		  For Idx As Integer = 0 To Inventories.LastRowIndex
		    Var InventoryPath As String = Self.NormalizePath(Inventories.ValueAt(Idx))
		    Self.ScanLootDrop(InventoryPath, If(IsBoss, LootDropType.Boss, LootDropType.Dino))
		    
		    Var Names() As String
		    If Self.mInventoryNames.HasKey(InventoryPath) Then
		      Names = Self.mInventoryNames.Value(InventoryPath)
		    Else
		      Self.mInventoryNames.Value(InventoryPath) = Names
		    End If
		    If Names.IndexOf(Label) = -1 Then
		      Names.Add(Label)
		    End If
		  Next
		  
		  // Anything that can be harvested from a dino that spawns on the map, should be available to the map.
		  If Properties.HasKey("DeathHarvestingComponent") And Properties.Value("DeathHarvestingComponent").IsNull = False Then
		    Var HarvestPath As String = Self.NormalizePath(Properties.Child("DeathHarvestingComponent").Value("ObjectPath"))
		    Var HarvestProperties As JSONMBS = Self.PropertiesForPath(HarvestPath)
		    If (HarvestProperties Is Nil) = False Then
		      Var Resources As JSONMBS = HarvestProperties.Query("$.HarvestResourceEntries[*].ResourceItem.ObjectPath")
		      For Idx As Integer = 0 To Resources.LastRowIndex
		        Var ItemPath As String = Self.NormalizePath(Resources.ValueAt(Idx))
		        Self.ScanItem(ItemPath, "harvestable", "resource")
		      Next
		    End If
		  End If
		  
		  // Include things that can be found in the dino.
		  If Properties.HasKey("TamedInventoryComponentTemplate") And Properties.Value("TamedInventoryComponentTemplate").IsNull = False Then
		    Var TamedInventoryComponentPath As String = Self.NormalizePath(Properties.Child("TamedInventoryComponentTemplate").Value("ObjectPath"))
		    Var TamedInventoryProperties As JSONMBS = Self.PropertiesForPath(TamedInventoryComponentPath)
		    If (TamedInventoryProperties Is Nil) = False Then
		      Var Resources As JSONMBS = TamedInventoryProperties.Query("$.DefaultInventoryItems[*].ObjectPath")
		      For Idx As Integer = 0 To Resources.LastRowIndex
		        Var ItemPath As String = Self.NormalizePath(Resources.ValueAt(Idx))
		        Self.ScanItem(ItemPath)
		      Next
		    End If
		  End If
		  
		  // Need eggs.
		  Var Eggs As JSONMBS = Properties.Query("$.EggItemsToSpawn[*].ObjectPath")
		  For Idx As Integer = 0 To Eggs.LastRowIndex
		    Var ItemPath As String = Self.NormalizePath(Eggs.ValueAt(Idx))
		    Self.ScanItem(ItemPath)
		  Next
		  
		  // And fertilized eggs.
		  Var FertilizedEggs As JSONMBS = Properties.Query("$.FertilizedEggItemsToSpawn[*].ObjectPath")
		  For Idx As Integer = 0 To FertilizedEggs.LastRowIndex
		    Var ItemPath As String = Self.NormalizePath(FertilizedEggs.ValueAt(Idx))
		    Self.ScanItem(ItemPath)
		  Next
		  
		  // Poops are generic and should not be directly associated with a creature. We grab the value here to make sure they are scanned.
		  If Properties.HasKey("PoopItemClass") And Properties.Value("PoopItemClass").IsNull = False Then
		    Var PoopPath As String = Self.NormalizePath(Properties.Child("PoopItemClass").Value("ObjectPath"))
		    Self.ScanItem(PoopPath)
		  End If
		  
		  // Alt poops are creature-specific, like achatina paste.
		  If Properties.HasKey("PoopAltItemClass") And Properties.Value("PoopAltItemClass").IsNull = False Then
		    Var PoopPath As String = Self.NormalizePath(Properties.Child("PoopAltItemClass").Value("ObjectPath"))
		    Self.ScanItem(PoopPath)
		  End If
		  
		  // Some creatures add their items this way.
		  Var DefaultInventoryItems As JSONMBS = Properties.Query("$.DinoExtraDefaultInventoryItems[*].DefaultItemsToGive[*].ObjectPath")
		  For Idx As Integer = 0 To DefaultInventoryItems.LastRowIndex
		    Var ItemPath As String = Self.NormalizePath(DefaultInventoryItems.ValueAt(Idx))
		    Self.ScanItem(ItemPath)
		  Next
		  
		  Self.ScanForChildren(Properties)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanForChildren(Properties As JSONMBS)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanItem(Path As String, NoSync As Boolean, ParamArray AdditionalTags() As String)
		  Self.ScanItem(Path, NoSync, AdditionalTags)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanItem(Path As String, NoSync As Boolean, AdditionalTags() As String)
		  Self.AddTagsToPath(Path, AdditionalTags)
		  
		  If Self.mPathsScanned.HasKey(Path) Then
		    Return
		  End If
		  Self.mPathsScanned.Value(Path) = True
		  
		  Var Properties As JSONMBS = Self.PropertiesForPath(Path)
		  If Properties Is Nil Then
		    Return
		  End If
		  
		  If Properties.HasKey("DescriptiveNameBase") And NoSync = False Then
		    Self.mItemPaths.Value(Path) = True
		  End If
		  
		  If Properties.HasChild("FuelItemsConsumedGiveItems") Then
		    Var GeneratedItems As JSONMBS = Properties.Child("FuelItemsConsumedGiveItems")
		    For Idx As Integer = 0 To GeneratedItems.LastRowIndex
		      Var GeneratedItem As JSONMBS = GeneratedItems.ChildAt(Idx)
		      If GeneratedItem Is Nil Or GeneratedItem.IsNull Then
		        Continue
		      End If
		      Var GeneratedItemPath As String = Self.NormalizePath(GeneratedItem.Value("ObjectPath"))
		      Self.ScanItem(GeneratedItemPath)
		    Next
		  End If
		  
		  If Properties.HasChild("BaseCraftingResourceRequirements") Then
		    Var BaseCraftingResourceRequirements As JSONMBS = Properties.Child("BaseCraftingResourceRequirements")
		    For Idx As Integer = 0 To BaseCraftingResourceRequirements.LastRowIndex
		      Var Requirement As JSONMBS = BaseCraftingResourceRequirements.ChildAt(Idx)
		      Var IngredientPath As String = Self.NormalizePath(Requirement.Child("ResourceItemType").Value("ObjectPath"))
		      Self.ScanItem(IngredientPath, "resource")
		    Next
		  End If
		  
		  If Properties.HasChild("GiveItemWhenUsed") Then
		    Var ItemPath As String = Self.NormalizePath(Properties.Child("GiveItemWhenUsed").Value("ObjectPath"))
		    Self.ScanItem(ItemPath)
		  End If
		  
		  If Properties.HasChild("CraftingActorToSpawn") Then
		    // Need to look for BossArenaClass (another file), OverrideBossClass, or BossClass
		    Var ActorProperties As JSONMBS = Self.PropertiesForPath(Self.NormalizePath(Properties.Child("CraftingActorToSpawn").Value("AssetPathName")))
		    Var BossPaths() As String
		    If ActorProperties.HasKey("OverrideBossClass") Then
		      BossPaths.Add(Self.NormalizePath(ActorProperties.Child("OverrideBossClass").Value("ObjectPath")))
		    ElseIf ActorProperties.HasKey("BossClass") Then
		      BossPaths.Add(Self.NormalizePath(ActorProperties.Child("BossClass").Value("ObjectPath")))
		    ElseIf ActorProperties.HasKey("BossArenaClass") Then
		      Var ArenaPath As String = Self.NormalizePath(ActorProperties.Child("BossArenaClass").Value("ObjectPath"))
		      Var ArenaProperties As JSONMBS = Self.PropertiesForPath(ArenaPath)
		      If ArenaProperties Is Nil Then
		        Return
		      End If
		      
		      If ArenaProperties.HasKey("BossClass") Then
		        BossPaths.Add(Self.NormalizePath(ArenaProperties.Child("BossClass").Value("AssetPathName")))
		      End If
		      If ArenaProperties.HasKey("SecondBossClass") Then
		        BossPaths.Add(Self.NormalizePath(ArenaProperties.Child("SecondBossClass").Value("AssetPathName")))
		      End If
		    End If
		    
		    If BossPaths.Count > 0 Then
		      Self.AddTagsToPath(Path, "tribute")
		    End If
		    
		    For Each BossPath As String In BossPaths
		      Self.ScanCreature(BossPath, True)
		    Next
		  End If
		  
		  If Properties.HasKey("StructureToBuild") Then
		    Var StructurePath As String = Self.NormalizePath(Properties.Child("StructureToBuild").Value("AssetPathName"))
		    Self.ScanItem(StructurePath, True)
		  End If
		  
		  Self.ScanForChildren(Properties)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanItem(Path As String, AdditionalTags() As String)
		  Self.ScanItem(Path, False, AdditionalTags)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanItem(Path As String, ParamArray AdditionalTags() As String)
		  Self.ScanItem(Path, False, AdditionalTags)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanLevelScriptActor(Path As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanLootDrop(Path As String, Type As LootDropType, AdditionalTags() As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanLootDrop(Path As String, Type As LootDropType, ParamArray AdditionalTags() As String)
		  Self.ScanLootDrop(Path, Type, AdditionalTags)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanMod(ModId As String, PackageName As String)
		  Var RegistryFile As FolderItem = Self.mRoot.Child("ShooterGame").Child("Mods").Child(PackageName).Child("AssetRegistry.json")
		  
		  Var NativeParents As New Dictionary
		  Var Registry As New JSONMBS(RegistryFile.Read(Encodings.UTF8))
		  Var PreallocatedAssetDataBuffers As JSONMBS = Registry.Child("PreallocatedAssetDataBuffers")
		  For Idx As Integer = 0 To PreallocatedAssetDataBuffers.LastRowIndex
		    Var Asset As JSONMBS = PreallocatedAssetDataBuffers.ChildAt(Idx)
		    Var AssetClass As String = Asset.Value("AssetClass")
		    If AssetClass <> "BlueprintGeneratedClass" Then
		      Continue
		    End If
		    Var ObjectPath As String = Self.NormalizePath(Asset.Value("ObjectPath"))
		    Var NativeParent As String = Asset.Child("TagsAndValues").Value("NativeParentClass")
		    
		    Var Siblings As Dictionary
		    If NativeParents.HasKey(NativeParent) Then
		      Siblings = NativeParents.Value(NativeParent)
		    Else
		      Siblings = New Dictionary
		      NativeParents.Value(NativeParent) = Siblings
		    End If
		    Siblings.Value(ObjectPath) = True
		  Next
		  
		  // The primal game data is the kicking off point for most mods
		  If NativeParents.HasKey("/Script/CoreUObject.Class'/Script/ShooterGame.PrimalGameData'") Then
		    Var PrimalGameDataPaths As Dictionary = NativeParents.Value("/Script/CoreUObject.Class'/Script/ShooterGame.PrimalGameData'")
		    For Each Entry As DictionaryEntry In PrimalGameDataPaths
		      Self.ScanPrimalGameData(Entry.Key.StringValue)
		    Next
		  End If
		  
		  // Map mods will have a level script actor
		  If NativeParents.HasKey("/Script/CoreUObject.Class'/Script/Engine.LevelScriptActor'") Then
		    Var ScriptActorPaths As Dictionary = NativeParents.Value("/Script/CoreUObject.Class'/Script/Engine.LevelScriptActor'")
		    For Each Entry As DictionaryEntry In ScriptActorPaths
		      Self.ScanLevelScriptActor(Entry.Key.StringValue)
		    Next
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanPrimalGameData(Path As String)
		  Var PrimalGameData As JSONMBS = Self.PropertiesForPath(Path)
		  Var AssetContainers() As JSONMBS = Array(PrimalGameData)
		  
		  If PrimalGameData.HasKey("AdditionalModDataAsset") Then
		    Var AdditionalModDataAssetPath As String = Self.NormalizePath(PrimalGameData.Child("AdditionalModDataAsset").Value("ObjectPath"))
		    Var AdditionalModDataAsset As JSONMBS = Self.PropertiesForPath(AdditionalModDataAssetPath)
		    If (AdditionalModDataAsset Is Nil) = False Then
		      AssetContainers.Add(AdditionalModDataAsset)
		    End If
		  End If
		  
		  For Each AssetContainer As JSONMBS In AssetContainers
		    // Additional skins
		    Var ItemSkinPaths As JSONMBS = AssetContainer.Query("$.ModCustomCosmeticEntries[*].ModSkinItem.AssetPathName")
		    Var StructureSkinPaths As JSONMBS = AssetContainer.Query("$.ModCustomCosmeticEntries[*].ModSkinStructure.AssetPathName")
		    Var SkinPaths() As JSONMBS = Array(ItemSkinPaths, StructureSkinPaths)
		    For Each PathArray As JSONMBS In SkinPaths
		      For Idx As Integer = 0 To PathArray.LastRowIndex
		        Var SkinPath As String = PathArray.ValueAt(Idx)
		        If SkinPath.IsEmpty Then
		          Continue
		        End If
		        
		        Self.ScanItem(Self.NormalizePath(SkinPath), "skin")
		      Next
		    Next
		    
		    // Additional unlocks
		    Var AdditionalEngramPaths As JSONMBS = AssetContainer.Query("$.AdditionalEngramBlueprintClasses[*].ObjectPath")
		    For Idx As Integer = 0 To AdditionalEngramPaths.LastRowIndex
		      Var UnlockPath As String = AdditionalEngramPaths.ValueAt(Idx)
		      If UnlockPath.IsEmpty Then
		        Continue
		      End If
		      
		      Self.ScanUnlock(Self.NormalizePath(UnlockPath))
		    Next
		    
		    // Stuff added to crafting stations
		    Var AdditionalStructureEngrams As JSONMBS = AssetContainer.Query("$.AdditionalStructureEngrams[*].ClassAdditions.AssetPathName")
		    For Idx As Integer = 0 To AdditionalStructureEngrams.LastRowIndex
		      Var ItemPath As String = AdditionalStructureEngrams.ValueAt(Idx)
		      If ItemPath.IsEmpty Then
		        Continue
		      End If
		      
		      Self.ScanItem(Self.NormalizePath(ItemPath))
		    Next
		    
		    // Creatures the mod injects
		    Var InjectedCreaturePaths As JSONMBS = AssetContainer.Query("$.TheNPCSpawnEntriesContainerAdditions[*].AdditionalNPCSpawnEntries[*].NPCsToSpawn[*].AssetPathName")
		    Var InjectedLimitPaths As JSONMBS = AssetContainer.Query("$.TheNPCSpawnEntriesContainerAdditions[*].AdditionalNPCSpawnLimits[*].NPCClass.AssetPathName")
		    Var InjectedReplacementPaths As JSONMBS = AssetContainer.Query("$.GlobalNPCRandomSpawnClassWeights[*].ToClasses[*].AssetPathName")
		    Var CreaturePaths() As JSONMBS = Array(InjectedCreaturePaths, InjectedLimitPaths, InjectedReplacementPaths)
		    For Each PathList As JSONMBS In CreaturePaths
		      For Idx As Integer = 0 To PathList.LastRowIndex
		        Var CreaturePath As String = PathList.ValueAt(Idx)
		        If CreaturePath.IsEmpty Then
		          Continue
		        End If
		        
		        Self.ScanCreature(Self.NormalizePath(CreaturePath), False)
		      Next
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ScanUnlock(Path As String)
		  If Self.mPathsScanned.HasKey(Path) Then
		    Return
		  End If
		  
		  Var Properties As JSONMBS = Self.PropertiesForPath(Path)
		  If Properties Is Nil Then
		    Return
		  End If
		  
		  Var UnlockString As String = Path.NthField(".", 2) + "_C"
		  Var RequiredLevel As Variant
		  Var RequiredPoints As Variant
		  If Properties.Lookup("bCanBeManuallyUnlocked", True).BooleanValue = True Then
		    RequiredPoints = Properties.Lookup("RequiredEngramPoints", 0).IntegerValue
		    RequiredLevel = Properties.Lookup("RequiredCharacterLevel", 1).IntegerValue
		  End If
		  
		  Var ItemPath As String = Self.NormalizePath(Properties.Child("BluePrintEntry").Value("ObjectPath"))
		  Self.mUnlockDetails.Value(ItemPath) = New Dictionary("UnlockString": UnlockString, "RequiredLevel": RequiredLevel, "RequiredPoints": RequiredPoints)
		  Self.ScanItem(ItemPath)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Settings() As ArkSA.ModDiscoverySettings
		  Return Self.mSettings
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start(Settings As ArkSA.ModDiscoverySettings)
		  If (Self.mActiveInstance Is Nil) = False Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Mod discovery is already running"
		    Raise Err
		  End If
		  
		  Self.mActiveInstance = Self
		  Self.mSettings = Settings
		  Self.mStatusMessage = "Initializing…"
		  Self.mSuccess = False
		  Self.mCancelled = False
		  
		  Self.mThread = New Beacon.Thread
		  Self.mThread.DebugIdentifier = "ArkSA.ModDiscoveryEngine2"
		  AddHandler mThread.Run, WeakAddressOf mThread_Run
		  AddHandler mThread.UserInterfaceUpdate, WeakAddressOf mThread_UserInterfaceUpdate
		  
		  Self.mThread.Start
		  
		  RaiseEvent Started()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StatusMessage() As String
		  If Self.mCancelled Then
		    Return "Cancelling…"
		  Else
		    Return Self.mStatusMessage
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub StatusMessage(Assigns Message As String)
		  If Self.mStatusMessage.Compare(Message, ComparisonOptions.CaseSensitive) = 0 Then
		    Return
		  End If
		  
		  Self.mStatusMessage = Message
		  
		  If Thread.Current Is Nil Then
		    RaiseEvent StatusUpdated()
		  Else
		    Self.mThread.AddUserInterfaceUpdate(New Dictionary("Event": "StatusUpdated"))
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SyncCreature(Path As String)
		  Var ContentPackId As String = Self.ContentPackIdForPath(Path)
		  If ContentPackId = Self.OfficialContentPackId Then
		    Return
		  End If
		  Var Pack As Beacon.ContentPack = Self.mContentPacks.Value(ContentPackId)
		  
		  Var Properties As JSONMBS = Self.PropertiesForPath(Path)
		  
		  Var CreatureName As String = Properties.Lookup("DescriptiveName", "").StringValue.ReplaceLineEndings(" ")
		  If CreatureName.IsEmpty Then
		    CreatureName = ArkSA.LabelFromClassString(Path.NthField(".", 2))
		  End If
		  
		  Var CreatureId As String = Self.CreateObjectId(Path, ContentPackId)
		  Var Creature As New ArkSA.MutableCreature(Path, CreatureId)
		  Creature.Availability = ArkSA.Maps.UniversalMask
		  Creature.ContentPackId = ContentPackId
		  Creature.ContentPackName = Pack.Name
		  Creature.Label = CreatureName
		  
		  If Properties.HasKey("DinoNameTag") And Properties.Value("DinoNameTag").IsNull = False And Properties.Value("DinoNameTag").StringValue.IsEmpty = False Then
		    Creature.NameTag = Properties.Value("DinoNameTag").StringValue
		  ElseIf Properties.HasKey("CustomTag") And Properties.Value("CustomTag").IsNull = False And Properties.Value("CustomTag").StringValue.IsEmpty = False Then
		    Creature.NameTag = Properties.Value("CustomTag").StringValue
		  End If
		  
		  Var CanBeTamed As Boolean = Properties.Lookup("bCanBeTamed", True).BooleanValue
		  Var CanHaveBaby As Boolean = Properties.Lookup("bCanHaveBaby", False).BooleanValue
		  If (CanBeTamed And CanHaveBaby And Self.ComputeBreedingStats(Properties, Creature)) = False Then
		    Creature.IncubationTime = 0
		    Creature.MatureTime = 0
		    Creature.MinMatingInterval = 0
		    Creature.MaxMatingInterval = 0
		  End If
		  
		  Var Results As JSONMBS = Properties.Query("$['X-Beacon-Children'][*][?(@.CraftingSpeedMultiplier)]")
		  Static AdditionalBaseValue() As Integer = Array(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1)
		  If Results.Count = 1 Then
		    Var StatusComponent As JSONMBS = Results.Child(0)
		    Var StatInfos(11) As JSONMBS
		    StatInfos(0) = StatusComponent.Child("Health")
		    StatInfos(1) = StatusComponent.Child("Stamina")
		    StatInfos(2) = StatusComponent.Child("Torpidity")
		    StatInfos(3) = StatusComponent.Child("Oxygen")
		    StatInfos(4) = StatusComponent.Child("Food")
		    StatInfos(5) = StatusComponent.Child("Water")
		    StatInfos(6) = StatusComponent.Child("Temperature")
		    StatInfos(7) = StatusComponent.Child("Weight")
		    StatInfos(8) = StatusComponent.Child("MeleeDamageMultiplier")
		    StatInfos(9) = StatusComponent.Child("SpeedMultiplier")
		    StatInfos(10) = StatusComponent.Child("Fortitude")
		    StatInfos(11) = StatusComponent.Child("CraftingSpeedMultiplier")
		    
		    Var UsedStats As Integer = 0
		    Var UsesOxygenWild As Boolean = StatusComponent.Lookup("bCanSuffocate", True).BooleanValue
		    Var UsesOxygenTamed As Boolean = UsesOxygenWild Or StatusComponent.Lookup("bCanSuffocateIfTamed", False).BooleanValue
		    Var ForceOxygen As Boolean = StatusComponent.Lookup("bForceGainOxygen", False).BooleanValue
		    Var DoesntUseOxygen As Boolean = Not (UsesOxygenTamed Or ForceOxygen)
		    Var IsFlyer As Boolean = Properties.Lookup("bIsFlyerDino", False).BooleanValue
		    
		    For StatIndex As Integer = 0 To StatInfos.LastIndex
		      Var StatInfo As JSONMBS = StatInfos(StatIndex)
		      Var CanLevel As Boolean = StatIndex = 2 Or StatInfo.Value("CanLevelUpValue").BooleanValue
		      Var DontUse As Boolean = StatInfo.Value("DontUseValue").BooleanValue
		      If DontUse = False And Not (StatIndex = 3 And DoesntUseOxygen) Then
		        UsedStats = UsedStats Or Bitwise.ShiftLeft(1, StatIndex)
		      End If
		      If DontUse And Not CanLevel Then
		        Continue
		      End If
		      
		      Var WildMultiplier As Integer = If(CanLevel, 1, 0)
		      Var DomesticMultiplier As Integer = If(StatIndex = 9 And IsFlyer, 1, WildMultiplier)
		      Var ExtraTamedHealthMultiplier As Double = 1.0
		      If StatIndex = 0 Then
		        ExtraTamedHealthMultiplier = StatusComponent.Lookup("ExtraTamedHealthMultiplier", 1.35)
		      End If
		      
		      Var WildPerLevel As Double = StatInfo.Value("WildPerLevel")
		      If StatIndex = 2 Then
		        WildPerLevel = StatusComponent.Lookup("TheMaxTorporIncreasePerBaseLevel", 0.06)
		      End If
		      
		      Var Stat As ArkSA.Stat = ArkSA.Stats.WithIndex(StatIndex)
		      Var BaseValue As Double = StatInfo.Value("BaseValue") + AdditionalBaseValue(StatIndex)
		      Var PerLevelWildMultiplier As Double = WildPerLevel * WildMultiplier
		      Var PerLevelTamedMultiplier As Double = StatInfo.Value("TamedPerLevel").DoubleValue * ExtraTamedHealthMultiplier * DomesticMultiplier
		      Var AddMultiplier As Double = StatInfo.Value("TamingReward")
		      Var AffinityMultiplier As Double = StatInfo.Value("EffectivenessReward")
		      Creature.AddStatValue(New ArkSA.CreatureStatValue(Stat, BaseValue, PerLevelWildMultiplier, PerLevelTamedMultiplier, AddMultiplier, AffinityMultiplier))
		    Next
		    Creature.StatsMask = UsedStats
		  Else
		    Creature.StatsMask = 0
		  End If
		  
		  If Self.mBossPaths.HasKey(Path) Then
		    Creature.AddTag("boss")
		  End If
		  
		  If Self.mTags.HasKey(Path) Then
		    Var Tags() As String = Self.mTags.Value(Path)
		    Creature.AddTags(Tags)
		  End If
		  
		  Self.AddBlueprint(Creature)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SyncItem(Path As String)
		  Var ContentPackId As String = Self.ContentPackIdForPath(Path)
		  If ContentPackId = Self.OfficialContentPackId Then
		    Return
		  End If
		  Var Pack As Beacon.ContentPack = Self.mContentPacks.Value(ContentPackId)
		  
		  Var Properties As JSONMBS = Self.PropertiesForPath(Path)
		  
		  Var ItemName As String = Properties.Lookup("DescriptiveNameBase", "").StringValue.ReplaceLineEndings(" ")
		  If ItemName.IsEmpty Then
		    ItemName = ArkSA.LabelFromClassString(Path.NthField(".", 2))
		  End If
		  
		  Var ItemId As String = Self.CreateObjectId(Path, ContentPackId)
		  Var Item As New ArkSA.MutableEngram(Path, ItemId)
		  Item.Availability = ArkSA.Maps.UniversalMask
		  Item.ContentPackId = ContentPackId
		  Item.ContentPackName = Pack.Name
		  Item.StackSize = Properties.Lookup("MaxItemQuantity", 1).IntegerValue
		  Item.Label = ItemName
		  
		  If Self.mUnlockDetails.HasKey(Path) Then
		    Var UnlockDetails As Dictionary = Self.mUnlockDetails.Value(Path)
		    Item.EntryString = UnlockDetails.Value("UnlockString")
		    Item.RequiredPlayerLevel = NullableDouble.FromVariant(UnlockDetails.Value("RequiredLevel"))
		    Item.RequiredUnlockPoints = NullableDouble.FromVariant(UnlockDetails.Value("RequiredPoints"))
		  End If
		  
		  Var Ingredients() As ArkSA.CraftingCostIngredient
		  If Properties.HasChild("BaseCraftingResourceRequirements") Then
		    Var BaseCraftingResourceRequirements As JSONMBS = Properties.Child("BaseCraftingResourceRequirements")
		    If (BaseCraftingResourceRequirements Is Nil) = False And BaseCraftingResourceRequirements.IsNull = False And BaseCraftingResourceRequirements.IsArray = True Then
		      For Idx As Integer = 0 To BaseCraftingResourceRequirements.LastRowIndex
		        Var Requirement As JSONMBS = BaseCraftingResourceRequirements.ChildAt(Idx)
		        Var Quantity As Integer = Requirement.Value("BaseResourceRequirement")
		        Var RequireExact As Boolean = Requirement.Value("bCraftingRequireExactResourceType")
		        Var IngredientPath As String = Self.NormalizePath(Requirement.Child("ResourceItemType").Value("ObjectPath"))
		        Var IngredientId As String = Self.CreateObjectId(IngredientPath)
		        Var Ingredient As New ArkSA.CraftingCostIngredient(New ArkSA.BlueprintReference(ArkSA.BlueprintReference.KindEngram, IngredientId, IngredientPath), Quantity, RequireExact)
		        Ingredients.Add(Ingredient)
		      Next
		    End If
		  End If
		  Item.Recipe = Ingredients
		  
		  If Properties.HasKey("GenericQuality") Then
		    Var StatInfos(7) As JSONMBS
		    StatInfos(0) = Properties.Child("GenericQuality")
		    StatInfos(1) = Properties.Child("Armor")
		    StatInfos(2) = Properties.Child("MaxDurability")
		    StatInfos(3) = Properties.Child("WeaponDamagePercent")
		    StatInfos(4) = Properties.Child("WeaponClipAmmo")
		    StatInfos(5) = Properties.Child("HypothermalInsulation")
		    StatInfos(6) = Properties.Child("Weight")
		    StatInfos(7) = Properties.Child("HyperthermalInsulation")
		    
		    For StatIndex As Integer = 0 To StatInfos.LastIndex
		      Var StatInfo As JSONMBS = StatInfos(StatIndex)
		      If StatInfo.Value("Used").BooleanValue = False Then
		        Continue
		      End If
		      
		      Var RandomizerRangeOverride As Double = StatInfo.Value("RandomizerRangeOverride")
		      Var RandomizerRangeMultiplier As Double = StatInfo.Value("RandomizerRangeMultiplier")
		      Var StateModifierScale As Double = StatInfo.Value("StateModifierScale")
		      Var RatingValueMultiplier As Double = StatInfo.Value("RatingValueMultiplier")
		      Var InitialValueConstant As Double = StatInfo.Value("InitialValueConstant").DoubleValue + If(StatInfo.Value("DisplayAsPercent").BooleanValue, 100.0, 0.0)
		      Var Stat As New ArkSA.EngramStat(StatIndex, RandomizerRangeOverride, RandomizerRangeMultiplier, StateModifierScale, RatingValueMultiplier, InitialValueConstant)
		      Item.Stat(StatIndex) = Stat
		    Next
		  End If
		  
		  If Properties.Lookup("bTekItem", False).BooleanValue Then
		    Item.AddTag("tek")
		  End If
		  
		  If Properties.Lookup("bCanBeBlueprint", true).BooleanValue Then
		    Item.AddTag("blueprintable")
		  End If
		  
		  If Properties.Lookup("bIsEgg", False).BooleanValue Then
		    Item.AddTag("egg")
		  End If
		  
		  If Self.mTags.HasKey(Path) Then
		    Var Tags() As String = Self.mTags.Value(Path)
		    Item.AddTags(Tags)
		  End If
		  
		  Self.AddBlueprint(Item)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SyncLootDrop(Path As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SyncSpawnContainer(Path As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TagsForPath(Path As String) As String()
		  Var Tags() As String
		  If Self.mTags.HasKey(Path) Then
		    Tags = Self.mTags.Value(Path)
		  End If
		  Return Tags
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WasSuccessful() As Boolean
		  Return Self.mSuccess
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ContentPackDiscovered(ContentPack As Beacon.ContentPack, Blueprints() As ArkSA.Blueprint)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(ErrorMessage As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Finished()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Started()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event StatusUpdated()
	#tag EndHook


	#tag Property, Flags = &h21
		Private Shared mActiveInstance As ArkSA.ModDiscoveryEngine2
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBossPaths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContentPackIdsByPackage As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContentPacks As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCreaturePaths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFoundBlueprints As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInventoryNames As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mItemPaths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLootPaths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPathsScanned As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPropertiesCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRoot As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSettings As ArkSA.ModDiscoverySettings
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSpawnPaths As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStatusMessage As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSuccess As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTags As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mThread As Beacon.Thread
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUnlockDetails As Dictionary
	#tag EndProperty


	#tag Constant, Name = OfficialContentPackId, Type = String, Dynamic = False, Default = \"b32a3d73-9406-56f2-bd8f-936ee0275249", Scope = Private
	#tag EndConstant


	#tag Enum, Name = LootDropType, Flags = &h21
		Regular
		  Dino
		Boss
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
