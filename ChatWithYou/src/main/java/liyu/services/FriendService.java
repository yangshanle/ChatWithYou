package liyu.services;

import liyu.model.FriendRequest;
import liyu.model.User;
import java.util.List;

public interface FriendService {
    List<User> searchUser(String keyword, Integer myId);
    boolean sendFriendRequest(Integer fromId, Integer toId, String remark);
    List<FriendRequest> getMyReceiveRequest(Integer toId);
    boolean handleRequest(Integer requestId, Integer status, Integer myId);
    List<User> getMyFriends(Integer userId);
}