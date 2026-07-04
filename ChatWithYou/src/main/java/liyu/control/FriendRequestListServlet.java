package liyu.control;

import liyu.model.FriendRequest;
import liyu.model.User;
import liyu.services.FriendService;
import liyu.services.impl.FriendServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class FriendRequestListServlet extends HttpServlet {
    private FriendService friendService = new FriendServiceImpl();

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

        List<FriendRequest> list = friendService.getMyReceiveRequest(loginUser.getId());
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            FriendRequest req = list.get(i);
            json.append("{\"id\":").append(req.getId())
                    .append(",\"fromUserId\":").append(req.getFromUserId())
                    .append(",\"fromNickname\":\"").append(req.getFromNickname()).append("\"")
                    .append(",\"remark\":\"").append(req.getRemark() == null ? "" : req.getRemark()).append("\"}");
            if (i != list.size() - 1) json.append(",");
        }
        json.append("]");
        response.getWriter().write(json.toString());
    }
}