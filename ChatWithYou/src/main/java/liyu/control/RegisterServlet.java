package liyu.control;

import liyu.model.User;
import liyu.services.UserService;
import liyu.services.impl.UserServiceImpl;
import liyu.util.ValidationUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String username = req.getParameter("username");
        String nickname = req.getParameter("nickname");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String repassword = req.getParameter("repassword");

        String errorMsg = ValidationUtils.validateUsername(username);
        if (errorMsg != null) {
            req.setAttribute("msg", errorMsg);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        errorMsg = ValidationUtils.validateNickname(nickname);
        if (errorMsg != null) {
            req.setAttribute("msg", errorMsg);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        errorMsg = ValidationUtils.validateEmail(email);
        if (errorMsg != null) {
            req.setAttribute("msg", errorMsg);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        errorMsg = ValidationUtils.validatePassword(password);
        if (errorMsg != null) {
            req.setAttribute("msg", errorMsg);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(repassword)) {
            req.setAttribute("msg", "两次输入的密码不一致！");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPassword(password);

        boolean flag = userService.register(user);

        if (flag) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
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