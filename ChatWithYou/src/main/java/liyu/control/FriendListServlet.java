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
import java.util.List;

public class FriendListServlet extends HttpServlet {
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

        List<User> list = friendService.getMyFriends(loginUser.getId());
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            User u = list.get(i);
            json.append("{\"id\":").append(u.getId())
                    .append(",\"username\":\"").append(u.getUsername()).append("\"")
                    .append(",\"nickname\":\"").append(u.getNickname()).append("\"}");
            if (i != list.size() - 1) json.append(",");
        }
        json.append("]");
        response.getWriter().write(json.toString());
    }
}