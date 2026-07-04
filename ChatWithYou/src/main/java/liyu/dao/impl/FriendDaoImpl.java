package liyu.dao.impl;

import liyu.dao.FriendDao;
import liyu.model.FriendRequest;
import liyu.model.User;
import liyu.util.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FriendDaoImpl implements FriendDao {

    @Override
    public List<User> searchUser(String keyword, Integer myId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = JDBCUtils.getConnection();
            // 注意：如果你的user表字段是 user_name / nick_name，这里SQL和rs.getString必须对应修改
            String sql = "SELECT id, username, nickname FROM user " +
                    "WHERE id != ? AND (username LIKE ? OR nickname LIKE ?) " +
                    "AND id NOT IN (SELECT friend_id FROM friend WHERE user_id = ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, myId);
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, "%" + keyword + "%");
            pstmt.setInt(4, myId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                // 这里的字段名必须和数据库表完全一致，区分大小写
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setNickname(rs.getString("nickname"));
                list.add(user);
                // 控制台打印，确认查到了数据
                System.out.println("查到用户：" + user.getId() + " " + user.getNickname());
            }
            System.out.println("搜索结果总数：" + list.size());
        } catch (Exception e) {
            e.printStackTrace(); // 有错误会直接打印在IDEA控制台
        } finally {
            // 匹配你的JDBCUtils参数顺序：conn, stmt, rs
            JDBCUtils.close(conn, pstmt, rs);
        }
        return list;
    }

    @Override
    public int addFriendRequest(FriendRequest request) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "INSERT INTO friend_request(from_user_id, to_user_id, status, remark) VALUES (?,?,0,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, request.getFromUserId());
            pstmt.setInt(2, request.getToUserId());
            pstmt.setString(3, request.getRemark());
            rows = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, null);
        }
        return rows;
    }

    @Override
    public List<FriendRequest> listMyReceiveRequest(Integer toUserId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<FriendRequest> list = new ArrayList<>();
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT fr.*, u.nickname as from_nickname FROM friend_request fr " +
                    "LEFT JOIN user u ON fr.from_user_id = u.id " +
                    "WHERE fr.to_user_id = ? AND fr.status = 0 ORDER BY fr.create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, toUserId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                FriendRequest req = new FriendRequest();
                req.setId(rs.getInt("id"));
                req.setFromUserId(rs.getInt("from_user_id"));
                req.setToUserId(rs.getInt("to_user_id"));
                req.setStatus(rs.getInt("status"));
                req.setRemark(rs.getString("remark"));
                req.setCreateTime(rs.getTimestamp("create_time"));
                req.setFromNickname(rs.getString("from_nickname"));
                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return list;
    }

    @Override
    public int updateRequestStatus(Integer id, Integer status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "UPDATE friend_request SET status = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setInt(2, id);
            rows = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, null);
        }
        return rows;
    }

    @Override
    public FriendRequest getRequestById(Integer id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        FriendRequest req = null;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT * FROM friend_request WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                req = new FriendRequest();
                req.setId(rs.getInt("id"));
                req.setFromUserId(rs.getInt("from_user_id"));
                req.setToUserId(rs.getInt("to_user_id"));
                req.setStatus(rs.getInt("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return req;
    }

    @Override
    public int addFriendRelation(Integer userId, Integer friendId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "INSERT INTO friend(user_id, friend_id) VALUES (?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, friendId);
            rows = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, null);
        }
        return rows;
    }

    @Override
    public List<User> listMyFriends(Integer userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT u.id, u.username, u.nickname FROM friend f " +
                    "LEFT JOIN user u ON f.friend_id = u.id " +
                    "WHERE f.user_id = ? ORDER BY f.create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setNickname(rs.getString("nickname"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return list;
    }

    @Override
    public boolean isFriend(Integer userId, Integer friendId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean flag = false;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT id FROM friend WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, friendId);
            pstmt.setInt(3, friendId);
            pstmt.setInt(4, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return flag;
    }
}