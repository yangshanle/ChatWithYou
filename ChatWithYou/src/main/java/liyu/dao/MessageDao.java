package liyu.dao;

import liyu.model.PrivateMessage;
import java.util.List;

public interface MessageDao {
    // 发送私聊消息：插入一条记录
    int addPrivateMessage(PrivateMessage msg);

    // 查询两人之间的所有历史消息（按时间升序）
    List<PrivateMessage> listPrivateMsg(Integer userId, Integer friendId);

    // 标记对方发给我的消息为已读
    int markRead(Integer myId, Integer friendId);
}