package liyu.control;

import liyu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 销毁当前Session，彻底清除登录状态
        request.getSession().invalidate();
        // 重定向到登录页
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}