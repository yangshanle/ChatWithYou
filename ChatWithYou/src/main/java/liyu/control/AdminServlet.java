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
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        List<User> userList = userService.findAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (action == null || userIdStr == null) {
            response.getWriter().write("{\"success\":false,\"msg\":\"参数错误\"}");
            return;
        }

        Integer userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"msg\":\"用户ID格式错误\"}");
            return;
        }

        boolean success;
        String msg;

        switch (action) {
            case "delete":
                success = userService.deleteUser(userId);
                msg = success ? "删除成功" : "删除失败";
                break;
            case "update":
                String nickname = request.getParameter("nickname");
                String email = request.getParameter("email");
                String roleStr = request.getParameter("role");
                
                Integer role = null;
                if (roleStr != null && !roleStr.isEmpty()) {
                    try {
                        role = Integer.parseInt(roleStr);
                    } catch (NumberFormatException e) {
                        response.getWriter().write("{\"success\":false,\"msg\":\"角色格式错误\"}");
                        return;
                    }
                }
                
                success = userService.updateUserInfo(userId, nickname, email, role);
                msg = success ? "更新成功" : "更新失败";
                break;
            case "updateRole":
                String roleStr2 = request.getParameter("role");
                if (roleStr2 == null) {
                    response.getWriter().write("{\"success\":false,\"msg\":\"角色参数错误\"}");
                    return;
                }
                Integer role2;
                try {
                    role2 = Integer.parseInt(roleStr2);
                } catch (NumberFormatException e) {
                    response.getWriter().write("{\"success\":false,\"msg\":\"角色格式错误\"}");
                    return;
                }
                success = userService.updateUserRole(userId, role2);
                msg = success ? "角色更新成功" : "角色更新失败";
                break;
            default:
                response.getWriter().write("{\"success\":false,\"msg\":\"未知操作\"}");
                return;
        }

        response.getWriter().write("{\"success\":" + success + ",\"msg\":\"" + msg + "\"}");
    }
}