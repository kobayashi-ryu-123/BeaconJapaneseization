#tag Class
Protected Class CraftingCostIngredient
	#tag Method, Flags = &h0
		Function ClassString() As String
		  Return Self.mEngram.ClassString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Reference As Ark.BlueprintReference, Quantity As Integer, RequireExact As Boolean)
		  If Reference Is Nil Or Reference.IsEngram = False Or Quantity <= 0 Then
		    Var Err As New RuntimeException
		    Err.Message = "Invalid engram or quantity"
		    Raise Err
		  End If
		  
		  Self.mEngram = Reference
		  Self.mQuantity = Quantity
		  Self.mRequireExact = RequireExact
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Engram As Ark.Engram, Quantity As Integer, RequireExact As Boolean)
		  Self.Constructor(New Ark.BlueprintReference(Engram.ImmutableVersion), Quantity, RequireExact)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Engram() As Ark.Engram
		  Return Ark.Engram(Self.mEngram.Resolve).ImmutableVersion
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromDictionary(Dict As Dictionary, ContentPacks As Beacon.StringList) As Ark.CraftingCostIngredient
		  If Dict Is Nil Then
		    Return Nil
		  End If
		  
		  If Dict.HasAllKeys("Blueprint", "Quantity", "Exact") Then
		    Try
		      Var Reference As Ark.BlueprintReference = Ark.BlueprintReference.FromSaveData(Dict.Value("Blueprint"))
		      If Reference Is Nil Then
		        Return Nil
		      End If
		      Var Quantity As Integer = Dict.Value("Quantity")
		      Var Exact As Boolean = Dict.Value("Exact")
		      
		      Return New Ark.CraftingCostIngredient(Reference, Quantity, Exact)
		    Catch Err As RuntimeException
		      Return Nil
		    End Try
		  ElseIf (Dict.HasKey("object_id") Or Dict.HasKey("path")) And Dict.HasKey("quantity") And Dict.HasKey("exact") Then
		    Try
		      Var Engram As Ark.Engram = Ark.ResolveEngram(Dict, "object_id", "path", "", ContentPacks)
		      Var Quantity As Integer = Dict.Value("quantity")
		      Var Exact As Boolean = Dict.Value("exact")
		      
		      Return New Ark.CraftingCostIngredient(Engram, Quantity, Exact)
		    Catch Err As RuntimeException
		      Return Nil
		    End Try
		  Else
		    Return Nil
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromVariant(Value As Variant, ContentPacks As Beacon.StringList) As Ark.CraftingCostIngredient()
		  Var Ingredients() As Ark.CraftingCostIngredient
		  
		  If IsNull(Value) Then
		    Return Ingredients
		  End If
		  
		  If Value.Type = Variant.TypeObject And Value.ObjectValue IsA Dictionary Then
		    // It's just a dictionary
		    Var Ingredient As Ark.CraftingCostIngredient = Ark.CraftingCostIngredient.FromDictionary(Value, ContentPacks)
		    If (Ingredient Is Nil) = False Then
		      Ingredients.Add(Ingredient)
		    End If
		  ElseIf Value.Type = Variant.TypeString Then
		    // Treat it as JSON
		    Try
		      Var Parsed() As Variant = Beacon.ParseJSON(Value.StringValue)
		      For Each Dict As Dictionary In Parsed
		        Var Ingredient As Ark.CraftingCostIngredient = Ark.CraftingCostIngredient.FromDictionary(Dict, ContentPacks)
		        If (Ingredient Is Nil) = False Then
		          Ingredients.Add(Ingredient)
		        End If
		      Next
		    Catch Err As RuntimeException
		    End Try
		  ElseIf Value.IsArray And Value.ArrayElementType = Variant.TypeObject Then
		    // Array of dictionaries
		    Var Dicts() As Dictionary
		    Try
		      #Pragma BreakOnExceptions False
		      Dicts = Value
		      #Pragma BreakOnExceptions Default
		    Catch Err As RuntimeException
		      Var Values() As Variant = Value
		      For Each Obj As Variant In Values
		        If Obj IsA Dictionary Then
		          Dicts.Add(Dictionary(Obj))
		        End If
		      Next
		    End Try
		    
		    For Each Dict As Dictionary In Dicts
		      Try
		        Var Ingredient As Ark.CraftingCostIngredient = Ark.CraftingCostIngredient.FromDictionary(Dict, ContentPacks)
		        If (Ingredient Is Nil) = False Then
		          Ingredients.Add(Ingredient)
		        End If
		      Catch Err As RuntimeException
		      End Try
		    Next
		  End If
		  
		  Return Ingredients
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(Other As Ark.CraftingCostIngredient) As Integer
		  If Other Is Nil Then
		    Return 1
		  End If
		  
		  Var MyKey As String = Self.mEngram.ObjectID + ":" + Self.mQuantity.ToString(Locale.Raw, "00000000") + ":" + If(Self.mRequireExact, "True", "False")
		  Var OtherKey As String = Other.mEngram.ObjectID + ":" + Other.mQuantity.ToString(Locale.Raw, "00000000") + ":" + If(Other.mRequireExact, "True", "False")
		  
		  Return MyKey.Compare(OtherKey, ComparisonOptions.CaseInsensitive)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pack() As Dictionary
		  Var Dict As New Dictionary
		  Dict.Value("object_id") = Self.mEngram.ObjectID
		  Dict.Value("quantity") = Self.mQuantity
		  Dict.Value("exact") = Self.mRequireExact
		  Return Dict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Quantity() As Integer
		  Return Self.mQuantity
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RequireExact() As Boolean
		  Return Self.mRequireExact
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDictionary() As Dictionary
		  Var Dict As New Dictionary
		  Dict.Value("Blueprint") = Self.mEngram.SaveData
		  Dict.Value("Quantity") = Self.mQuantity
		  Dict.Value("Exact") = Self.mRequireExact
		  Return Dict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ToJSON(Ingredients() As Ark.CraftingCostIngredient, Pretty As Boolean = False) As String
		  Var Dicts() As Dictionary
		  For Each Ingredient As Ark.CraftingCostIngredient In Ingredients
		    Dicts.Add(Ingredient.ToDictionary)
		  Next
		  Return Beacon.GenerateJSON(Dicts, Pretty)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEngram As Ark.BlueprintReference
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mQuantity As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRequireExact As Boolean
	#tag EndProperty


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
