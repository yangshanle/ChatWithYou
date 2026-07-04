package liyu.dao;

import liyu.model.FriendRequest;
import liyu.model.User;
import java.util.List;

public interface FriendDao {
    // 搜索用户（排除自己和已好友）
    List<User> searchUser(String keyword, Integer myId);
    // 新增好友申请
    int addFriendRequest(FriendRequest request);
    // 查询我收到的待处理申请（带申请人昵称）
    List<FriendRequest> listMyReceiveRequest(Integer toUserId);
    // 根据ID更新申请状态
    int updateRequestStatus(Integer id, Integer status);
    // 根据ID查询申请记录（校验用）
    FriendRequest getRequestById(Integer id);
    // 添加一条好友关系
    int addFriendRelation(Integer userId, Integer friendId);
    // 查询我的所有好友
    List<User> listMyFriends(Integer userId);
    // 校验两人是否已是好友
    boolean isFriend(Integer userId, Integer friendId);
}