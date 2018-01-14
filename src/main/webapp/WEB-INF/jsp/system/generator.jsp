<%--
  Created by IntelliJ IDEA.
  User: cjbi
  Date: 2018/1/8
  Time: 16:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="wetechfn" uri="http://wetech.tech/admin/tags/wetech-functions" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .am-list-border > li, .am-list-bordered > li {
        border-width: 0px;
    }
</style>
<div class="admin-content">
    <div class="admin-content-body">
        <div class="am-cf am-padding">
            <ol class="am-breadcrumb">
                <li><a href="#" class="am-icon-home">首页</a></li>
                <li class="am-active">代码生成器</li>
            </ol>
        </div>
        <div class="am-u-md-3 am-u-sm-12">
            <div class="am-panel am-panel-default">
                <div class="am-panel-hd">选择表</div>
                <div class="am-panel-bd">
                    <ul class="am-list am-list-border" id="tableNames" style="overflow-y: auto;height:600px;">
                        <c:forEach items="${tableNames}" var="tableName">
                            <li><a class="am-text-truncate" href="#">${tableName}</a></li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
        <div class="am-u-md-9 am-u-sm-12 am-u-end">
            <div class="am-panel am-panel-default">
                <div class="am-panel-hd">生成器配置</div>
                <div class="am-panel-bd">
                    <form class="am-form am-form-horizontal" onsubmit="return false;" id="generator-form">
                        <input type="hidden" name="id"/>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">表名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="tableName" placeholder="person" data-foolish-msg="请先从右侧选择数据库表" required readonly>
                            </div>
                            <label class="am-u-md-2 am-form-label">模块名称<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="moduleName" placeholder="模块名称" required>
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">Java实体类名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4">
                                <div class="am-input-group">
                                    <input type="text" class="am-form-field" name="modelName" placeholder="Person">
                                    <span class="am-input-group-btn">
                                    <button class="am-btn am-btn-primary am-btn-hollow" type="button">定制列</button>
                                  </span>
                                </div>
                            </div>
                            <label class="am-u-md-2 am-form-label">实体类包名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="modelPackage" placeholder="com.example.model">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">Dao接口包名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="daoPackage" placeholder="com.example.model" placeholder="primary key,such as id">
                            </div>
                            <label class="am-u-md-2 am-form-label">Dao接口名称(选填)</label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="daoName" placeholder="PersonMapper">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">映射XML文件包名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="mappingXMLPackage" placeholder="com.example.model" placeholder="primary key,such as id">
                            </div>
                            <label class="am-u-md-2 am-form-label">映射XML文件存放目录<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="mappingXMLTargetFolder" value="src/main/resources" placeholder="src/main/resources">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">Service接口包名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="servicePackage" placeholder="com.example.service">
                            </div>
                            <label class="am-u-md-2 am-form-label">Service接口名称(选填)</label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="serviceName" placeholder="PersonService">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">Service实现类包名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="serviceImplPackage" placeholder="com.example.service.impl">
                            </div>
                            <label class="am-u-md-2 am-form-label">Service实现类名称(选填)</label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="name" placeholder="PersonServiceImpl">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">Controller包名<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="name" placeholder="com.example.controller" placeholder="primary key,such as id">
                            </div>
                            <label class="am-u-md-2 am-form-label">Controller名称(选填)</label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="name" placeholder="PersonController">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <label class="am-u-md-2 am-form-label">jsp页面存放目录<span class="asterisk">*</span></label>
                            <div class="am-u-md-4 am-u-end">
                                <div class="am-input-group">
                                    <span class="am-input-group-label" style="font-size:0.5rem;">src/main/webapp/WEB-INF/jsp/</span>
                                    <input type="text" class="am-form-field">
                                </div>
                            </div>
                            <label class="am-u-md-2 am-form-label">jsp页面名称(选填)</label>
                            <div class="am-u-md-4 am-u-end">
                                <input type="text" name="name" placeholder="person">
                            </div>
                        </div>
                        <div class="am-form-group">
                            <div class="am-u-md-12 am-pagination-centered">
                                <label class="am-checkbox-inline">
                                    <input type="checkbox" value="" data-am-ucheck> 生成实体域注释(来自表注释)
                                </label>
                                <label class="am-checkbox-inline">
                                    <input type="checkbox" value="" data-am-ucheck> 使用实际的列名
                                </label>
                                <label class="am-checkbox-inline">
                                    <input type="checkbox" value="" data-am-ucheck> XML中生成表的别名
                                </label>
                            </div>
                        </div>
                        <div class="am-form-group">
                            <div class="am-u-md-end am-text-right">
                                <button type="submit" class="am-btn am-btn-primary am-radius">代码生成</button>
                                <%--<button type="reset" class="am-btn am-btn-warning am-radius">保存配置</button>--%>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        var $form = $('#generator-form');
        $('#tableNames').find('a').on('click', function (e) {
            $('#tableNames').find('a').removeClass('am-active');
            $(this).addClass('am-active');
            e.preventDefault();
            var tableName = $(this).html();
            var modelName = Utils.string.formatHump(tableName, '_');//转换为驼峰命名
            modelName = modelName.substring(0, 1).toUpperCase() + modelName.substring(1);//首字母大写
            $form.find('input[name="tableName"]').val(tableName);
            $form.find('input[name="modelName"]').val(modelName);
            debugger;

        });
    });
</script>