-- awful.util.spawn("killall trayer")
--awful.util.spawn(os.getenv('HOME') .. "/bin/run_once nm-applet")
--awful.util.spawn(os.getenv('HOME') .. "/bin/run_once kmix")
--awful.util.spawn(os.getenv('HOME') .. "/bin/run_once klipper")
--awful.util.spawn(os.getenv('HOME') .. "/bin/run_once pulseaudio -D")
--awful.util.spawn(os.getenv('HOME') .. "/bin/run_once xscreensaver")
--awful.util.spawn(os.getenv('HOME') .. "/bin/run_once udiskie")

run_once("nm-applet")
--run_once("kmix")
run_once("gnome-sound-applet")
run_once("klipper")
run_once("pulseaudio -D")
run_once("xscreensaver")
run_once("udiskie")


awful.util.spawn("wmname LG3D")
awful.util.spawn("feh --bg-scale ~/.config/qtile/wallpaper.jpg")
-- awful.util.spawn("trayer --edge top --align right --widthtype pixels --width 100 --height 18 --SetDockType true --transparent true --alpha 102 --distance 0 --expand false --margin 20 --padding 0 --tint 0x2D2D2D")
