package com.atguigu.crowd.service.api;

import com.atguigu.crowd.Role;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface RoleService {
    /**
     * 按关键词查询
     * @param pageNum
     * @param pageSize
     * @param keyword
     * @return
     */
    PageInfo<Role> getPageInfo(Integer pageNum,Integer pageSize,String keyword);

    void saveRole(Role role);

    void updateRole(Role role);

    void removeRole(List<Integer> roleIdList);

    /**
     * 查询已分配角色
     * @param adminId
     * @return
     */
    List<Role> getAssignedRole(Integer adminId);

    /**
     * 查询未分配角色
     * @param adminId
     * @return
     */
    List<Role> getUnAssignedRole(Integer adminId);
}
