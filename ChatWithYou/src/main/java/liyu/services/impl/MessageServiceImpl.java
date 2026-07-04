package liyu.services.impl;

import liyu.dao.FriendDao;
import liyu.dao.MessageDao;
import liyu.dao.impl.FriendDaoImpl;
import liyu.dao.impl.MessageDaoImpl;
import liyu.model.PrivateMessage;
import liyu.services.MessageService;

import java.util.List;
import java.util.Map;

public class MessageServiceImpl implements MessageService {

    private MessageDao messageDao = new MessageDaoImpl();
    private FriendDao friendDao = new FriendDaoImpl();

    @Override
    public boolean sendPrivateMsg(Integer fromId, Integer toId, String content) {
        // 校验：必须是好友才能发消息
        if (!friendDao.isFriend(fromId, toId)) {
            return false;
        }
        if (content == null || content.trim().isEmpty()) {
            return false;
        }
        PrivateMessage msg = new PrivateMessage();
        msg.setFromUserId(fromId);
        msg.setToUserId(toId);
        msg.setContent(content.trim());
        return messageDao.addPrivateMessage(msg) > 0;
    }

    @Override
    public List<PrivateMessage> getPrivateMsg(Integer myId, Integer friendId) {
        if (!friendDao.isFriend(myId, friendId)) {
            return null;
        }
        // 拉取消息前先标记已读
        messageDao.markRead(myId, friendId);
        return messageDao.listPrivateMsg(myId, friendId);
    }

    @Override
    public int countUnreadMsg(Integer myId, Integer friendId) {
        if (!friendDao.isFriend(myId, friendId)) {
            return 0;
        }
        return messageDao.countUnreadMsg(myId, friendId);
    }

    @Override
    public Map<Integer, Integer> countAllUnreadMsg(Integer myId) {
        return messageDao.countAllUnreadMsg(myId);
    }
}