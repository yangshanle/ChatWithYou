package liyu.services.impl;

import liyu.dao.UserDao;
import liyu.dao.impl.UserDaoImpl;
import liyu.model.User;
import liyu.services.UserService;

public class UserServiceImpl implements UserService {
    // 调用DAO层对象
    private UserDao userDao = new UserDaoImpl();

    // 注册业务逻辑
    @Override
    public boolean register(User user) {
        // 1. 先查询用户名是否已存在
        User existUser = userDao.findByUsername(user.getUsername());
        if (existUser != null) {
            // 用户名已存在，注册失败
            return false;
        }
        // 2. 用户名不存在，执行新增
        int rows = userDao.addUser(user);
        // 3. 返回结果：受影响行数>0则成功
        return rows > 0;
    }

    // 登录业务逻辑
    @Override
    public User login(String username, String password) {
        // 1. 根据用户名查询用户
        User user = userDao.findByUsername(username);
        // 2. 判断用户存在且密码一致
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        // 3. 账号或密码错误，返回null
        return null;
    }
    // UserServiceImpl.java 实现
    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }
}