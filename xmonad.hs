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
import XMonad.Config.Xfce

main = do
    xmproc <- spawnPipe "xfce4-panel --restart" 
    xmonad $ xfceConfig {
	modMask = mod4Mask
        , manageHook = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook xfceConfig 
        , layoutHook = avoidStruts $ smartBorders $ layoutHook xfceConfig
	-- comment for fullscreen
        , handleEventHook = handleEventHook def <+> fullscreenEventHook
        , startupHook = startupHook def <+> setFullscreenSupported
        , normalBorderColor = "#000000"
        , focusedBorderColor = "#657583"
        }

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
