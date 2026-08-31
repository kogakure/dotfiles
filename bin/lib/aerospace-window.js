// Window geometry I/O for the aerospace-* scripts, over the macOS
// Accessibility API.
//
// AeroSpace cannot place or size a floating window: `resize` is tiling-only
// (nikitabobko/AeroSpace#9) and there is no command to set a position at all
// (nikitabobko/AeroSpace#494). So the two aerospace-* scripts read and write
// the frame here instead.
//
// This file is deliberately plain I/O. Every decision about *what* the frame
// should be lives in the pure helpers in bin/lib/aerospace.sh, which can be
// exercised without a window server, a focused window, or an accessibility
// grant — the same seam bin/lib/shells.sh draws between shells_file_desired
// and register_login_shell.
//
// All coordinates in and out are System Events coordinates: one top-left
// origin shared by every display, y growing downward. NSScreen uses a
// bottom-left origin, so visibleFrame is converted below.
//
// It lives under bin/lib/ with a .js extension rather than in bin/ so that
// dotfiles-lint's shell_sources() never sees it: that glob is
// `bin/* bin/lib/*.sh`, so a non-.sh file under lib/ is out by construction
// rather than by its shebang.
//
// Usage: osascript -l JavaScript aerospace-window.js <action> [args...]
//
//   frame                      "x y width height" of the frontmost window
//   visible-frame              "x y width height" of the screen that window
//                              sits on, menu bar and Dock excluded
//   visible-frame-screen ID    the same, for an explicitly named screen —
//                              the only action that needs no window, and so
//                              the only one usable against a window that is
//                              not frontmost
//   set-frame x y width height

function run(argv) {
    ObjC.import('AppKit')

    const action = argv[0]

    // Addressed by screen, so this is resolved before any window lookup: a
    // callback firing on a window that is not frontmost has nothing for
    // System Events to return.
    if (action === 'visible-frame-screen') {
        return formatBox(screenBox(requireInt(argv[1], 'screen-id')))
    }

    const win = frontmostWindow()

    if (action === 'frame') {
        const pos = win.position()
        const size = win.size()
        return [pos[0], pos[1], size[0], size[1]].join(' ')
    }

    if (action === 'visible-frame') {
        return formatBox(screenBoxContaining(win))
    }

    if (action === 'set-frame') {
        const x = requireInt(argv[1], 'x')
        const y = requireInt(argv[2], 'y')
        const width = requireInt(argv[3], 'width')
        const height = requireInt(argv[4], 'height')

        // Size, position, size again. An app that clamps the first size —
        // a minimum, or a terminal snapping to its character grid — otherwise
        // ends up positioned for a rectangle it never accepted, and lands
        // off-centre.
        win.size = [width, height]
        win.position = [x, y]
        win.size = [width, height]
        return ''
    }

    throw new Error('unknown action: ' + String(action))
}

function requireInt(value, name) {
    const n = parseInt(value, 10)
    if (isNaN(n)) throw new Error(name + ' is not a number: ' + String(value))
    return n
}

function formatBox(box) {
    return [box.x, box.y, box.width, box.height].join(' ')
}

// The frontmost application's first window. Normally the focused one; an app
// with floating inspector panels can disagree, which is the same assumption
// bin/aerospace-resize-percent has always made.
function frontmostWindow() {
    const se = Application('System Events')
    const frontmost = se.processes.whose({ frontmost: true })[0]
    if (!frontmost.exists()) throw new Error('no frontmost process')

    const win = frontmost.windows[0]
    if (!win.exists()) throw new Error('frontmost process has no window')
    return win
}

// Every screen's visible frame, in System Events coordinates, in NSScreen
// order. visibleFrame rather than frame, so a centred window lands below the
// menu bar and above the Dock; AeroSpace's outer gaps do not apply to floating
// windows, so this is the whole of the usable rectangle.
function screenBoxes() {
    // NSScreen's origin is bottom-left and the main screen sits at (0, 0), so
    // its height is what converts a y between the two coordinate spaces.
    const mainHeight = $.NSScreen.mainScreen.frame.size.height
    const screens = $.NSScreen.screens
    const boxes = []

    for (let i = 0; i < screens.count; i++) {
        const vf = screens.objectAtIndex(i).visibleFrame
        boxes.push({
            x: Math.round(vf.origin.x),
            y: Math.round(mainHeight - (vf.origin.y + vf.size.height)),
            width: Math.round(vf.size.width),
            height: Math.round(vf.size.height),
        })
    }

    if (boxes.length === 0) throw new Error('no screens')
    return boxes
}

// A screen by the id AeroSpace reports as
// %{monitor-appkit-nsscreen-screens-id}, which is **1-based**: on a two-screen
// setup here it reports 1 and 2, and the one it reports as 1 is the same
// display %{monitor-is-main} is true for — which is NSScreen.screens[0].
function screenBox(id) {
    const boxes = screenBoxes()
    if (id < 1 || id > boxes.length) {
        throw new Error(
            'screen id ' + id + ' is out of range (1..' + boxes.length + ')'
        )
    }
    return boxes[id - 1]
}

// The screen holding the window's centre.
function screenBoxContaining(win) {
    const pos = win.position()
    const size = win.size()
    const cx = pos[0] + size[0] / 2
    const cy = pos[1] + size[1] / 2

    const boxes = screenBoxes()

    for (let i = 0; i < boxes.length; i++) {
        const box = boxes[i]
        const inX = cx >= box.x && cx <= box.x + box.width
        const inY = cy >= box.y && cy <= box.y + box.height
        if (inX && inY) return box
    }

    // boxes[0] is the screen carrying the menu bar. Used only when the
    // window's centre is off every display, which happens while AeroSpace has
    // a workspace parked off-screen.
    return boxes[0]
}
