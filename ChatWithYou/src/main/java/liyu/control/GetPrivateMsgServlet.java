package liyu.control;

import liyu.model.PrivateMessage;
import liyu.model.User;
import liyu.services.MessageService;
import liyu.services.impl.MessageServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class GetPrivateMsgServlet extends HttpServlet {
    private MessageService messageService = new MessageServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.getWriter().write("[]");
            return;
        }

        String friendIdStr = request.getParameter("friendId");
        try {
            Integer friendId = Integer.parseInt(friendIdStr);
            List<PrivateMessage> list = messageService.getPrivateMsg(loginUser.getId(), friendId);
            if (list == null) {
                response.getWriter().write("[]");
                return;
            }

            // 把原来的循环替换成下面这段
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                PrivateMessage msg = list.get(i);
                json.append("{\"id\":").append(msg.getId())
                        .append(",\"fromUserId\":").append(msg.getFromUserId())
                        .append(",\"content\":\"").append(msg.getContent()).append("\"")
                        .append(",\"isSelf\":").append(msg.getFromUserId().equals(loginUser.getId()) ? 1 : 0)
                        .append(",\"fromNickname\":\"").append(msg.getFromNickname() == null ? "" : msg.getFromNickname()).append("\"")
                        .append(",\"isRead\":").append(msg.getIsRead())
                        // 补上时间戳（毫秒数，前端直接new Date使用）
                        .append(",\"createTime\":").append(msg.getCreateTime() == null ? 0 : msg.getCreateTime().getTime())
                        .append("}");
                if (i != list.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
}