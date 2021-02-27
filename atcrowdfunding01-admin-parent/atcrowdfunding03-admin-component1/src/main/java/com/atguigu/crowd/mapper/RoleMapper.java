package com.atguigu.crowd.mapper;


import java.util.List;

import com.atguigu.crowd.Role;
import com.atguigu.crowd.RoleExample;
import org.apache.ibatis.annotations.Param;

public interface RoleMapper {

    int countByExample(RoleExample example);

    int deleteByExample(RoleExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Role record);

    int insertSelective(Role record);

    List<Role> selectByExample(RoleExample example);

    Role selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Role record, @Param("example") RoleExample example);

    int updateByExample(@Param("record") Role record, @Param("example") RoleExample example);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);

    /**
     * 按关键词查询
     * @param keyword
     * @return
     */
    List<Role> selectRoleByKeyword(String keyword);

    List<Role> selectAssignedRole(Integer adminId);

    List<Role> selectUnAssignedRole(Integer adminId);
}