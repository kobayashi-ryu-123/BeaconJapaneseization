#tag Class
Protected Class GenericGameSetting
Implements Beacon.GameSetting
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(NitradoPaths() As String)
		  Self.Constructor()
		  Self.mPaths = NitradoPaths
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(NitradoPath As String)
		  Self.Constructor(Array(NitradoPath))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasNitradoEquivalent() As Boolean
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NitradoPaths() As String()
		  Return Self.mPaths
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NitradoPaths(Assigns Paths() As String)
		  Self.mPaths = Paths
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValuesEqual(FirstValue As Variant, SecondValue As Variant) As Boolean
		  // For this generic implementation, keep it simple
		  
		  Var FirstString As String = Beacon.VariantToString(FirstValue)
		  Var SecondString As String = Beacon.VariantToString(SecondValue)
		  Return FirstString.Compare(SecondString, ComparisonOptions.CaseSensitive, Locale.Raw) = 0
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mPaths() As String
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
