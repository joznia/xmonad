import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Util.SpawnOnce

-- Set variables
myTerm = "xterm" -- use xterm as terminal
myBorderWidth = 3 -- i like fat borders
myNormalBorderColor  = "#072822" -- nice color
myFocusedBorderColor = "#01f9c6" -- ^
myModMask = mod4Mask -- windows key

-- Autostart

main = do
    xmproc <- spawnPipe "xmobar -x 0 /home/jz/.config/xmobar/xmobarrc0"
    xmonad $ docks def
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , focusedBorderColor = myFocusedBorderColor
        , normalBorderColor = myNormalBorderColor
        , borderWidth = myBorderWidth
        } `additionalKeys`
        [ ((myModMask .|. shiftMask, xK_Return), spawn "dmenu_run" )
        , ((myModMask .|. shiftMask, xK_z), spawn "kill -9 $(pgrep xmobar)" )
        , ((myModMask, xK_Return), spawn myTerm)
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]

