<!-- 全局js -->
<#include "/admin/common/css.ftl">
<#include "/admin/common/js.ftl">
<#include "/admin/common/ztree.ftl">
    <script type="text/javascript">
        $(document).ready(function () {
            //初始化表格,动态从服务器加载数据
            $("#table_station_list").bootstrapTable({
                //使用get请求到服务器获取数据
                method: "POST",
                //必须设置，不然request.getParameter获取不到请求参数
                contentType: "application/x-www-form-urlencoded",
                //获取数据的Servlet地址
                url: "${ctx!}/admin/station/list",
                //表格显示条纹
                striped: true,
                //启动分页
                pagination: true,
                //每页显示的记录数
                pageSize: 10,
                //当前第几页
                pageNumber: 1,
                //记录数可选列表
                pageList: [5, 10, 15, 20, 25],
                //是否启用查询
                search: true,
                //是否启用详细信息视图
                //detailView:true,
                //detailFormatter:detailFormatter,
                //表示服务端请求
                sidePagination: "server",
                //设置为undefined可以获取pageNumber，pageSize，searchText，sortName，sortOrder
                //设置为limit可以获取limit, offset, search, sort, order
                queryParamsType: "undefined",
                //json数据解析
                responseHandler: function(res) {
                    return {
                        "rows": res.content,
                        "total": res.totalElements
                    };
                },
                //数据列
                columns: [{
                    title: "ID",
                    field: "id",
                    sortable: true
                },{
                    title: "文件名",
                    field: "fileName"
                },{
                    title: "大小",
                    field: "fileSize",
                },{
                    title: "创建时间",
                    field: "createTime"
                },{
                    title: "操作",
                    field: "empty",
                    formatter: function (value, row, index) {
                        var operateHtml = '<@shiro.hasPermission name="system:user:edit"><button class="btn btn-primary btn-xs" type="button" onclick="down(\''+row.fileUrl+'\')"><i class="fa fa-edit"></i>&nbsp;下载</button> &nbsp;</@shiro.hasPermission>';
                        operateHtml = operateHtml + '<@shiro.hasPermission name="system:user:deleteBatch"><button class="btn btn-danger btn-xs" type="button" onclick="del(\''+row.id+'\')"><i class="fa fa-remove"></i>&nbsp;删除</button> &nbsp;</@shiro.hasPermission>';
                        return operateHtml;
                    }
                }]
            });
            $.get("${ctx!}/admin/station/tree",function(data){
                console.log("|||"+data);
                var zNodes =eval(data);
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            })
        });
        var setting = {
            view: {
                addHoverDom: addHoverDom,
                removeHoverDom: removeHoverDom,
                selectedMulti: false
            },
            edit: {
                enable: true,
                editNameSelectAll: false,
                removeTitle: '删除',
                renameTitle: '编辑'

            },
            data: {
                simpleData: {
                    enable: true
                }
            },
            callback: {
                beforeDrag: beforeDrag,
                beforeEditName: beforeEditName,
                beforeRemove: beforeRemove,
                beforeRename: beforeRename,
                onRemove: onRemove,
                onRename: onRename,
                onClick: onClick
            }
        };

        function beforeDrag(treeId, treeNodes) {
            return false;
        };
        function beforeEditName(treeId, treeNode) {
            //return confirm("确认编辑节点 " + treeNode.name +" 吗？");
        };
        function beforeRemove(treeId, treeNode) {
            var zTree = getTree();
            zTree.selectNode(treeNode);
            return confirm("确认删除节点 " + treeNode.name + " 吗？");
        };
        /*删除节点*/
        function onRemove(e, treeId, treeNode) {
            var nodeId = treeNode.id;
            $.ajax({
                url: '/admin/station/del/'+nodeId,
                type: 'DELETE',
                data: {}
            });
        };

        function beforeRename(treeId, treeNode, newName) {
            newName = $.trim(newName);
            if (newName.length == 0) {
                alert("节点名称不能为空.");
                var zTree = getTree();
                setTimeout(function(){zTree.editName(treeNode)}, 10);
                return false;
            }
            return true;
        };
        /*修改节点*/
        function onRename(e,treeId,treeNode){
            console.log("treeId:"+treeId);
            $.post("/admin/station/update/"+treeNode.id,treeNode,function(data){

            });
        };

        /*点击新增增加节点*/
        function addHoverDom(treeId, treeNode) {
            var sObj = $("#" + treeNode.tId + "_span");
            if (treeNode.editNameFlag || $("#addBtn_"+treeNode.id).length>0) return;
            var addStr = "<span class='button add' id='addBtn_" + treeNode.id
                    + "' title='新增' ></span>";
            sObj.after(addStr);
            var btn = $("#addBtn_"+treeNode.id);
            if (btn) btn.bind("click", function(){
                saveNode(treeNode);
                return false;
            });
        };

        function removeHoverDom(treeId, treeNode) {
            $("#addBtn_"+treeNode.id).unbind().remove();
        };

        /*保存新的节点*/
        function saveNode(parentNode){
            var zTree = getTree();
            var _nodeName="新节点";
            $.post('/admin/station/save',{pId:parentNode.id,name:_nodeName},function(data){
                var newCode = {id:data.nodeCode,pId:parentNode.id,name:_nodeName};
                zTree.addNodes(parentNode,newCode);
            },"json");
        };
        /*单击节点显示节点详情*/
        function onClick(e,treeId,treeNode){
            console.log("|||"+treeNode.id+"|||"+treeNode.name)
            //初始化表格,动态从服务器加载数据
            $(".fileUploadBtton").attr("dataid",treeNode.id);
            var opt = {
                url: "${ctx!}/admin/station/list",
                silent: true,
                query:{
                    nodeCode:treeNode.id
                }
            };

            $("#table_station_list").bootstrapTable('refresh', opt);
        };

        function upload(){
            layer.open({
                type: 2,
                title: '上传',
                shadeClose: true,
                shade: false,
                area: ['600px', '600px'],
                content: '${ctx!}/admin/station/upload',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        };

        function uploadFile(){
            var id=$(".fileUploadBtton").attr("dataid");
            console.log("id:++"+id);
            layer.open({
                type: 2,
                title: '上传文件',
                shadeClose: true,
                shade: false,
                area: ['600px', '600px'],
                content: '${ctx!}/admin/station/uploadFile?nodeCode='+id,
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        };

        function getTree(){
            return $.fn.zTree.getZTreeObj("treeDemo");
        };
        function down(url){
            window.open(url);
            //window.location.href=url;
        }
        function del(id){
            layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
                $.ajax({
                    type: "DELETE",
                    dataType: "json",
                    url: "${ctx!}/admin/station/delete/" + id,
                    success: function(msg){
                        layer.msg(msg.message, {time: 2000},function(){
                            $('#table_station_list').bootstrapTable("refresh");
                            layer.close(index);
                        });
                    }
                });
            });
        };
    </script>

<body class="gray-bg">
    <div class="wrapper wrapper-content  animated fadeInRight">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox ">
                    <div class="ibox-title">
                        <h5>车站信息管理</h5>
                    </div>
                    <div class="ibox-content">
                        <p>
                        	<@shiro.hasPermission name="system:resource:add">
                        		<#--<button class="btn btn-success " type="button" onclick="add();"><i class="fa fa-plus"></i>&nbsp;添加</button>-->
                                <#--<button class="btn btn-success " type="button" onclick="upload();"><i class="fa fa-plus"></i>&nbsp;上传</button>-->
                                <button class="btn btn-success fileUploadBtton" type="button" onclick="uploadFile();"><i class="fa fa-plus"></i>&nbsp;上传文件</button>
                        	</@shiro.hasPermission>
                        </p>
                        <hr>
                        <div class="row row-lg">
		                    <div class="col-sm-3">
                                    <div class='tree'><ul id="treeDemo" class="ztree"></ul></div>
                            </div>
                            <div class="col-sm-9">
		                        <!-- Example Card View -->
		                        <div class="example-wrap">
		                            <div class="example">
		                            	<table id="table_station_list"></table>
		                            </div>
		                        </div>
		                        <!-- End Example Card View -->
		                    </div>
	                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
