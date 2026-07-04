package liyu.util;

import java.util.regex.Pattern;

public class ValidationUtils {

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[\\u4e00-\\u9fa5a-zA-Z0-9_]{3,20}$");
    private static final Pattern NICKNAME_PATTERN = Pattern.compile("^[\\u4e00-\\u9fa5a-zA-Z0-9_]{2,20}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^[a-zA-Z0-9!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]{6,32}$");

    private ValidationUtils() {}

    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username).matches();
    }

    public static boolean isValidNickname(String nickname) {
        return nickname != null && NICKNAME_PATTERN.matcher(nickname).matches();
    }

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }

    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static String validateUsername(String username) {
        if (!isNotEmpty(username)) {
            return "用户名不能为空";
        }
        if (!isValidUsername(username)) {
            return "用户名只能包含字母、数字和下划线，长度3-20位";
        }
        return null;
    }

    public static String validateNickname(String nickname) {
        if (!isNotEmpty(nickname)) {
            return "昵称不能为空";
        }
        if (!isValidNickname(nickname)) {
            return "昵称只能包含中文、字母、数字和下划线，长度2-20位";
        }
        return null;
    }

    public static String validateEmail(String email) {
        if (!isNotEmpty(email)) {
            return "邮箱不能为空";
        }
        if (!isValidEmail(email)) {
            return "请输入有效的邮箱地址";
        }
        return null;
    }

    public static String validatePassword(String password) {
        if (!isNotEmpty(password)) {
            return "密码不能为空";
        }
        if (!isValidPassword(password)) {
            return "密码长度6-32位，可包含字母、数字和特殊字符";
        }
        return null;
    }
}