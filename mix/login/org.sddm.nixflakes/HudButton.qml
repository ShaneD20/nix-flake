// Small glass button: icon, optional uppercase label, hover/focus glow.
import QtQuick

Item {
    id: btn

    property url icon
    property string label: ""
    property string fontFamily: "sans-serif"
    property bool primary: false
    property bool showLabel: true
    signal clicked()

    readonly property bool lit: mouse.containsMouse || activeFocus

    implicitHeight: 40
    implicitWidth: row.implicitWidth + (showLabel && label ? 28 : 24)
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: label

    Keys.onReturnPressed: btn.clicked()
    Keys.onEnterPressed: btn.clicked()
    Keys.onSpacePressed: btn.clicked()

    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: 12
        color: "transparent"
        border.width: 3
        border.color: "#3377B6E1"
        opacity: btn.lit ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 180 } }
    }

    Rectangle {
        id: face
        anchors.fill: parent
        radius: 9
        border.width: 1
        border.color: btn.primary ? "#B3A0D2F5" : (btn.lit ? "#B377B6E1" : "#5277B6E1")
        gradient: Gradient {
            GradientStop { position: 0.00; color: btn.primary ? "#8C77B6E1" : (btn.lit ? "#2E77B6E1" : "#1AFFFFFF") }
            GradientStop { position: 0.50; color: btn.primary ? "#8C4D6FB7" : (btn.lit ? "#1477B6E1" : "#08FFFFFF") }
            GradientStop { position: 0.51; color: btn.primary ? "#B32E488C" : (btn.lit ? "#1477B6E1" : "#05FFFFFF") }
            GradientStop { position: 1.00; color: btn.primary ? "#994D6FB7" : (btn.lit ? "#1F77B6E1" : "#05FFFFFF") }
        }
        Rectangle { x: 6; y: 1; width: parent.width - 12; height: 1; color: btn.primary ? "#59FFFFFF" : "#26FFFFFF" }
    }

    Row {
        id: row
        anchors.centerIn: parent
        anchors.verticalCenterOffset: mouse.pressed ? 1 : 0
        spacing: 8
        Image {
            source: btn.icon
            width: 18; height: 18
            sourceSize: Qt.size(36, 36)
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            visible: btn.showLabel && btn.label.length > 0
            text: btn.label.toUpperCase()
            color: "#DBE8F5"
            font.family: btn.fontFamily
            font.pixelSize: 12
            font.weight: Font.Medium
            font.letterSpacing: 1.6
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
