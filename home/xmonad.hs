import XMonad
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import System.IO
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.GridSelect
import XMonad.Hooks.SetWMName
import XMonad.Layout.PerWorkspace


bw = 1
nbc = "#777777"
--fbc = "#96fcfc"
fbc = "#444444"

quickCommands = ["midori","chromium","eclipse","gimp","minecraft","thunar"]

defaultl = tiled ||| Mirror tiled ||| Full
   where
	tiled = Tall nmaster delta ratio
	nmaster = 1
	delta = 5/100
	ratio = 3/5

medial = noBorders $ Full
ml = onWorkspace "6" medial $ defaultl


wspcs = ["1","2","3","4","5","6" ]
managehook = composeAll
	   [ isFullscreen --> doFullFloat
	   , className =? "net-minecraft-LauncherFrame" --> doShift "6"
	   , className =? "net-minecraft-LauncherFrame" --> doFloat
	   ]

term = "urxvtc"

main = do
xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
xmonad $ defaultConfig
       {
       manageHook = manageDocks <+> managehook <+> manageHook defaultConfig
       , handleEventHook = fullscreenEventHook
       , startupHook = setWMName "LG3D"
       , layoutHook = smartBorders $ avoidStruts $ ml
       , logHook = dynamicLogWithPP xmobarPP
       	 {
		ppOutput = hPutStrLn xmproc
		, ppTitle = xmobarColor "#000000" "" . shorten 50
		, ppLayout = const ""
		}
	 , borderWidth = bw
	 , normalBorderColor = nbc
	 , focusedBorderColor = fbc
	 , workspaces = wspcs
	 , terminal = term
	 } `additionalKeys`
	 [((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 3%-")
	 , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 3%+")
	 , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
	 ] `additionalKeysP` 
	 [("M-n", spawnSelected defaultGSConfig quickCommands)
	 ]
