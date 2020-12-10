import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Util.SpawnOnce
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps

-- Set variables
myTerm = "xterm" -- use xterm as terminal
myBorderWidth = 3 -- i like fat borders
myNormalBorderColor  = "#072822" -- nice color
myFocusedBorderColor = "#01f9c6" -- ^
myModMask = mod4Mask -- windows key

-- Autostart
myStartupHook = do
    spawnOnce "/home/jz/.xmonad/autostart.sh"

-- Gaps
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    tiled = smartSpacing 5 $ Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/jz/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/jz/.config/xmobar/xmobarrc0"
    xmonad $ docks def
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = myLayout 
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
	, startupHook = myStartupHook -- autostart
        , focusedBorderColor = myFocusedBorderColor
        , normalBorderColor = myNormalBorderColor
        , borderWidth = myBorderWidth
        } `additionalKeys`
        [ ((myModMask .|. shiftMask, xK_Return), spawn "dmenu_run" )
        , ((myModMask .|. shiftMask, xK_z), spawn "kill -9 $(pgrep xmobar)" )
        , ((myModMask, xK_Return), spawn myTerm)
        , ((myModMask .|. shiftMask, xK_e), spawn "xterm -e vifm" )
        , ((myModMask, xK_v), spawn "xterm -e vim" )
        ]

