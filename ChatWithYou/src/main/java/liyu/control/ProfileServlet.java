package liyu.control;

import liyu.dao.UserDao;
import liyu.dao.impl.UserDaoImpl;
import liyu.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User loginUser = (User) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        // 每次访问都重新查库，保证数据最新
        User user = userDao.findUserById(loginUser.getId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User loginUser = (User) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String nickname = request.getParameter("nickname");
        String email = request.getParameter("email");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String reNewPassword = request.getParameter("reNewPassword");

        System.out.println("[ProfileServlet] 收到修改请求，昵称：" + nickname + "，邮箱：" + email);

        User user = userDao.findUserById(loginUser.getId());

        // 基础校验
        if (nickname == null || nickname.trim().isEmpty()) {
            request.setAttribute("msg", "昵称不能为空");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        // 密码修改逻辑
        if (oldPassword != null && !oldPassword.trim().isEmpty()) {
            if (!user.getPassword().equals(oldPassword)) {
                request.setAttribute("msg", "旧密码错误");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            if (newPassword == null || newPassword.length() < 6) {
                request.setAttribute("msg", "新密码至少6位");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            if (!newPassword.equals(reNewPassword)) {
                request.setAttribute("msg", "两次输入的新密码不一致");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            user.setPassword(newPassword);
            System.out.println("[ProfileServlet] 用户修改了密码");
        }

        // 更新基础信息
        user.setNickname(nickname);
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email);
        }

        int rows = userDao.updateUser(user);
        if (rows > 0) {
            // 更新成功：重新查库，同步Session
            User freshUser = userDao.findUserById(loginUser.getId());
            request.getSession().setAttribute("loginUser", freshUser);
            request.setAttribute("user", freshUser);
            request.setAttribute("msg", "保存成功");
            System.out.println("[ProfileServlet] 信息更新成功");
        } else {
            request.setAttribute("user", user);
            request.setAttribute("msg", "保存失败，请重试");
            System.err.println("[ProfileServlet] 信息更新失败，受影响行数为0");
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
