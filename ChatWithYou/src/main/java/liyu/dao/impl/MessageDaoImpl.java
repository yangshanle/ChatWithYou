package liyu.dao.impl;

import liyu.dao.MessageDao;
import liyu.model.PrivateMessage;
import liyu.util.JDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MessageDaoImpl implements MessageDao {

    @Override
    public int addPrivateMessage(PrivateMessage msg) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "INSERT INTO private_message(from_user_id, to_user_id, content) VALUES (?,?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, msg.getFromUserId());
            pstmt.setInt(2, msg.getToUserId());
            pstmt.setString(3, msg.getContent());
            rows = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt);
        }
        return rows;
    }

    @Override
    public List<PrivateMessage> listPrivateMsg(Integer userId, Integer friendId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<PrivateMessage> list = new ArrayList<>();
        try {
            conn = JDBCUtils.getConnection();
            // 查询双向消息，联表取发送者昵称
            String sql = "SELECT pm.*, u.username as from_nickname FROM private_message pm " +
                    "LEFT JOIN user u ON pm.from_user_id = u.id " +
                    "WHERE (pm.from_user_id = ? AND pm.to_user_id = ?) " +
                    "OR (pm.from_user_id = ? AND pm.to_user_id = ?) " +
                    "ORDER BY pm.create_time ASC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, friendId);
            pstmt.setInt(3, friendId);
            pstmt.setInt(4, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PrivateMessage msg = new PrivateMessage();
                msg.setId(rs.getInt("id"));
                msg.setFromUserId(rs.getInt("from_user_id"));
                msg.setToUserId(rs.getInt("to_user_id"));
                msg.setContent(rs.getString("content"));
                msg.setIsRead(rs.getInt("is_read"));
                msg.setCreateTime(rs.getTimestamp("create_time"));
                msg.setFromNickname(rs.getString("from_nickname"));
                list.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return list;
    }

    @Override
    public int markRead(Integer myId, Integer friendId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = JDBCUtils.getConnection();
            // 把对方发给我的未读消息标记为已读
            String sql = "UPDATE private_message SET is_read = 1 " +
                    "WHERE from_user_id = ? AND to_user_id = ? AND is_read = 0";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, friendId);
            pstmt.setInt(2, myId);
            rows = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt);
        }
        return rows;
    }

    @Override
    public int countUnreadMsg(Integer myId, Integer friendId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT COUNT(*) FROM private_message " +
                    "WHERE from_user_id = ? AND to_user_id = ? AND is_read = 0";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, friendId);
            pstmt.setInt(2, myId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return count;
    }

    @Override
    public Map<Integer, Integer> countAllUnreadMsg(Integer myId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<Integer, Integer> map = new HashMap<>();
        try {
            conn = JDBCUtils.getConnection();
            String sql = "SELECT from_user_id, COUNT(*) as cnt FROM private_message " +
                    "WHERE to_user_id = ? AND is_read = 0 GROUP BY from_user_id";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, myId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                map.put(rs.getInt("from_user_id"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCUtils.close(conn, pstmt, rs);
        }
        return map;
    }
}