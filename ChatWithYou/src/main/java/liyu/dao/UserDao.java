package liyu.dao;

import liyu.model.User;
import java.util.List;

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

    // 3. 查询所有用户（管理员用）
    List<User> findAllUsers();

    // 4. 删除用户（管理员用）
    int deleteUser(Integer userId);

    // 5. 更新用户角色（管理员用）
    int updateUserRole(Integer userId, Integer role);
    
    // 6. 更新用户信息（管理员用）
    int updateUserInfo(Integer userId, String nickname, String email, Integer role);
}