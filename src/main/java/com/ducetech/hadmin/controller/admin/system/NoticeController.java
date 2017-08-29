package com.ducetech.hadmin.controller.admin.system;

import com.ducetech.hadmin.common.JsonResult;
import com.ducetech.hadmin.common.utils.BigConstant;
import com.ducetech.hadmin.common.utils.StringUtil;
import com.ducetech.hadmin.controller.BaseController;
import com.ducetech.hadmin.dao.IBigFileDao;
import com.ducetech.hadmin.dao.INoticeDao;
import com.ducetech.hadmin.dao.INoticeDao;
import com.ducetech.hadmin.dao.IStationDao;
import com.ducetech.hadmin.entity.*;
import com.ducetech.hadmin.entity.Notice;
import com.ducetech.hadmin.service.specification.SimpleSpecificationBuilder;
import com.ducetech.hadmin.service.specification.SpecificationOperator;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 通知管理
 *  fire safety
 * @author lisx
 * @create 2017-08-15 08:47
 **/
@Controller
@RequestMapping("/admin/notice")
public class NoticeController extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(NoticeController.class);
    @Autowired
    private IStationDao stationDao;
    @Autowired
    INoticeDao noticeDao;
    @Autowired
    IBigFileDao fileDao;

    /**
     * 通知首页
     * @return
     */
    @RequestMapping("/index")
    public String index() {
        logger.info("进入通知管理首页");
        return "admin/notice/index";
    }

    @RequestMapping("/show")
    public String form(Model map,Integer id) {
        logger.info("详情{}",id);
        Notice notice=noticeDao.findOne(id);
        map.addAttribute("notice",notice);
        logger.info("进入通知详情页");
        return "admin/notice/show";
    }

    /**
     * 查询集合
     * @return Page<User>
     */
    @RequestMapping(value = { "/list" })
    @ResponseBody
    public Page<Notice> list() {
        SimpleSpecificationBuilder<Notice> builder = new SimpleSpecificationBuilder<>();
        String searchText = request.getParameter("searchText");
        if(!StringUtil.isBlank(searchText)){
            builder.add("fileName", SpecificationOperator.Operator.likeAll.name(), searchText);
        }
        return  noticeDao.findAll(builder.generateSpecification(), getPageRequest());
    }

    @RequestMapping(value = "/delete/{id}", method = RequestMethod.DELETE)
    @ResponseBody
    public JsonResult delete(@PathVariable Integer id) {
        try {
            noticeDao.delete(id);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResult.failure(e.getMessage());
        }
        return JsonResult.success();
    }
    /**
     * 进入培训上传页面
     * @param map
     * @return
     */
    @RequestMapping(value = "/uploadFile", method = RequestMethod.GET)
    public String uploadFile(Model map) {
        User user=getUser();
        Station station=stationDao.findByNodeName(user.getStationArea());
        List<String> stations=stationDao.findByTreeStations(6,station.getNodeCode()+"%");
        map.addAttribute("stations",stations);
        map.addAttribute("menu",BigConstant.Notice);
        return "admin/notice/uploadFile";
    }

    @RequestMapping(value = "/uploadFilePost", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult uploadFilePost(MultipartHttpServletRequest request,String [] area, Notice notice){
        logger.info("进入通知上传文件{}",area.length);
        List<MultipartFile> files =request.getFiles("file");
        User user=getUser();
        MultipartFile file;
        BufferedOutputStream stream;
        List<Integer> list=new ArrayList<>();
        for (int i =0; i< files.size(); ++i) {
            long flag = new Date().getTime();
            file = files.get(i);
            if (!file.isEmpty()) {
                try {
                    String suffix = StringUtil.suffix(file.getOriginalFilename());
                    File tempPartFile = new File(BigConstant.upload, +flag+file.getOriginalFilename());
                    byte[] bytes = file.getBytes();
                    stream = new BufferedOutputStream(new FileOutputStream(tempPartFile));
                    stream.write(bytes);
                    stream.close();
                    BigFile bigFile=new BigFile();
                    bigFile.setIfUse(0);
                    bigFile.setFileName(file.getOriginalFilename());
                    bigFile.setFileType(suffix);
                    bigFile.setMenuType(BigConstant.Notice);
                    bigFile.setByteSize(file.getSize()+"");
                    fileDao.saveAndFlush(bigFile);
                    list.add(bigFile.getId());
                } catch (Exception e) {
                    logger.info("上传失败{}", e.getMessage());
                }
            }
        }
        notice.setStationName(StringUtils.join(area,","));
        notice.setCreateId(user.getId());
        notice.setIfUse(0);
        if(list.size()>0)
        notice.setFiles(StringUtils.join(list,","));
        notice.setCreateTime(new Date());
        noticeDao.save(notice);
        return JsonResult.success();
    }
}
