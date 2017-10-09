<!-- 全局js -->
<#include "/admin/common/js.ftl">
<link href="${ctx!}/hadmin/css/font-awesome.css?v=4.4.0" rel="stylesheet">
<link href="${ctx!}/hadmin/css/animate.css" rel="stylesheet">
<#include "/admin/common/css.ftl">
<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">
    <div id="wrapper">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="nav-close"><i class="fa fa-times-circle"></i>
            </div>
            <div class="sidebar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="nav-header">
                        <div class="dropdown profile-element">
                            <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear">
                                    <span class="block m-t-xs" style="font-size:20px;">
                                        <img src="${ctx!}/hadmin/img/logo.png" width="160" height="50">
                                    </span>
                                </span>
                            </a>
                        </div>
                        <div class="logo-element">运三
                        </div>
                    </li>
                    <#--<li class="hidden-folded padder m-t m-b-sm text-muted text-xs">-->
                        <#--<span class="ng-scope">分类</span>-->
                    <#--</li>-->
                    <li>
                        <a href="#">
                            <i class="fa fa-cubes"></i>
                            <span class="nav-label">基础信息维护</span>
                        </a>
                        <ul class="nav nav-second-level collapse in">
                         <@shiro.hasPermission name="system:user:index">
                            <li>
                               <a class="J_menuItem" href="${ctx!}/admin/user/index">人员信息</a>
                            </li>
                         </@shiro.hasPermission>
                         <@shiro.hasPermission name="system:user:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/role/index">权限管理</a>
                            </li>
                         </@shiro.hasPermission>
                         <#--<@shiro.hasPermission name="system:user:index">-->
                            <#--<li>-->
                                <#--<a class="J_menuItem" href="${ctx!}/admin/resource/index">资源管理</a>-->
                            <#--</li>-->
                         <#--</@shiro.hasPermission>-->
                         <@shiro.hasPermission name="system:station:index">
                             <li>
                                 <a class="J_menuItem" href="${ctx!}/admin/station/index">车站信息</a>
                             </li>
                         </@shiro.hasPermission>
                        </ul>
                    </li>
                    <li>
                        <a href="#">
                            <i class="fa fa-gears"></i>
                            <span class="nav-label">运营管理</span>
                            <span class="fa arrow"></span>
                        </a>
                        <ul class="nav nav-second-level collapse in">
<@shiro.hasPermission name="system:train:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/train/index">学习园地</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:examlog:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/examlog/index">考试记录</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:emergency:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/emergency/index">应急预案</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:rules:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/rules/index">规章制度</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:fire:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/fire/index">消防安全文件</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:running:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/running/index">运行图管理</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:notice:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/notice/index">通知管理</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:rollPlay:index">
                            <li>
                                <a class="J_menuItem" href="${ctx!}/admin/rollPlay/index">首页滚播图</a>
                            </li>
</@shiro.hasPermission>
<@shiro.hasPermission name="system:edtion:index">
                            <li>
                                <a class="javascript:void(); uploadApk" is-shown="true" onclick="uploadApk()" >前端版本更新</a>
                            </li>
</@shiro.hasPermission>
                        </ul>
                    </li>
                    <li class="line dk"></li>
                </ul>
            </div>
        </nav>
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="row border-bottom">
                <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                    <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-info " href="#"><i class="fa fa-bars"></i> </a>
                    </div>
                    <ul class="nav navbar-top-links navbar-right">
                        <li class="dropdown">
                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
                                <i class="fa fa-user"></i> <span class="label label-primary"></span>【<@shiro.principal type="com.ducetech.hadmin.entity.User" property="userName"/>】
                            </a>
                            <ul class="dropdown-menu dropdown-alerts">
                                <li>
                                    <a href="${ctx!}/admin/logout">
                                        <div>
                                            <i class="fa fa-remove"></i> 注销
                                            <span class="pull-right text-muted small"><@shiro.principal type="com.ducetech.hadmin.entity.User" property="userName"/></span>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="row J_mainContent" id="content-main">
                <iframe id="J_iframe" width="100%" height="100%" src="${ctx!}/admin/welcome" frameborder="0" data-id="index_v1.html" seamless></iframe>
            </div>
        </div>
        <!--右侧部分结束-->
    </div>
    <script src="${ctx!}/hadmin/js/hAdmin.js"></script>
</body>
<script>
    function uploadApk() {
        var status = $(".uploadApk").attr('is-shown');
        console.log(status)
        if (status=='true') {
            $(".uploadApk").attr('is-shown', false)
            layer.open({
                type: 2,
                title: '上传升级文件',
                shadeClose: true,
                shade:[0.2,'#fff'],
                area: ['50%', '50%'],
                content: '${ctx!}/admin/edition/index',
                end: function (index) {
                    layer.close(index);
                    $(".uploadApk").attr('is-shown', true)
                }
            });
        }
    }
</script>
</html>
