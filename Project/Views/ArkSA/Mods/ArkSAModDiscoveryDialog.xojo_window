#tag DesktopWindow
Begin BeaconDialog ArkSAModDiscoveryDialog
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   Composite       =   False
   DefaultLocation =   1
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   False
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   Height          =   356
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   266
   MaximumWidth    =   600
   MenuBar         =   0
   MenuBarVisible  =   True
   MinimumHeight   =   266
   MinimumWidth    =   600
   Resizeable      =   False
   Title           =   "Mod Discovery"
   Type            =   8
   Visible         =   True
   Width           =   600
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
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   316
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
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   316
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin UITweaks.ResizedTextField ModsField
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF00
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      Height          =   22
      Hint            =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   147
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
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   "#DesiredModIdsTooltip"
      Top             =   152
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   433
   End
   Begin UITweaks.ResizedLabel ModsLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
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
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "#DesiredModIdsCaption"
      TextAlignment   =   3
      TextColor       =   &c00000000
      Tooltip         =   "#DesiredModIdsTooltip"
      Top             =   151
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   115
   End
   Begin DesktopLabel ExplanationLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   54
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   True
      Scope           =   2
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "This feature will look at the manifest inside the mod archive to try to guess at contents. It will be wrong very frequently, but may help you get started."
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   52
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   560
   End
   Begin DesktopLabel MessageLabel
      AllowAutoDeactivate=   True
      Bold            =   True
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
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Automatic Mod Discovery"
      TextAlignment   =   0
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   376
   End
   Begin DesktopCheckBox AllowDeleteCheck
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "#DeleteContentCaption"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   147
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#DeleteContentTooltip"
      Top             =   185
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      VisualState     =   1
      Width           =   433
   End
   Begin DesktopLabel BetaLabel
      AllowAutoDeactivate=   True
      Bold            =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   380
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Beta"
      TextAlignment   =   3
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
   End
   Begin DesktopCheckBox IgnoreBuiltInClassesCheck
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "#IgnoreBuiltInClassesCaption"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   147
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "#IgnoreBuiltInClassesTooltip"
      Top             =   217
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      VisualState     =   0
      Width           =   433
   End
   Begin RangeField ThresholdField
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   False
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
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
      Left            =   147
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   "#ThresholdTooltip"
      Top             =   249
      Transparent     =   False
      Underline       =   False
      ValidationMask  =   ""
      Visible         =   True
      Width           =   80
   End
   Begin UITweaks.ResizedLabel ThresholdLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
      Index           =   -2147483648
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
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "#ThresholdCaption"
      TextAlignment   =   3
      TextColor       =   &c00000000
      Tooltip         =   "#ThresholdTooltip"
      Top             =   249
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   115
   End
   Begin UITweaks.ResizedLabel ThresholdSuffixLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   22
      Index           =   -2147483648
      Italic          =   False
      Left            =   239
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "%"
      TextAlignment   =   1
      TextColor       =   &c00000000
      Tooltip         =   ""
      Top             =   249
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   115
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  Self.BetaLabel.TextColor = SystemColors.SystemRedColor
		  
		  BeaconUI.SizeToFit(Self.ModsLabel, Self.ThresholdLabel)
		  Self.ExplanationLabel.Height = Self.ExplanationLabel.IdealHeight
		  
		  Self.ModsField.Top = Self.ExplanationLabel.Bottom + 12
		  Self.ModsLabel.Top = Self.ModsField.Top
		  Self.ModsLabel.Height = Self.ModsField.Height
		  Self.AllowDeleteCheck.Top = Self.ModsField.Bottom + 12
		  Self.IgnoreBuiltInClassesCheck.Top = Self.AllowDeleteCheck.Bottom + 12
		  Self.ThresholdField.Top = Self.IgnoreBuiltInClassesCheck.Bottom + 12
		  Self.ThresholdLabel.Top = Self.ThresholdField.Top
		  Self.ThresholdLabel.Height = Self.ThresholdField.Height
		  Self.ThresholdSuffixLabel.Top = Self.ThresholdField.Top
		  Self.ThresholdSuffixLabel.Height = Self.ThresholdField.Height
		  Self.ActionButton.Top = Self.ThresholdField.Bottom + 20
		  Self.CancelButton.Top = Self.ActionButton.Top
		  
		  Var IdealHeight As Integer = Self.ActionButton.Bottom + 20
		  Self.MinimumHeight = IdealHeight
		  Self.Height = IdealHeight
		  Self.MaximumHeight = IdealHeight
		  
		  Self.ModsField.Left = Self.ModsLabel.Left + Self.ModsLabel.Width + 12
		  Self.ModsField.Width = Self.Width - (20 + Self.ModsField.Left)
		  Self.ThresholdField.Left = Self.ModsField.Left
		  Self.ThresholdSuffixLabel.Left = Self.ThresholdField.Right + 6
		  Self.AllowDeleteCheck.Left = Self.ModsField.Left
		  Self.AllowDeleteCheck.Width = Self.ModsField.Width
		  Self.IgnoreBuiltInClassesCheck.Left = Self.ModsField.Left
		  Self.IgnoreBuiltInClassesCheck.Width = Self.ModsField.Width
		  
		  If Self.mForcedModsString.IsEmpty = False Then
		    Self.ModsField.Text = Self.mForcedModsString
		    Self.ModsField.ReadOnly = True
		  End If
		  
		  Self.ThresholdField.DoubleValue = 50
		  
		  Self.SwapButtons()
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Constructor(ForcedModsString As String)
		  // Calling the overridden superclass constructor.
		  Self.mForcedModsString = ForcedModsString
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As DesktopWindow, ForceModIds() As String) As ArkSA.ModDiscoverySettings
		  Var Win As New ArkSAModDiscoveryDialog(String.FromArray(ForceModIds, ","))
		  Win.ShowModal(Parent)
		  
		  Var Settings As ArkSA.ModDiscoverySettings = Win.mSettings
		  Win.Close
		  
		  Return Settings
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As DesktopWindow, ParamArray ForceModIds() As String) As ArkSA.ModDiscoverySettings
		  Return Present(Parent, ForceModIds)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mForcedModsString As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSettings As ArkSA.ModDiscoverySettings
	#tag EndProperty


	#tag Constant, Name = DeleteContentCaption, Type = String, Dynamic = True, Default = \"Delete Blueprints That Are Not Found by Discovery", Scope = Private
	#tag EndConstant

	#tag Constant, Name = DeleteContentTooltip, Type = String, Dynamic = True, Default = \"If checked\x2C discovery will remove classes that have previously been discovered but are not found on this run.", Scope = Private
	#tag EndConstant

	#tag Constant, Name = DesiredModIdsCaption, Type = String, Dynamic = True, Default = \"Desired Mod Numbers:", Scope = Private
	#tag EndConstant

	#tag Constant, Name = DesiredModIdsTooltip, Type = String, Dynamic = True, Default = \"One or more mod numbers\x2C separated by commas. Mod numbers can be found on the mod\'s CurseForge page called \"Project ID\".", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IgnoreBuiltInClassesCaption, Type = String, Dynamic = True, Default = \"Ignore Official Classes", Scope = Private
	#tag EndConstant

	#tag Constant, Name = IgnoreBuiltInClassesTooltip, Type = String, Dynamic = True, Default = \"If checked\x2C discovered classes that match official classes will be skipped.", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageFinished, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageIntro, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = PageWorking, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ThresholdCaption, Type = String, Dynamic = True, Default = \"Confidence Threshold:", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ThresholdTooltip, Type = String, Dynamic = True, Default = \"When matching unlock strings to engrams\x2C discovery assigns a 0 to 100 confidence score to every combination. A lower threshold will discard fewer matches. This can help discover more unlock strings\x2C but may reduce the quality of matches.", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events ActionButton
	#tag Event
		Sub Pressed()
		  Var ModsString As String = Self.ModsField.Text.Trim
		  
		  Var Matcher As New Regex
		  Matcher.SearchPattern = "[^\d,]+"
		  Matcher.ReplacementPattern = ""
		  Matcher.Options.ReplaceAllMatches = True
		  ModsString = Matcher.Replace(ModsString)
		  
		  If ModsString.IsEmpty Then
		    Self.ShowAlert("Don't forget to include some mods", "This process doesn't make much sense without mod ids does it?")
		    Return
		  End If
		  
		  Var Threshold As Double = (100 - Self.ThresholdField.DoubleValue) / 100
		  Self.mSettings = New ArkSA.ModDiscoverySettings(ModsString.Split(","), Self.AllowDeleteCheck.Value, Self.IgnoreBuiltInClassesCheck.Value, Threshold)
		  Self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CancelButton
	#tag Event
		Sub Pressed()
		  Self.mSettings = Nil
		  Self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ThresholdField
	#tag Event
		Sub GetRange(ByRef MinValue As Double, ByRef MaxValue As Double)
		  MinValue = 0
		  MaxValue = 100
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
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
			"9 - Modeless Dialog"
		#tag EndEnumValues
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
		Type="ColorGroup"
		EditorType="ColorGroup"
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
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
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
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
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
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
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
		Type="DesktopMenuBar"
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
#tag EndViewBehavior
