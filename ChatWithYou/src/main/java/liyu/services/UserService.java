package liyu.services;

import liyu.model.User;

// 用户业务层接口
public interface UserService {
    // 1. 用户注册，返回true表示注册成功，false失败
    boolean register(User user);
    // UserService.java 接口新增
    User findByUsername(String username);
    // 2. 用户登录，返回用户对象（null表示登录失败）
    User login(String username, String password);
}