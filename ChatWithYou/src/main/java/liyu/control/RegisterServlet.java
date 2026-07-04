package liyu.control;

import liyu.model.User;
import liyu.services.UserService;
import liyu.services.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register") // 访问路径：http://localhost:8080/项目名/register
public class RegisterServlet extends HttpServlet {
    // 业务层对象
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }  

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        System.out.println("dopost done");
        // 2. 获取表单参数
        String username = req.getParameter("username");
        String nickname = req.getParameter("nickname");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");

        // 3. 基础校验：两次密码是否一致
        if (!password.equals(repassword)) {
            req.setAttribute("msg", "两次输入的密码不一致！");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 4. 封装User对象
        User user = new User();
        user.setUsername(username);
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPassword(password);

        // 5. 调用Service层执行注册
        boolean flag = userService.register(user);

// 6. 根据结果跳转
        if (flag) {
            // 注册成功，跳转到登录页
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            // 注册失败，区分错误原因
            User existUser = userService.findByUsername(username);
            if (existUser != null) {
                req.setAttribute("msg", "用户名已存在，请更换后重试！");
            } else {
                req.setAttribute("msg", "注册失败，系统异常，请检查数据库连接！");
            }
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}