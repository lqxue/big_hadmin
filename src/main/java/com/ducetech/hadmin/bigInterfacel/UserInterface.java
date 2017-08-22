package com.ducetech.hadmin.bigInterfacel;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.ValueFilter;
import com.ducetech.hadmin.common.utils.BigConstant;
import com.ducetech.hadmin.common.utils.MD5Utils;
import com.ducetech.hadmin.controller.BaseController;
import com.ducetech.hadmin.dao.IUserDao;
import com.ducetech.hadmin.entity.User;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 用户接口
 *
 * @author lisx
 * @create 2017-08-07 17:39
 **/
@RestController
@RequestMapping("/interface/user")
public class UserInterface extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(UserInterface.class);

    int state=0;
    String msg;
    JSONObject obj;
    @Autowired
    IUserDao userDao;
    @ApiOperation(value="用户登录", notes="根据用户工号及密码登录")
    @RequestMapping(value="/login", method = RequestMethod.GET)
    @ApiImplicitParams({
            @ApiImplicitParam(name="code",value="用户工号",dataType="string", paramType = "query"),
            @ApiImplicitParam(name="password",value="用户密码",dataType="string", paramType = "query")})
    public JSONObject login(String code,String password){
        logger.info("进入登录接口==code:{}|password:{}",code,password);
        User user=userDao.findByUserCode(code);
        obj=new JSONObject();
        if(null!=user){
            if(user.getPassword().equals(MD5Utils.md5(password))){
                user.setRoles(null);
                msg="登录成功！";
                state=1;
            }else{
                msg="密码错误！";
            }
        }else{
            msg="工号错误！";
        }
        obj.put("state",state);
        obj.put("msg",msg);
        obj.put("data",user);
        return JSONObject.parseObject(JSONObject.toJSONString(obj, BigConstant.filter));
    }
    static Map<Long, User> users = Collections.synchronizedMap(new HashMap<Long, User>());
    @ApiOperation(value="获取用户列表", notes="根据站点站区或线路获取用户")
    @RequestMapping(value={"/list"}, method=RequestMethod.GET)
    @ApiImplicitParam(name="station",value="线路，站点，站区",dataType="string", paramType = "query")
    public JSONObject getUserList(String station) {
        logger.info("进入获取用户列表接口==station:{}"+station);
        obj=new JSONObject();
        int state=1;
        String msg;
        List<User> r = userDao.findAllByStation(station);
        obj.put("state",state);
        obj.put("msg","查询成功！");
        obj.put("data",r);
        return JSONObject.parseObject(JSONObject.toJSONString(obj, BigConstant.filter));
    }
    @ApiOperation(value="获取用户详细信息", notes="根据url的id来获取用户详细信息")
    @ApiImplicitParam(name = "id", value = "用户ID", required = true, dataType = "Integer")
    @RequestMapping(value="/{id}", method=RequestMethod.GET)
    public JSONObject getUser(@PathVariable Integer id) {
        logger.info("进入获取用户详情接口=={}"+id);
        obj=new JSONObject();
        User user=userDao.findOne(id);
        obj.put("state",1);
        obj.put("msg",msg);
        obj.put("data",user);
        return JSONObject.parseObject(JSONObject.toJSONString(obj, BigConstant.filter));
    }


}
