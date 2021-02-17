package com.atguigu.crowd.service.api;

import com.atguigu.crowd.Role;
import com.github.pagehelper.PageInfo;

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
}
