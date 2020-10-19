#tag Class
 Attributes ( OmniVersion = 1 ) Protected Class EngramControl
Inherits Beacon.ConfigGroup
	#tag Event
		Sub GameIniValues(SourceDocument As Beacon.Document, Values() As Beacon.ConfigValue, Profile As Beacon.ServerProfile)
		  #Pragma Unused Profile
		  
		  Var Levels As Integer = Self.LevelsDefined
		  Var OfficialLevels As Beacon.PlayerLevelData = Beacon.Data.OfficialPlayerLevelData
		  For Level As Integer = 1 To Levels
		    Var PointsForLevel As NullableDouble = Self.PointsForLevel(Level)
		    
		    Var Points As Integer
		    If Self.AutoUnlockAllEngrams Then
		      Points = 0
		    Else
		      If IsNull(PointsForLevel) Then
		        Points = OfficialLevels.PointsForLevel(Level)
		      Else
		        Points = PointsForLevel.IntegerValue
		      End If
		    End If
		    
		    Values.Add(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "OverridePlayerLevelEngramPoints", Points.ToString))
		  Next
		  
		  Values.Add(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "bOnlyAllowSpecifiedEngrams", If(Self.OnlyAllowSpecifiedEngrams, "True", "False")))
		  Values.Add(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "bAutoUnlockAllEngrams", If(Self.AutoUnlockAllEngrams, "True", "False")))
		  
		  Var UnlockEntries(), OverrideEntries() As String
		  Var UnlockConfigs(), OverrideConfigs() As Beacon.ConfigValue
		  Var Whitelisting As Boolean = Self.OnlyAllowSpecifiedEngrams
		  For Each Entry As DictionaryEntry In Self.mBehaviors
		    Var Behaviors As Dictionary = Entry.Value
		    Var UUID As String = Entry.Key
		    
		    // Get the entry string from the engram if available, or use the backup if not available.
		    Var Engram As Beacon.Engram = Beacon.Data.GetEngramByID(UUID)
		    If (Engram Is Nil) Or SourceDocument.ModEnabled(Engram.ModID) = False Then
		      // Don't include items for disabled mods
		      Continue
		    End If
		    
		    Var EntryString As String
		    If Engram <> Nil And Engram.HasUnlockDetails Then
		      EntryString = Engram.EntryString
		    ElseIf Behaviors.HasKey(Self.KeyEntryString) Then
		      EntryString = Behaviors.Value(Self.KeyEntryString)
		    End If
		    If EntryString.IsEmpty Then
		      Continue
		    End If
		    
		    Var AutoUnlocked As Boolean = Self.AutoUnlockAllEngrams
		    If Self.mAutoUnlockAllEngrams = False And Behaviors.HasKey(Self.KeyAutoUnlockLevel) And Behaviors.Value(Self.KeyAutoUnlockLevel).BooleanValue = True Then
		      Var Level As Integer
		      If Behaviors.HasKey(Self.KeyPlayerLevel) And IsNull(Behaviors.Value(Self.KeyPlayerLevel)) = False Then
		        Level = Behaviors.Value(Self.KeyPlayerLevel).IntegerValue
		      ElseIf IsNull(Engram.RequiredPlayerLevel) = False Then
		        Level = Engram.RequiredPlayerLevel.IntegerValue
		      Else
		        Level = 0
		      End If
		      
		      AutoUnlocked = True
		      UnlockEntries.Add(EntryString)
		      UnlockConfigs.Add(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "EngramEntryAutoUnlocks", "(EngramClassName=""" + EntryString + """,LevelToAutoUnlock=" + Level.ToString + ")"))
		    End If
		    
		    Var Arguments() As String
		    If Behaviors.HasKey(Self.KeyHidden) Then
		      Var Hidden As Boolean = Behaviors.Value(Self.KeyHidden).BooleanValue
		      If Hidden <> Whitelisting Then
		        Arguments.Add("EngramHidden=" + If(Hidden, "True", "False"))
		      End If
		    End If
		    
		    If Not AutoUnlocked Then
		      If Not Self.EffectivelyHidden(Engram) Then
		        If Behaviors.HasKey(Self.KeyRemovePrerequisites) Then
		          Var RemovePrereq As Boolean = Behaviors.Value(Self.KeyRemovePrerequisites).BooleanValue
		          If RemovePrereq = True Then
		            Arguments.Add("RemoveEngramPreReq=True")
		          End If
		        End If
		        
		        If Behaviors.HasKey(Self.KeyPlayerLevel) Then
		          Var Level As Integer = Round(Behaviors.Value(Self.KeyPlayerLevel).DoubleValue)
		          Arguments.Add("EngramLevelRequirement=" + Level.ToString)
		        Else
		          Var Level As NullableDouble = Engram.RequiredPlayerLevel
		          If (Level Is Nil) = False Then
		            Arguments.Add("EngramLevelRequirement=" + Level.IntegerValue.ToString)
		          End If
		        End If
		        
		        If Behaviors.HasKey(Self.KeyUnlockPoints) Then
		          Var Points As Integer = Round(Behaviors.Value(Self.KeyUnlockPoints).DoubleValue)
		          Arguments.Add("EngramPointsCost=" + Points.ToString)
		        Else
		          Var Points As NullableDouble = Engram.RequiredUnlockPoints
		          If (Points Is Nil) = False Then
		            Arguments.Add("EngramPointsCost=" + Points.IntegerValue.ToString)
		          End If
		        End If
		      End If
		    End If
		    
		    If Arguments.LastIndex > -1 Then
		      Arguments.AddAt(0, "EngramClassName=""" + EntryString + """")
		      OverrideEntries.Add(EntryString)
		      OverrideConfigs.Add(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "OverrideNamedEngramEntries", "(" + Arguments.Join(",") + ")"))
		    End If
		  Next
		  
		  UnlockEntries.SortWith(UnlockConfigs)
		  OverrideEntries.SortWith(OverrideConfigs)
		  
		  For Each Config As Beacon.ConfigValue In UnlockConfigs
		    Values.Add(Config)
		  Next
		  For Each Config As Beacon.ConfigValue In OverrideConfigs
		    Values.Add(Config)
		  Next
		End Sub
	#tag EndEvent

	#tag Event
		Sub MergeFrom(Other As Beacon.ConfigGroup)
		  Var Source As BeaconConfigs.EngramControl = BeaconConfigs.EngramControl(Other)
		  For Each Entry As DictionaryEntry In Source.mBehaviors
		    Self.mBehaviors.Value(Entry.Key) = Entry.Value
		    Self.Modified = True
		  Next
		  
		  Self.mPointsPerLevel.ResizeTo(Max(Self.mPointsPerLevel.LastIndex, Source.mPointsPerLevel.LastIndex))
		  For Idx As Integer = 0 To Source.mPointsPerLevel.LastIndex
		    Self.mPointsPerLevel(Idx) = Source.mPointsPerLevel(Idx)
		    Self.Modified = True
		  Next
		End Sub
	#tag EndEvent

	#tag Event
		Sub NonGeneratedKeys(Keys() As Beacon.ConfigKey)
		  // Include all the keys here to prevent them from going into Custom Config when
		  // Beacon generates lines that are slightly different than imported.
		  
		  Keys.Add(New Beacon.ConfigKey("Game.ini", Beacon.ShooterGameHeader, "OverrideEngramEntries"))
		  Keys.Add(New Beacon.ConfigKey("Game.ini", Beacon.ShooterGameHeader, "OverrideNamedEngramEntries"))
		  Keys.Add(New Beacon.ConfigKey("Game.ini", Beacon.ShooterGameHeader, "bOnlyAllowSpecifiedEngrams"))
		  Keys.Add(New Beacon.ConfigKey("Game.ini", Beacon.ShooterGameHeader, "OverridePlayerLevelEngramPoints"))
		  Keys.Add(New Beacon.ConfigKey("Game.ini", Beacon.ShooterGameHeader, "bAutoUnlockAllEngrams"))
		  Keys.Add(New Beacon.ConfigKey("Game.ini", Beacon.ShooterGameHeader, "EngramEntryAutoUnlocks"))
		End Sub
	#tag EndEvent

	#tag Event
		Sub ReadDictionary(Dict As Dictionary, Identity As Beacon.Identity, Document As Beacon.Document)
		  #Pragma Unused Identity
		  #Pragma Unused Document
		  
		  If Dict.HasKey("Whitelist Mode") Then
		    Self.mOnlyAllowSpecifiedEngrams = Dict.Value("Whitelist Mode").BooleanValue
		  End If
		  
		  If Dict.HasKey("Auto Unlock All") Then
		    Self.mAutoUnlockAllEngrams = Dict.Value("Auto Unlock All").BooleanValue
		  End If
		  
		  If Dict.HasKey("Points Per Level") Then
		    Var Values() As Variant = Dict.Value("Points Per Level")
		    Self.mPointsPerLevel.ResizeTo(Values.LastIndex)
		    For Idx As Integer = Self.mPointsPerLevel.FirstRowIndex To Self.mPointsPerLevel.LastIndex
		      If IsNull(Values(Idx)) Then
		        Self.mPointsPerLevel(Idx) = Nil
		      Else
		        Self.mPointsPerLevel(Idx) = Values(Idx).IntegerValue
		      End If
		    Next
		  End If
		  
		  If Dict.HasKey("Behaviors") Then
		    Self.mBehaviors = Dict.Value("Behaviors")
		  ElseIf Dict.HasKey("Engrams") Then
		    Var Behaviors As Dictionary = Dict.Value("Engrams")
		    Var Mods As Beacon.StringList = Document.Mods
		    For Each Entry As DictionaryEntry In Behaviors
		      Var Path As String = Entry.Key
		      Var BehaviorDict As Dictionary = Entry.Value
		      Var Engram As Beacon.Engram = Beacon.ResolveEngram("", Path, "", Mods)
		      Self.BehaviorDict(Engram) = BehaviorDict
		    Next
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub WriteDictionary(Dict As Dictionary, Document As Beacon.Document, BlueprintsMap As Dictionary)
		  #Pragma Unused Document
		  
		  If Self.mBehaviors.KeyCount > 0 Then
		    Dict.Value("Behaviors") = Self.mBehaviors
		    
		    Var Engrams() As Beacon.Engram = Self.SpecifiedEngrams
		    For Each Engram As Beacon.Engram In Engrams
		      BlueprintsMap.Value(Engram.ObjectID.StringValue) = Engram
		    Next
		  End If
		  
		  If Self.mPointsPerLevel.LastIndex > -1 Then
		    Var Levels() As Variant
		    Var Bound As Integer = Self.LevelsDefined - 1
		    Levels.ResizeTo(Bound)
		    For I As Integer = 0 To Bound
		      If IsNull(Self.mPointsPerLevel(I)) Then
		        Levels(I) = Nil
		      Else
		        Levels(I) = Self.mPointsPerLevel(I).IntegerValue
		      End If
		    Next
		    Dict.Value("Points Per Level") = Levels
		  End If
		  
		  Dict.Value("Auto Unlock All") = Self.mAutoUnlockAllEngrams
		  Dict.Value("Whitelist Mode") = Self.mOnlyAllowSpecifiedEngrams
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Sub AddOverrideToConfig(Config As BeaconConfigs.EngramControl, Details As Dictionary, Mods As Beacon.StringList)
		  If Not Details.HasKey("EngramClassName") Then
		    Return
		  End If
		  
		  Try
		    Var EntryString As String = Details.Value("EngramClassName")
		    Var Engrams() As Beacon.Engram = Beacon.Data.GetEngramsByEntryString(EntryString, Mods)
		    If Engrams.Count = 0 Then
		      Engrams.Add(Beacon.Engram.CreateFromEntryString(EntryString))
		    End If
		    For Each Engram As Beacon.Engram In Engrams
		      If Details.HasKey("EngramHidden") Then
		        Config.Hidden(Engram) = Details.BooleanValue("EngramHidden", False)
		      End If
		      
		      If Details.HasKey("RemoveEngramPreReq") Then
		        Config.RemovePrerequisites(Engram) = Details.BooleanValue("RemoveEngramPreReq", False)
		      End If
		      
		      If Details.HasKey("EngramLevelRequirement") And Details.Value("EngramLevelRequirement").Type = Variant.TypeDouble Then
		        Config.RequiredPlayerLevel(Engram) = Details.Value("EngramLevelRequirement").DoubleValue
		      End If
		      
		      If Details.HasKey("EngramPointsCost") And Details.Value("EngramPointsCost").Type = Variant.TypeDouble Then
		        Config.RequiredPoints(Engram) = Details.Value("EngramPointsCost").DoubleValue
		      End If
		    Next
		  Catch Err As RuntimeException
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AutoUnlockEngram(Engram As Beacon.Engram) As NullableBoolean
		  Var Value As Variant = Self.BehaviorForEngram(Engram, Self.KeyAutoUnlockLevel)
		  If IsNull(Value) Then
		    Return Nil
		  Else
		    Return Value.BooleanValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AutoUnlockEngram(Engram As Beacon.Engram, Assigns ShouldUnlock As NullableBoolean)
		  If IsNull(ShouldUnlock) Then
		    Self.BehaviorForEngram(Engram, Self.KeyAutoUnlockLevel) = Nil
		  Else
		    Self.BehaviorForEngram(Engram, Self.KeyAutoUnlockLevel) = ShouldUnlock.BooleanValue
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BehaviorDict(Engram As Beacon.Engram) As Dictionary
		  If Self.mBehaviors.HasKey(Engram.ObjectID.StringValue) Then
		    Var Dict As Dictionary = Self.mBehaviors.Value(Engram.ObjectID.StringValue)
		    Return Dict.Clone
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BehaviorDict(Engram As Beacon.Engram, Assigns Dict As Dictionary)
		  If IsNull(Dict) Or Dict.HasKey(Self.KeyEntryString) = False Then
		    If Self.mBehaviors.HasKey(Engram.ObjectID.StringValue) Then
		      Self.mBehaviors.Remove(Engram.ObjectID.StringValue)
		      Self.Modified = True
		    End If
		    Return
		  End If
		  
		  Var Behavior As New Dictionary
		  Behavior.Value(Self.KeyEntryString) = Dict.Value(Self.KeyEntryString)
		  If Dict.HasKey(Self.KeyAutoUnlockLevel) And IsNull(Dict.Value(Self.KeyAutoUnlockLevel)) = False Then
		    Behavior.Value(Self.KeyAutoUnlockLevel) = Dict.Value(Self.KeyAutoUnlockLevel).IntegerValue
		  End If
		  If Dict.HasKey(Self.KeyHidden) And IsNull(Dict.Value(Self.KeyHidden)) = False Then
		    Behavior.Value(Self.KeyHidden) = Dict.Value(Self.KeyHidden).BooleanValue
		  End If
		  If Dict.HasKey(Self.KeyPlayerLevel) And IsNull(Dict.Value(Self.KeyPlayerLevel)) = False Then
		    Behavior.Value(Self.KeyPlayerLevel) = Dict.Value(Self.KeyPlayerLevel).IntegerValue
		  End If
		  If Dict.HasKey(Self.KeyRemovePrerequisites) And IsNull(Dict.Value(Self.KeyRemovePrerequisites)) = False Then
		    Behavior.Value(Self.KeyRemovePrerequisites) = Dict.Value(Self.KeyRemovePrerequisites).BooleanValue
		  End If
		  If Dict.HasKey(Self.KeyUnlockPoints) And IsNull(Dict.Value(Self.KeyUnlockPoints)) = False Then
		    Behavior.Value(Self.KeyUnlockPoints) = Dict.Value(Self.KeyUnlockPoints).IntegerValue
		  End If
		  
		  Self.mBehaviors.Value(Engram.ObjectID.StringValue) = Behavior
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BehaviorForEngram(Engram As Beacon.Engram, Key As String) As Variant
		  If Not Self.mBehaviors.HasKey(Engram.ObjectID.StringValue) Then
		    Return Nil
		  End If
		  
		  Var Dict As Dictionary = Self.mBehaviors.Value(Engram.ObjectID.StringValue)
		  If Dict.HasKey(Key) Then
		    Return Dict.Value(Key)
		  Else
		    Return Nil
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BehaviorForEngram(Engram As Beacon.Engram, Key As String, Assigns Value As Variant)
		  If IsNull(Value) Then
		    If Self.mBehaviors.HasKey(Engram.ObjectID.StringValue) = False Then
		      Return
		    End If
		    
		    Var Dict As Dictionary = Self.mBehaviors.Value(Engram.ObjectID.StringValue)
		    If Dict.HasKey(Key) = False Then
		      Return
		    End If
		    
		    Dict.Remove(Key)
		    If Engram.HasUnlockDetails Then
		      Dict.Value(Self.KeyEntryString) = Engram.EntryString
		    End If
		    Self.mBehaviors.Value(Engram.ObjectID.StringValue) = Dict
		    Self.Modified = True
		    
		    Return
		  End If
		  
		  Var Dict As Dictionary
		  If Self.mBehaviors.HasKey(Engram.ObjectID.StringValue) Then
		    Dict = Self.mBehaviors.Value(Engram.ObjectID.StringValue)
		  Else
		    Dict = New Dictionary
		  End If
		  
		  If Engram.HasUnlockDetails Then
		    Dict.Value(Self.KeyEntryString) = Engram.EntryString
		  End If
		  Dict.Value(Key) = Value
		  Self.mBehaviors.Value(Engram.ObjectID.StringValue) = Dict
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ConfigName() As String
		  Return ConfigKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor()
		  
		  Self.mBehaviors = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EffectivelyHidden(Engram As Beacon.Engram) As Boolean
		  Var Hidden As NullableBoolean = Self.Hidden(Engram)
		  If IsNull(Hidden) Then
		    Return Self.OnlyAllowSpecifiedEngrams
		  Else
		    Return Hidden.BooleanValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EffectivelyHidden(Engram As Beacon.Engram, Assigns Hidden As Boolean)
		  // Really just an alias for Hidden.
		  // This *could* compare against OnlyAllowSpecifiedEngrams and set to nil when it matches,
		  // but that would cause confusion if the setting were changed after this is set. So
		  // this style explicitly sets the user intentions, and code generation will figure out
		  // if a line is actually necessary for this.
		  
		  Self.Hidden(Engram) = Hidden
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EntryString(ForEngram As Beacon.Engram) As String
		  If ForEngram.HasUnlockDetails Then
		    Return ForEngram.EntryString
		  ElseIf Self.mBehaviors.HasKey(ForEngram.ObjectID.StringValue) Then
		    Return Dictionary(Self.mBehaviors.Value(ForEngram.ObjectID.StringValue)).Lookup(Self.KeyEntryString, "").StringValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromImport(ParsedData As Dictionary, CommandLineOptions As Dictionary, MapCompatibility As UInt64, Difficulty As BeaconConfigs.Difficulty, Mods As Beacon.StringList) As BeaconConfigs.EngramControl
		  #Pragma Unused CommandLineOptions
		  #Pragma Unused MapCompatibility
		  #Pragma Unused Difficulty
		  
		  Var Config As New BeaconConfigs.EngramControl
		  Config.AutoUnlockAllEngrams = ParsedData.BooleanValue("bAutoUnlockAllEngrams", False)
		  Config.OnlyAllowSpecifiedEngrams = ParsedData.BooleanValue("bOnlyAllowSpecifiedEngrams", False)
		  
		  If ParsedData.HasKey("OverridePlayerLevelEngramPoints") Then
		    Var ParsedValue As Variant = ParsedData.Value("OverridePlayerLevelEngramPoints")
		    Var Overrides() As Variant
		    If ParsedValue.IsArray Then
		      Overrides = ParsedValue
		    Else
		      Overrides.Add(ParsedValue)
		    End If
		    
		    For Idx As Integer = Overrides.FirstRowIndex To Overrides.LastIndex
		      Var Level As Integer = Idx + 1
		      Var Points As Integer
		      Try
		        Points = Overrides(Idx)
		      Catch Err As RuntimeException
		      End Try
		      Config.PointsForLevel(Level) = Points
		    Next
		  End If
		  
		  If ParsedData.HasKey("OverrideEngramEntries") Then
		    // We're going to convert these to OverrideNamedEngramEntries
		    Var ParsedValue As Variant = ParsedData.Value("OverrideEngramEntries")
		    Var Overrides() As Variant
		    If ParsedValue.IsArray Then
		      Overrides = ParsedValue
		    Else
		      Overrides.Add(ParsedValue)
		    End If
		    
		    For Idx As Integer = Overrides.FirstRowIndex To Overrides.LastIndex
		      Try
		        Var Details As Dictionary = Overrides(Idx)
		        Var ItemID As Integer = Details.Value("EngramIndex")
		        Var Engram As Beacon.Engram = Beacon.Data.GetEngramByItemID(ItemID)
		        If (Engram Is Nil) = False And Engram.EntryString.IsEmpty = False Then
		          Details.Value("EngramClassName") = Engram.EntryString
		          AddOverrideToConfig(Config, Details, Mods)
		        End If
		      Catch Err As RuntimeException
		      End Try
		    Next
		  End If
		  
		  If ParsedData.HasKey("OverrideNamedEngramEntries") Then
		    Var ParsedValue As Variant = ParsedData.Value("OverrideNamedEngramEntries")
		    Var Overrides() As Variant
		    If ParsedValue.IsArray Then
		      Overrides = ParsedValue
		    Else
		      Overrides.Add(ParsedValue)
		    End If
		    
		    For Idx As Integer = Overrides.FirstRowIndex To Overrides.LastIndex
		      Var Details As Dictionary
		      Try
		        Details = Overrides(Idx)
		      Catch Err As RuntimeException
		        Continue
		      End Try
		      
		      AddOverrideToConfig(Config, Details, Mods)
		    Next
		  End If
		  
		  If ParsedData.HasKey("EngramEntryAutoUnlocks") Then
		    Var ParsedValue As Variant = ParsedData.Value("EngramEntryAutoUnlocks")
		    Var Unlocks() As Variant
		    If ParsedValue.IsArray Then
		      Unlocks = ParsedValue
		    Else
		      Unlocks.Add(ParsedValue)
		    End If
		    
		    For Idx As Integer = Unlocks.FirstRowIndex To Unlocks.LastIndex
		      Var Details As Dictionary
		      Try
		        Details = Unlocks(Idx)
		      Catch Err As RuntimeException
		        Continue
		      End Try
		      
		      If Not Details.HasAllKeys("EngramClassName", "LevelToAutoUnlock") Then
		        Continue
		      End If
		      
		      Try
		        Var EntryString As String = Details.Value("EngramClassName")
		        Var Level As Integer = Details.Value("LevelToAutoUnlock")
		        
		        Var Engrams() As Beacon.Engram = Beacon.Data.GetEngramsByEntryString(EntryString, Mods)
		        If Engrams.Count = 0 Then
		          Engrams.Add(Beacon.Engram.CreateFromEntryString(EntryString))
		        End If
		        For Each Engram As Beacon.Engram In Engrams
		          Config.AutoUnlockEngram(Engram) = True
		          Config.RequiredPlayerLevel(Engram) = Level
		        Next
		      Catch Err As RuntimeException
		      End Try
		    Next
		  End If
		  
		  If Config.Modified Then
		    Return Config
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Hidden(Engram As Beacon.Engram) As NullableBoolean
		  Var Value As Variant = Self.BehaviorForEngram(Engram, Self.KeyHidden)
		  If IsNull(Value) Then
		    Return Nil
		  Else
		    Return Value.BooleanValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Hidden(Engram As Beacon.Engram, Assigns Hidden As NullableBoolean)
		  If IsNull(Hidden) Then
		    Self.BehaviorForEngram(Engram, Self.KeyHidden) = Nil
		  Else
		    Self.BehaviorForEngram(Engram, Self.KeyHidden) = Hidden.BooleanValue
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LevelsDefined() As Integer
		  For I As Integer = Self.mPointsPerLevel.LastIndex DownTo 0
		    If IsNull(Self.mPointsPerLevel(I)) = False Then
		      Return I + 1
		    End If
		  Next
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LevelsDefined(Assigns FinalLevel As Integer)
		  Var LastRowIndex As Integer = FinalLevel - 1
		  If Self.mPointsPerLevel.LastIndex = LastRowIndex Then
		    Return
		  End If
		  
		  Self.mPointsPerLevel.ResizeTo(LastRowIndex)
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointsForLevel(Level As Integer) As NullableDouble
		  // This is 1-based, as the player starts at level 1.
		  
		  Var Idx As Integer = Level - 1
		  If Idx < Self.mPointsPerLevel.FirstRowIndex Or Idx > Self.mPointsPerLevel.LastIndex Then
		    Return Nil
		  End If
		  
		  Return Self.mPointsPerLevel(Idx)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PointsForLevel(Level As Integer, Assigns Points As NullableDouble)
		  // This is 1-based, as the player starts at level 1.
		  
		  Var Idx As Integer = Level - 1
		  If Idx < Self.mPointsPerLevel.FirstRowIndex Then
		    Return
		  End If
		  
		  Var Modified As Boolean = Self.Modified
		  Do Until Self.mPointsPerLevel.LastIndex >= Idx
		    Self.mPointsPerLevel.Add(Nil)
		    Modified = True
		  Loop
		  
		  If Self.mPointsPerLevel(Idx) <> Points Then
		    Self.mPointsPerLevel(Idx) = Points
		    Modified = True
		  End If
		  Self.Modified = Modified
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(Engram As Beacon.Engram)
		  If Not Self.mBehaviors.HasKey(Engram.ObjectID.StringValue) Then
		    Return
		  End If
		  
		  Self.mBehaviors.Remove(Engram.ObjectID.StringValue)
		  Self.Modified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RemovePrerequisites(Engram As Beacon.Engram) As NullableBoolean
		  Var Value As Variant = Self.BehaviorForEngram(Engram, Self.KeyRemovePrerequisites)
		  If IsNull(Value) Then
		    Return Nil
		  Else
		    Return Value.BooleanValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemovePrerequisites(Engram As Beacon.Engram, Assigns Value As NullableBoolean)
		  If IsNull(Value) Then
		    Self.BehaviorForEngram(Engram, Self.KeyRemovePrerequisites) = Nil
		  Else
		    Self.BehaviorForEngram(Engram, Self.KeyRemovePrerequisites) = Value.BooleanValue
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RequiredPlayerLevel(Engram As Beacon.Engram) As NullableDouble
		  Var Value As Variant = Self.BehaviorForEngram(Engram, Self.KeyPlayerLevel)
		  If IsNull(Value) Then
		    Return Nil
		  Else
		    Return Value.DoubleValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RequiredPlayerLevel(Engram As Beacon.Engram, Assigns Level As NullableDouble)
		  If IsNull(Level) Then
		    Self.BehaviorForEngram(Engram, Self.KeyPlayerLevel) = Nil
		  Else
		    Self.BehaviorForEngram(Engram, Self.KeyPlayerLevel) = Level.IntegerValue
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RequiredPoints(Engram As Beacon.Engram) As NullableDouble
		  Var Value As Variant = Self.BehaviorForEngram(Engram, Self.KeyUnlockPoints)
		  If IsNull(Value) Then
		    Return Nil
		  Else
		    Return Value.DoubleValue
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RequiredPoints(Engram As Beacon.Engram, Assigns Points As NullableDouble)
		  If IsNull(Points) Then
		    Self.BehaviorForEngram(Engram, Self.KeyUnlockPoints) = Nil
		  Else
		    Self.BehaviorForEngram(Engram, Self.KeyUnlockPoints) = Points.IntegerValue
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SpecifiedEngrams() As Beacon.Engram()
		  Var Engrams() As Beacon.Engram
		  For Each Entry As DictionaryEntry In Self.mBehaviors
		    Var Engram As Beacon.Engram = Beacon.Data.GetEngramByID(Entry.Key.StringValue)
		    If Engram = Nil Then
		      Var Dict As Dictionary = Entry.Value
		      Engram = Beacon.Engram.CreateFromEntryString(Dict.Value(Self.KeyEntryString))
		    End If
		    If Engram <> Nil Then
		      Engrams.Add(Engram)
		    End If
		  Next
		  Return Engrams
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SupportsMerging() As Boolean
		  Return True
		End Function
	#tag EndMethod


	#tag Note, Name = Configs
		OverrideEngramEntries - Target engrams by index. This is not used by Beacon and will be ignored.
		OverrideNamedEngramEntries - Targets engrams by "entry string" such as EngramEntry_Popsicle. Can change the level requirement, remove prerequisites, change point cost, or enable/disable entirely.
		bOnlyAllowSpecifiedEngrams - When true, engrams are hidden by default. Use OverrideNamedEngramEntries to whitelist. When false, OverrideNamedEngramEntries can be used to blacklist engrams.
		OverridePlayerLevelEngramPoints - Needs one per player level. Each defines the number of unlock points earned for that level.
		bAutoUnlockAllEngrams - Unlocks all engrams that are possible to earn at the player's level. Causes server lag when leveling.
		EngramEntryAutoUnlocks - Automatically unlock the specified engram at the given level.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mAutoUnlockAllEngrams
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mAutoUnlockAllEngrams <> Value Then
			    Self.mAutoUnlockAllEngrams = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		AutoUnlockAllEngrams As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAutoUnlockAllEngrams As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBehaviors As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOnlyAllowSpecifiedEngrams As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPointsPerLevel() As NullableDouble
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mOnlyAllowSpecifiedEngrams
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mOnlyAllowSpecifiedEngrams <> Value Then
			    Self.mOnlyAllowSpecifiedEngrams = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		OnlyAllowSpecifiedEngrams As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = ConfigKey, Type = Text, Dynamic = False, Default = \"EngramControl", Scope = Private
	#tag EndConstant

	#tag Constant, Name = KeyAutoUnlockLevel, Type = String, Dynamic = False, Default = \"Auto Unlock Level", Scope = Private
	#tag EndConstant

	#tag Constant, Name = KeyEntryString, Type = String, Dynamic = False, Default = \"Entry String", Scope = Private
	#tag EndConstant

	#tag Constant, Name = KeyHidden, Type = String, Dynamic = False, Default = \"Hidden", Scope = Private
	#tag EndConstant

	#tag Constant, Name = KeyPlayerLevel, Type = String, Dynamic = False, Default = \"Player Level", Scope = Private
	#tag EndConstant

	#tag Constant, Name = KeyRemovePrerequisites, Type = String, Dynamic = False, Default = \"Remove Prerequisites", Scope = Private
	#tag EndConstant

	#tag Constant, Name = KeyUnlockPoints, Type = String, Dynamic = False, Default = \"Unlock Points", Scope = Private
	#tag EndConstant


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
		#tag ViewProperty
			Name="IsImplicit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OnlyAllowSpecifiedEngrams"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoUnlockAllEngrams"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
