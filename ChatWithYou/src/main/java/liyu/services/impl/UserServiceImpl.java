package liyu.services.impl;

import liyu.dao.UserDao;
import liyu.dao.impl.UserDaoImpl;
import liyu.model.User;
import liyu.services.UserService;

public class UserServiceImpl implements UserService {
    private UserDao userDao = new UserDaoImpl();

    @Override
    public boolean register(User user) {
        try {
            User existUser = userDao.findByUsername(user.getUsername());
            if (existUser != null) {
                return false;
            }
            int rows = userDao.addUser(user);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User login(String username, String password) {
        try {
            User user = userDao.findByUsername(username);
            if (user != null && password.equals(user.getPassword())) {
                return user;
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }
}