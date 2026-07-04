package liyu.services.impl;

import liyu.dao.UserDao;
import liyu.dao.impl.UserDaoImpl;
import liyu.model.User;
import liyu.services.UserService;
import liyu.util.PasswordUtils;

public class UserServiceImpl implements UserService {
    private UserDao userDao = new UserDaoImpl();

    @Override
    public boolean register(User user) {
        User existUser = userDao.findByUsername(user.getUsername());
        if (existUser != null) {
            return false;
        }
        String hashedPassword = PasswordUtils.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        int rows = userDao.addUser(user);
        return rows > 0;
    }

    @Override
    public User login(String username, String password) {
        User user = userDao.findByUsername(username);
        if (user != null && PasswordUtils.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }
    // UserServiceImpl.java 实现
    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }
}