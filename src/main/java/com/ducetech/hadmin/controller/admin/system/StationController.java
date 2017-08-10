package com.ducetech.hadmin.controller.admin.system;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ducetech.hadmin.common.JsonResult;
import com.ducetech.hadmin.common.utils.PoiUtil;
import com.ducetech.hadmin.common.utils.StringUtil;
import com.ducetech.hadmin.controller.BaseController;
import com.ducetech.hadmin.dao.IBigFileDao;
import com.ducetech.hadmin.entity.BigFile;
import com.ducetech.hadmin.entity.Station;
import com.ducetech.hadmin.service.IStationService;
import com.ducetech.hadmin.service.specification.SimpleSpecificationBuilder;
import com.ducetech.hadmin.service.specification.SpecificationOperator.Operator;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.List;

/**
 * 车站信息
 */
@Controller
@RequestMapping("/admin/station")
public class StationController extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(StationController.class);
	@Autowired
	private IStationService stationService;
    @Autowired
    IBigFileDao fileDao;
    /**
     * 树形菜单
     * @return
     */
	@RequestMapping("/tree")
	@ResponseBody
	public JSONArray tree(){
        List<Station> stations = stationService.findAll();
        return Station.createTree(stations);
	}

    /**
     * 删除
     * @param nodeId
     * @return
     */
    @RequestMapping(value = "/del/{nodeId}",method = RequestMethod.DELETE)
    @ResponseBody
    public JsonResult delete(String nodeId){
        System.out.println("||||||"+nodeId);
        Station station = stationService.findByNodeCode(nodeId);
        stationService.delete(station);
        return JsonResult.success();
    }

    /**
     * 增加节点
     */
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public Station save(String name, String pId){
        String pcode =StringUtil.trim(pId);
        List<Station> stations = stationService.findAll();
        String nodeCode = Station.getNodeCode(stations,pcode);
        Station node = new Station();
        stationService.save(node);
        return (node);
    }
    /**
     * 编辑节点
     */
    @RequestMapping(value = "/update/{nodeCode}", method = RequestMethod.POST)
    public JSONObject update(@PathVariable String nodeCode, String name){
        logger.debug("进入编辑节点nodeCode{}||name{}",nodeCode,name);
        nodeCode = StringUtil.trim(nodeCode);
        String nodeName = StringUtil.trim(name);
        Station node = stationService.findByNodeCode(nodeCode);
        node.setNodeName(nodeName);
        node.setUpdateTime(new Date());
        stationService.saveOrUpdate(node);
        JSONObject obj=new JSONObject();
        obj.put("node",node);
        return obj;
    }
	@RequestMapping("/index")
	public String index() {
		return "admin/station/index";
	}

    @RequestMapping("/upload")
    public String file() {
        return "admin/station/upload";
    }

    @RequestMapping(value = "/fileUploadStation", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult uploadStationExcel(@RequestParam("fileUpload") MultipartFile fileUpload) {
        try {
            if (fileUpload != null && !fileUpload.isEmpty()) {
                List<List<List<String>>> data = PoiUtil.readExcelToList(fileUpload, 1);
                if (null != data && !data.isEmpty()) {
                    for (List<List<String>> sheet : data) {
                        if (null != sheet && !sheet.isEmpty()) {
                            for (List<String> row : sheet) {
                                String line = StringUtil.trim(row.get(0));
                                String area = StringUtil.trim(row.get(1));
                                String station = StringUtil.trim(row.get(2));
                                Station lineObj = stationService.findByNodeName(line);
                                Station areaObj = stationService.findByNodeName(area+"站区");
                                Station stationObj = stationService.findByNodeName(station);
                                String nodeCode;
                                if(null==lineObj) {
                                    List<Station> objs=stationService.findByStationArea(3);
                                    nodeCode=Station.getNodeCode(objs, "");
                                    lineObj = new Station();
                                    lineObj.setNodeName(line);
                                    lineObj.setNodeCode(nodeCode);
                                    stationService.saveOrUpdate(lineObj);
                                }
                                if(null==areaObj) {
                                    List<Station> objs=stationService.querySubNodesByCode(lineObj.getNodeCode()+"___",6);
                                    nodeCode=Station.getNodeCode(objs, lineObj.getNodeCode());
                                    areaObj = new Station();
                                    areaObj.setNodeName(area+"站区");
                                    areaObj.setNodeCode(nodeCode);
                                    stationService.saveOrUpdate(areaObj);
                                }
                                if(null==stationObj) {
                                    List<Station> objs=stationService.querySubNodesByCode(areaObj.getNodeCode()+"___",9);
                                    nodeCode=Station.getNodeCode(objs, areaObj.getNodeCode());
                                    stationObj = new Station();
                                    stationObj.setNodeName(station);
                                    stationObj.setNodeCode(nodeCode);
                                    stationService.saveOrUpdate(stationObj);
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            return JsonResult.failure(e.getMessage());
        }
        return JsonResult.success("上传成功！");
    }

    @RequestMapping(value = "/uploadFile", method = RequestMethod.GET)
    public String uploadFile() {
        return "admin/station/file";
    }

    @RequestMapping(value = "/uploadFilePost", method = RequestMethod.POST)
    @ResponseBody
    public JsonResult uploadFilePost(HttpServletRequest request){
        List<MultipartFile> files =((MultipartHttpServletRequest)request).getFiles("file");
        MultipartFile file;
        //创建临时文件夹
        File dirTempFile = new File("/Users/lisx/Ducetech/logs/");
        if (!dirTempFile.exists()) {
            dirTempFile.mkdirs();
        }
        BigFile learn;
        BufferedOutputStream stream;
        for (int i =0; i< files.size(); ++i) {
            file = files.get(i);
            if (!file.isEmpty()) {
                try {
                    byte[] bytes = file.getBytes();
                    stream = new BufferedOutputStream(new FileOutputStream(new File(dirTempFile.getAbsolutePath()+"/"+file.getOriginalFilename())));
                    stream.write(bytes);
                    stream.close();
                    learn=new BigFile();
                    learn.setFileName(file.getOriginalFilename());
                    learn.setFileSize(""+file.getSize()/1000);
                    learn.setCreateTime(new Date());
                    fileDao.save(learn);
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
	@RequestMapping("/list")
	@ResponseBody
	public Page<Station> list() {
		SimpleSpecificationBuilder<Station> builder = new SimpleSpecificationBuilder<Station>();
		String searchText = request.getParameter("searchText");
		if(StringUtils.isNotBlank(searchText)){
			builder.add("name", Operator.likeAll.name(), searchText);
		}
		Page<Station> page = stationService.findAll(builder.generateSpecification(),getPageRequest());
		return page;
	}

	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(ModelMap map) {
		List<Station> list = stationService.findAll();
		map.put("list", list);
		return "admin/station/form";
	}


	@RequestMapping(value = "/edit/{id}", method = RequestMethod.GET)
	public String edit(@PathVariable Integer id,ModelMap map) {
		Station station = stationService.find(id);
		map.put("station", station);

		List<Station> list = stationService.findAll();
		map.put("list", list);
		return "admin/station/form";
	}

	@RequestMapping(value= {"/edit"}, method = RequestMethod.POST)
	@ResponseBody
	public JsonResult edit(Station station, ModelMap map){
		try {
			stationService.saveOrUpdate(station);
		} catch (Exception e) {
			return JsonResult.failure(e.getMessage());
		}
		return JsonResult.success();
	}


}
