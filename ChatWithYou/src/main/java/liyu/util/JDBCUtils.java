package liyu.util;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

// JDBC连接工具类
public class JDBCUtils {
    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    // 静态代码块：项目启动时就读取配置文件
    static {
        try {
            InputStream is = JDBCUtils.class.getClassLoader().getResourceAsStream("db.properties");
            Properties prop = new Properties();
            prop.load(is);
            driver = prop.getProperty("driver");
            url = prop.getProperty("url");
            username = prop.getProperty("username");
            password = prop.getProperty("password");
            // 注册驱动
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 获取数据库连接
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    // 释放资源（增删改操作释放）
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }

    // 释放资源（查询操作释放）
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}