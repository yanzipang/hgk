package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.Admin;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.ResultEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class TestHandler {
    @Autowired
    private AdminService adminService;

    @ResponseBody
    @RequestMapping("/send/array/three.json")
    public ResultEntity<List<Integer>> testReceiveArrayThree(@RequestBody() List<Integer> array){
        Logger logger = LoggerFactory.getLogger(TestHandler.class);
        for (Integer number : array) {
            logger.info("number==="+number);
        }
        //将查询到的数组对象封装到ResultEntity中返回
        ResultEntity<List<Integer>> resultEntity = ResultEntity.successWithData(array);
        return resultEntity;
    }

    @ResponseBody
    @RequestMapping("/send/array/one.html")
    public String testReceiveArrayOne(@RequestParam("array[]") List<Integer> array){
        for (Integer number : array) {
            System.out.println(number);
        }
        return "success";
    }

    @RequestMapping("/test/ssm.html")
    public String testSSM(ModelMap modelMap){
        List<Admin> adminList = adminService.getAll();
        modelMap.addAttribute("adminList",adminList);
        return "target";
    }
}
