#tag Class
Protected Class ImportThread
Inherits Beacon.Thread
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
	#tag Event
		Sub Run()
		  Self.mFinished = False
		  Self.mCancelled = False
		  Self.mCreatedProject = Nil
		  Self.mError = Nil
		  
		  If Self.mProgress Is Nil Then
		    Self.mProgress = New Beacon.DummyProgressDisplayer
		  End If
		  
		  Try
		    Var Project As Ark.Project = Self.RunSynchronous(Self.mData, Self.mDestinationProject, Self.mProgress)
		    If Self.mCancelled Then
		      Return
		    End If
		    
		    Self.mCreatedProject = Project
		    Self.mFinished = True
		  Catch Err As RuntimeException
		    Self.mFinished = True
		    Self.mError = Err
		  End Try
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Sub AddCharactersParsed(CharacterCount As Integer, TotalCharacters As Integer, Progress As Beacon.ProgressDisplayer, ByRef CharactersProcessed As Integer)
		  CharactersProcessed = CharactersProcessed + CharacterCount
		  Var Percent As Double = CharactersProcessed / TotalCharacters
		  Progress.Progress = Percent
		  Progress.Detail = "Parsing files (" + Percent.ToString(Locale.Current, "0%") + "%)…"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function BuildProject(Data As Ark.DiscoveredData, DestinationProject As Ark.Project, Progress As Beacon.ProgressDisplayer, ParsedData As Dictionary, CommandLineOptions As Dictionary) As Ark.Project
		  Var Profile As Ark.ServerProfile
		  If (Data Is Nil) = False And (Data.Profile Is Nil) = False Then
		    Profile = Data.Profile
		  End If
		  
		  Var Project As New Ark.Project
		  If (Profile Is Nil) = False Then
		    Project.MapMask = Profile.Mask
		  End If
		  If Project.MapMask = CType(0, UInt64) Then
		    Project.MapMask = Ark.Maps.TheIsland.Mask
		  End If
		  If ParsedData.HasKey("SessionName") Then
		    Var SessionNames() As Variant = ParsedData.AutoArrayValue("SessionName")
		    For Each SessionName As Variant In SessionNames
		      Try
		        Project.Title = SessionName.StringValue.GuessEncoding
		        Exit
		      Catch Err As RuntimeException
		      End Try
		    Next
		  End If
		  
		  If CommandLineOptions Is Nil Then
		    CommandLineOptions = New Dictionary
		  End If
		  
		  If (Data Is Nil) = False And Data.IsPrimitivePlus Then
		    Project.ContentPackEnabled("68d1be8b-a66e-41a2-b0b4-cb2a724fc80b") = True
		  End If
		  
		  If ParsedData.HasKey("ActiveMods") And IsNull(ParsedData.Value("ActiveMods")) = False Then
		    Var ActiveMods As String = ParsedData.StringValue("ActiveMods", "")
		    Var ModIDs() As String = ActiveMods.Split(",")
		    For Each ModId As String In ModIDs
		      Var ContentPack As Beacon.ContentPack = Ark.DataSource.Pool.Get(False).GetContentPackWithSteamId(ModId)
		      If (ContentPack Is Nil) = False Then
		        Project.ContentPackEnabled(ContentPack) = True
		      End If
		    Next
		  End If
		  
		  If (DestinationProject Is Nil) = False Then
		    Var DestinationPacks As Beacon.StringList = DestinationProject.ContentPacks
		    For Each PackUUID As String In DestinationPacks
		      Project.ContentPackEnabled(PackUUID) = True
		    Next PackUUID
		  End If
		  
		  Try
		    Var Maps() As Ark.Map = Project.Maps
		    Var DifficultyTotal, DifficultyScale As Double
		    For Each Map As Ark.Map In Maps
		      DifficultyTotal = DifficultyTotal + Map.DifficultyScale
		    Next
		    DifficultyScale = DifficultyTotal / Maps.Count
		    
		    Var ImpliedDifficulty As Boolean
		    Var DifficultyValue As Double
		    If CommandLineOptions.HasKey("OverrideOfficialDifficulty") And CommandLineOptions.DoubleValue("OverrideOfficialDifficulty") > 0 Then
		      DifficultyValue = CommandLineOptions.DoubleValue("OverrideOfficialDifficulty")
		    ElseIf ParsedData.HasKey("OverrideOfficialDifficulty") And ParsedData.DoubleValue("OverrideOfficialDifficulty") > 0 Then
		      DifficultyValue = ParsedData.DoubleValue("OverrideOfficialDifficulty")
		    ElseIf ParsedData.HasKey("DifficultyOffset") Then
		      DifficultyValue = ParsedData.DoubleValue("DifficultyOffset") * (DifficultyScale - 0.5) + 0.5
		    ElseIf (DestinationProject Is Nil) = False Then
		      DifficultyValue = DestinationProject.Difficulty.DifficultyValue
		      ImpliedDifficulty = True
		    Else
		      DifficultyValue = DifficultyScale
		      ImpliedDifficulty = True
		    End If
		    
		    Var DifficultyConfig As New Ark.Configs.Difficulty(DifficultyValue)
		    DifficultyConfig.IsImplicit = ImpliedDifficulty
		    Project.AddConfigGroup(DifficultyConfig)
		  Catch Err As RuntimeException
		  End Try
		  
		  If (Profile Is Nil) = False Then
		    Profile.Name = Project.Title
		    
		    Var ServerPassword, AdminPassword, SpectatorPassword As String
		    If ParsedData.HasKey("ServerPassword") Then
		      ServerPassword = ParsedData.StringValue("ServerPassword", "")
		    ElseIf CommandLineOptions.HasKey("ServerPassword") Then
		      ServerPassword = CommandLineOptions.StringValue("ServerPassword", "")
		    End If
		    If CommandLineOptions.HasKey("SpectatorPassword") Then
		      SpectatorPassword = CommandLineOptions.StringValue("SpectatorPassword", "")
		    ElseIf ParsedData.HasKey("SpectatorPassword") Then
		      SpectatorPassword = ParsedData.StringValue("SpectatorPassword", "")
		    End If
		    If CommandLineOptions.HasKey("ServerAdminPassword") Then
		      AdminPassword = CommandLineOptions.StringValue("ServerAdminPassword", "")
		    ElseIf ParsedData.HasKey("ServerAdminPassword") Then
		      AdminPassword = ParsedData.StringValue("ServerAdminPassword", "")
		    End If
		    Profile.ServerPassword = ServerPassword
		    Profile.SpectatorPassword = SpectatorPassword
		    Profile.AdminPassword = AdminPassword
		    
		    If ParsedData.HasKey("Message") Then
		      Var Duration As Integer = 30
		      If ParsedData.HasKey("Duration") Then
		        Duration = Round(ParsedData.DoubleValue("Duration", 30, True))
		      End If
		      
		      Profile.MessageOfTheDay = Ark.ArkML.FromArkML(ParsedData.StringValue("Message", "", True).Trim())
		      Profile.MessageDuration = Duration
		    End If
		    
		    Project.AddServerProfile(Profile)
		  End If
		  
		  Var ConfigNames() As String = Ark.Configs.AllNames()
		  Var Identity As Beacon.Identity = App.IdentityManager.CurrentIdentity
		  Var Configs() As Ark.ConfigGroup
		  For Each ConfigName As String In ConfigNames
		    If ConfigName = Ark.Configs.NameDifficulty Or ConfigName = Ark.Configs.NameCustomConfig Then
		      // Difficulty and custom content are special
		      Continue For ConfigName
		    End If
		    
		    If Ark.Configs.ConfigUnlocked(ConfigName, Identity) = False Then
		      // Do not import code for groups that the user has not purchased
		      Continue For ConfigName
		    End If
		    
		    Progress.Message = "Building Beacon project… (" + Language.LabelForConfig(ConfigName) + ")"
		    Var Group As Ark.ConfigGroup
		    Try
		      Group = Ark.Configs.CreateInstance(ConfigName, ParsedData, CommandLineOptions, Project)
		    Catch Err As RuntimeException
		    End Try
		    If Group <> Nil Then
		      Project.AddConfigGroup(Group)
		      Configs.Add(Group)
		    End If
		  Next
		  
		  // Now split the content into values and remove the ones controlled by the imported groups
		  Progress.Message = "Building Beacon project… (" + Language.LabelForConfig(Ark.Configs.NameCustomConfig) + ")"
		  Var CustomConfigOrganizer As New Ark.ConfigOrganizer(Ark.ConfigFileGame, Ark.HeaderShooterGame, Data.GameIniContent)
		  CustomConfigOrganizer.Add(Ark.ConfigFileGameUserSettings, Ark.HeaderServerSettings, Data.GameUserSettingsIniContent)
		  For Each Config As Ark.ConfigGroup In Configs
		    Var ManagedKeys() As Ark.ConfigOption = Config.ManagedKeys()
		    CustomConfigOrganizer.Remove(ManagedKeys)
		  Next
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGameUserSettings, "/Game/PrimalEarth/CoreBlueprints/TestGameMode.TestGameMode_C")
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGameUserSettings, "/Script/Engine.GameSession")
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGameUserSettings, "/Script/ShooterGame.ShooterGameUserSettings")
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGameUserSettings, "ScalabilityGroups")
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGameUserSettings, "ScalabilityGroups.sg")
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGameUserSettings, "Beacon")
		  CustomConfigOrganizer.Remove(Ark.ConfigFileGame, "Beacon")
		  
		  Var CustomContent As New Ark.Configs.CustomContent
		  Try
		    CustomContent.GameIniContent() = CustomConfigOrganizer
		  Catch Err As RuntimeException
		  End Try
		  Try
		    CustomContent.GameUserSettingsIniContent() = CustomConfigOrganizer
		  Catch Err As RuntimeException
		  End Try
		  If CustomContent.Modified Then
		    Project.AddConfigGroup(CustomContent)
		  End If
		  
		  Return Project
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cancel()
		  Self.mCancelled = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Data As Ark.DiscoveredData, DestinationProject As Ark.Project)
		  Self.mData = Data
		  Self.mDestinationProject = DestinationProject
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Error() As RuntimeException
		  Return Self.mError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Errored() As Boolean
		  Return (Self.mError Is Nil) = False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Finished() As Boolean
		  Return Self.mFinished
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Import(Content As String, TotalCharacters As Integer, Progress As Beacon.ProgressDisplayer, ByRef CharactersProcessed As Integer) As Variant
		  Var Parser As New Ark.ConfigParser
		  Var Value As Variant
		  Var Characters() As String = Content.Split("")
		  For Each Char As String In Characters
		    If Progress.CancelPressed Then
		      Return Nil
		    End If
		    
		    If Parser.AddCharacter(Char) Then
		      Value = Parser.Value
		      Exit
		    End If
		    
		    AddCharactersParsed(1, TotalCharacters, Progress, CharactersProcessed)
		  Next
		  
		  Return ToXojoType(Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function LineEndingChar() As String
		  Return Encodings.UTF8.Chr(10)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As String
		  Var Name As String
		  If (Self.mData Is Nil) = False And (Self.mData.Profile Is Nil) = False Then
		    Name = Self.mData.Profile.Name
		  End If
		  If Name.IsEmpty Then
		    Name = "Untitled Importer"
		  End If
		  Return Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Progress() As Beacon.ProgressDisplayer
		  Return Self.mProgress
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Progress(Assigns Displayer As Beacon.ProgressDisplayer)
		  Var OldDisplayer As Beacon.ProgressDisplayer = Self.mProgress
		  Self.mProgress = Displayer
		  If (OldDisplayer Is Nil) = False And (Self.mProgress Is Nil) = False Then
		    Self.mProgress.Detail = OldDisplayer.Detail
		    Self.mProgress.Message = OldDisplayer.Message
		    Self.mProgress.Progress = OldDisplayer.Progress
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Project() As Ark.Project
		  Return Self.mCreatedProject
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function RunSynchronous(Data As Ark.DiscoveredData, DestinationProject As Ark.Project, Progress As Beacon.ProgressDisplayer) As Ark.Project
		  Progress.Message = "Importing…"
		  Progress.Detail = "Cleaning up files…"
		  Progress.Progress = Nil
		  Progress.ShowSubProgress = False
		  
		  Var LineEnding As String = LineEndingChar()
		  
		  // Normalize line endings
		  Var Content As String
		  If (Data Is Nil) = False Then
		    Var Blocks() As String
		    
		    Var GameUserSettingsIniContent As String = Data.GameUserSettingsIniContent.ReplaceLineEndings(LineEnding)
		    If GameUserSettingsIniContent.IsEmpty = False Then
		      If GameUserSettingsIniContent.BeginsWith("[") = False Then
		        GameUserSettingsIniContent = "[" + Ark.HeaderServerSettings + "]" + LineEnding + GameUserSettingsIniContent
		      End If
		      Blocks.Add(GameUserSettingsIniContent)
		    End If
		    
		    Var GameIniContent As String = Data.GameIniContent.ReplaceLineEndings(LineEnding)
		    If GameIniContent.IsEmpty = False Then
		      If GameIniContent.BeginsWith("[") = False Then
		        GameIniContent = "[" + Ark.HeaderShooterGame + "]" + LineEnding + GameIniContent
		      End If
		      Blocks.Add(GameIniContent)
		    End If
		    
		    Content = Blocks.Join(LineEnding)
		  End If
		  
		  // Fix smart quotes
		  Content = Content.SanitizeIni
		  
		  // The UWP/Windows Store version uses Ark.HeaderShooterGameUWP instead of Ark.HeaderShooterGame because it's inbred
		  If Content.IndexOf("[" + Ark.HeaderShooterGameUWP + "]") > -1 Then
		    Content = Content.ReplaceAll(Ark.HeaderShooterGameUWP, Ark.HeaderShooterGame)
		    Data.GameIniContent = Data.GameIniContent.ReplaceAll(Ark.HeaderShooterGameUWP, Ark.HeaderShooterGame)
		  End If
		  
		  Var CharactersProcessed As Integer
		  Var CharactersTotal As Integer = Content.Length
		  Var CurrentHeader As String
		  Var MessageOfTheDayMode As Boolean = False
		  Var ParsedData As New Dictionary
		  Var Lines() As String = Content.Split(LineEnding)
		  CharactersTotal = CharactersTotal + ((Lines.LastIndex + 1) * LineEnding.Length) // To account for the trailing line ending characters we're adding
		  
		  Progress.Detail = "Parsing files…"
		  AddCharactersParsed(0, CharactersTotal, Progress, CharactersProcessed)
		  
		  For Each Line As String In Lines
		    If Progress.CancelPressed Then
		      Return Nil
		    End If
		    
		    Var CharacterCount As Integer = Line.Length + LineEnding.Length
		    
		    If Line.BeginsWith("[") And Line.EndsWith("]") Then
		      CurrentHeader = Line.Middle(1, Line.Length - 2)
		      MessageOfTheDayMode = (CurrentHeader = "MessageOfTheDay")
		    End If
		    
		    If MessageOfTheDayMode Then
		      Try
		        If Line.BeginsWith("Duration=") Then
		          Var Duration As Integer = Integer.FromString(Line.Middle(9))
		          ParsedData.Value("Duration") = Duration
		          ParsedData.Value("MessageOfTheDay.Duration") = Duration
		        Else
		          Var Message As String
		          If Line.BeginsWith("Message=") Then
		            Line = Line.Middle(8)
		          Else
		            Message = ParsedData.Lookup("MessageOfTheDay.Message", "")
		          End If
		          If Message.IsEmpty Then
		            Message = Line
		          Else
		            Message = Message + LineEnding + Line
		          End If
		          ParsedData.Value("Message") = Message
		          ParsedData.Value("MessageOfTheDay.Message") = Message
		        End If
		      Catch Err As RuntimeException
		      End Try
		      
		      AddCharactersParsed(CharacterCount, CharactersTotal, Progress, CharactersProcessed)
		      Continue
		    End If
		    
		    If Line.IsEmpty Or Line.BeginsWith(";") Then
		      AddCharactersParsed(CharacterCount, CharactersTotal, Progress, CharactersProcessed)
		      Continue
		    End If
		    
		    Try
		      Var Value As Variant = Import(Line + LineEnding, CharactersTotal, Progress, CharactersProcessed)
		      If Value = Nil Then
		        Continue
		      End If
		      If Value.Type <> Variant.TypeObject Or Value IsA Beacon.KeyValuePair = False Then
		        Continue
		      End If
		      
		      Var Key As String = Beacon.KeyValuePair(Value).Key
		      Var ExtendedKey As String = CurrentHeader + "." + Key
		      Value = Beacon.KeyValuePair(Value).Value
		      
		      If ParsedData.HasKey(Key) Then
		        Var ExistingValue As Variant = ParsedData.Value(Key)
		        
		        Var ValueArray() As Variant
		        If ExistingValue.IsArray Then
		          ValueArray = ExistingValue
		        Else
		          ValueArray.Add(ExistingValue)
		        End If
		        ValueArray.Add(Value)
		        ParsedData.Value(Key) = ValueArray
		      Else
		        ParsedData.Value(Key) = Value
		      End If
		      
		      If ParsedData.HasKey(ExtendedKey) Then
		        Var ExistingValue As Variant = ParsedData.Value(ExtendedKey)
		        
		        Var ValueArray() As Variant
		        If ExistingValue.IsArray Then
		          ValueArray = ExistingValue
		        Else
		          ValueArray.Add(ExistingValue)
		        End If
		        ValueArray.Add(Value)
		        ParsedData.Value(ExtendedKey) = ValueArray
		      Else
		        ParsedData.Value(ExtendedKey) = Value
		      End If
		    Catch Err As RuntimeException
		      // Don't let an error halt processing, skip and move on
		    End Try
		    
		    Thread.SleepCurrent(10)
		  Next
		  CharactersProcessed = CharactersTotal
		  
		  Progress.Detail = "Building Beacon project…"
		  Try
		    Var CommandLineOptions As Dictionary
		    If (Data Is Nil) = False Then
		      CommandLineOptions = Data.CommandLineOptions
		    End If
		    Return BuildProject(Data, DestinationProject, Progress, ParsedData, CommandLineOptions)
		  Catch Err As RuntimeException
		  End Try
		  Progress.Detail = "Finished"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ToXojoType(Input As Variant) As Variant
		  If Input = Nil Then
		    Return Nil
		  End If
		  
		  If Input.IsArray And Input.ArrayElementType = Variant.TypeObject Then
		    Var ArrayValue() As Variant = Input
		    Var IsDict As Boolean = True
		    For Each Item As Variant In ArrayValue
		      IsDict = IsDict And Item.Type = Variant.TypeObject And Item.ObjectValue IsA Beacon.KeyValuePair
		    Next
		    If IsDict Then
		      Var Dict As New Dictionary
		      For Each Item As Beacon.KeyValuePair In ArrayValue
		        Dict.Value(Item.Key) = ToXojoType(Item.Value)
		      Next
		      Return Dict
		    Else
		      Var Items() As Variant
		      For Each Item As Variant In ArrayValue
		        Items.Add(ToXojoType(Item))
		      Next
		      Return Items
		    End If
		  End If
		  
		  Select Case Input.Type
		  Case Variant.TypeObject
		    Var ObjectValue As Object = Input.ObjectValue
		    Select Case ObjectValue
		    Case IsA Beacon.KeyValuePair
		      Var Original As Beacon.KeyValuePair = Input
		      Return New Beacon.KeyValuePair(Original.Key, ToXojoType(Original.Value))
		    End Select
		  Case Variant.TypeString
		    Var StringValue As String = Input.StringValue
		    If StringValue = "true" Then
		      Return True
		    ElseIf StringValue = "false" Then
		      Return False
		    Else
		      Var IsNumeric As Boolean
		      If StringValue.Length > 0 Then
		        IsNumeric = True
		        Var DecimalPoints As Integer
		        Var Characters() As String = StringValue.Split("")
		        For Each Char As String In Characters
		          Select Case Char
		          Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
		            // Still a Number
		          Case "."
		            If DecimalPoints = 1 Then
		              IsNumeric = False
		              Exit
		            Else
		              DecimalPoints = 1
		            End If
		          Else
		            IsNumeric = False
		            Exit
		          End Select
		        Next
		      End If
		      If IsNumeric Then
		        // Number
		        Return Double.FromString(StringValue, Locale.Raw)
		      Else
		        // Probably String
		        Return StringValue
		      End If
		    End If
		  End Select
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Finished(Project As Ark.Project)
	#tag EndHook


	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCreatedProject As Ark.Project
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mData As Ark.DiscoveredData
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDestinationProject As Ark.Project
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mError As RuntimeException
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFinished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mProgress As Beacon.ProgressDisplayer
	#tag EndProperty


	#tag ViewBehavior
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
		#tag ViewProperty
			Name="DebugIdentifier"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadState"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ThreadStates"
			EditorType="Enum"
			#tag EnumValues
				"0 - Running"
				"1 - Waiting"
				"2 - Paused"
				"3 - Sleeping"
				"4 - NotRunning"
			#tag EndEnumValues
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
	#tag EndViewBehavior
End Class
#tag EndClass
