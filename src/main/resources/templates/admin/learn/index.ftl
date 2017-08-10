<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>车站信息列表</title>
    <meta name="keywords" content="">
    <meta name="description" content="">
    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx!}/hadmin/css/bootstrap.min.css?v=${version!}" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/font-awesome.css?v=${version!}" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/plugins/bootstrap-table/bootstrap-table.min.css?v=${version!}" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/animate.css?v=${version!}" rel="stylesheet">
    <link href="${ctx!}/hadmin/css/style.css?v=${version!}" rel="stylesheet">

</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content  animated fadeInRight">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox ">
                    <div class="ibox-title">
                        <h5>学习园地</h5>
                    </div>
                    <div class="col-sm-13">
                        <div class="tabs-container">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"> 培训资料</a>
                                </li>
                                <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">练习/考试</a>
                                </li>
                                <li class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false">考试类型</a>
                                </li>
                            </ul>
                            <div class="tab-content">
                                <div id="tab-1" class="tab-pane active">
                                    <div class="panel-body">
                                            <p>
                                            <@shiro.hasPermission name="system:resource:add">
                                                <button class="btn btn-success " type="button" onclick="uploadFile();"><i class="fa fa-plus"></i>&nbsp;上传</button>
                                                <button class="btn btn-success " type="button" onclick="add();"><i class="fa fa-plus"></i>&nbsp;新建文件夹</button>
                                            </@shiro.hasPermission>
                                            </p>
                                            <hr>
                                            <div class="row row-lg">
                                                <div class="col-sm-12">
                                                    <!-- Example Card View -->
                                                    <div class="example-wrap">
                                                        <div class="example">
                                                            <table id="table_train_list"></table>
                                                        </div>
                                                    </div>
                                                    <!-- End Example Card View -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <div id="tab-2" class="tab-pane">
                                    <div class="panel-body">
                                            <p>
                                            <@shiro.hasPermission name="system:resource:add">
                                                <button class="btn btn-success " type="button" onclick="uploadQuestion();"><i class="fa fa-plus"></i>&nbsp;上传题库</button>
                                                <button class="btn btn-success " type="button" onclick="uploadImage();"><i class="fa fa-plus"></i>&nbsp;批量导入附件</button>
                                            </@shiro.hasPermission>
                                            </p>
                                        <hr>
                                        <div class="row row-lg">
                                            <div class="col-sm-12">
                                                <!-- Example Card View -->
                                                <div class="example-wrap">
                                                    <div class="example">
                                                        <table id="table_bank_list"></table>
                                                    </div>
                                                </div>
                                                <!-- End Example Card View -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="tab-3" class="tab-pane">
                                    <div class="panel-body">
                                        <p>
                                        <@shiro.hasPermission name="system:resource:add">
                                            <button class="btn btn-success " type="button" onclick="configExam();"><i class="fa fa-plus"></i>&nbsp;配置考试类型</button>
                                        </@shiro.hasPermission>
                                        </p>
                                        <hr>
                                        <div class="row row-lg">
                                            <div class="col-sm-12">
                                                <!-- Example Card View -->
                                                <div class="example-wrap">
                                                    <div class="example">
                                                        <table id="table_exam_list"></table>
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

                </div>
            </div>
        </div>
    </div>
    <!-- 全局js -->
	<#include "/admin/common/common.ftl">
    <!-- 自定义js -->
    <script src="${ctx!}/hadmin/js/content.js?v=${version!}"></script>
    <!-- Page-Level Scripts -->
    <script>
        $(document).ready(function () {
            console.log("++++++++++++++++++++++")
			//初始化表格,动态从服务器加载数据
			$("#table_train_list").bootstrapTable({
			    //使用get请求到服务器获取数据
			    method: "POST",
			    //必须设置，不然request.getParameter获取不到请求参数
			    contentType: "application/x-www-form-urlencoded",
			    //获取数据的Servlet地址
			    url: "${ctx!}/admin/train/folder",
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
			   // detailView:true,
			   // detailFormatter:detailFormatter,
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
                    title: "文件夹",
                    field: "name",
                },{
			        title: "创建时间",
			        field: "createTime",
			        sortable: true
			    },{
			        title: "操作",
			        field: "empty",
                    formatter: function (value, row, index) {
                    	var operateHtml = '<@shiro.hasPermission name="system:resource:add"><button class="btn btn-primary btn-xs" type="button" onclick="show(\''+row.name+'\')"><i class="fa fa-edit"></i>&nbsp;查看</button> &nbsp;</@shiro.hasPermission>';
                    	operateHtml = operateHtml + '<@shiro.hasPermission name="system:resource:deleteBatch"><button class="btn btn-danger btn-xs" type="button" onclick="del(\''+row.id+'\')"><i class="fa fa-remove"></i>&nbsp;删除</button></@shiro.hasPermission>';
                        return operateHtml;
                    }
			    }]
			});
            //初始化表格,动态从服务器加载数据
            $("#table_bank_list").bootstrapTable({
                //使用get请求到服务器获取数据
                method: "GET",
                //必须设置，不然request.getParameter获取不到请求参数
                contentType: "application/x-www-form-urlencoded",
                //获取数据的Servlet地址
                url: "${ctx!}/admin/question/bank",
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
                // detailView:true,
                // detailFormatter:detailFormatter,
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
                    title: "问题库",
                    field: "name",
                },{
                    title: "创建时间",
                    field: "createTime",
                    sortable: true
                },{
                    title: "操作",
                    field: "empty",
                    formatter: function (value, row, index) {
                        var operateHtml = '<@shiro.hasPermission name="system:resource:add"><button class="btn btn-primary btn-xs" type="button" onclick="bankShow(\''+row.id+'\')"><i class="fa fa-edit"></i>&nbsp;查看</button> &nbsp;</@shiro.hasPermission>';
                        operateHtml = operateHtml + '<@shiro.hasPermission name="system:resource:deleteBatch"><button class="btn btn-danger btn-xs" type="button" onclick="del(\''+row.id+'\')"><i class="fa fa-remove"></i>&nbsp;删除</button></@shiro.hasPermission>';
                        return operateHtml;
                    }
                }]
            });
            $("#table_exam_list").bootstrapTable({
                //使用get请求到服务器获取数据
                method: "GET",
                //必须设置，不然request.getParameter获取不到请求参数
                contentType: "application/x-www-form-urlencoded",
                //获取数据的Servlet地址
                url: "${ctx!}/admin/exam/list",
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
                // detailView:true,
                // detailFormatter:detailFormatter,
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
                    title: "试卷名称",
                    field: "examName",
                },{
                    title: "单选题",
                    field: "singleNum",
                },{
                    title: "分数",
                    field: "singleScore",
                },{
                    title: "多选题",
                    field: "multipleNum",
                },{
                    title: "分数",
                    field: "multipleScore",
                },{
                    title: "判断题",
                    field: "judgeNum",
                },{
                    title: "分数",
                    field: "judgeScore",
                },{
                    title: "排序提",
                    field: "rankNum",
                },{
                    title: "分数",
                    field: "rankScore",
                },{
                    title: "创建时间",
                    field: "createTime",
                    sortable: true
                },{
                    title: "操作",
                    field: "empty",
                    formatter: function (value, row, index) {
                        var operateHtml = '<@shiro.hasPermission name="system:resource:add"><button class="btn btn-primary btn-xs" type="button" onclick="examEdit(\''+row.id+'\')"><i class="fa fa-edit"></i>&nbsp;编辑</button> &nbsp;</@shiro.hasPermission>';
                        operateHtml = operateHtml + '<@shiro.hasPermission name="system:resource:deleteBatch"><button class="btn btn-danger btn-xs" type="button" onclick="examDel(\''+row.id+'\')"><i class="fa fa-remove"></i>&nbsp;删除</button></@shiro.hasPermission>';
                        return operateHtml;
                    }
                }]
            });
        });
        function bankShow(id){
            layer.open({
                type: 2,
                title: '查看试题',
                shadeClose: true,
                shade: false,
                area: ['100%', '100%'],
                content: '${ctx!}/admin/question/index',
                end: function(index){
                    $('#table_bank_list').bootstrapTable("refresh");
                }
            });
        }
        function configExam(){
            layer.open({
                type: 2,
                title: '配置考试类型',
                shadeClose: true,
                shade: false,
                area: ['600px', '600px'],
                content: '${ctx!}/admin/exam/index',
                end: function(index){
                    $('#table_exam_list').bootstrapTable("refresh");
                }
            });
        }
        function examEdit(id){
            layer.open({
                type: 2,
                title: '配置考试类型',
                shadeClose: true,
                shade: false,
                area: ['600px', '600px'],
                content: '${ctx!}/admin/exam/examEdit?id='+id,
                end: function(index){
                    $('#table_exam_list').bootstrapTable("refresh");
                }
            });
        }

        function examDel(id){
            layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
                $.ajax({
                    type: "DELETE",
                    dataType: "json",
                    url: "${ctx!}/admin/exam/delete/" + id,
                    success: function(msg){
                        layer.msg(msg.message, {time: 2000},function(){
                            $('#table_exam_list').bootstrapTable("refresh");
                            layer.close(index);
                        });
                    }
                });
            });
        }
        function uploadFile(){
            layer.open({
                type: 2,
                title: '批量上传资料',
                shadeClose: true,
                shade: false,
                area: ['600px', '600px'],
                content: '${ctx!}/admin/train/uploadFile',
                end: function(index){
                    $('#table_train_list').bootstrapTable("refresh");
                }
            });
        }
        function show(station){
            layer.open({
                type: 2,
                //title: '培训资料',
                shadeClose: true,
                shade: false,
                area: ['1654px', '800px'],
                content: '${ctx!}/admin/train/toFolder?folder='+station,
                end: function(index){
                    $('#table_train_list').bootstrapTable("refresh");
                }
            });
        }
        function add(){
        	layer.open({
        	      type: 2,
        	      title: '新建文件夹',
        	      shadeClose: true,
        	      shade: false,
        	      area: ['400px', '400px'],
        	      content: '${ctx!}/admin/folder/edit/1',
        	      end: function(index){
        	    	  $('#table_train_list').bootstrapTable("refresh");
       	    	  }
        	    });
        }
        function del(id){
        	layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
        		$.ajax({
    	    		   type: "DELETE",
    	    		   dataType: "json",
    	    		   url: "${ctx!}/admin/train/delete/" + id,
    	    		   success: function(msg){
	 	   	    			layer.msg(msg.message, {time: 2000},function(){
	 	   	    				$('#table_train_list').bootstrapTable("refresh");
	 	   	    				layer.close(index);
	 	   					});
    	    		   }
    	    	});
       		});
        }

        function uploadQuestion(){
            layer.open({
                type: 2,
                title: '上传题库',
                shadeClose: true,
                shade: false,
                area: ['400px', '400px'],
                content: '${ctx!}/admin/question/uploadQuestion',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function uploadImage(){
            layer.open({
                type: 2,
                title: '批量上传附件',
                shadeClose: true,
                shade: false,
                area: ['400px', '400px'],
                content: '${ctx!}/admin/folder/edit/1',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function detailFormatter(index, row) {
	        var html = [];
	        html.push('<p><b>描述:</b> ' + row.description + '</p>');
	        return html.join('');
	    }
    </script>




</body>

</html>
