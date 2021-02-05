package com.atguigu.crowd.service.api;

import com.atguigu.crowd.Admin;

import java.util.List;

public interface AdminService {
    void savaAdmin(Admin admin);

    List<Admin> getAll();

    Admin getAdminByLoginAcct(String loginAcct, String userPswd);
}
