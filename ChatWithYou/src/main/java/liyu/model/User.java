package liyu.model;

// 用户实体类，对应数据库user表
public class User {
    private Integer id;
    private String username;
    private String nickname;
    private String email;
    private String password;
    private Integer role;

    // 无参构造（必须有，框架/反射会用到）
    public User() {}

    // 全参构造（方便创建对象）
    public User(Integer id, String username, String nickname, String email, String password, Integer role) {
        this.id = id;
        this.username = username;
        this.nickname = nickname;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // 所有属性的 Getter 和 Setter 方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public Integer getRole() { return role; }
    public void setRole(Integer role) { this.role = role; }
}