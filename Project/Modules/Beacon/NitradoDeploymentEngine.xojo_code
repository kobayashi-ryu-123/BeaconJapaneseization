#tag Class
Protected Class NitradoDeploymentEngine
Inherits Beacon.TaskQueue
Implements Beacon.DeploymentEngine
	#tag Event
		Sub Finished()
		  Self.ClearTasks()
		  Self.mFinished = True
		  Self.mErrored = False
		  Self.mStatus = "Finished"
		  RaiseEvent Finished()
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function BackupGameIni() As Text
		  Return Self.mGameIniOriginal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BackupGameUserSettingsIni() As Text
		  Return Self.mGameUserSettingsIniOriginal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Begin(Label As Text, Document As Beacon.Document, Identity As Beacon.Identity)
		  Self.mLabel = Label
		  Self.mDocument = Document
		  Self.mIdentity = Identity
		  
		  Self.RunNextTask()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_DownloadGameIni(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Could not download Game.ini."
		      Return
		    End If
		    
		    Dim Data As Xojo.Core.Dictionary = Response.Value("data")
		    Dim TokenDict As Xojo.Core.Dictionary = Data.Value("token")
		    
		    Dim Headers As New Xojo.Core.Dictionary
		    Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		    
		    SimpleHTTP.Get(TokenDict.Value("url"), AddressOf Callback_DownloadGameIni_Content, Nil, Headers)
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_DownloadGameIni_Content(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Content.ToText
		    Self.mGameIniOriginal = TextContent
		    Self.RunNextTask()
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_DownloadGameUserSettingsIni(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Could not download GameUserSettings.ini."
		      Return
		    End If
		    
		    Dim Data As Xojo.Core.Dictionary = Response.Value("data")
		    Dim TokenDict As Xojo.Core.Dictionary = Data.Value("token")
		    
		    Dim Headers As New Xojo.Core.Dictionary
		    Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		    
		    SimpleHTTP.Get(TokenDict.Value("url"), AddressOf Callback_DownloadGameUserSettingsIni_Content, Nil, Headers)
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_DownloadGameUserSettingsIni_Content(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Content.ToText
		    Self.mGameUserSettingsIniOriginal = TextContent
		    Self.RunNextTask()
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_DownloadLogFile(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Then
		    Return
		  End If
		  
		  // If the log file cannot be downloaded for any reason, assume a stop time of now
		  
		  If Self.CheckError(Status) Then
		    Self.mServerStopTime = Xojo.Core.Date.Now
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mServerStopTime = Xojo.Core.Date.Now
		      Self.RunNextTask()
		      Return
		    End If
		    
		    Dim Data As Xojo.Core.Dictionary = Response.Value("data")
		    Dim TokenDict As Xojo.Core.Dictionary = Data.Value("token")
		    
		    Dim Headers As New Xojo.Core.Dictionary
		    Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		    
		    SimpleHTTP.Get(TokenDict.Value("url"), AddressOf Callback_DownloadLogFile_Content, Nil, Headers)
		  Catch Err As RuntimeException
		    Self.mServerStopTime = Xojo.Core.Date.Now
		    Self.RunNextTask()
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_DownloadLogFile_Content(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Then
		    Return
		  End If
		  
		  If Self.CheckError(Status) Then
		    Self.mServerStopTime = Xojo.Core.Date.Now
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Try
		    Dim EOL As String = Encodings.ASCII.Chr(10)
		    Dim StringContent As String = Beacon.ConvertMemoryBlock(Content)
		    Dim Lines() As String = ReplaceLineEndings(StringContent, EOL).Split(EOL)
		    Dim TimestampFound As Boolean
		    For I As Integer = Lines.Ubound DownTo 0
		      Dim Line As String = Lines(I)
		      If Line.IndexOf("Log file closed") = -1 Then
		        Continue
		      End If
		      
		      Dim Year As Integer = Val(Line.SubString(1, 4))
		      Dim Month As Integer = Val(Line.SubString(6, 2))
		      Dim Day As Integer = Val(Line.SubString(9, 2))
		      Dim Hour As Integer = Val(Line.SubString(12, 2))
		      Dim Minute As Integer = Val(Line.SubString(15, 2))
		      Dim Second As Integer = Val(Line.SubString(18, 2))
		      Dim Nanosecond As Integer = (Val(Line.SubString(21, 3)) / 1000) * 1000000000
		      
		      Self.mServerStopTime = New Xojo.Core.Date(Year, Month, Day, Hour, Minute, Second, Nanosecond, New Xojo.Core.TimeZone(0))
		      TimestampFound = True
		      Exit For I
		    Next
		    
		    If Not TimestampFound Then
		      Self.mServerStopTime = Xojo.Core.Date.Now
		    End If
		  Catch Err As RuntimeException
		    Self.mServerStopTime = Xojo.Core.Date.Now
		  End Try
		  
		  Self.RunNextTask()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_EnableExpertMode(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Could not enable expert mode."
		      Return
		    End If
		    
		    Self.mExpertMode = True
		    Self.RunNextTask()
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_MakeConfigBackup(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Could not backup current settings."
		      Return
		    End If
		    
		    Self.RunNextTask()
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_ServerStart(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Nitrado refused to start the server."
		      Return
		    End If
		    
		    If Not Self.mExpertMode Then
		      Self.mWatchForStatusStopCallbackKey = CallLater.Schedule(10000, AddressOf WatchStatusForStop)
		    Else
		      Self.RunNextTask()
		    End If
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_ServerStatus(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    Dim Data As Xojo.Core.Dictionary = Response.Value("data")
		    Dim GameServer As Xojo.Core.Dictionary = Data.Value("gameserver")
		    
		    If Self.mMask = 0 Then
		      Dim Settings As Xojo.Core.Dictionary = GameServer.Value("settings")
		      Dim Config As Xojo.Core.Dictionary = Settings.Value("config")
		      Dim MapText As Text = Config.Value("map")
		      Dim MapParts() As Text = MapText.Split(",")
		      Self.mMask = Beacon.Maps.MaskForIdentifier(MapParts(MapParts.Ubound))
		      Dim Options() As Beacon.ConfigValue
		      Self.mDocument.CreateConfigObjects(Options, Self.mGameIniDict, Self.mGameUserSettingsIniDict, Self.mMask, Self.mIdentity, Self.mProfile)
		      Self.mCommandLineOptions = Options
		      
		      Dim SessionSettingsValues() As Text = Array("SessionName=" + Self.mProfile.Name)
		      Dim SessionSettings As New Xojo.Core.Dictionary
		      SessionSettings.Value("SessionName") = SessionSettingsValues
		      Self.mGameUserSettingsIniDict.Value("SessionSettings") = SessionSettings
		    End If
		    
		    Self.mServerStatus = GameServer.Value("status")
		    If Self.mInitialServerStatus = "" Then
		      Self.mInitialServerStatus = Self.mServerStatus
		    End If
		    Select Case Self.mServerStatus
		    Case "started"
		      // Stop
		      Self.mWatchForStatusStopCallbackKey = CallLater.Schedule(5000, AddressOf StopServer)
		    Case "starting", "restarting", "stopping"
		      // Wait
		      Self.mWatchForStatusStopCallbackKey = CallLater.Schedule(5000, AddressOf WatchStatusForStop)
		    Case "stopped"
		      // Ok to continue... maybe
		      Dim Settings As Xojo.Core.Dictionary = GameServer.Value("settings")
		      Dim GeneralSettings As Xojo.Core.Dictionary = Settings.Value("general")
		      Self.mExpertMode = GeneralSettings.Value("expertMode") = "true"
		      
		      If Self.mDidRebuildStart = False And Self.mExpertMode = False Then
		        // Since the server is not in expert mode, issue a start to rebuild the ini, just in case
		        Self.mDidRebuildStart = True
		        Self.StartServer(True)
		        Return
		      End If
		      
		      Dim Groups() As Beacon.ConfigGroup = Self.mDocument.ImplementedConfigs
		      Dim CommandLineOptions() As Beacon.ConfigValue
		      For Each Group As Beacon.ConfigGroup In Groups
		        If Group.ConfigName = BeaconConfigs.CustomContent.ConfigName Then
		          Continue
		        End If
		        
		        Dim Options() As Beacon.ConfigValue = Group.CommandLineOptions(Self.mDocument, Self.mIdentity, Self.mMask)
		        For Each Option As Beacon.ConfigValue In Options
		          CommandLineOptions.Append(Option)
		        Next
		      Next
		      
		      Dim StartParams As Xojo.Core.Dictionary = Settings.Value("start-param")
		      For Each ConfigValue As Beacon.ConfigValue In CommandLineOptions
		        Dim Key As Text = ConfigValue.Key
		        Dim Value As Text = ConfigValue.Value
		        
		        If Not StartParams.HasKey(Key) Then
		          Continue
		        End If
		        
		        If StartParams.Value(Key) <> Value Then
		          Self.mCommandLineChanges.Append(ConfigValue)
		        End If
		      Next
		      
		      If Self.mCommandLineChanges.Ubound = -1 And Self.mGameIniDict.Count = 0 And Self.mGameUserSettingsIniDict.Count = 0 Then
		        // Nothing to do
		        Self.mStatus = "Finished, no changes were necessary."
		        Self.mFinished = True
		        Return
		      End If
		      
		      Dim GameSpecific As Xojo.Core.Dictionary = GameServer.Value("game_specific")
		      Self.mLogFilePath = GameSpecific.Value("path") + "ShooterGame/Saved/Logs/ShooterGame.log"
		      Self.mConfigPath = GameSpecific.Value("path") + "ShooterGame/Saved/Config/WindowsServer"
		      
		      Self.RunNextTask()
		    Else
		      Self.mErrored = True
		      Self.mStatus = "Unexpected server status: " + Self.mServerStatus
		      Self.mFinished = True
		      Return
		    End Select
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_ServerStop(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Nitrado refused to stop the server."
		      Return
		    End If
		    
		    Self.WatchStatusForStop()
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_SetNextCommandLineParam(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Unable to change command line parameter."
		      Return
		    End If
		    
		    Self.mCommandLineChanges.Remove(0)
		    Self.SetNextCommandLineParam()
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_UploadGameIni(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Could not get permission to upload Game.ini."
		      Return
		    End If
		    
		    Dim Data As Xojo.Core.Dictionary = Response.Value("data")
		    Dim TokenDict As Xojo.Core.Dictionary = Data.Value("token")
		    Dim Token As Text = TokenDict.Value("token")
		    
		    Dim Headers As New Xojo.Core.Dictionary
		    Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		    Headers.Value("token") = Token
		    
		    Dim NewTextContent As Text = Beacon.RewriteIniContent(Self.mGameIniOriginal, Self.mGameIniDict)
		    Dim NewContent As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(NewTextContent)
		    
		    SimpleHTTP.Post(TokenDict.Value("url"), "text/plain", NewContent, AddressOf Callback_UploadGameIni_Content, Nil, Headers)
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_UploadGameIni_Content(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Content
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  If Status < 400 Then
		    Self.RunNextTask()
		  Else
		    Self.mErrored = True
		    Self.mStatus = "Error: Could not upload Game.ini, server said " + Status.ToText
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_UploadGameUserSettingsIni(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  Try
		    Dim TextContent As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content, False)
		    Dim Response As Xojo.Core.Dictionary = Xojo.Data.ParseJSON(TextContent)
		    
		    If Response.Value("status") <> "success" Then
		      Self.mErrored = True
		      Self.mStatus = "Error: Could not get permission to upload GameUserSettings.ini."
		      Return
		    End If
		    
		    Dim Data As Xojo.Core.Dictionary = Response.Value("data")
		    Dim TokenDict As Xojo.Core.Dictionary = Data.Value("token")
		    Dim Token As Text = TokenDict.Value("token")
		    
		    Dim Headers As New Xojo.Core.Dictionary
		    Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		    Headers.Value("token") = Token
		    
		    Dim NewTextContent As Text = Beacon.RewriteIniContent(Self.mGameUserSettingsIniOriginal, Self.mGameUserSettingsIniDict)
		    Dim NewContent As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(NewTextContent)
		    
		    SimpleHTTP.Post(TokenDict.Value("url"), "text/plain", NewContent, AddressOf Callback_UploadGameUserSettingsIni_Content, Nil, Headers)
		  Catch Err As RuntimeException
		    Self.SetError(Err)
		    Return
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Callback_UploadGameUserSettingsIni_Content(URL As Text, Status As Integer, Content As Xojo.Core.MemoryBlock, Tag As Auto)
		  #Pragma Unused URL
		  #Pragma Unused Content
		  #Pragma Unused Tag
		  
		  If Self.mCancelled Or Self.CheckError(Status) Then
		    Return
		  End If
		  
		  If Status < 400 Then
		    Self.RunNextTask()
		  Else
		    Self.mErrored = True
		    Self.mStatus = "Error: Could not upload GameUserSettings.ini, server said " + Status.ToText
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cancel()
		  CallLater.Cancel(Self.mWaitNitradoCallbackKey)
		  CallLater.Cancel(Self.mWatchForStatusStopCallbackKey)
		  Self.mCancelled = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CheckError(HTTPStatus As Integer) As Boolean
		  Select Case HTTPStatus
		  Case 401
		    Self.mStatus = "Error: Authorization failed."
		  Case 429
		    Self.mStatus = "Error: Rate limit has been exceeded."
		  Case 503
		    Self.mStatus = "Error: Nitrado is offline for maintenance."
		  Else
		    Self.mErrored = False
		    Return False
		  End Select
		  
		  Self.mErrored = True
		  Self.mFinished = True
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Profile As Beacon.NitradoServerProfile, OAuthData As Xojo.Core.Dictionary)
		  Self.mProfile = Profile
		  Self.mAccessToken = OAuthData.Value("Access Token")
		  Self.mGameIniDict = New Xojo.Core.Dictionary
		  Self.mGameUserSettingsIniDict = New Xojo.Core.Dictionary
		  
		  Self.AppendTask(AddressOf WatchStatusForStop, AddressOf DownloadLogFile, AddressOf WaitNitradoIdle, AddressOf MakeConfigBackup, AddressOf EnableExpertMode, AddressOf SetNextCommandLineParam, AddressOf DownloadGameIni, AddressOf DownloadGameUserSettingsIni, AddressOf UploadGameIni, AddressOf UploadGameUserSettingsIni, AddressOf StartServerIfNeeded)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DownloadGameIni()
		  If Self.mGameIniDict.Count = 0 Then
		    // Skip
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Downloading Game.ini…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FilePath As Text = Self.mConfigPath + "/Game.ini"
		  
		  SimpleHTTP.Get("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/file_server/download?file=" + Beacon.EncodeURLComponent(FilePath), AddressOf Callback_DownloadGameIni, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DownloadGameUserSettingsIni()
		  If Self.mGameUserSettingsIniDict.Count = 0 Then
		    // Skip
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Downloading GameUserSettings.ini…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FilePath As Text = Self.mConfigPath + "/GameUserSettings.ini"
		  
		  SimpleHTTP.Get("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/file_server/download?file=" + Beacon.EncodeURLComponent(FilePath), AddressOf Callback_DownloadGameUserSettingsIni, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DownloadLogFile()
		  Self.mStatus = "Downloading Log File…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  SimpleHTTP.Get("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/file_server/download?file=" + Beacon.EncodeURLComponent(Self.mLogFilePath), AddressOf Callback_DownloadLogFile, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnableExpertMode()
		  If Self.mExpertMode Then
		    // Nothing to disable
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Enabling expert mode…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FormData As New Xojo.Core.Dictionary
		  FormData.Value("category") = "general"
		  FormData.Value("key") = "expertMode"
		  FormData.Value("value") = "true"
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/settings", FormData, AddressOf Callback_EnableExpertMode, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Errored() As Boolean
		  Return Self.mErrored
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Finished() As Boolean
		  Return Self.mFinished
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MakeConfigBackup()
		  Self.mStatus = "Making config backup…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FormData As New Xojo.Core.Dictionary
		  FormData.Value("name") = "Beacon " + Self.mLabel
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/settings/sets", FormData, AddressOf Callback_MakeConfigBackup, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As Text
		  Return Self.mProfile.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ServerIsStarting() As Boolean
		  Return Self.mInitialServerStatus = "started" Or Self.mInitialServerStatus = "starting"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetError(Err As RuntimeException)
		  Dim Info As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(Err)
		  Dim Reason As Text
		  If Err.Reason <> "" Then
		    Reason = Err.Reason
		  ElseIf Err.Message <> "" Then
		    Reason = Err.Message.ToText
		  Else
		    Reason = "No details available"
		  End If
		  
		  Self.mStatus = "Error: Unhandled " + Info.FullName + ": '" + Reason + "'"
		  Self.mErrored = True
		  Self.mFinished = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetNextCommandLineParam()
		  If Self.mCommandLineChanges.Ubound = -1 Then
		    // Move on
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Setting command line parameters…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FormData As New Xojo.Core.Dictionary
		  FormData.Value("category") = "start-param"
		  FormData.Value("key") = Self.mCommandLineChanges(0).Key
		  FormData.Value("value") = Self.mCommandLineChanges(0).Value
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/settings", FormData, AddressOf Callback_SetNextCommandLineParam, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartServer(Force As Boolean)
		  If Force = False And Not Self.ServerIsStarting Then
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Starting server…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FormData As New Xojo.Core.Dictionary
		  FormData.Value("message") = "Server started by Beacon (https://beaconapp.cc)"
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/restart", FormData, AddressOf Callback_ServerStart, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartServerIfNeeded()
		  Self.StartServer(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Status() As Text
		  Return Self.mStatus
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StopServer()
		  Self.mStatus = "Stopping server…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim FormData As New Xojo.Core.Dictionary
		  FormData.Value("message") = "Server is being updated by Beacon (https://beaconapp.cc)"
		  FormData.Value("stop_message") = "Server is now stopping for a few minutes for changes."
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/stop", FormData, AddressOf Callback_ServerStop, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UploadGameIni()
		  If Self.mGameIniDict.Count = 0 Then
		    // Skip
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Uploading Game.ini…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim Fields As New Xojo.Core.Dictionary
		  Fields.Value("path") = Self.mConfigPath
		  Fields.Value("file") = "Game.ini"
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/file_server/upload", Fields, AddressOf Callback_UploadGameIni, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UploadGameUserSettingsIni()
		  If Self.mGameUserSettingsIniDict.Count = 0 Then
		    // Skip
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Self.mStatus = "Uploading GameUserSettings.ini…"
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  
		  Dim Fields As New Xojo.Core.Dictionary
		  Fields.Value("path") = Self.mConfigPath
		  Fields.Value("file") = "GameUserSettings.ini"
		  
		  SimpleHTTP.Post("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers/file_server/upload", Fields, AddressOf Callback_UploadGameUserSettingsIni, Nil, Headers)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub WaitNitradoIdle()
		  Dim Now As Xojo.Core.Date = Xojo.Core.Date.Now
		  Dim SecondsToWait As Double = Double.FromText(Beacon.Data.GetTextVariable("Nitrado Wait Seconds"))
		  SecondsToWait = SecondsToWait - (Now.SecondsFrom1970 - Self.mServerStopTime.SecondsFrom1970)
		  If SecondsToWait < 10 Then // Don't need to be THAT precise
		    Self.RunNextTask()
		    Return
		  End If
		  
		  Dim ResumeTime As Xojo.Core.Date = Now + New Xojo.Core.DateInterval(0, 0, 0, 0, 0, Floor(SecondsToWait), (SecondsToWait - Floor(SecondsToWait)) * 1000000000)
		  
		  Self.mStatus = "Waiting per Nitrado recommendations. Will resume at " + ResumeTime.ToText(Xojo.Core.Locale.Current, Xojo.Core.Date.FormatStyles.None, Xojo.Core.Date.FormatStyles.Medium) + "…"
		  Self.mWaitNitradoCallbackKey = CallLater.Schedule(SecondsToWait * 1000, AddressOf WaitNitradoIdle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub WatchStatusForStop()
		  If Self.mServerStatus = "" Then
		    Self.mStatus = "Getting server status…"
		  Else
		    Self.mStatus = "Stopping server…"
		  End If
		  
		  Dim Headers As New Xojo.Core.Dictionary
		  Headers.Value("Authorization") = "Bearer " + Self.mAccessToken
		  SimpleHTTP.Get("https://api.nitrado.net/services/" + Self.mProfile.ServiceID.ToText + "/gameservers", AddressOf Callback_ServerStatus, Nil, Headers)
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Finished()
	#tag EndHook


	#tag Property, Flags = &h21
		Private mAccessToken As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCommandLineChanges() As Beacon.ConfigValue
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCommandLineOptions() As Beacon.ConfigValue
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mConfigPath As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDidRebuildStart As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDocument As Beacon.Document
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mErrored As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExpertMode As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFinished As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameIniDict As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameIniOriginal As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameUserSettingsIniDict As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameUserSettingsIniOriginal As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHasBeenStartedRecently As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIdentity As Beacon.Identity
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialServerStatus As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLabel As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLogFilePath As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMask As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mProfile As Beacon.NitradoServerProfile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mServerStatus As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mServerStopTime As Xojo.Core.Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStatus As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWaitNitradoCallbackKey As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mWatchForStatusStopCallbackKey As String
	#tag EndProperty


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Class
#tag EndClass
