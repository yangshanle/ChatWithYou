package liyu.dao;

import liyu.model.User;

// 用户数据访问层接口
public interface UserDao {
    // 根据用户ID查询完整用户信息
    User findUserById(Integer userId);

    // 更新用户信息（昵称、邮箱、密码）
    int updateUser(User user);
    // 1. 新增用户（注册用），返回受影响的行数
    int addUser(User user);

    // 2. 根据用户名查询用户（注册查重、登录验证用）
    User findByUsername(String username);
}