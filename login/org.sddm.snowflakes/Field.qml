// Dark inset text field with a leading icon and placeholder.
import QtQuick

FocusScope {
    id: field

    property alias text: input.text
    property alias echoMode: input.echoMode
    property alias input: input
    property string placeholder: ""
    property url icon
    property string fontFamily: "monospace"
    property color textColor: "#DBE8F5"
    property color mutedColor: "#8397B0"

    signal accepted()

    implicitHeight: 42
    activeFocusOnTab: true

    Rectangle {
        anchors.fill: parent
        radius: 9
        color: "#66000000"
        border.width: 1
        border.color: input.activeFocus ? "#BF77B6E1" : "#5277B6E1"
        Behavior on border.color { ColorAnimation { duration: 200 } }
    }
    // focus glow
    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: 12
        color: "transparent"
        border.width: 3
        border.color: "#2877B6E1"
        opacity: input.activeFocus ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Image {
        id: glyph
        source: field.icon
        width: 16; height: 16
        sourceSize: Qt.size(32, 32)
        smooth: true
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    TextInput {
        id: input
        anchors.left: glyph.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        focus: true
        clip: true
        color: field.textColor
        selectionColor: "#77B6E1"
        selectedTextColor: "#000000"
        selectByMouse: true
        passwordCharacter: "•"
        passwordMaskDelay: 0
        font.family: field.fontFamily
        font.pixelSize: 14
        onAccepted: field.accepted()
    }

    Text {
        anchors.fill: input
        verticalAlignment: Text.AlignVCenter
        text: field.placeholder
        color: field.mutedColor
        opacity: 0.85
        font: input.font
        visible: input.text.length === 0 && input.preeditText.length === 0
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        onPressed: function (mouse) { input.forceActiveFocus(); mouse.accepted = false }
    }
}
