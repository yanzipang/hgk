package com.atguigu.crowd.util;

import com.aliyun.api.gateway.demo.util.HttpUtils;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.util.EntityUtils;

import java.util.HashMap;
import java.util.Map;

public class CrowdUtil {
    /**
     * @param host 短信接口调用的URL地址 https://smssend.shumaidata.com
     * @param path 具体发送短信功能的地址 /sms/send
     * @param method 请求方式 POST
     *  给远程第三方短信接口发送请求，把验证码发送到用户的手机上
     * @param phoneNum 接收验证码的手机号
     * @param appcode 用来接收第三方API的AppCode 6bbfe5dc91d44b478297c30d0d8fddbe
     * @param skin 模板编号 M09DD535F4
     * @return
     *          成功：返回验证码
     *          失败：返货回失败信息
     *  101	手机号码错误	手机号码错误
     *  102	参数过长或者为null	参数过长或者为null
     *  1002	参数传入的形式不符合	参数传入的形式不符合
     *  105	模板编号错误	模板编号错误
     */
    public ResultEntity<String> sendCodeByShortMessage(

            String host,

            String path,

            String method,

            // 接收验证码的手机号
            String phoneNum,

            // 用来接收第三方API的AppCode
            String appcode,

            // 模板编号
            String skin
    ) {

        // 登录阿里云，进入控制台，找到已购买的短信接口的AppCode
        // String appcode = "6bbfe5dc91d44b478297c30d0d8fddbe";

        Map<String, String> headers = new HashMap<String, String>();
        //最后在header中的格式(中间是英文空格)为Authorization:APPCODE 83359fd73fe94948385f570e3c139105
        headers.put("Authorization", "APPCODE " + appcode);

        // 封装其他的参数
        Map<String, String> querys = new HashMap<String, String>();

        // 生成验证码
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < 4; i++) {
            int random = (int) (Math.random()*10);
            builder.append(random);
        }

        String code = builder.toString();

        // 要发送的验证码，也就是模板当中会变的那部分（短信中的变量，如：验证码）
        querys.put("tag", code);

        // 手短信的手机号（接收人手机号码）
        querys.put("receive", phoneNum);

        // 模板编号（模板ID（联系客服开通））
        querys.put("templateId", skin);
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
            String reasonPhrase = statusLine.getReasonPhrase();

            if (statusCode == 200) {
                // 操作成功，把生成的验证码返回
                return ResultEntity.successWithData(code);
            }

            return ResultEntity.failed(reasonPhrase);

        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(e.getMessage());
        }

    }

}
