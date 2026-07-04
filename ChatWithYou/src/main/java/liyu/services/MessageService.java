package liyu.services;

import liyu.model.PrivateMessage;
import java.util.List;

public interface MessageService {
    // 发送消息（校验好友关系）
    boolean sendPrivateMsg(Integer fromId, Integer toId, String content);

    // 获取两人历史消息（同时标记已读）
    List<PrivateMessage> getPrivateMsg(Integer myId, Integer friendId);
}