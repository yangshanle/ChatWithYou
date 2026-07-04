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

public class SendFriendRequestServlet extends HttpServlet {
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

        String toUserIdStr = request.getParameter("toUserId");
        String remark = request.getParameter("remark");
        if (remark == null) remark = "";

        // 控制台打印收到的参数，方便排查
        System.out.println("收到添加请求，toUserId = " + toUserIdStr);

        try {
            if (toUserIdStr == null || toUserIdStr.trim().isEmpty()) {
                throw new NumberFormatException("空ID");
            }
            Integer toUserId = Integer.parseInt(toUserIdStr.trim());
            boolean flag = friendService.sendFriendRequest(loginUser.getId(), toUserId, remark);
            if (flag) {
                response.getWriter().write("{\"success\":true,\"msg\":\"申请已发送\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"msg\":\"发送失败，不能重复添加\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"msg\":\"参数错误\"}");
        }
    }
}