package liyu.services.impl;

import liyu.dao.FriendDao;
import liyu.dao.impl.FriendDaoImpl;
import liyu.model.FriendRequest;
import liyu.model.User;
import liyu.services.FriendService;

import java.util.List;

public class FriendServiceImpl implements FriendService {

    private FriendDao friendDao = new FriendDaoImpl();

    @Override
    public List<User> searchUser(String keyword, Integer myId) {
        return friendDao.searchUser(keyword, myId);
    }

    @Override
    public boolean sendFriendRequest(Integer fromId, Integer toId, String remark) {
        if (fromId.equals(toId)) return false;
        if (friendDao.isFriend(fromId, toId)) return false;
        FriendRequest req = new FriendRequest();
        req.setFromUserId(fromId);
        req.setToUserId(toId);
        req.setRemark(remark);
        return friendDao.addFriendRequest(req) > 0;
    }

    @Override
    public List<FriendRequest> getMyReceiveRequest(Integer toId) {
        return friendDao.listMyReceiveRequest(toId);
    }

    @Override
    public boolean handleRequest(Integer requestId, Integer status, Integer myId) {
        FriendRequest req = friendDao.getRequestById(requestId);
        if (req == null) return false;
        if (!req.getToUserId().equals(myId)) return false;

        int rows = friendDao.updateRequestStatus(requestId, status);
        if (rows <= 0) return false;

        // 同意则添加双向好友关系
        if (status == 1) {
            friendDao.addFriendRelation(req.getFromUserId(), req.getToUserId());
            friendDao.addFriendRelation(req.getToUserId(), req.getFromUserId());
        }
        return true;
    }

    @Override
    public List<User> getMyFriends(Integer userId) {
        return friendDao.listMyFriends(userId);
    }
}