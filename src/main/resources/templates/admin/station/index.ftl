<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>车站信息列表</title>
    <meta name="keywords" content="">
    <meta name="description" content="">
    <link rel="shortcut icon" href="favicon.ico"> <link href="${ctx!}/hadmin/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/animate.css" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/style.css?v=4.1.0" rel="stylesheet">
    <!-- 全局js -->
    <!--jquery-->
<#include "/admin/common/common.ftl">
    <script src="${ctx!}/hadmin/js/plugins/zTree/js/jquery.ztree.all.js"></script>
    <link href="${ctx!}/hadmin/js/plugins/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet">
    <script>

        $(document).ready(function () {
            var setting = {
                data: {
                    simpleData: {
                        enable: true,
                        idKey: "id",
                        pIdKey: "pId",
                        rootPId: -1
                    }
                }
            };
            $.ajax({
                type : "GET",
                url : "${ctx!}/admin/station/tree/",
                dataType : 'json',
                success : function(msg) {
                    $.fn.zTree.init($("#tree"), setting, msg);
                }
            });
            //初始化表格,动态从服务器加载数据
            $("#table_list").bootstrapTable({
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
                detailView:true,
                detailFormatter:detailFormatter,
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
                },{
                    title: "车站名称",
                    field: "nodeName"
                },{
                    title: "创建时间",
                    field: "createTime",
                },{
                    title: "更新时间",
                    field: "updateTime",
                },{
                    title: "操作",
                    field: "empty",
                    formatter: function (value, row, index) {
                        var operateHtml = '<@shiro.hasPermission name="system:resource:add"><button class="btn btn-primary btn-xs" type="button" onclick="edit(\''+row.id+'\')"><i class="fa fa-edit"></i>&nbsp;修改</button> &nbsp;</@shiro.hasPermission>';
                        operateHtml = operateHtml + '<@shiro.hasPermission name="system:resource:deleteBatch"><button class="btn btn-danger btn-xs" type="button" onclick="del(\''+row.id+'\')"><i class="fa fa-remove"></i>&nbsp;删除</button></@shiro.hasPermission>';
                        return operateHtml;
                    }
                }]
            });
        });

        function edit(id){
            layer.open({
                type: 2,
                title: '资源修改',
                shadeClose: true,
                shade: false,
                area: ['893px', '600px'],
                content: '${ctx!}/admin/resource/edit/' + id,
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function add(){
            layer.open({
                type: 2,
                title: '资源添加',
                shadeClose: true,
                shade: false,
                area: ['893px', '600px'],
                content: '${ctx!}/admin/resource/add',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function uploadFile(){
            layer.open({
                type: 2,
                title: '批量上传资料',
                shadeClose: true,
                shade: false,
                area: ['600px', '600px'],
                content: '${ctx!}/admin/station/uploadFile',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function del(id){
            layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "${ctx!}/admin/resource/delete/" + id,
                    success: function(msg){
                        layer.msg(msg.message, {time: 2000},function(){
                            $('#table_list').bootstrapTable("refresh");
                            layer.close(index);
                        });
                    }
                });
            });
        }

        function detailFormatter(index, row) {
            var html = [];
            html.push('<p><b>描述:</b> ' + row.description + '</p>');
            return html.join('');
        }
    </script>
</head>

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
                        		<button class="btn btn-success " type="button" onclick="add();"><i class="fa fa-plus"></i>&nbsp;添加</button>
                                <button class="btn btn-success " type="button" onclick="uploadFile();"><i class="fa fa-plus"></i>&nbsp;上传文件</button>
                        	</@shiro.hasPermission>
                        </p>
                        <hr>
                        <div class="row row-lg">
		                    <div class="col-sm-3">
                                <div class="ibox-content">
                                    <ul id="tree" class="ztree"></ul>
                                </div>
                            </div>
                            <div class="col-sm-9">
		                        <!-- Example Card View -->
		                        <div class="example-wrap">
		                            <div class="example">
		                            	<table id="table_list"></table>
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





</body>

</html>
