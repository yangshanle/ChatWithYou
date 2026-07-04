package liyu.control;

import liyu.model.User;
import liyu.services.UserService;
import liyu.services.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // 1. 获取登录参数
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // 2. 调用Service登录
        User user = userService.login(username, password);

        // 3. 判断结果
        if (user != null) {
            // 登录成功：将用户信息存入Session（全局共享）
            HttpSession session = req.getSession();
            session.setAttribute("loginUser", user);
            // 跳转到首页
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            // 登录失败：返回登录页提示
            req.setAttribute("msg", "用户名或密码错误！");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}