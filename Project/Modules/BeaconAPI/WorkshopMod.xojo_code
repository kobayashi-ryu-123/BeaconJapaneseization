#tag Class
Protected Class WorkshopMod
	#tag Method, Flags = &h0
		Attributes( Deprecated )  Function AsDictionary() As Dictionary
		  Var Dict As New Dictionary
		  Dict.Value("mod_id") = Self.mModID
		  Return Dict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfirmationCode() As String
		  Return Self.mConfirmationCode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Confirmed() As Boolean
		  Return Self.mConfirmed
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Details As Beacon.ContentPack)
		  Self.mModID = Details.ContentPackId
		  Self.mName = Details.Name
		  If Details.MarketplaceId.IsEmpty = False Then
		    Self.mWorkshopID = Details.MarketplaceId
		  End If
		  Self.mIsLocalMod = Details.IsLocal
		  Self.mConfirmed = True
		  Self.mLastUpdate = Details.LastUpdate
		  Self.mGameId = Ark.Identifier
		  Self.mMinVersion = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As Dictionary)
		  // For mod info from the API
		  
		  Self.mConfirmationCode = Source.Lookup("confirmationCode", "")
		  Self.mConfirmed = Source.Lookup("isConfirmed", "")
		  Self.mGameId = Source.Lookup("gameId", Ark.Identifier)
		  Self.mIsLocalMod = False
		  Self.mLastUpdate = Source.Lookup("lastUpdate", 0)
		  Self.mMinVersion = Source.Lookup("minVersion", 0)
		  Self.mModID = Source.Value("contentPackId")
		  Self.mName = Source.Value("name")
		  Self.mWorkshopId = Source.Value("steamId").DoubleValue.ToString(Locale.Raw, "0")
		  
		  If Source.HasKey("steamUrl") Then
		    Self.mWorkshopURL = Source.Value("steamUrl")
		  ElseIf (Self.mWorkshopId Is Nil) = False Then
		    Self.mWorkshopURL = "https://steamcommunity.com/sharedfiles/filedetails/?id=" + Self.mWorkshopId.StringValue
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameId() As String
		  Return Self.mGameId
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsLocalMod() As Boolean
		  Return Self.mIsLocalMod
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastUpdate() As Double
		  Return Self.mLastUpdate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModID() As String
		  Return Self.mModID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As String
		  Return Self.mName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(Other As BeaconAPI.WorkshopMod) As Integer
		  If Other = Nil Then
		    Return 1
		  End If
		  
		  Return Self.mModID.Compare(Other.mModID, ComparisonOptions.CaseSensitive)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function UserBlueprintsMod() As BeaconAPI.WorkshopMod
		  Var ModInfo As New BeaconAPI.WorkshopMod
		  ModInfo.mConfirmed = True
		  ModInfo.mModID = Ark.UserContentPackId
		  ModInfo.mName = Ark.UserContentPackName
		  ModInfo.mWorkshopID = Nil
		  Return ModInfo
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WorkshopID() As NullableString
		  Return Self.mWorkshopID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WorkshopURL() As String
		  Return Self.mWorkshopURL
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mConfirmationCode As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mConfirmed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameId As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsLocalMod As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastUpdate As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMinVersion As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mModID As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWorkshopID As NullableString
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWorkshopURL As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
