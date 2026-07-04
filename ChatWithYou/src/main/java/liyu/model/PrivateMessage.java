package liyu.model;
import java.util.Date;

public class PrivateMessage {
    private Integer id;
    private Integer fromUserId;
    private Integer toUserId;
    private String content;
    private Integer isRead;
    private Date createTime;
    private Integer isSelf;
    // 额外字段：发送者昵称
    private String fromNickname;

    public PrivateMessage() {
    }

    public PrivateMessage(Integer id, Integer fromUserId, Integer toUserId, String content, Integer isRead, Date createTime, String fromNickname) {
        this.id = id;
        this.fromUserId = fromUserId;
        this.toUserId = toUserId;
        this.content = content;
        this.isRead = isRead;
        this.createTime = createTime;
        this.fromNickname = fromNickname;
    }

    /**
     * 获取
     * @return id
     */
    public Integer getId() {
        return id;
    }

    /**
     * 设置
     * @param id
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * 获取
     * @return fromUserId
     */
    public Integer getFromUserId() {
        return fromUserId;
    }

    /**
     * 设置
     * @param fromUserId
     */
    public void setFromUserId(Integer fromUserId) {
        this.fromUserId = fromUserId;
    }

    /**
     * 获取
     * @return toUserId
     */
    public Integer getToUserId() {
        return toUserId;
    }

    /**
     * 设置
     * @param toUserId
     */
    public void setToUserId(Integer toUserId) {
        this.toUserId = toUserId;
    }

    /**
     * 获取
     * @return content
     */
    public String getContent() {
        return content;
    }

    /**
     * 设置
     * @param content
     */
    public void setContent(String content) {
        this.content = content;
    }

    /**
     * 获取
     * @return isRead
     */
    public Integer getIsRead() {
        return isRead;
    }

    /**
     * 设置
     * @param isRead
     */
    public void setIsRead(Integer isRead) {
        this.isRead = isRead;
    }

    /**
     * 获取
     * @return createTime
     */
    public Date getCreateTime() {
        return createTime;
    }

    /**
     * 设置
     * @param createTime
     */
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    /**
     * 获取
     * @return isSelf
     */
    public Integer getIsSelf() {
        return isSelf;
    }

    /**
     * 设置
     * @param isSelf
     */
    public void setIsSelf(Integer isSelf) {
        this.isSelf = isSelf;
    }

    /**
     * 获取
     * @return fromNickname
     */
    public String getFromNickname() {
        return fromNickname;
    }

    /**
     * 设置
     * @param fromNickname
     */
    public void setFromNickname(String fromNickname) {
        this.fromNickname = fromNickname;
    }

    public String toString() {
        return "PrivateMessage{id = " + id + ", fromUserId = " + fromUserId + ", toUserId = " + toUserId + ", content = " + content + ", isRead = " + isRead + ", createTime = " + createTime + ", isSelf = " + isSelf + ", fromNickname = " + fromNickname + "}";
    }

}