import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2 as OriginalDialogs
import QtQuick.Controls.Styles 1.4

import "../../../styles-uit"
import "../../../controls-uit" as HifiControls
import "../../../windows"
import "../attachments"

Item {
    id: content

    readonly property var originalAttachments: MyAvatar.getAttachmentsVariant();
    property var attachments: [];

    Component.onCompleted: {
        for (var i = 0; i < originalAttachments.length; ++i) {
            var attachment = originalAttachments[i];
            content.attachments.push(attachment);
            listView.model.append({});
        }
    }

    Column {
        width: pane.width

        Rectangle {
            width: parent.width
            height: root.height - (keyboardEnabled && keyboardRaised ? 200 : 0)
            radius: 4
            color: hifi.colors.baseGray

            Rectangle {
                id: attachmentsBackground
                anchors {
                    left: parent.left; right: parent.right; top: parent.top; bottom: newAttachmentButton.top;
                    margins: hifi.dimensions.contentMargin.x
                    bottomMargin: hifi.dimensions.contentSpacing.y
                }
                color: hifi.colors.baseGrayShadow
                radius: 4

                ScrollView {
                    id: scrollView
                    anchors.fill: parent
                    anchors.margins: 4

                    style: ScrollViewStyle {

                        padding {
                            top: 0
                            right: 0
                            bottom: 0
                        }

                        decrementControl: Item {
                            visible: false
                        }
                        incrementControl: Item {
                            visible: false
                        }
                        scrollBarBackground: Rectangle{
                            implicitWidth: 14
                            color: hifi.colors.baseGray
                            radius: 4
                            Rectangle {
                                // Make top left corner of scrollbar appear square
                                width: 8
                                height: 4
                                color: hifi.colors.baseGray
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.left
                            }

                        }
                        handle:
                            Rectangle {
                            implicitWidth: 8
                            anchors {
                                left: parent.left
                                leftMargin: 3
                                top: parent.top
                                topMargin: 3
                                bottom: parent.bottom
                                bottomMargin: 4
                            }
                            radius: 4
                            color: hifi.colors.lightGrayText
                        }
                    }

                    ListView {
                        id: listView
                        model: ListModel {}
                        delegate: Item {
                            id: attachmentDelegate
                            implicitHeight: attachmentView.height + 8;
                            implicitWidth: attachmentView.width
                            Attachment {
                                id: attachmentView
                                width: scrollView.width
                                attachment: content.attachments[index]
                                onDeleteAttachment: {
                                    attachments.splice(index, 1);
                                    listView.model.remove(index, 1);
                                }
                                onUpdateAttachment: MyAvatar.setAttachmentsVariant(attachments);
                            }
                        }
                        onCountChanged: MyAvatar.setAttachmentsVariant(attachments);
                    }

                    function scrollBy(delta) {
                        flickableItem.contentY += delta;
                    }
                }
            }

            HifiControls.Button {
                id: newAttachmentButton
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: buttonRow.top
                    margins: hifi.dimensions.contentMargin.x;
                    topMargin: hifi.dimensions.contentSpacing.y
                    bottomMargin: hifi.dimensions.contentSpacing.y
                }
                text: "New Attachment"
                color: hifi.buttons.black
                colorScheme: hifi.colorSchemes.dark
                onClicked: {
                    var template = {
                        modelUrl: "",
                        translation: { x: 0, y: 0, z: 0 },
                        rotation: { x: 0, y: 0, z: 0 },
                        scale: 1,
                        jointName: MyAvatar.jointNames[0],
                        soft: false
                    };
                    attachments.push(template);
                    listView.model.append({});
                    MyAvatar.setAttachmentsVariant(attachments);
                }
            }

            Row {
                id: buttonRow
                spacing: 8
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: hifi.dimensions.contentMargin.x
                    topMargin: hifi.dimensions.contentSpacing.y
                    bottomMargin: hifi.dimensions.contentSpacing.y
                }
                HifiControls.Button {
                    action: okAction
                    color: hifi.buttons.black
                    colorScheme: hifi.colorSchemes.dark
                }
                HifiControls.Button {
                    action: cancelAction
                    color: hifi.buttons.black
                    colorScheme: hifi.colorSchemes.dark
                }
            }

            Action {
                id: cancelAction
                text: "Cancel"
                onTriggered: {
                    MyAvatar.setAttachmentsVariant(originalAttachments);
                    closeDialog();
                }
            }

            Action {
                id: okAction
                text: "OK"
                onTriggered: {
                    for (var i = 0; i < attachments.length; ++i) {
                        console.log("Attachment " + i + ": " + attachments[i]);
                    }

                    MyAvatar.setAttachmentsVariant(attachments);
                    closeDialog();
                }
            }
        }
    }

    function scrollBy(delta) {
        scrollView.scrollBy(delta);
    }
}

