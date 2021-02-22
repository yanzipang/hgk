package com.atguigu.crowd.service.impl;

import com.atguigu.crowd.Menu;
import com.atguigu.crowd.MenuExample;
import com.atguigu.crowd.mapper.MenuMapper;
import com.atguigu.crowd.service.api.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuServiceImpl implements MenuService {

    @Autowired
    private MenuMapper menuMapper;

    @Override
    public List<Menu> getAll() {
        //return adminMapper.selectByExample(new AdminExample());
        return menuMapper.selectByExample(new MenuExample());
    }
}
