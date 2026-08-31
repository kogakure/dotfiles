# Geometry helpers shared by bin/aerospace-float-center and
# bin/aerospace-resize-percent.
#
# AeroSpace has no command that can place a window and none that can size a
# *floating* one: `resize` is tiling-only (nikitabobko/AeroSpace#9) and there
# is no position command at all (nikitabobko/AeroSpace#494). Both scripts
# therefore go through the Accessibility API, via bin/lib/aerospace-window.js.
#
# The arithmetic is separated from the write for the same reason
# bin/lib/shells.sh separates shells_file_desired from register_login_shell:
# aerospace_centered_frame and aerospace_resized_frame are pure, take every
# input as an argument, and can be checked without a window server, a focused
# window or an accessibility grant. aerospace_window is the impure half.
#
# **Not** sourced by common.sh — only the two aerospace-* scripts need it, the
# same rule shells.sh and privilege.sh follow.
#
# All coordinates are System Events coordinates: one top-left origin shared by
# every display, y growing downward. See aerospace-window.js.

# The JXA helper, resolved from this file's own location rather than from the
# repo root, since the aerospace-* scripts are invoked by absolute path from
# AeroSpace's `exec-and-forget` and by bare name from PATH.
_DL_AEROSPACE_JS="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)/aerospace-window.js"

# Round $1/$2 to the nearest integer, for $2 > 0. $(( )) truncates, and a
# truncated percentage of a 3456px display is off by enough to see.
aerospace_div_round() {
    printf '%s\n' "$(((2 * $1 + $2) / (2 * $2)))"
}

# Clamp $1 into [$2, $3].
aerospace_clamp() {
    if [ "$1" -lt "$2" ]; then
        printf '%s\n' "$2"
    elif [ "$1" -gt "$3" ]; then
        printf '%s\n' "$3"
    else
        printf '%s\n' "$1"
    fi
}

# The largest W_PCT x H_PCT rectangle inside a visible frame, centred in it.
# Echoes "x y width height".
#
# Usage: aerospace_centered_frame VX VY VW VH W_PCT H_PCT
aerospace_centered_frame() {
    local vx="$1" vy="$2" vw="$3" vh="$4" w_pct="$5" h_pct="$6"
    local w h

    w=$(aerospace_clamp "$(aerospace_div_round "$((vw * w_pct))" 100)" 1 "$vw")
    h=$(aerospace_clamp "$(aerospace_div_round "$((vh * h_pct))" 100)" 1 "$vh")

    printf '%s %s %s %s\n' \
        "$((vx + (vw - w) / 2))" "$((vy + (vh - h) / 2))" "$w" "$h"
}

# Resize one axis of an existing frame to a pixel value, holding the window's
# centre on that axis and keeping the result inside the visible frame.
# Echoes "x y width height".
#
# Holding the centre rather than the top-left corner is what makes this compose
# with aerospace_centered_frame: a window centred by the float toggle and then
# widened stays centred, instead of growing rightwards off the display.
#
# Usage: aerospace_resized_frame X Y W H VX VY VW VH (width|height) PIXELS
aerospace_resized_frame() {
    local x="$1" y="$2" w="$3" h="$4"
    local vx="$5" vy="$6" vw="$7" vh="$8"
    local dimension="$9" pixels="${10}"
    local centre

    if [ "$dimension" = width ]; then
        centre=$((x + w / 2))
        w=$(aerospace_clamp "$pixels" 1 "$vw")
        x=$(aerospace_clamp "$((centre - w / 2))" "$vx" "$((vx + vw - w))")
    else
        centre=$((y + h / 2))
        h=$(aerospace_clamp "$pixels" 1 "$vh")
        y=$(aerospace_clamp "$((centre - h / 2))" "$vy" "$((vy + vh - h))")
    fi

    printf '%s %s %s %s\n' "$x" "$y" "$w" "$h"
}

# Run the JXA helper. Everything that touches a real window goes through here.
aerospace_window() {
    osascript -l JavaScript "$_DL_AEROSPACE_JS" "$@"
}

# The focused window's layout as AeroSpace sees it: one of h_tiles, v_tiles,
# h_accordion, v_accordion, floating, macos_native_window_of_hidden_app.
# `list-windows` right-pads its columns, so the whitespace is stripped rather
# than trusted.
aerospace_window_layout() {
    aerospace list-windows --focused --format '%{window-parent-container-layout}' |
        tr -d '[:space:]'
}

# Layout and NSScreen id for a window addressed by id. Echoes "layout screen".
#
# `list-windows` has no --window-id flag, so this filters --all rather than
# querying one window. One call for both fields: the alternative is two
# subprocesses in a callback that is already racing AeroSpace's own tiling.
aerospace_window_info() {
    aerospace list-windows --all --format \
        '%{window-id} %{window-parent-container-layout} %{monitor-appkit-nsscreen-screens-id}' |
        awk -v id="$1" '$1 == id { print $2, $3; found = 1 } END { exit !found }'
}

# True when a layout is one AeroSpace actually tiles, and so one `resize` can
# act on. Rules out `floating` and `macos_native_window_of_hidden_app`, which
# is what a window of a hidden app reports.
aerospace_layout_is_tiling() {
    case "$1" in
        h_tiles | v_tiles | h_accordion | v_accordion) return 0 ;;
    esac
    return 1
}
