#tag Window
Begin Window EngramControlWizard
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   "1"
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   False
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   Height          =   142
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "Engram Control Wizard"
   Type            =   "8"
   Visible         =   True
   Width           =   600
   Begin Label MessageLabel
      AllowAutoDeactivate=   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextAlignment   =   "0"
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Value           =   "Engram Control Quick Setup Wizard"
      Visible         =   True
      Width           =   560
   End
   Begin UITweaks.ResizedPopupMenu TemplateMenu
      AllowAutoDeactivate=   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Unlock all at spawn\nUnlock all except Tek at spawn\nUnlock all while leveling\nUnlock unobtainable while leveling\nUnlock Tek at level:\nGrant exact points needed per level"
      Italic          =   False
      Left            =   86
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      SelectedRowIndex=   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   60
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   310
   End
   Begin UITweaks.ResizedLabel TemplateLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextAlignment   =   "3"
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   60
      Transparent     =   False
      Underline       =   False
      Value           =   "Design:"
      Visible         =   True
      Width           =   54
   End
   Begin UITweaks.ResizedPushButton ActionButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "OK"
      Default         =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   500
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   "0"
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   102
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin UITweaks.ResizedPushButton CancelButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   True
      Caption         =   "Cancel"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   408
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   "0"
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   102
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin RangeField TekLevelField
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF00
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   408
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextAlignment   =   "2"
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   59
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Value           =   "135"
      Visible         =   False
      Width           =   80
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub Constructor(Document As Beacon.Document)
		  Self.mDocument = Document
		  Super.Constructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As Window, Document As Beacon.Document) As Boolean
		  If Parent = Nil Then
		    Return False
		  End If
		  
		  Var Win As New EngramControlWizard(Document)
		  Win.ShowModalWithin(Parent.TrueWindow)
		  
		  Var Cancelled As Boolean = Win.mCancelled
		  Win.Close
		  
		  Return Not Cancelled
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDocument As Beacon.Document
	#tag EndProperty


	#tag Constant, Name = IndexGrantExactPoints, Type = Double, Dynamic = False, Default = \"5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IndexUnlockAll, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IndexUnlockAllNoTek, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IndexUnlockNaturally, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IndexUnlockTek, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IndexUnlockUnobtainable, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events TemplateMenu
	#tag Event
		Sub Change()
		  Self.TekLevelField.Visible = Me.SelectedRowIndex = Self.IndexUnlockTek
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ActionButton
	#tag Event
		Sub Action()
		  Var Config As BeaconConfigs.EngramControl
		  Var AddWhenFinished As Boolean
		  If Self.mDocument.HasConfigGroup(BeaconConfigs.EngramControl.ConfigName) Then
		    Config = BeaconConfigs.EngramControl(Self.mDocument.ConfigGroup(BeaconConfigs.EngramControl.ConfigName, False))
		  Else
		    Config = New BeaconConfigs.EngramControl
		    AddWhenFinished = True
		  End If
		  
		  // Do the work
		  Select Case Self.TemplateMenu.SelectedRowIndex
		  Case Self.IndexUnlockAll
		    Var Engrams() As Beacon.Engram = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "")
		    For Each Engram As Beacon.Engram In Engrams
		      Config.AutoUnlockEngram(Engram) = 0
		    Next
		    Config.AutoUnlockAllEngrams = False
		  Case Self.IndexUnlockAllNoTek
		    Var Engrams() As Beacon.Engram = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "object NOT tek")
		    For Each Engram As Beacon.Engram In Engrams
		      Config.AutoUnlockEngram(Engram) = 0
		    Next
		    Engrams = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "object AND tek")
		    For Each Engram As Beacon.Engram In Engrams
		      Config.AutoUnlockEngram(Engram) = Nil
		    Next
		    Config.AutoUnlockAllEngrams = False
		  Case Self.IndexUnlockNaturally
		    Var Engrams() As Beacon.Engram = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "")
		    For Each Engram As Beacon.Engram In Engrams
		      If IsNull(Engram.RequiredPlayerLevel) = False Then
		        Config.AutoUnlockEngram(Engram) = Engram.RequiredPlayerLevel
		      End If
		    Next
		    Config.AutoUnlockAllEngrams = False
		  Case Self.IndexUnlockUnobtainable
		    Var Engrams() As Beacon.Engram = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "")
		    Var Mask As UInt64 = Self.mDocument.MapCompatibility
		    For Each Engram As Beacon.Engram In Engrams
		      If Engram.ValidForMask(Mask) = False Then
		        Config.AutoUnlockEngram(Engram) = Engram.RequiredPlayerLevel
		      Else
		        Config.AutoUnlockEngram(Engram) = Nil
		      End If
		    Next
		    Config.AutoUnlockAllEngrams = False
		  Case Self.IndexGrantExactPoints
		    Config.LevelsDefined = 0 // Reset
		    
		    Var Engrams() As Beacon.Engram = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "")
		    Var Organizer As New Dictionary
		    For Each Engram As Beacon.Engram In Engrams
		      // If the engram is auto unlocked, don't include it here
		      If IsNull(Config.AutoUnlockEngram(Engram)) = False Then
		        Continue
		      End If
		      
		      Var Level As NullableDouble = Config.RequiredPlayerLevel(Engram)
		      If IsNull(Level) Then
		        Level = Engram.RequiredPlayerLevel
		        If IsNull(Level) Then
		          Continue
		        End If
		      End If
		      
		      Var Points As NullableDouble = Config.RequiredPoints(Engram)
		      If IsNull(Points) Then
		        Points = Engram.RequiredUnlockPoints
		        If IsNull(Points) Then
		          Continue
		        End If
		      End If
		      
		      Var ActualLevel As Integer = Round(Level.Value)
		      Var ActualPoints As Integer = Round(Points.Value)
		      Config.PointsForLevel(ActualLevel) = Config.PointsForLevel(ActualLevel) + ActualPoints
		    Next
		    
		    Var PlayerLevelCap As Integer = LocalData.SharedInstance.GetIntegerVariable("Player Level Cap")
		    If Self.mDocument.HasConfigGroup(BeaconConfigs.ExperienceCurves.ConfigName) Then
		      Var ExperienceConfig As BeaconConfigs.ExperienceCurves = BeaconConfigs.ExperienceCurves(Self.mDocument.ConfigGroup(BeaconConfigs.ExperienceCurves.ConfigName, False))
		      If ExperienceConfig <> Nil Then
		        PlayerLevelCap = Max(PlayerLevelCap, ExperienceConfig.PlayerLevelCap)
		      End If
		    End If
		    Config.LevelsDefined = Max(Config.LevelsDefined, PlayerLevelCap)
		  Case Self.IndexUnlockTek
		    Var Engrams() As Beacon.Engram = LocalData.SharedInstance.SearchForEngramEntries("", Self.mDocument.Mods, "object AND tek")
		    Var Level As Integer = Round(Self.TekLevelField.DoubleValue)
		    For Each Engram As Beacon.Engram In Engrams
		      Config.AutoUnlockEngram(Engram) = Level
		    Next
		    Config.AutoUnlockAllEngrams = False
		  End Select
		  
		  If AddWhenFinished Then
		    Self.mDocument.AddConfigGroup(Config)
		  End If
		  
		  Self.mCancelled = False
		  Self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CancelButton
	#tag Event
		Sub Action()
		  Self.mCancelled = True
		  Self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TekLevelField
	#tag Event
		Sub GetRange(ByRef MinValue As Double, ByRef MaxValue As Double)
		  MinValue = 0
		  MaxValue = 65535
		End Sub
	#tag EndEvent
	#tag Event
		Sub RangeError(DesiredValue As Double, NewValue As Double)
		  #Pragma Unused DesiredValue
		  #Pragma Unused NewValue
		  
		  System.Beep
		End Sub
	#tag EndEvent
#tag EndEvents
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
		Name="Interfaces"
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
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
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
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="mDocument"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
