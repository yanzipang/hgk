package com.atguigu.crowd.test;

import com.aliyun.api.gateway.demo.util.HttpUtils;
import com.atguigu.crowd.util.CrowdUtil;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.util.EntityUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.HashMap;
import java.util.Map;

@RunWith(SpringRunner.class)
@SpringBootTest
public class CrowdTest {

    private Logger logger = LoggerFactory.getLogger(CrowdTest.class);

    @Test
    public void testSendMessage() {

        // 短信接口调用的URL地址
        String host = "https://smssend.shumaidata.com";

        // 具体发送短信功能的地址
        String path = "/sms/send";

        // 请求方式
        String method = "POST";

        // 登录阿里云，进入控制台，找到已购买的短信接口的AppCode
        String appcode = "6bbfe5dc91d44b478297c30d0d8fddbe";

        Map<String, String> headers = new HashMap<String, String>();
        //最后在header中的格式(中间是英文空格)为Authorization:APPCODE 83359fd73fe94948385f570e3c139105
        headers.put("Authorization", "APPCODE " + appcode);

        // 封装其他的参数
        Map<String, String> querys = new HashMap<String, String>();

        // 手短信的手机号（接收人手机号码）
        querys.put("receive", "17048666644");

        // 要发送的验证码，也就是模板当中会变的那部分（短信中的变量，如：验证码）
        querys.put("tag", "654321");

        // 模板编号（模板ID（联系客服开通））
        querys.put("templateId", "M09DD535F4");
        Map<String, String> bodys = new HashMap<String, String>();


        try {
            /**
             * 重要提示如下:
             * HttpUtils请从
             * https://github.com/aliyun/api-gateway-demo-sign-java/blob/master/src/main/java/com/aliyun/api/gateway/demo/util/HttpUtils.java
             * 下载
             *
             * 相应的依赖请参照
             * https://github.com/aliyun/api-gateway-demo-sign-java/blob/master/pom.xml
             */
            HttpResponse response = HttpUtils.doPost(host, path, method, headers, querys, bodys);

            StatusLine statusLine = response.getStatusLine();
            int statusCode = statusLine.getStatusCode();
            logger.info("code="+statusCode);
            String reasonPhrase = statusLine.getReasonPhrase();
            logger.info("reason="+reasonPhrase);

            logger.info("字符串="+response.toString());
            //获取response的body
            logger.info("响应体="+EntityUtils.toString(response.getEntity()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void test() {
        CrowdUtil crowdUtil = new CrowdUtil();
        crowdUtil.sendCodeByShortMessage("https://smssend.shumaidata.com","/sms/send","POST","17048666644","6bbfe5dc91d44b478297c30d0d8fddbe","M09DD535F4");
    }

}
