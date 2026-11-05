// Blurs whatever part of `source` sits behind this item, clipped to a rounded rect.
// Requires Qt >= 6.5 (QtQuick.Effects). Loaded through a Loader by Glass.qml.
import QtQuick
import QtQuick.Effects

Item {
    id: blur

    property Item source: null
    property real radius: 14

    ShaderEffectSource {
        id: snap
        anchors.fill: parent
        sourceItem: blur.source
        live: true
        visible: false
    }

    // Keep the sampled region under the panel, even while it moves (shake, fades).
    FrameAnimation {
        running: blur.source !== null && blur.visible
        onTriggered: {
            var p = blur.mapToItem(blur.source, 0, 0)
            snap.sourceRect = Qt.rect(p.x, p.y, blur.width, blur.height)
        }
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: blur.radius
        color: "white"
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: snap
        autoPaddingEnabled: false
        blurEnabled: true
        blur: 1.0
        blurMax: 40
        saturation: 0.35
        maskEnabled: true
        maskSource: mask
    }
}
