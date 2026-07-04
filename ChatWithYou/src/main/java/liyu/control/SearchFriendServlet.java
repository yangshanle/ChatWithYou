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

public class SearchFriendServlet extends HttpServlet {
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

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        List<User> list = friendService.searchUser(keyword.trim(), loginUser.getId());
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            User u = list.get(i);
            // 空值容错，避免前端显示异常
            String username = u.getUsername() == null ? "" : u.getUsername();
            String nickname = u.getNickname() == null ? "" : u.getNickname();
            Integer id = u.getId() == null ? 0 : u.getId();

            json.append("{\"id\":").append(id)
                    .append(",\"username\":\"").append(username).append("\"")
                    .append(",\"nickname\":\"").append(nickname).append("\"}");
            if (i != list.size() - 1) json.append(",");
        }
        json.append("]");
        response.getWriter().write(json.toString());
    }
}