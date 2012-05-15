import XMonad
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName -- for recognition as a tiling WM by java
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import Graphics.X11.ExtraTypes.XF86
import System.IO

bw = 1
nbc = "#777777"
--fbc = "#96fcfc"
fbc = "#444444"

defaultl = tiled ||| Mirror tiled ||| Full
   where
	tiled = Tall nmaster delta ratio
	nmaster = 1
	delta = 5/100
	ratio = 3/5

medial = noBorders $ Full
ml = defaultl

wspcs = ["1","2","3","4","5","6" ]
managehook = composeAll
	   [ isFullscreen --> doFullFloat
	   , className =? "net-minecraft-LauncherFrame" --> doFloat
	   ]

term = "urxvtc"

myDzenStatus = "dzen2 -w '320' -ta 'l'" ++ myDzenStyle
myDzenConky  = "conky -c ~/.xmonad/conkyrc | dzen2 -x '320' -w '704' -ta 'r'" ++ myDzenStyle
myDzenStyle  = " -h '20' -fg '#777777' -bg '#222222' -fn 'arial:bold:size=11'"
 
main = do
status <- spawnPipe myDzenStatus    -- xmonad status on the left
conky  <- spawnPipe myDzenConky     -- conky stats on the right
xmonad $ defaultConfig
       {
       manageHook = manageDocks <+> managehook <+> manageHook defaultConfig
       , handleEventHook = fullscreenEventHook
       , startupHook = setWMName "LG3D" -- java compatability
       , layoutHook = smartBorders $ avoidStruts $ ml
       , logHook = dynamicLog
	 , borderWidth = bw
	 , normalBorderColor = nbc
	 , focusedBorderColor = fbc
	 , workspaces = wspcs
	 , terminal = term
	 } `additionalKeys`
	 [((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 3%-")
	 , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 3%+")
	 , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
	 ] `additionalKeysP` [("M-n", spawn "urxvtc -e ncmpcpp")]
