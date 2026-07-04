package liyu.control;

import liyu.model.User;
import liyu.services.FriendService;
import liyu.services.impl.FriendServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class HandleFriendRequestServlet extends HttpServlet {
    private FriendService friendService = new FriendServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.getWriter().write("{\"success\":false,\"msg\":\"请先登录\"}");
            return;
        }

        String requestIdStr = request.getParameter("requestId");
        String statusStr = request.getParameter("status");

        try {
            Integer requestId = Integer.parseInt(requestIdStr);
            Integer status = Integer.parseInt(statusStr);
            boolean flag = friendService.handleRequest(requestId, status, loginUser.getId());
            if (flag) {
                response.getWriter().write("{\"success\":true,\"msg\":\"操作成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"msg\":\"操作失败\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"msg\":\"参数错误\"}");
        }
    }
}