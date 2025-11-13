import QtQuick 2.12
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.4
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: buttons

    property bool cfg_showAboutThisPCButton: true
    property bool cfg_showSystemSettingsButton: true
    property bool cfg_showAppStoreButton: true
    property bool cfg_showForceQuitButton: true
    property bool cfg_showSleepButton: true
    property bool cfg_showRestartButton: true
    property bool cfg_showShutdownButton: true
    property bool cfg_showLockScreenButton: true
    property bool cfg_showLogOutButton: true

    property bool listLoaded: false

    Component.onCompleted: {
        syncModelFromProperties()
        
        listLoader.active = true
        listLoaded = true
    }

    ListModel {
        id: buttonsModel
        ListElement { key: "showAboutThisPCButton"; text: i18n("About This PC"); checked: false }
        ListElement { key: "showSystemSettingsButton"; text: i18n("System Settings"); checked: false }
        ListElement { key: "showAppStoreButton"; text: i18n("App Store"); checked: false }
        ListElement { key: "showForceQuitButton"; text: i18n("Force Quit"); checked: false }
        ListElement { key: "showSleepButton"; text: i18n("Sleep"); checked: false }
        ListElement { key: "showRestartButton"; text: i18n("Restart"); checked: false }
        ListElement { key: "showShutdownButton"; text: i18n("Shutdown"); checked: false }
        ListElement { key: "showLockScreenButton"; text: i18n("Lock Screen"); checked: false }
        ListElement { key: "showLogOutButton"; text: i18n("Log Out"); checked: false }
    }

    function syncModelFromProperties() {
        for (var i = 0; i < buttonsModel.count; ++i) {
            var key = buttonsModel.get(i).key;
            var val = false;
            switch (key) {
            case "showAboutThisPCButton": val = cfg_showAboutThisPCButton; break;
            case "showSystemSettingsButton": val = cfg_showSystemSettingsButton; break;
            case "showAppStoreButton": val = cfg_showAppStoreButton; break;
            case "showForceQuitButton": val = cfg_showForceQuitButton; break;
            case "showSleepButton": val = cfg_showSleepButton; break;
            case "showRestartButton": val = cfg_showRestartButton; break;
            case "showShutdownButton": val = cfg_showShutdownButton; break;
            case "showLockScreenButton": val = cfg_showLockScreenButton; break;
            case "showLogOutButton": val = cfg_showLogOutButton; break;
            }
            buttonsModel.setProperty(i, "checked", val);
        }
    }

    function syncPropertyFromModel(index) {
        var key = buttonsModel.get(index).key;
        var checked = buttonsModel.get(index).checked;
        switch (key) {
        case "showAboutThisPCButton": cfg_showAboutThisPCButton = checked; break;
        case "showSystemSettingsButton": cfg_showSystemSettingsButton = checked; break;
        case "showAppStoreButton": cfg_showAppStoreButton = checked; break;
        case "showForceQuitButton": cfg_showForceQuitButton = checked; break;
        case "showSleepButton": cfg_showSleepButton = checked; break;
        case "showRestartButton": cfg_showRestartButton = checked; break;
        case "showShutdownButton": cfg_showShutdownButton = checked; break;
        case "showLockScreenButton": cfg_showLockScreenButton = checked; break;
        case "showLogOutButton": cfg_showLogOutButton = checked; break;
        }
    }


    Loader {
        id: listLoader
        active: false
        anchors.fill: parent
        sourceComponent: listViewContainer
    }

    Component {
        id: listViewContainer
        Rectangle {
            id: container
            anchors.fill: parent
            color: "transparent"
            opacity: 0.0
            y: 8
            Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
            Behavior on y { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }

            Component.onCompleted: {
                Qt.callLater(function() {
                    container.opacity = 1.0
                    container.y = 0
                })
            }

            ListView {
                id: listView
                anchors.fill: parent
                model: buttonsModel
                clip: true
                spacing: 2

                delegate: Item {
                    id: row
                    width: parent.width
                    height: 52
                    property bool appeared: false

                    RowLayout {
                        id: rowLayout
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 12

                        QQC2.Label {
                            id: itemLabel
                            text: model.text
                            horizontalAlignment: Text.AlignLeft
                            Layout.preferredWidth: 300
                            elide: Text.ElideRight
                            opacity: 0.0
                            y: 6
                        }

                        QQC2.Switch {
                            id: itemSwitch
                            checked: model.checked
                            Layout.alignment: Qt.AlignRight
                            opacity: 0.0
                            y: 6
                            onCheckedChanged: {
                                buttonsModel.setProperty(index, "checked", checked)
                                syncPropertyFromModel(index)
                            }
                        }
                    }

                    MouseArea { anchors.fill: parent; onClicked: itemSwitch.checked = !itemSwitch.checked }

                    Timer {
                        id: appearTimer
                        interval: Math.min(300, index * 40)
                        running: !row.appeared
                        repeat: false
                        onTriggered: {
                            row.appeared = true
                            labelAnim.start()
                            switchAnim.start()
                        }
                    }

                    ParallelAnimation {
                        id: labelAnim
                        PropertyAnimation { target: itemLabel; property: "opacity"; from: 0.0; to: 1.0; duration: 260; easing.type: Easing.OutCubic }
                        PropertyAnimation { target: itemLabel; property: "y"; from: 6; to: 0; duration: 260; easing.type: Easing.OutCubic }
                    }

                    ParallelAnimation {
                        id: switchAnim
                        PropertyAnimation { target: itemSwitch; property: "opacity"; from: 0.0; to: 1.0; duration: 260; easing.type: Easing.OutCubic }
                        PropertyAnimation { target: itemSwitch; property: "y"; from: 6; to: 0; duration: 260; easing.type: Easing.OutCubic }
                    }
                }
            }
        }
    }

    onCfg_showAboutThisPCButtonChanged: syncModelFromProperties()
    onCfg_showSystemSettingsButtonChanged: syncModelFromProperties()
    onCfg_showAppStoreButtonChanged: syncModelFromProperties()
    onCfg_showForceQuitButtonChanged: syncModelFromProperties()
    onCfg_showSleepButtonChanged: syncModelFromProperties()
    onCfg_showRestartButtonChanged: syncModelFromProperties()
    onCfg_showShutdownButtonChanged: syncModelFromProperties()
    onCfg_showLockScreenButtonChanged: syncModelFromProperties()
    onCfg_showLogOutButtonChanged: syncModelFromProperties()
}
