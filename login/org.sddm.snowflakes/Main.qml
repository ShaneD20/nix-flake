// Flying Snowflakes — SDDM greeter theme (Qt 6)
// NixOS logomarks fly out of the dark, Windows 3.1 "Flying Windows" style,
// behind a smoked-glass sci-fi login panel.
import QtQuick

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#000000"

    // ---- Fixed screensaver settings ---------------------------------------
    readonly property real warpSpeed: 4
    readonly property int flakeCount: 64

    // ---- Palette ----------------------------------------------------------
    readonly property color cText: "#DBE8F5"
    readonly property color cMuted: "#8397B0"
    readonly property color cIce: "#77B6E1"
    readonly property color cDeep: "#4D6FB7"
    readonly property color cError: "#FF8D9B"

    // ---- theme.conf -------------------------------------------------------
    function cfg(key, fallback) {
        if (typeof config === "undefined" || config === null) return fallback
        var v = config[key]
        return (v === undefined || v === null || String(v) === "") ? fallback : String(v)
    }
    readonly property string displayFont: cfg("displayFont", "Chakra Petch")
    readonly property string monoFont: cfg("monoFont", "IBM Plex Mono")
    readonly property bool useBlur: cfg("blur", "true") !== "false"
    readonly property string timeFormat: cfg("timeFormat", "")
    readonly property string dateFormat: cfg("dateFormat", "dddd, MMMM d")

    // Only the primary screen gets the login UI; other screens just fly.
    readonly property bool isPrimary: typeof primaryScreen === "undefined" ? true : primaryScreen

    property int sessionIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property string sessionName: ""
    property real boost: 1
    property bool busy: false

    // =======================================================================
    // Flake field
    // =======================================================================
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
            for (var i = 0; i < root.flakeCount; i++) s.push(spawn({}, true))
            flakeState = s
        }

        Repeater {
            id: flakes
            model: root.flakeCount
            Image {
                source: "assets/flake.png"
                sourceSize.width: 512
                smooth: true
                mipmap: true
                visible: false
            }
        }

        FrameAnimation {
            running: true
            onTriggered: {
                var dt = Math.min(frameTime, 0.1)
                root.boost = 1 + (root.boost - 1) * Math.exp(-dt * 1.4)
                var v = root.warpSpeed * 22 * root.boost      // depth units / second
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
                    img.z = -f.z                                      // near flakes paint on top
                    img.opacity = Math.min(1, (field.zFar - f.z) / (field.zFar * 0.25))
                    img.visible = w >= 1
                }
            }
        }
    }

    // =======================================================================
    // Login greeter
    // =======================================================================
    Item {
        id: greeter
        anchors.fill: parent
        visible: root.isPrimary

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var d = new Date()
                clockTime.text = root.timeFormat !== ""
                        ? Qt.formatTime(d, root.timeFormat)
                        : d.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
                clockDate.text = Qt.formatDate(d, root.dateFormat)
            }
        }

        Column {
            id: center
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -20
            spacing: 44
            width: Math.min(340, root.width - 32)

            Behavior on opacity { NumberAnimation { duration: 600 } }
            transform: Scale {
                id: leaveScale
                origin.x: center.width / 2
                origin.y: center.height / 2
                Behavior on xScale { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }
                Behavior on yScale { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Text {
                    id: clockTime
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.cText
                    font.family: root.displayFont
                    font.pixelSize: 56
                    font.weight: Font.Light
                    font.letterSpacing: 2
                }
                Text {
                    id: clockDate
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.cMuted
                    font.family: root.monoFont
                    font.pixelSize: 11
                    font.letterSpacing: 2.2
                    font.capitalization: Font.AllUppercase
                }
            }

            Glass {
                id: card
                width: parent.width
                height: cardBody.implicitHeight + 60
                radius: 16
                blurSource: field
                blurEnabled: root.useBlur
                transform: Translate { id: shake }

                // Avatar: the snowflake, half outside the card
                Rectangle {
                    id: avatar
                    width: 64; height: 64; radius: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: -32
                    color: "#F00A101E"
                    border.width: 1
                    border.color: "#9977B6E1"
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -4
                        radius: 36
                        color: "transparent"
                        border.width: 4
                        border.color: "#2277B6E1"
                    }
                    Image {
                        anchors.centerIn: parent
                        source: "assets/flake.png"
                        width: 40
                        height: 40 * 2010 / 2320
                        sourceSize.width: 128
                        smooth: true
                        mipmap: true
                    }
                }

                Column {
                    id: cardBody
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 20
                    anchors.topMargin: 40
                    spacing: 12

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        textFormat: Text.StyledText
                        text: "login on <font color=\"#77B6E1\">" + (typeof sddm !== "undefined" && sddm.hostName ? sddm.hostName : "nixos") + "</font>"
                        color: root.cMuted
                        font.family: root.monoFont
                        font.pixelSize: 11
                        font.letterSpacing: 1.5
                    }

                    Field {
                        id: userField
                        width: parent.width
                        placeholder: "User"
                        icon: "assets/user.png"
                        fontFamily: root.monoFont
                        onAccepted: passField.forceActiveFocus()
                    }

                    Row {
                        width: parent.width
                        spacing: 8
                        Field {
                            id: passField
                            width: parent.width - goBtn.width - parent.spacing
                            placeholder: "Password"
                            icon: "assets/lock.png"
                            fontFamily: root.monoFont
                            echoMode: TextInput.Password
                            onAccepted: root.doLogin()
                        }
                        HudButton {
                            id: goBtn
                            width: 44
                            height: passField.height
                            icon: "assets/arrow.png"
                            label: "Log in"
                            showLabel: false
                            primary: true
                            fontFamily: root.displayFont
                            onClicked: root.doLogin()
                        }
                    }

                    Text {
                        id: status
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        property string message: ""
                        property string kind: ""      // "", "ok", "err"
                        readonly property bool caps: typeof keyboard !== "undefined" && keyboard.capsLock
                        text: message !== "" ? message : (caps ? "Caps Lock is on" : " ")
                        color: kind === "ok" ? root.cIce : (kind === "err" || (message === "" && caps) ? root.cError : root.cMuted)
                        font.family: root.monoFont
                        font.pixelSize: 11
                        font.letterSpacing: 1.4
                        font.capitalization: Font.AllUppercase
                    }
                }
            }
        }

        SequentialAnimation {
            id: shakeAnim
            NumberAnimation { target: shake; property: "x"; to: -7; duration: 60 }
            NumberAnimation { target: shake; property: "x"; to: 7; duration: 70 }
            NumberAnimation { target: shake; property: "x"; to: -5; duration: 70 }
            NumberAnimation { target: shake; property: "x"; to: 4; duration: 70 }
            NumberAnimation { target: shake; property: "x"; to: 0; duration: 60 }
        }

        // ---- Session picker (bottom left) ---------------------------------
        Glass {
            id: sessionMenu
            visible: false
            anchors.left: sessionBtn.left
            anchors.bottom: sessionBtn.top
            anchors.bottomMargin: 10
            width: Math.max(240, sessionList.implicitWidth + 16)
            height: sessionList.implicitHeight + 16
            radius: 12
            brackets: false
            blurSource: field
            blurEnabled: root.useBlur
            z: 10

            Column {
                id: sessionList
                anchors.centerIn: parent
                spacing: 2
                Repeater {
                    model: typeof sessionModel !== "undefined" ? sessionModel : 0
                    delegate: Rectangle {
                        id: sessionRow
                        required property int index
                        required property string name
                        readonly property bool current: index === root.sessionIndex
                        width: Math.max(224, rowText.implicitWidth + 52)
                        height: 34
                        radius: 7
                        color: rowMouse.containsMouse ? "#2677B6E1" : "transparent"
                        onCurrentChanged: if (current) root.sessionName = name
                        Component.onCompleted: if (current) root.sessionName = name
                        Image {
                            visible: sessionRow.current
                            source: "assets/check.png"
                            width: 14; height: 14
                            sourceSize: Qt.size(28, 28)
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            id: rowText
                            anchors.left: parent.left
                            anchors.leftMargin: 32
                            anchors.verticalCenter: parent.verticalCenter
                            text: sessionRow.name
                            color: sessionRow.current ? root.cIce : root.cText
                            font.family: root.displayFont
                            font.pixelSize: 13
                        }
                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.sessionIndex = sessionRow.index
                                sessionMenu.visible = false
                                passField.forceActiveFocus()
                            }
                        }
                    }
                }
            }
        }

        Glass {
            id: sessionPill
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 24
            width: sessionBtn.width + 12
            height: sessionBtn.height + 12
            radius: 14
            brackets: false
            blurSource: field
            blurEnabled: root.useBlur
        }
        HudButton {
            id: sessionBtn
            anchors.left: sessionPill.left
            anchors.leftMargin: 6
            anchors.verticalCenter: sessionPill.verticalCenter
            icon: "assets/session.png"
            label: root.sessionName !== "" ? root.sessionName : "Session"
            fontFamily: root.displayFont
            onClicked: sessionMenu.visible = !sessionMenu.visible
        }

        // ---- Power controls (bottom right) --------------------------------
        Glass {
            id: powerPill
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 24
            width: powerRow.implicitWidth + 12
            height: 52
            radius: 14
            brackets: false
            blurSource: field
            blurEnabled: root.useBlur
            visible: typeof sddm !== "undefined" && (sddm.canSuspend || sddm.canHibernate || sddm.canReboot || sddm.canPowerOff)

            Row {
                id: powerRow
                anchors.centerIn: parent
                spacing: 6
                HudButton {
                    id: suspendBtn
                    visible: typeof sddm !== "undefined" && sddm.canSuspend
                    icon: "assets/suspend.png"; label: "Suspend"
                    fontFamily: root.displayFont
                    onClicked: sddm.suspend()
                }
                HudButton {
                    id: hibernateBtn
                    visible: typeof sddm !== "undefined" && sddm.canHibernate
                    icon: "assets/hibernate.png"; label: "Hibernate"
                    fontFamily: root.displayFont
                    onClicked: sddm.hibernate()
                }
                HudButton {
                    id: rebootBtn
                    visible: typeof sddm !== "undefined" && sddm.canReboot
                    icon: "assets/restart.png"; label: "Restart"
                    fontFamily: root.displayFont
                    onClicked: sddm.reboot()
                }
                HudButton {
                    id: powerBtn
                    visible: typeof sddm !== "undefined" && sddm.canPowerOff
                    icon: "assets/power.png"; label: "Shut down"
                    fontFamily: root.displayFont
                    onClicked: sddm.powerOff()
                }
            }
        }

        // Click outside the session menu closes it
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: sessionMenu.visible = false
        }
    }

    // =======================================================================
    // Behaviour
    // =======================================================================
    function setStatus(msg, kind) {
        status.message = msg
        status.kind = kind || ""
    }

    function doLogin() {
        if (root.busy) return
        var user = userField.text.trim()
        if (user === "") { setStatus("Enter a user name", "err"); shakeAnim.restart(); userField.forceActiveFocus(); return }
        if (passField.text === "") { setStatus("Enter a password", "err"); shakeAnim.restart(); passField.forceActiveFocus(); return }
        root.busy = true
        setStatus("Authenticating…", "")
        sddm.login(user, passField.text, root.sessionIndex)
    }

    Connections {
        target: typeof sddm !== "undefined" ? sddm : null
        function onLoginSucceeded() {
            root.setStatus("Welcome, " + userField.text.trim(), "ok")
            root.boost = 7
            center.opacity = 0
            leaveScale.xScale = 1.06
            leaveScale.yScale = 1.06
        }
        function onLoginFailed() {
            root.busy = false
            passField.text = ""
            root.setStatus("Login failed", "err")
            shakeAnim.restart()
            passField.forceActiveFocus()
        }
    }

    Keys.onEscapePressed: sessionMenu.visible = false

    Component.onCompleted: {
        var last = (typeof userModel !== "undefined" && userModel.lastUser) ? userModel.lastUser : ""
        userField.text = last
        if (last !== "") passField.forceActiveFocus()
        else userField.forceActiveFocus()
    }
}
