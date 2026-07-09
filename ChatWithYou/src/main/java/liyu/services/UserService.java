package liyu.services;

import liyu.model.User;
import java.util.List;

// 用户业务层接口
public interface UserService {
    // 1. 用户注册，返回true表示注册成功，false失败
    boolean register(User user);
    // UserService.java 接口新增
    User findByUsername(String username);
    // 2. 用户登录，返回用户对象（null表示登录失败）
    User login(String username, String password);

    // 3. 查询所有用户（管理员用）
    List<User> findAllUsers();

    // 4. 删除用户（管理员用）
    boolean deleteUser(Integer userId);

    // 5. 更新用户角色（管理员用）
    boolean updateUserRole(Integer userId, Integer role);
    
    // 6. 更新用户信息（管理员用）
    boolean updateUserInfo(Integer userId, String nickname, String email, Integer role);
}