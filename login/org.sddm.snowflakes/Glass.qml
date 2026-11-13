// Smoked-glass surface: blurred backdrop (optional), tinted fill, glossy top sheen,
// hairline rim and two HUD corner brackets. Children are placed inside `content`.
import QtQuick

Item {
    id: glass

    property real radius: 14
    property Item blurSource: null
    property bool blurEnabled: true
    property bool brackets: true
    property color tint: "#8C0A101E"       // rgba(10,16,30,0.55)
    property color rim: "#5277B6E1"        // rgba(119,182,225,0.32)
    property color bracket: "#CC77B6E1"
    property bool glow: false              // hover / focus glow

    default property alias content: inner.data

    // Soft outer glow when highlighted
    Rectangle {
        anchors.fill: parent
        anchors.margins: -4
        radius: glass.radius + 4
        color: "transparent"
        border.width: 4
        border.color: "#3077B6E1"
        opacity: glass.glow ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    // Backdrop blur lives in its own file so a missing QtQuick.Effects module
    // only costs the blur, never the whole greeter.
    Loader {
        anchors.fill: parent
        active: glass.blurEnabled && glass.blurSource !== null
        source: "GlassBlur.qml"
        onLoaded: {
            item.source = Qt.binding(function () { return glass.blurSource })
            item.radius = Qt.binding(function () { return glass.radius })
        }
    }

    // Tint
    Rectangle {
        anchors.fill: parent
        radius: glass.radius
        color: glass.tint
    }

    // Aero sheen: bright top half that cuts off sharply
    Rectangle {
        anchors.fill: parent
        radius: glass.radius
        gradient: Gradient {
            GradientStop { position: 0.00; color: "#1AFFFFFF" }
            GradientStop { position: 0.42; color: "#05FFFFFF" }
            GradientStop { position: 0.43; color: "#00FFFFFF" }
            GradientStop { position: 1.00; color: "#00FFFFFF" }
        }
    }

    // Rim + inner top highlight
    Rectangle {
        anchors.fill: parent
        radius: glass.radius
        color: "transparent"
        border.width: 1
        border.color: glass.glow ? "#B377B6E1" : glass.rim
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }
    Rectangle {
        x: glass.radius; y: 1
        width: parent.width - glass.radius * 2; height: 1
        color: "#2EFFFFFF"
    }

    // HUD corner brackets (top-left, bottom-right)
    Item {
        visible: glass.brackets
        anchors.fill: parent
        anchors.margins: 6
        Rectangle { x: 0; y: 0; width: 14; height: 1; color: glass.bracket }
        Rectangle { x: 0; y: 0; width: 1; height: 14; color: glass.bracket }
        Rectangle { x: parent.width - 14; y: parent.height - 1; width: 14; height: 1; color: glass.bracket }
        Rectangle { x: parent.width - 1; y: parent.height - 14; width: 1; height: 14; color: glass.bracket }
    }

    Item {
        id: inner
        anchors.fill: parent
    }
}
