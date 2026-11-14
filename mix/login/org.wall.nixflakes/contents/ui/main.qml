// Flying Snowflakes — Plasma 6 wallpaper plugin
// Works on the desktop and on the lock screen.
import QtQuick
import org.kde.plasma.plasmoid

WallpaperItem {
    id: wallpaper

    readonly property real warpSpeed: 4
    readonly property int flakeCount: 64

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    Item {
        id: field
        anchors.fill: parent

        readonly property real zFar: 1000
        readonly property real zNear: 8
        readonly property real spread: 1100
        readonly property real flakeSize: 90
        readonly property real aspect: 2010 / 2320
        property var flakeState: []

        function spawn(f, anyDepth) {
            f.x = (Math.random() * 2 - 1) * spread
            f.y = (Math.random() * 2 - 1) * spread
            f.z = anyDepth ? zNear + Math.random() * (zFar - zNear) : zFar
            return f
        }

        Component.onCompleted: {
            var s = []
            for (var i = 0; i < wallpaper.flakeCount; i++) s.push(spawn({}, true))
            flakeState = s
        }

        Repeater {
            id: flakes
            model: wallpaper.flakeCount
            Image {
                source: Qt.resolvedUrl("../images/flake.png")
                sourceSize.width: 512
                smooth: true
                mipmap: true
                visible: false
            }
        }

        FrameAnimation {
            running: wallpaper.visible
            onTriggered: {
                var dt = Math.min(frameTime, 0.1)
                var v = wallpaper.warpSpeed * 22          // depth units / second
                var W = field.width, H = field.height
                var focal = Math.min(W, H) * 0.55
                var cx = W / 2, cy = H / 2
                var st = field.flakeState

                for (var i = 0; i < st.length; i++) {
                    var f = st[i]
                    var img = flakes.itemAt(i)
                    if (!img) continue

                    f.z -= v * dt
                    if (f.z <= field.zNear) field.spawn(f, false)

                    var s = focal / f.z
                    var w = field.flakeSize * s
                    var h = w * field.aspect
                    var sx = cx + f.x * s
                    var sy = cy + f.y * s

                    if (sx + w < 0 || sx - w > W || sy + h < 0 || sy - h > H) {
                        if (f.z < field.zFar * 0.9) field.spawn(f, false)
                        img.visible = false
                        continue
                    }
                    img.x = sx - w / 2
                    img.y = sy - h / 2
                    img.width = w
                    img.height = h
                    img.z = -f.z                              // near flakes paint on top
                    img.opacity = Math.min(1, (field.zFar - f.z) / (field.zFar * 0.25))
                    img.visible = w >= 1
                }
            }
        }
    }
}
