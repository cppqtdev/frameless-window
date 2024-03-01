import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluContentPage{

    id:root
    title: "Generate Report"
    signal checkBoxChanged

    property var dataSource : []
    property int sortType: 0

    Component.onCompleted: {
        loadData(1,15)
    }
    onSortTypeChanged: {
        table_view.closeEditor()
        if(sortType === 0){
            table_view.sort()
        }else if(sortType === 1){
            table_view.sort((a, b) => a.age - b.age);
        }else if(sortType === 2){
            table_view.sort((a, b) => b.age - a.age);
        }
    }

    Component{
        id:com_checbox
        Item{
            FluCheckBox{
                anchors.centerIn: parent
                checked: true === options.checked
                enableAnimation: false
                clickListener: function(){
                    var obj = tableModel.getRow(row)
                    obj.checkbox = table_view.customItem(com_checbox,{checked:!options.checked})
                    tableModel.setRow(row,obj)
                    checkBoxChanged()
                }
            }
        }
    }

    Component{
        id:com_action
        Item{
            RowLayout{
                anchors.centerIn: parent

                FluButton{
                    text:"delete"
                    onClicked: {
                        table_view.closeEditor()
                        tableModel.removeRow(row)
                        checkBoxChanged()
                    }
                }

                //                FluFilledButton{
                //                    text:"edit"
                //                    onClicked: {
                //                        var obj = tableModel.getRow(row)
                //                        obj.name = "12345"
                //                        tableModel.setRow(row,obj)
                //                    }
                //                }
            }
        }
    }


    Component{
        id:com_column_checbox
        Item{
            RowLayout{
                anchors.centerIn: parent
                FluText{
                    text:"select all"
                    Layout.alignment: Qt.AlignVCenter
                }
                FluCheckBox{
                    checked: true === options.checked
                    enableAnimation: false
                    Layout.alignment: Qt.AlignVCenter
                    clickListener: function(){
                        var checked = !options.checked
                        itemModel.display = table_view.customItem(com_column_checbox,{"checked":checked})
                        for(var i =0;i< tableModel.rowCount ;i++){
                            var rowData = tableModel.getRow(i)
                            rowData.checkbox = table_view.customItem(com_checbox,{"checked":checked})
                            tableModel.setRow(i,rowData)
                        }
                    }
                }
                Connections{
                    target: root
                    function onCheckBoxChanged(){
                        for(var i =0;i< tableModel.rowCount ;i++){
                            if(false === tableModel.getRow(i).checkbox.options.checked){
                                itemModel.display = table_view.customItem(com_column_checbox,{"checked":false})
                                return
                            }
                        }
                        itemModel.display = table_view.customItem(com_column_checbox,{"checked":true})
                    }
                }
            }
        }
    }

    Component{
        id:com_combobox
        FluComboBox {
            anchors.fill: parent
            focus: true
            currentIndex: display
            editable: true
            model: ListModel {
                ListElement { text: 100 }
                ListElement { text: 300 }
                ListElement { text: 500 }
                ListElement { text: 1000 }
            }
            Component.onCompleted: {
                currentIndex=[100,300,500,1000].findIndex((element) => element === Number(display))
                selectAll()
            }
            onCommit: {
                display = editText
                tableView.closeEditor()
            }
        }
    }

    Component{
        id:com_avatar
        Item{
            FluClip{
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: [20,20,20,20]
                Image{
                    anchors.fill: parent
                    source: {
                        if(options && options.avatar){
                            return options.avatar
                        }
                        return ""
                    }
                    sourceSize: Qt.size(80,80)
                }
            }
        }
    }

    Component{
        id:com_column_sort_age
        Item{
            FluText{
                text:"Age"
                anchors.centerIn: parent
            }
            ColumnLayout{
                spacing: 0
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 4
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronUp
                    iconColor: {
                        if(1 === root.sortType){
                            return FluTheme.primaryColor.dark
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortType === 1){
                            root.sortType = 0
                            return
                        }
                        root.sortType = 1
                    }
                }
                FluIconButton{
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    iconSize: 12
                    verticalPadding:0
                    horizontalPadding:0
                    iconSource: FluentIcons.ChevronDown
                    iconColor: {
                        if(2 === root.sortType){
                            return FluTheme.primaryColor.dark
                        }
                        return FluTheme.dark ?  Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                    }
                    onClicked: {
                        if(root.sortType === 2){
                            root.sortType = 0
                            return
                        }
                        root.sortType = 2
                    }
                }
            }
        }
    }

    FluTableView{
        id:table_view
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: footer.top
        }
        anchors.leftMargin: 10
        anchors.topMargin: 20
        columnSource:[
            {
                title: 'Investigation',
                dataIndex: 'name',
                //readOnly:true,
                width:200,
            },
            {
                title: "Result",
                dataIndex: 'age',
                editDelegate: com_combobox,
                width:100,
                minimumWidth:100,
                maximumWidth:100
            },
            {
                title: 'Reference Value',
                dataIndex: 'address',
                width:200,
                minimumWidth:200,
                maximumWidth:350
            },
            {
                title: 'Unit',
                dataIndex: 'nickname',
                width:100,
                minimumWidth:80,
                maximumWidth:200
            },
            {
                title: ' ',
                dataIndex: 'action',
                width:200,
                minimumWidth:200,
                maximumWidth:200
            }
        ]
    }

    RowLayout{
        id: footer
        width: parent.width
        height: 50
        spacing: 10
        anchors{
            bottom: parent.bottom
            left: parent.left
        }
        FluFilledButton{
            Layout.alignment: Qt.AlignVCenter
            text: "Print"
            onClicked: {
                for(let i = 0;i<table_view.tableModel.rowCount;i++){
                    var data = table_view.tableModel.getRow(i)
                    var person = {
                        "name": data.name,
                        "age": data.age,
                        "address":data.address,
                        "nickname": data.nickname
                    };
                    console.log(JSON.stringify(person))
                }
            }
        }
        FluButton{
            Layout.alignment: Qt.AlignVCenter
            text:"Discard"
            onClicked: {
                loadData(1,15)
            }
        }
        FluButton{
            Layout.alignment: Qt.AlignVCenter
            text:"Add Field"
            onClicked: {
                addField()
                for(let i = 0;i<table_view.tableModel.rowCount;i++){
                    table_view.increasePosition()
                }
            }
        }
        Item{
            Layout.fillWidth: true
        }
    }

    function loadData(page,count){
        var numbers = [100, 300, 500, 1000];
        function getRandomAge() {
            var randomIndex = Math.floor(Math.random() * numbers.length);
            return numbers[randomIndex];
        }

        var names = ["Sun Wukong", "Zhu Bajie", "Monk Sha", "Tang Monk", "Mrs. Bones", "Golden Horn King", "Xiong Shanjun", "Yellow Wind Monster", "Silver Horn King"];
        function getRandomName(){
            var randomIndex = Math.floor(Math.random() * names.length);
            return names[randomIndex];
        }

        var nicknames = ["g/dL","mill/cumm","%","fL","pg","g/dL","cumm"]
        function getRandomNickname(){
            var randomIndex = Math.floor(Math.random() * nicknames.length);
            return nicknames[randomIndex];
        }

        var addresses = ["100 - 200","50 - 100","500 - 2000","1000 - 20000","200 - 500"]
        function getRandomAddresses(){
            var randomIndex = Math.floor(Math.random() * addresses.length);
            return addresses[randomIndex];
        }

        const dataSource = []
        for(var i=0;i<count;i++){
            dataSource.push({
                                name: getRandomName(),
                                age: getRandomAge(),
                                address: getRandomAddresses(),
                                nickname: getRandomNickname(),
                                action: table_view.customItem(com_action),
                                minimumHeight:50
                            })
        }
        root.dataSource = dataSource
        table_view.dataSource = root.dataSource
    }

    function addField(){
        let data = {
            name: "Sample",
            age: 23,
            address: "100-200",
            nickname: "mg",
            action: table_view.customItem(com_action),
            minimumHeight:50
        }
        root.dataSource.push(data)
        table_view.dataSource.push(data)
        table_view.appendRow(data)
    }
}
