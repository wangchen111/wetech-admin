package tech.wetech.admin.web.controller.system;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import tech.wetech.admin.common.utils.Constants;
import tech.wetech.admin.common.utils.ZipUtils;
import tech.wetech.admin.generator.bridge.MybatisGeneratorBridge;
import tech.wetech.admin.generator.model.GeneratorConfig;
import tech.wetech.admin.generator.util.JdbcConfigHelper;
import tech.wetech.admin.model.system.BizException;
import tech.wetech.admin.model.system.User;
import tech.wetech.admin.web.controller.base.BaseController;
import tech.wetech.admin.web.dto.system.GeneratorDto;

/**
 * 代码生成器控制层
 * <p>
 * Created by cjbi on 2018/1/8.
 */
@Controller
@RequestMapping("/generator")
public class GeneratorController extends BaseController{

    @Autowired
    private MybatisGeneratorBridge mybatisGeneratorBridge;

    @RequestMapping(method = RequestMethod.GET)
    public String toPage(Model model) throws SQLException {
        model.addAttribute("tableNames", JdbcConfigHelper.getTableNames());
        return "system/generator";
    }

    @RequestMapping(method = RequestMethod.GET, value = "/code.zip")
    public ResponseEntity<byte[]> downloadCode(HttpServletRequest request) {
        ResponseEntity<byte[]> responseEntity = null;
        String tmpPath = request.getSession().getServletContext().getRealPath("/WEB-INF/tmp");
        User user = (User) request.getAttribute(Constants.CURRENT_USER);
        String srcPath = tmpPath + File.separator + user.getUsername() + File.separator + "code";
        String destPath = tmpPath + File.separator + user.getUsername() + File.separator + "code" + ZipUtils.EXT;
        try {
            GeneratorDto generatorDto = new GeneratorDto();
            generatorDto.setProjectFolder(srcPath);
            mybatisGeneratorBridge.setGeneratorConfig(getConfig(generatorDto));
            mybatisGeneratorBridge.generate();
            ZipUtils.compress(srcPath, destPath);
            File file = new File(destPath);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            headers.setContentDispositionFormData("attachment", file.getName());
            responseEntity = new ResponseEntity<>(FileUtils.readFileToByteArray(file), headers, HttpStatus.CREATED);
        } catch (Exception e) {
            new BizException("生成代码失败", e);
            e.printStackTrace();
        } finally {
            File file = new File(tmpPath + File.separator + user.getUsername());
            if (file.exists()) {
                FileUtils.deleteQuietly(file);
            }
        }
        return responseEntity;
    }

    private GeneratorConfig getConfig(GeneratorDto generatorDto) {

        GeneratorConfig generatorConfig = new GeneratorConfig();
        generatorConfig.setProjectFolder(generatorDto.getProjectFolder());// 项目目录
        generatorConfig.setModuleName("system");
        generatorConfig.setModelPackage("tech.wetech.admin.model");// 实体类包名
        generatorConfig.setModelPackageTargetFolder("src/main/java");// 实体类存放目录
        generatorConfig.setDaoPackage("tech.wetech.admin.mapper");// dao接口包名
        generatorConfig.setDaoTargetFolder("src/main/java");// dao存放目录
        generatorConfig.setMapperName("");// 自定义接口名称(选填)
        generatorConfig.setMappingXMLPackage("mybatis.system");// 映射xml文件包名
        generatorConfig.setMappingXMLTargetFolder("src/main/resource");// 映射xml文件存放目录
        generatorConfig.setServiceName("LogService");
        generatorConfig.setServicePackage("tech.wetech.admin.service.system");
        generatorConfig.setServiceTargetFolder("src/main/java");
        generatorConfig.setServiceImplName("LogServiceImpl");
        generatorConfig.setServiceImplPackage("tech.wetech.admin.service.system.impl");
        generatorConfig.setServiceImplTargetFolder("src/main/java");
        generatorConfig.setControllerName("LogController");
        generatorConfig.setControllerPackage("tech.wetech.admin.web.controller.system");
        generatorConfig.setControllerTargetFolder("src/main/java");
        generatorConfig.setJspName("log");
        generatorConfig.setJspTargetFolder("src/main/webapp/WEB-INF/jsp/system");
        generatorConfig.setTableName("sys_log");// 表名
        generatorConfig.setModelName("Log");// 实体类名
        generatorConfig.setOffsetLimit(true);// 是否分页
        generatorConfig.setComment(true);// 是否生成实体域注释(来自表注释)
        generatorConfig.setNeedToStringHashcodeEquals(true);// 是否生成toString/hashCode/equals方法
        generatorConfig.setAnnotation(false);// 是否生成JPA注解
        generatorConfig.setUseActualColumnNames(false);// 是否使用实际的列名
        generatorConfig.setGenerateKeys("");//
        generatorConfig.setUseTableNameAlias(false);// 是否xml中生成表的表面
        if (!checkDirs(generatorConfig)) {
            return null;
        }
        return generatorConfig;
    }

    /**
     * 检查并创建不存在的文件夹
     *
     * @return
     */
    private boolean checkDirs(GeneratorConfig config) {
        List<String> dirs = new ArrayList<>();
        dirs.add(config.getProjectFolder());
        dirs.add(FilenameUtils
                .normalize(config.getProjectFolder().concat("/").concat(config.getModelPackageTargetFolder())));
        dirs.add(FilenameUtils.normalize(config.getProjectFolder().concat("/").concat(config.getDaoTargetFolder())));
        dirs.add(FilenameUtils
                .normalize(config.getProjectFolder().concat("/").concat(config.getMappingXMLTargetFolder())));
        dirs.add(FilenameUtils.normalize(config.getProjectFolder().concat("/").concat(config.getJspTargetFolder())));
        boolean haveNotExistFolder = false;
        for (String dir : dirs) {
            File file = new File(dir);
            if (!file.exists()) {
                haveNotExistFolder = true;
            }
        }
        if (haveNotExistFolder) {

            try {
                for (String dir : dirs) {
                    FileUtils.forceMkdir(new File(dir));
                }
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return true;
    }

}
