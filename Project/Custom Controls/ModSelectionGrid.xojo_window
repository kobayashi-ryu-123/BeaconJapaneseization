#tag Window
Begin ContainerControl ModSelectionGrid Implements PopoverContainer
   AllowAutoDeactivate=   True
   AllowFocus      =   False
   AllowFocusRing  =   False
   AllowTabs       =   True
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   DoubleBuffer    =   False
   Enabled         =   True
   EraseBackground =   True
   HasBackgroundColor=   False
   Height          =   300
   Index           =   -2147483648
   InitialParent   =   ""
   Left            =   0
   LockBottom      =   False
   LockLeft        =   True
   LockRight       =   False
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Tooltip         =   ""
   Top             =   0
   Transparent     =   True
   Visible         =   True
   Width           =   370
   BeginDesktopSegmentedButton DesktopSegmentedButton ViewSelector
      Enabled         =   True
      Height          =   24
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   45
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      Segments        =   "Universal\n\nFalse\rSteam Only\n\nFalse\rCustom\n\nFalse"
      SelectionStyle  =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   False
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Visible         =   True
      Width           =   280
   End
   Begin CheckBox ModCheckbox
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Untitled"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   0
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   64
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   0
      Width           =   100
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Self.ViewSelector.Width = Self.ViewSelector.SegmentCount * 110 // Because the design-time size is not being respected
		  Self.ViewSelector.Left = (Self.Width - Self.ViewSelector.Width) / 2
		  Self.ViewSelector.ResizeCells
		  Self.ViewSelector.SegmentAt(0).Selected = True
		  Self.BuildCheckboxes()
		  RaiseEvent Open
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub BuildCheckboxes()
		  Self.mSettingUp = True
		  
		  Const EdgePadding = 20
		  
		  Const PageUniversal = 0
		  Const PageSteam = 1
		  Const PageLocal = 2
		  
		  Var Packs() As Ark.ContentPack = Ark.DataSource.SharedInstance.GetContentPacks
		  Var RequiredPage As Integer
		  For Idx As Integer = 0 To Self.ViewSelector.LastSegmentIndex
		    If Self.ViewSelector.SegmentAt(Idx).Selected Then
		      RequiredPage = Idx
		      Exit For Idx
		    End If
		  Next Idx
		  
		  For Idx As Integer = Self.CheckboxesBound DownTo 1
		    Self.ModCheckbox(Idx).Close
		  Next
		  
		  Var Measure As New Picture(20, 20)
		  Var Filtered() As Ark.ContentPack
		  Var MaxWidth As Double
		  For Idx As Integer = 0 To Packs.LastIndex
		    Var TargetPage As Integer
		    If Packs(Idx).IsLocal Then
		      TargetPage = PageLocal
		    ElseIf Packs(Idx).ConsoleSafe Then
		      TargetPage = PageUniversal
		    Else
		      TargetPage = PageSteam
		    End If
		    If TargetPage <> RequiredPage Then
		      Continue
		    End If
		    
		    Filtered.Add(Packs(Idx))
		    MaxWidth = Max(MaxWidth, Measure.Graphics.TextWidth(Packs(Idx).Name))
		  Next
		  Self.CheckboxesBound = Filtered.LastIndex
		  
		  Var CheckboxWidth As Integer = Ceiling(MaxWidth + 40)
		  Var ColumnCount As Integer = Ceiling(450 / CheckboxWidth)
		  Var RowCount As Integer = Ceiling(Filtered.Count / ColumnCount)
		  
		  Self.mMap.ResizeTo(Filtered.LastIndex)
		  
		  Self.ModCheckbox(0).Caption = Filtered(0).Name
		  Self.ModCheckbox(0).Width = CheckboxWidth
		  Self.ModCheckbox(0).Value = Self.ModEnabled(Filtered(0).UUID)
		  Self.mMap(0) = Filtered(0).UUID
		  
		  Var NextLeft As Integer = Self.ModCheckbox(0).Left + Self.ModCheckbox(0).Width + 12
		  Var NextTop As Integer = Self.ModCheckbox(0).Top
		  For Idx As Integer = 1 To Filtered.LastIndex
		    Var Check As CheckBox = New ModCheckbox
		    Check.Caption = Filtered(Idx).Name
		    Check.Width = CheckboxWidth
		    Check.Left = NextLeft
		    Check.Top = NextTop
		    Check.Value = Self.ModEnabled(Filtered(Idx).UUID)
		    Self.mMap(Idx) = Filtered(Idx).UUID
		    
		    If (Idx + 1) Mod ColumnCount = 0 Then
		      NextLeft = Self.ModCheckbox(0).Left
		      NextTop = NextTop + Check.Height + 12
		    Else
		      NextLeft = NextLeft + Check.Width + 12
		    End If
		  Next
		  
		  Self.Width = (ColumnCount * CheckboxWidth) + ((ColumnCount - 1) * 12) + (EdgePadding * 2)
		  Self.Height = (RowCount * 20) + ((RowCount - 1) * 12) + (Self.ViewSelector.Height + (EdgePadding * 3))
		  Self.ViewSelector.Left = (Self.Width - Self.ViewSelector.Width) / 2
		  
		  Self.mSettingUp = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(EnabledMods As Beacon.StringList)
		  Self.EnabledMods = EnabledMods
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EnabledMods() As Beacon.StringList
		  Var List As New Beacon.StringList
		  For Each Entry As DictionaryEntry In Self.mModStates
		    If Entry.Value.BooleanValue Then
		      List.Append(Entry.Key.StringValue)
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub EnabledMods(Assigns List As Beacon.StringList)
		  Self.mModStates = New Dictionary
		  Self.mModStates.Value(Ark.UserContentPackUUID) = True
		  
		  For Each ModID As String In List
		    Self.mModStates.Value(ModID) = True
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetPadding(ByRef PaddingLeft As Integer, ByRef PaddingTop As Integer, ByRef PaddingRight As Integer, ByRef PaddingBottom As Integer)
		  // Part of the PopoverContainer interface.
		  
		  PaddingLeft = 0
		  PaddingTop = 0
		  PaddingRight = 0
		  PaddingBottom = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ModEnabled(ModID As String) As Boolean
		  Return Self.mModStates.Lookup(ModID, False).BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ModEnabled(ModID As String, Assigns Value As Boolean)
		  Self.mModStates.Value(ModID) = Value Or ModID = Ark.UserContentPackUUID
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook


	#tag Property, Flags = &h21
		Private CheckboxesBound As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMap() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mModStates As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSettingUp As Boolean
	#tag EndProperty


	#tag Constant, Name = MaxColumns, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = MinColumns, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events ViewSelector
	#tag Event
		Sub Pressed(segmentIndex as integer)
		  #Pragma Unused SegmentIndex
		  
		  Self.BuildCheckboxes()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ModCheckbox
	#tag Event
		Sub Action(index as Integer)
		  If Self.mSettingUp Then
		    Return
		  End If
		  
		  Self.ModEnabled(Self.mMap(Index)) = Me.Value
		End Sub
	#tag EndEvent
#tag EndEvents
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="InitialParent"
		Visible=false
		Group="Position"
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
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabPanelIndex"
		Visible=false
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabStop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Tooltip"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="EraseBackground"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DoubleBuffer"
		Visible=true
		Group="Windows Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
