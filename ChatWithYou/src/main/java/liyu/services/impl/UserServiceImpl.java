package liyu.services.impl;

import liyu.dao.UserDao;
import liyu.dao.impl.UserDaoImpl;
import liyu.model.User;
import liyu.services.UserService;

import java.util.List;

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

    @Override
    public List<User> findAllUsers() {
        try {
            return userDao.findAllUsers();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean deleteUser(Integer userId) {
        try {
            int rows = userDao.deleteUser(userId);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUserRole(Integer userId, Integer role) {
        try {
            int rows = userDao.updateUserRole(userId, role);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUserInfo(Integer userId, String nickname, String email, Integer role) {
        try {
            int rows = userDao.updateUserInfo(userId, nickname, email, role);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}