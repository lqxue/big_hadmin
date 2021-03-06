package com.ducetech.hadmin.controller.admin.system;

import com.ducetech.hadmin.common.JsonResult;
import com.ducetech.hadmin.common.utils.BigConstant;
import com.ducetech.hadmin.common.utils.StringUtil;
import com.ducetech.hadmin.controller.BaseController;
import com.ducetech.hadmin.dao.ILearnDao;
import com.ducetech.hadmin.entity.Learn;
import com.ducetech.hadmin.entity.User;
import com.ducetech.hadmin.service.ILearnService;
import com.ducetech.hadmin.service.specification.SimpleSpecificationBuilder;
import com.ducetech.hadmin.service.specification.SpecificationOperator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.List;

/**
 * 学习园地
 *
 * @author lisx
 * @create 2017-08-02 11:07
 **/
@Controller
@RequestMapping("/admin/learn")
public class LearnController  extends BaseController {
    @Autowired
    ILearnService learnService;
    @Autowired

    @RequestMapping("/index")
    public String index() {
        return "admin/learn/index";
    }

    /**
     * 查询集合
     * @return Page<User>
     */
    @RequestMapping(value = { "/list" })
    @ResponseBody
    public Page<Learn> list() {
        SimpleSpecificationBuilder<Learn> builder = new SimpleSpecificationBuilder<>();
        String searchText = request.getParameter("searchText");
        if(!StringUtil.isBlank(searchText)){
            builder.add("name", SpecificationOperator.Operator.likeAll.name(), searchText);
        }
        return learnService.findAll(builder.generateSpecification(), getPageRequest());
    }

    @RequestMapping(value = "/uploadFile", method = RequestMethod.GET)
    public String uploadFile() {
        return "admin/learn/file";
    }

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String add() {
        return "admin/learn/form";
    }


    @RequestMapping(value = "/uploadFilePost", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult uploadFilePost(MultipartHttpServletRequest request){
        List<MultipartFile> files =request.getFiles("file");
        MultipartFile file;
        //创建临时文件夹
        File dirTempFile = new File(BigConstant.IMAGE_PATH);
        if (!dirTempFile.exists()) {
            dirTempFile.mkdirs();
        }
        Learn learn;
        BufferedOutputStream stream;
        for (int i =0; i< files.size(); ++i) {
            file = files.get(i);
            if (!file.isEmpty()) {
                try {
                    byte[] bytes = file.getBytes();
                    stream = new BufferedOutputStream(new FileOutputStream(new File(dirTempFile.getAbsolutePath()+"/"+file.getOriginalFilename())));
                    stream.write(bytes);
                    stream.close();
                    learn=new Learn();
                    learn.setFileName(file.getOriginalFilename());
                    learn.setFileSize(""+Math.round(file.getSize()/1024));
                    learn.setCreateTime(new Date());
                    System.out.println("fileSize"+learn.getFileSize());
                    learnService.save(learn);
                } catch (Exception e) {
                    //stream =  null;
                    return JsonResult.success("You failed to upload " + i + " =>" + e.getMessage());
                }
            } else {
                return JsonResult.success("You failed to upload " + i + " becausethe file was empty.");
            }
        }
        return JsonResult.success();
    }

}
