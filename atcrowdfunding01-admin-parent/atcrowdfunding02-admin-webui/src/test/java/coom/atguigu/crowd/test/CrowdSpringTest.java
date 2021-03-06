package coom.atguigu.crowd.test;




import com.atguigu.crowd.Admin;
import com.atguigu.crowd.Role;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.service.api.AdminService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

// 指定 Spring 给 Junit 提供的运行器类
@RunWith(SpringJUnit4ClassRunner.class)
// 加载 Spring 配置文件的注解
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class CrowdSpringTest {
    @Autowired
    private DataSource dataSource;
    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private AdminService adminService;
    @Autowired
    private RoleMapper roleMapper;

    // 添加角色测试数据
    @Test
    public void testSaveRole(){
        for (int i = 0; i < 235; i++) {
            roleMapper.insert(new Role(null,"韩广凯(角色)"+i));
        }
    }

    // 添加用户测试数据
    @Test
    public void test(){
        for (int i = 0; i < 238; i++) {
            adminMapper.insert(new Admin(null,"韩广凯(用户)"+i,"userPswd"+i,"userName"+i,"email"+i,null));
        }
    }

    @Test
    public void testTx(){
        Admin admin = new Admin(null, "jerry", "123456", "杰瑞", "jerry@qq.com", null);
        adminService.saveAdmin(admin);
    }
    @Test
    public void testAdminMapperAutowired() {
        Admin admin = new Admin(null,"tom1","123321","汤姆猫","tom@qq.com",null);
        int i = adminMapper.insert(admin);
        //如果在实际开发中，所有想查看数值的地方都使用sysout方式打印，会给项目上线运行带来问题
        //sysout本质上是一个IO操作，通常IO的操作是比较消耗性能的，如果项目中sysout很多，那么对性能的影响就比较大了
        //上线前删掉可能会有遗漏，且麻烦。那么通过日志级别就可以批量的控制信息的打印
        System.out.println(i);
    }
    @Test
    public void testDataSource() throws SQLException {
        // 1.通过数据源对象获取数据源连接
        Connection connection = dataSource.getConnection();
        // 2.打印数据库连接
        System.out.println(connection);
    }

    //使用logback-classic打印日志
    @Test
    public void textLog(){
        //1.获取Logger日志记录对象 ,这里传入的Class对象就是当前打印日志的类
        Logger logger = LoggerFactory.getLogger(CrowdSpringTest.class);
        //2.根据不同日志级别打印日志
        logger.debug("hello,Debug");
        logger.info("hello info");
        logger.warn("Warn!");
        logger.error("Error");
        /* 打印结果
        21:21:55.969 [main] DEBUG coom.atguigu.crowd.test.CrowdSpringTest - hello,Debug
        21:21:55.974 [main] INFO coom.atguigu.crowd.test.CrowdSpringTest - hello info
        21:21:55.974 [main] WARN coom.atguigu.crowd.test.CrowdSpringTest - Warn!
        21:21:55.974 [main] ERROR coom.atguigu.crowd.test.CrowdSpringTest - Error
        */
    }


    }
