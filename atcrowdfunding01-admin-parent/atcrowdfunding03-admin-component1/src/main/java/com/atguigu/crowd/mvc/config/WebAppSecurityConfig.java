package com.atguigu.crowd.mvc.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;

// 注意！这个类一定要放在自动扫描的包下，否则所有配置都不会生效！
// 将当前类标记为配置类
@Configuration
// 启用 Web 环境下权限控制功能
@EnableWebSecurity
public class WebAppSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void configure(AuthenticationManagerBuilder builder) throws Exception {

        // 临时使用内存版登录模式测试代码
        // builder.inMemoryAuthentication().withUser("tom").password("123123").roles("ADMIN");

        // 正式功能中使用基于数据库的认证
        builder.userDetailsService(userDetailsService);
    }

    @Override
    protected void configure(HttpSecurity security) throws Exception {

        // 放行首页、静态资源。
        security
                .authorizeRequests()                                        // 对请求进行授权
                .antMatchers("/admin/to/login/page.html")       // 针对登录页进行设置
                .permitAll()                                                // 无条件访问
                .antMatchers("/static/**")                      // 针对静态资源进行设置
                .permitAll()                                                // 无条件访问
                .anyRequest()                                               // 其他任意的请求
                .authenticated()                                            // 认证后访问
                .and()
                .csrf()                                                     // 仿跨站请求伪造功能
                .disable()                                                  // 禁用
                .formLogin()                                                // 开启表单登录的功能
                .loginPage("/admin/to/login/page.html")                     // 指定登录页面
                .loginProcessingUrl("/security/do/login.html")              // 指定处理登录请求的地址
                .permitAll()
                .defaultSuccessUrl("/admin/to/main/page.html")              // 指定登录成功后前往的地址
                .usernameParameter("loginAcct")                             // 定制账号的请求参数名称
                .passwordParameter("userPswd")                              // 定制密码的请求参数名称
                .and()
                .logout()                                                   // 开启退出登录功能
                .logoutUrl("/security/do/logout.html")                      // 指定退出登录地址
                .logoutSuccessUrl("/admin/to/login/page.html")              // 指定退出成功以后前往的地址
                ;
    }

}
