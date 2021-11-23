import XMonad
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys,additionalKeysP)
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar $HOME/.xmobarrc"
    xmproc <- spawnPipe "$HOME/custom_scripts/inc2.sh"
    xmproc <- spawnPipe "~/.fehbg &"
    xmonad $ docks defaultConfig {
        manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
              , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , handleEventHook = handleEventHook def <+> fullscreenEventHook
        , startupHook = startupHook def <+> setFullscreenSupported
        , normalBorderColor = "#000000"
        , focusedBorderColor = "#657583"
        , terminal="terminator"
        }`additionalKeys`
        [((mod4Mask, xK_l), spawn "slock")
        , ((mod4Mask, xK_p), spawn "/home/fedeb/hdmi.sh")
        , ((0, xK_Print), spawn "scrot -q 1 $HOME/Pictures/screen%Y-%m-%d-%H:%M:%S.png")
        , ((mod4Mask, xK_t), spawn "$HOME/telegram")
        ]
        `additionalKeysP`
        [("M-<F6>", spawn "$HOME/custom_scripts/inc2.sh")
        , ("M-<F5>", spawn "$HOME/custom_scripts/dec2.sh")
        , ("M-<F11>", lowerVolume 4 >> return())
        , ("M-<F12>", raiseVolume 4 >> return())
        , ("M-<F10>", toggleMute >> return())
        , ("M-<F2>", spawn "$HOME/custom_scripts/nettogle.sh")
        ]

-- hack to let firefox fullscreen
setFullscreenSupported :: X ()
setFullscreenSupported = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- mapM getAtom ["_NET_WM_STATE_HIDDEN"
                         ,"_NET_WM_STATE_FULLSCREEN" -- XXX Copy-pasted to add this line
                         ,"_NET_NUMBER_OF_DESKTOPS"
                         ,"_NET_CLIENT_LIST"
                         ,"_NET_CLIENT_LIST_STACKING"
                         ,"_NET_CURRENT_DESKTOP"
                         ,"_NET_DESKTOP_NAMES"
                         ,"_NET_ACTIVE_WINDOW"
                         ,"_NET_WM_DESKTOP"
                         ,"_NET_WM_STRUT"
                         ]
    io $ changeProperty32 dpy r a c propModeReplace (fmap fromIntegral supp)
    setWMName "xmonad"
