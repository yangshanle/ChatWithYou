package liyu.dao.impl;

import liyu.dao.UserDao;
import liyu.model.User;
import liyu.util.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDaoImpl implements UserDao {

    @Override
    public User findUserById(Integer userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT id, username, nickname, email, password FROM `user` WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
            }
            System.out.println("[UserDao] 查询用户ID=" + userId + "，结果：" + (user != null ? user.getNickname() : "空"));
        } catch (Exception e) {
            System.err.println("[UserDao] 查询用户失败：");
            e.printStackTrace();
        } finally {
            // 参数顺序和工具类一致：连接 → 语句 → 结果集
            JDBCUtils.close(conn, pstmt, rs);
        }
        return user;
    }

    @Override
    public int updateUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "UPDATE `user` SET nickname = ?, email = ?, password = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getNickname());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            pstmt.setInt(4, user.getId());
            rows = pstmt.executeUpdate();
            System.out.println("[UserDao] 更新用户ID=" + user.getId() + "，受影响行数：" + rows);
        } catch (Exception e) {
            System.err.println("[UserDao] 更新用户失败：");
            e.printStackTrace();
        } finally {
            // 无结果集时传 null
            JDBCUtils.close(conn, pstmt, null);
        }
        return rows;
    }

    @Override
    public int addUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "INSERT INTO `user`(username,nickname,email,password) VALUES(?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getNickname());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPassword());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, null);
        }
        return 0;
    }

    @Override
    public User findByUsername(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT * FROM `user` WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return user;
    }
}