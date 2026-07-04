package liyu.model;

import java.util.Date;

public class FriendRequest {
    private Integer id;
    private Integer fromUserId;
    private Integer toUserId;
    private Integer status; // 0-待处理 1-同意 2-拒绝
    private Date createTime;
    private String remark;
    private String fromNickname;

    // 所有属性的 getter / setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getFromUserId() { return fromUserId; }
    public void setFromUserId(Integer fromUserId) { this.fromUserId = fromUserId; }
    public Integer getToUserId() { return toUserId; }
    public void setToUserId(Integer toUserId) { this.toUserId = toUserId; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getFromNickname() { return fromNickname; }
    public void setFromNickname(String fromNickname) { this.fromNickname = fromNickname; }
}
