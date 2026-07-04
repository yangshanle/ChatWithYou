package liyu.services;

import liyu.model.PrivateMessage;
import java.util.List;
import java.util.Map;

public interface MessageService {
    // 发送消息（校验好友关系）
    boolean sendPrivateMsg(Integer fromId, Integer toId, String content);

    // 获取两人历史消息（同时标记已读）
    List<PrivateMessage> getPrivateMsg(Integer myId, Integer friendId);

    // 统计某个好友发给我的未读消息数量
    int countUnreadMsg(Integer myId, Integer friendId);

    // 统计所有好友发给我的未读消息数量（返回 map: friendId -> count）
    Map<Integer, Integer> countAllUnreadMsg(Integer myId);
}