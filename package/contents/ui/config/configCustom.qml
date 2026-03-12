import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM

KCM.ScrollViewKCM {
    id: configCustom
    property alias cfg_customCommandsInSeparateMenu: customCommandsInSeparateMenu.checked
    property alias cfg_customCommandsMenuTitle: customCommandsMenuTitle.text
    property alias cfg_showCustomCommandIcons: showCustomCommandIcons.checked
    property alias cfg_defaultCustomCommandIcon: defaultCustomCommandIcon.text
    property list<string> cfg_commands: Plasmoid.configuration.commands ?? []

    function syncCommandsConfig() {
        const entries = []

        for (let i = 0; i < customCommands.count; i++) {
            const command = customCommands.get(i)
            const text = (command.text ?? "").trim()
            const executable = (command.command ?? "").trim()

            if (text.length === 0 && executable.length === 0) {
                continue
            }

            entries.push(JSON.stringify({
                "text": text,
                "command": executable,
                "icon": (command.icon ?? "").trim()
            }))
        }

        cfg_commands = entries
    }

    header: ColumnLayout {
        Switch {
            id: customCommandsInSeparateMenu
            text: i18n("Show custom commands in separate menu")
            checked: Plasmoid.configuration.customCommandsInSeparateMenu ?? false
        }
        RowLayout {
            visible: customCommandsInSeparateMenu.checked
            Layout.fillWidth: true
            Label {
                text: i18n("Custom commands menu title")
            }
            TextField {
                id: customCommandsMenuTitle
                Layout.fillWidth: true
                text: Plasmoid.configuration.customCommandsMenuTitle ?? ""
            }
        }
        Switch {
            id: showCustomCommandIcons
            text: i18n("Show icons for custom commands")
            checked: Plasmoid.configuration.showCustomCommandIcons ?? true
        }
        RowLayout {
            visible: showCustomCommandIcons.checked
            Layout.fillWidth: true
            Label {
                text: i18n("Default icon name")
            }
            TextField {
                id: defaultCustomCommandIcon
                Layout.fillWidth: true
                text: Plasmoid.configuration.defaultCustomCommandIcon ?? "utilities-terminal"
                placeholderText: "utilities-terminal"
            }
        }
        Item {
            Kirigami.FormData.isSection: true
        }
        Kirigami.ActionToolBar {
            alignment: Qt.AlignCenter
            actions: [
                Kirigami.Action {
                    text: i18n("Add command")
                    icon.name: "add"
                    shortcut: StandardKey.New
                    onTriggered: {
                        customCommands.append({
                            "text": "",
                            "command": "",
                            "icon": ""
                        })
                        configCustom.syncCommandsConfig()
                    }
                },
                Kirigami.Action {
                    text: i18n("Clear command list")
                    icon.name: "edit-clear-all"
                    onTriggered: {
                        customCommands.clear()
                        configCustom.syncCommandsConfig()
                    }
                }
            ]
        }
    }

    ListModel {
        id: customCommands
        Component.onCompleted: {
            for (const rawCommand of configCustom.cfg_commands) {
                const command = JSON.parse(rawCommand)
                customCommands.append({
                    "text": command.text,
                    "command": command.command,
                    "icon": command.icon ?? ""
                })
            }
        }
    }

    view: ListView {
        id: commandsList
        height: parent.height
        width: parent.width
        clip: true
        spacing: 1
        model: customCommands
        readonly property int columnSpacing: Kirigami.Units.smallSpacing
        readonly property int deleteButtonWidth: Math.round(Kirigami.Units.gridUnit * 1.8)
        readonly property int iconFieldWidth: Math.round(Kirigami.Units.gridUnit * 8)
        readonly property int tableInset: Kirigami.Units.smallSpacing * 2
        readonly property int viewportWidth: width - tableInset * 2
        readonly property int titleWidth: Math.round((viewportWidth - iconFieldWidth - deleteButtonWidth - columnSpacing * 3) * 0.35)
        readonly property int commandWidth: viewportWidth - titleWidth - iconFieldWidth - deleteButtonWidth - columnSpacing * 3

        header: Item {
            width: commandsList.width
            height: headerRow.implicitHeight + Kirigami.Units.smallSpacing

            Item {
                anchors.fill: parent
                anchors.leftMargin: commandsList.tableInset
                anchors.rightMargin: commandsList.tableInset

                Rectangle {
                    x: commandsList.titleWidth + commandsList.columnSpacing / 2
                    width: 1
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.08)
                }

                Rectangle {
                    x: commandsList.titleWidth + commandsList.commandWidth + commandsList.columnSpacing * 1.5
                    width: 1
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.08)
                }

                GridLayout {
                    id: headerRow
                    width: parent.width
                    columns: 4
                    columnSpacing: commandsList.columnSpacing

                    Label {
                        Layout.preferredWidth: commandsList.titleWidth
                        Layout.fillWidth: true
                        text: i18n("Title")
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        Layout.preferredWidth: commandsList.commandWidth
                        Layout.fillWidth: true
                        text: i18n("Command")
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Label {
                        Layout.preferredWidth: commandsList.iconFieldWidth
                        Layout.fillWidth: true
                        text: i18n("Icon")
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Item {
                        Layout.preferredWidth: commandsList.deleteButtonWidth
                    }
                }
            }
        }

        delegate: Item {
            width: commandsList.width
            height: rowLayout.implicitHeight

            Item {
                anchors.fill: parent
                anchors.leftMargin: commandsList.tableInset
                anchors.rightMargin: commandsList.tableInset

                Rectangle {
                    x: commandsList.titleWidth + commandsList.columnSpacing / 2
                    width: 1
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.06)
                }

                Rectangle {
                    x: commandsList.titleWidth + commandsList.commandWidth + commandsList.columnSpacing * 1.5
                    width: 1
                    height: parent.height
                    color: Qt.rgba(1, 1, 1, 0.06)
                }

                GridLayout {
                    id: rowLayout
                    width: parent.width
                    columns: 4
                    columnSpacing: commandsList.columnSpacing
                    rowSpacing: 0

                    TextField {
                        Layout.preferredWidth: commandsList.titleWidth
                        Layout.fillWidth: true
                        text: model.text

                        onTextChanged: {
                            customCommands.setProperty(model.index, "text", text)
                            configCustom.syncCommandsConfig()
                        }
                    }

                    TextField {
                        Layout.preferredWidth: commandsList.commandWidth
                        Layout.fillWidth: true
                        text: model.command

                        onTextChanged: {
                            customCommands.setProperty(model.index, "command", text)
                            configCustom.syncCommandsConfig()
                        }
                    }

                    TextField {
                        Layout.preferredWidth: commandsList.iconFieldWidth
                        Layout.fillWidth: true
                        text: model.icon ?? ""
                        placeholderText: "utilities-terminal"

                        onTextChanged: {
                            customCommands.setProperty(model.index, "icon", text)
                            configCustom.syncCommandsConfig()
                        }
                    }

                    ToolButton {
                        Layout.preferredWidth: commandsList.deleteButtonWidth
                        Layout.alignment: Qt.AlignRight
                        icon.name: "delete"
                        onClicked: {
                            customCommands.remove(model.index)
                            configCustom.syncCommandsConfig()
                        }
                    }
                }
            }
        }

        onCountChanged: count => {
            Qt.callLater(commandsList.positionViewAtEnd)
        }
    }
}
