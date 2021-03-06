package com.atguigu.crowd.service.api;

import com.atguigu.crowd.Admin;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface AdminService {

    /**
     * 添加管理员
     * @param admin
     */
    void saveAdmin(Admin admin);

    /**
     * 获取全部管理员信息
     * @return
     */
    List<Admin> getAll();

    /**
     * 管理员登录检查
     * @param loginAcct 账户
     * @param userPswd  密码
     * @return
     */
    Admin getAdminByLoginAcct(String loginAcct, String userPswd);

    /**
     * 分页查询
     * @param keyword   关键字
     * @param pageNum   分页的页码
     * @param pageSize  每页显示数据的条数
     * @return
     */
    PageInfo<Admin> getPageInfo(String keyword,Integer pageNum,Integer pageSize);

    /**
     * 根据ID进行删除
     * @param adminId
     */
    void remove(Integer adminId);

    /**
     * 根据ID查询用户
     * @param adminId
     * @return
     */
    Admin getAdminById(Integer adminId);

    /**
     * 更新用户信息
     * @param admin
     */
    void update(Admin admin);

    /**
     * 给管理员用户分配角色
     * @param adminId
     * @param roleIdList
     */
    void saveAdminRoleRelationship(Integer adminId, List<Integer> roleIdList);

    Admin getAdminByLoginAcct(String username);
}
