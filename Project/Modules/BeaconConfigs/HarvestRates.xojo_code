#tag Class
 Attributes ( OmniVersion = 1 ) Protected Class HarvestRates
Inherits Beacon.ConfigGroup
	#tag Event
		Sub CommandLineOptions(SourceDocument As Beacon.Document, Values() As Beacon.ConfigValue, Profile As Beacon.ServerProfile)
		  #Pragma Unused Profile
		  #Pragma Unused SourceDocument
		  
		  Values.Append(New Beacon.ConfigValue("?", "UseOptimizedHarvestingHealth", If(Self.mUseOptimizedRates, "true", "false")))
		End Sub
	#tag EndEvent

	#tag Event
		Sub GameIniValues(SourceDocument As Beacon.Document, Values() As Beacon.ConfigValue, Profile As Beacon.ServerProfile)
		  #Pragma Unused Profile
		  #Pragma Unused SourceDocument
		  
		  For Each Entry As Xojo.Core.DictionaryEntry In Self.mOverrides
		    Dim ClassString As Text = Entry.Key
		    Dim Rate As Double = Entry.Value
		    Values.Append(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "HarvestResourceItemAmountClassMultipliers", "(ClassName=""" + ClassString + """,Multiplier=" + Rate.PrettyText + ")"))
		  Next
		  
		  Values.Append(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "PlayerHarvestingDamageMultiplier", Self.mPlayerHarvestingDamageMultiplier.PrettyText))
		  Values.Append(New Beacon.ConfigValue(Beacon.ShooterGameHeader, "DinoHarvestingDamageMultiplier", Self.mDinoHarvestingDamageMultiplier.PrettyText))
		End Sub
	#tag EndEvent

	#tag Event
		Sub GameUserSettingsIniValues(SourceDocument As Beacon.Document, Values() As Beacon.ConfigValue, Profile As Beacon.ServerProfile)
		  #Pragma Unused Profile
		  #Pragma Unused SourceDocument
		  
		  Values.Append(New Beacon.ConfigValue(Beacon.ServerSettingsHeader, "HarvestAmountMultiplier", Self.mHarvestAmountMultiplier.PrettyText))
		  Values.Append(New Beacon.ConfigValue(Beacon.ServerSettingsHeader, "HarvestHealthMultiplier", Self.mHarvestHealthMultiplier.PrettyText))
		  Values.Append(New Beacon.ConfigValue(Beacon.ServerSettingsHeader, "ClampResourceHarvestDamage", If(Self.mClampResourceHarvestDamage, "True", "False")))
		End Sub
	#tag EndEvent

	#tag Event
		Sub ReadDictionary(Dict As Xojo.Core.Dictionary, Identity As Beacon.Identity)
		  #Pragma Unused Identity
		  
		  // There is a slight performance impact here, since DoubleValue will check HasKey too,
		  // but this way is safe.
		  If Dict.HasKey("Harvest Amount Multiplier") Then
		    Self.mHarvestAmountMultiplier = Dict.DoubleValue("Harvest Amount Multiplier", 1.0)
		  ElseIf Dict.HasKey("Global") Then
		    Self.mHarvestAmountMultiplier = Dict.DoubleValue("Global", 1.0)
		  End If
		  
		  Self.mHarvestHealthMultiplier = Dict.DoubleValue("Harvest Health Multiplier", 1.0)
		  Self.mUseOptimizedRates = Dict.BooleanValue("Use Optimized Rates", False)
		  Self.mClampResourceHarvestDamage = Dict.BooleanValue("Clamp Resource Harvest Damage", False)
		  Self.mPlayerHarvestingDamageMultiplier = Dict.DoubleValue("Player Harvesting Damage Multiplier", 1.0)
		  Self.mDinoHarvestingDamageMultiplier = Dict.DoubleValue("Dino Harvesting Damage Multiplier", 1.0)
		  
		  Self.mOverrides = Dict.DictionaryValue("Overrides", New Xojo.Core.Dictionary)
		End Sub
	#tag EndEvent

	#tag Event
		Sub WriteDictionary(Dict As Xojo.Core.DIctionary, Identity As Beacon.Identity)
		  #Pragma Unused Identity
		  
		  Dict.Value("Harvest Amount Multiplier") = Self.mHarvestAmountMultiplier
		  Dict.Value("Harvest Health Multiplier") = Self.mHarvestHealthMultiplier
		  Dict.Value("Overrides") = Self.mOverrides
		  Dict.Value("Use Optimized Rates") = Self.mUseOptimizedRates
		  Dict.Value("Clamp Resource Harvest Damage") = Self.mClampResourceHarvestDamage
		  Dict.Value("Player Harvesting Damage Multiplier") = Self.mPlayerHarvestingDamageMultiplier
		  Dict.Value("Dino Harvesting Damage Multiplier") = Self.mDinoHarvestingDamageMultiplier
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function Classes() As Text()
		  Dim Results() As Text
		  For Each Entry As Xojo.Core.DictionaryEntry In Self.mOverrides
		    Results.Append(Entry.Key)
		  Next
		  Return Results
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ConfigName() As Text
		  Return "HarvestRates"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor()
		  Self.mClampResourceHarvestDamage = False
		  Self.mDinoHarvestingDamageMultiplier = 1.0
		  Self.mHarvestAmountMultiplier = 1.0
		  Self.mHarvestHealthMultiplier = 1.0
		  Self.mPlayerHarvestingDamageMultiplier = 1.0
		  Self.mUseOptimizedRates = False
		  Self.mOverrides = New Xojo.Core.Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As UInteger
		  Return Self.mOverrides.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromImport(ParsedData As Xojo.Core.Dictionary, CommandLineOptions As Xojo.Core.Dictionary, MapCompatibility As UInt64, QualityMultiplier As Double) As BeaconConfigs.HarvestRates
		  #Pragma Unused CommandLineOptions
		  #Pragma Unused MapCompatibility
		  #Pragma Unused QualityMultiplier
		  
		  Dim HarvestAmountMultiplier As Double = ParsedData.DoubleValue("HarvestAmountMultiplier", 1.0, True)
		  Dim HarvestHealthMultiplier As Double = ParsedData.DoubleValue("HarvestHealthMultiplier", 1.0, True)
		  Dim PlayerHarvestingDamageMultiplier As Double = ParsedData.DoubleValue("PlayerHarvestingDamageMultiplier", 1.0, True)
		  Dim DinoHarvestingDamageMultiplier As Double = ParsedData.DoubleValue("DinoHarvestingDamageMultiplier", 1.0, True)
		  Dim ClampResourceHarvestDamage As Boolean = ParsedData.BooleanValue("ClampResourceHarvestDamage", False, True)
		  Dim UseOptimizedRates As Boolean = False
		  Dim Overrides As New Xojo.Core.Dictionary
		  
		  If CommandLineOptions <> Nil And CommandLineOptions.HasKey("UseOptimizedHarvestingHealth") Then
		    Try
		      UseOptimizedRates = CommandLineOptions.BooleanValue("UseOptimizedHarvestingHealth", False, False)
		    Catch Err As RuntimeException
		    End Try
		  End If
		  
		  If ParsedData.HasKey("HarvestResourceItemAmountClassMultipliers") Then
		    Dim AutoValue As Auto = ParsedData.Value("HarvestResourceItemAmountClassMultipliers")
		    Dim Dicts() As Xojo.Core.Dictionary
		    Dim Info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(AutoValue)
		    Select Case Info.FullName
		    Case "Xojo.Core.Dictionary"
		      Dicts.Append(AutoValue)
		    Case "Auto()"
		      Dim ArrayValue() As Auto = AutoValue
		      For Each Dict As Xojo.Core.Dictionary In ArrayValue
		        Dicts.Append(Dict)
		      Next
		    End Select
		    
		    For Each Dict As Xojo.Core.Dictionary In Dicts
		      If Not Dict.HasAllKeys("ClassName", "Multiplier") Then
		        Continue
		      End If   
		      
		      Dim Multiplier As Double = Dict.Value("Multiplier")
		      Dim ClassString As Text = Dict.Value("ClassName")
		      
		      If ClassString <> "" And ClassString.EndsWith("_C") And Multiplier > 0 Then
		        Overrides.Value(ClassString) = Multiplier
		      End If
		    Next
		  End If
		  
		  // Use the public properties here to toggle modified ...
		  Dim Config As New BeaconConfigs.HarvestRates
		  Config.HarvestAmountMultiplier = HarvestAmountMultiplier
		  Config.HarvestHealthMultiplier = HarvestHealthMultiplier
		  Config.PlayerHarvestingDamageMultiplier = PlayerHarvestingDamageMultiplier
		  Config.DinoHarvestingDamageMultiplier = DinoHarvestingDamageMultiplier
		  Config.ClampResourceHarvestDamage = ClampResourceHarvestDamage
		  Config.UseOptimizedRates = UseOptimizedRates
		  Config.mOverrides = Overrides
		  
		  // ... so it can be checked here to determine if any of the values are non-default
		  If Config.Modified Or Config.mOverrides.Count > 0 Then
		    Config.Modified = False
		    Return Config
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Override(ClassString As Text) As Double
		  Return Self.mOverrides.Lookup(ClassString, 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Override(ClassString As Text, Assigns Rate As Double)
		  If Rate <= 0 And Self.mOverrides.HasKey(ClassString) Then
		    Self.mOverrides.Remove(ClassString)
		    Self.Modified = True
		  ElseIf Rate > 0 And Self.mOverrides.Lookup(ClassString, 0) <> Rate Then
		    Self.mOverrides.Value(ClassString) = Rate
		    Self.Modified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UBound() As Integer
		  Return Self.mOverrides.Count - 1
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mClampResourceHarvestDamage
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mClampResourceHarvestDamage <> Value Then
			    Self.mClampResourceHarvestDamage = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		ClampResourceHarvestDamage As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mDinoHarvestingDamageMultiplier
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mDinoHarvestingDamageMultiplier <> Value Then
			    Self.mDinoHarvestingDamageMultiplier = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		DinoHarvestingDamageMultiplier As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mHarvestAmountMultiplier
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mHarvestAmountMultiplier <> Value Then
			    Self.mHarvestAmountMultiplier = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		HarvestAmountMultiplier As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mHarvestHealthMultiplier
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mHarvestHealthMultiplier <> Value Then
			    Self.mHarvestHealthMultiplier = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		HarvestHealthMultiplier As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mClampResourceHarvestDamage As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDinoHarvestingDamageMultiplier As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHarvestAmountMultiplier As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHarvestHealthMultiplier As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOverrides As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPlayerHarvestingDamageMultiplier As Double = 1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseOptimizedRates As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mPlayerHarvestingDamageMultiplier
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mPlayerHarvestingDamageMultiplier <> Value Then
			    Self.mPlayerHarvestingDamageMultiplier = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		PlayerHarvestingDamageMultiplier As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mUseOptimizedRates
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mUseOptimizedRates <> Value Then
			    Self.mUseOptimizedRates = Value
			    Self.Modified = True
			  End If
			End Set
		#tag EndSetter
		UseOptimizedRates As Boolean
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsImplicit"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HarvestAmountMultiplier"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClampResourceHarvestDamage"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DinoHarvestingDamageMultiplier"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HarvestHealthMultiplier"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PlayerHarvestingDamageMultiplier"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseOptimizedRates"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
