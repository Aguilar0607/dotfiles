# Get the number of connected monitors
num_monitors=$(xrandr --query | grep ' connected' | wc -l)

# Set the monitor number for Eww windows based on the number of connected monitors
if (( num_monitors > 1 )); then
    # If more than one monitor is connected, set windows to open on the external monitor
    sed -i 's/:monitor 0/:monitor 1/g' /home/blaze/.config/eww/setups/leftbar.yuck
else
    # If only one monitor is connected, set windows to open on the main monitor
    sed -i 's/:monitor 1/:monitor 0/g' /home/blaze/.config/eww/setups/leftbar.yuck
fi
