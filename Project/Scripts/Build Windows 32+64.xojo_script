ConstantValue("App.MBSKey") = Trim(DoShellCommand("cat ""%PROJECT_PATH%\MBSKey.txt"""))
Call BuildApp(3, False)
Call BuildApp(19, False)