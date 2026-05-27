import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Qqc
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Rectangle {
	color: "black"
	width: Window.width
	height: Window.height

	Connections {
		target: sddm

		onLoginSucceeded: {
		}

		onLoginFailed: {
			// Audio trigger removed
		}
	}

	AnimatedImage {
		width: parent.width
		height: parent.height
		fillMode: Image.Tile
		source: "bgN5.gif"
	}

	ColumnLayout {
		width: parent.width
		height: parent.height

		AnimatedImage {
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 2
			width: 192
			height: 192
			source: "WiredLogIn.gif"
		}

		AnimatedImage {
			Layout.alignment: Qt.AlignCenter
			Layout.bottomMargin: 20
			height: 50
			source: "whoIsUser.gif"
		}

		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "Ｕｓｅｒ ＩD:"
			color: "#5eeff5"
			font.pixelSize: 16
		}

		Qqc.TextField {
			id: username
			Layout.alignment: Qt.AlignCenter
			text: userModel.lastUser

			color: "#5eeff5"
			background: Rectangle {
				color: "#000"
				implicitWidth: 200
				border.color: "#3d3b93"
			}

			KeyNavigation.backtab: shutdownBtn; KeyNavigation.tab: password
			Keys.onPressed: {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}

		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "Ｐａｓｓｗｏｒｄ："
			color: "#5eeff5"
			font.pixelSize: 16
		}

		Qqc.TextField {
			id: password
			echoMode: TextInput.Password
			Layout.alignment: Qt.AlignCenter

			color: "#5eeff5"
			background: Rectangle {
				color: "#000"
				implicitWidth: 200
				border.color: "#3d3b93"
			}

			KeyNavigation.backtab: username; KeyNavigation.tab: session
			Keys.onPressed: {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}

		ColumnLayout {
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 4
			Layout.bottomMargin: 50
			width: 200
			Rectangle {
				anchors.fill: parent
				color: "#3d3b93"
			}
			Qqc.Label {
				Layout.alignment: Qt.AlignCenter
				text: "Ｌｏｇｉｎ"
				color: "#5eeff5"
				font.pixelSize: 20
			}
			MouseArea {
				anchors.fill: parent
				onClicked: sddm.login(username.text, password.text, session.index)
			}
		}
	}

	AnimatedImage {
		id: shutdownBtn
		height: 80
		width: 80
		y: 10
		x: Window.width - width - 10
		source: "VisLain.gif"
		fillMode: Image.PreserveAspectFit
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.powerOff()
			onEntered: {
				var component = Qt.createComponent("ShutdownToolTip.qml");
				if (component.status == Component.Ready) {
					var tooltip = component.createObject(shutdownBtn);
					tooltip.x = -45
					tooltip.y = 60
					tooltip.destroy(600);
				}
			}
		}
	}

	AnimatedImage {
		id: rebootBtn
		anchors.right: shutdownBtn.left
		anchors.rightMargin: 5
		y: shutdownBtn.y + 10
		height: 70
		width: 60
		source: "lain_myese.gif"
		fillMode: Image.PreserveAspectFit
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.reboot()
			onEntered: {
				var component = Qt.createComponent("RebootToolTip.qml");
				if (component.status == Component.Ready) {
					var tooltip = component.createObject(rebootBtn);
					tooltip.x = -45
					tooltip.y = 50
					tooltip.destroy(600);
				}
			}
		}
	}

	ComboBox {
		id: session
		height: 30
		width: 200
		x: 15
		y: 20
		model: sessionModel
		index: sessionModel.lastIndex
		color: "#000"
		borderColor: "#3d3b93"
		focusColor: "#3d3b93"
		hoverColor: "#3d3b93"
		textColor: "#5eeff5"
		menuColor: "#000"
		arrowIcon: "angle-down.png"
		KeyNavigation.backtab: password; KeyNavigation.tab: rebootBtn;
	}

	Component.onCompleted: {
		if (username.text == "") {
			username.focus = true
		} else {
			password.focus = true
		}
	}
}
