package liyu.control;

import liyu.model.PrivateMessage;
import liyu.services.MessageService;
import liyu.services.impl.MessageServiceImpl;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/chat")
public class ChatWebSocket {

    private static Map<Integer, Session> onlineUsers = new ConcurrentHashMap<>();
    private static MessageService messageService = new MessageServiceImpl();
    private static Gson gson = new Gson();

    private Integer userId;

    @OnOpen
    public void onOpen(Session session) {
        String userIdStr = session.getQueryString();
        if (userIdStr != null && userIdStr.startsWith("userId=")) {
            try {
                this.userId = Integer.parseInt(userIdStr.substring(7));
                onlineUsers.put(this.userId, session);
            } catch (NumberFormatException e) {
                try {
                    session.close();
                } catch (IOException ignored) {
                }
            }
        } else {
            try {
                session.close();
            } catch (IOException ignored) {
            }
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        if (this.userId == null) {
            return;
        }

        try {
            JsonObject json = gson.fromJson(message, JsonObject.class);
            Integer toUserId = json.get("toUserId").getAsInt();
            String content = json.get("content").getAsString();

            boolean success = messageService.sendPrivateMsg(this.userId, toUserId, content);

            if (success) {
                Session targetSession = onlineUsers.get(toUserId);
                if (targetSession != null && targetSession.isOpen()) {
                    PrivateMessage msg = new PrivateMessage();
                    msg.setFromUserId(this.userId);
                    msg.setToUserId(toUserId);
                    msg.setContent(content);
                    msg.setIsSelf(0);

                    JsonObject response = new JsonObject();
                    response.addProperty("type", "newMessage");
                    response.add("data", gson.toJsonTree(msg));
                    targetSession.getBasicRemote().sendText(response.toString());
                }

                JsonObject response = new JsonObject();
                response.addProperty("type", "sendSuccess");
                session.getBasicRemote().sendText(response.toString());
            } else {
                JsonObject response = new JsonObject();
                response.addProperty("type", "sendFailed");
                response.addProperty("msg", "发送失败，对方不是你的好友");
                session.getBasicRemote().sendText(response.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        if (this.userId != null) {
            onlineUsers.remove(this.userId);
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        if (this.userId != null) {
            onlineUsers.remove(this.userId);
        }
        throwable.printStackTrace();
    }

    public static int getOnlineCount() {
        return onlineUsers.size();
    }
}