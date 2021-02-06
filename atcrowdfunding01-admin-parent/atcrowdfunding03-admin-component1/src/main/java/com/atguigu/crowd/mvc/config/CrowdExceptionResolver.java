package com.atguigu.crowd.mvc.config;

import com.atguigu.crowd.constant.CrowdConstant;
import com.atguigu.crowd.exception.AccessForbiddenException;
import com.atguigu.crowd.exception.LoginFailedException;
import com.atguigu.crowd.util.CrowdUtil;
import com.atguigu.crowd.util.ResultEntity;
import com.google.gson.Gson;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//@ControllerAdvice 表示当前类是一个基于注解的异常处理器
@ControllerAdvice
public class CrowdExceptionResolver {

    @ExceptionHandler(value = AccessForbiddenException.class)
    public ModelAndView resolveAccessForbiddenException(
            ArithmeticException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        String vaewName = "admin-login";
        return commonResolve(vaewName,exception,request,response);
    }

    @ExceptionHandler(value = LoginFailedException.class)
    public ModelAndView resolveLoginFailedException(
            ArithmeticException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        String vaewName = "admin-login";
        //11.返回ModelAndView对象
        return commonResolve(vaewName,exception,request,response);
    }

    @ExceptionHandler(value = ArithmeticException.class)
    public ModelAndView resolveMathException(
            ArithmeticException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        String vaewName = "system-error";
        //11.返回ModelAndView对象
        return commonResolve(vaewName,exception,request,response);
    }

    //@ExceptionHandler 将一个具体的异常类型和一个方法关联起来
    @ExceptionHandler(value = NullPointerException.class)
    public ModelAndView resolveNullPointerException(
            NullPointerException exception,
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        String vaewName = "system-error";
        //11.返回ModelAndView对象
        return commonResolve(vaewName,exception,request,response);
    }

    //公用方法
    private ModelAndView commonResolve(
            //异常处理完成后要去的界面
            String viewName,
            //实际捕获的异常类型
            Exception exception,
            //当前请求对象
            HttpServletRequest request,
            //当前响应对象
            HttpServletResponse response
    ) throws IOException {
        //1.判断当前请求类型
        boolean judgeResult = CrowdUtil.judgeRequestType(request);
        //2.如果是Ajax请求
        if (judgeResult){
            //3.创建ResultEntity对象
            ResultEntity<Object> resultEntity = ResultEntity.failed(exception.getMessage());
            //4.创建一个Gson对象
            Gson gson = new Gson();
            //5.将ResultEntity对象转换成JSON字符串
            String json = gson.toJson(resultEntity);
            //6.将JSON字符串作为响应体返回给浏览器
            response.getWriter().write(json);
            //7.由于上面已经通过原生的response对象返回了响应，所以不提供ModelAndView对象
            return null;
        }
        //8.如果不是Ajax请求则创建ModelAndView对象
        ModelAndView modelAndView = new ModelAndView();
        //9.将Exception对象存入模型
        modelAndView.addObject(CrowdConstant.ATTR_NAME_EXCEPTION,exception);
        //10.设置对应的视图名称
        modelAndView.setViewName(viewName);
        //11.返回ModelAndView对象
        return modelAndView;
    }

}
