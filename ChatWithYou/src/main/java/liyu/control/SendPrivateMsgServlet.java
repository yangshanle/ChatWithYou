package liyu.control;

import liyu.model.User;
import liyu.services.MessageService;
import liyu.services.impl.MessageServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class SendPrivateMsgServlet extends HttpServlet {
    private MessageService messageService = new MessageServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

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
        String content = request.getParameter("content");

        try {
            Integer toUserId = Integer.parseInt(toUserIdStr);
            boolean flag = messageService.sendPrivateMsg(loginUser.getId(), toUserId, content);
            if (flag) {
                response.getWriter().write("{\"success\":true,\"msg\":\"发送成功\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"msg\":\"发送失败，非好友关系\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"msg\":\"参数错误\"}");
        }
    }
}