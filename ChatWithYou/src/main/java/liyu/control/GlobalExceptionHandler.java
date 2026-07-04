package liyu.control;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/error")
public class GlobalExceptionHandler extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleError(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleError(req, resp);
    }

    private void handleError(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        Throwable throwable = (Throwable) req.getAttribute("javax.servlet.error.exception");
        Integer statusCode = (Integer) req.getAttribute("javax.servlet.error.status_code");
        String requestUri = (String) req.getAttribute("javax.servlet.error.request_uri");
        String servletName = (String) req.getAttribute("javax.servlet.error.servlet_name");

        String errorType = "未知错误";
        String errorMessage = "系统发生了一个未预期的错误";
        String errorDetail = "";

        if (throwable != null) {
            if (throwable instanceof SQLException) {
                errorType = "数据库错误";
                errorMessage = "数据库操作失败，请稍后重试";
                errorDetail = throwable.getMessage();
            } else if (throwable instanceof IllegalArgumentException) {
                errorType = "参数错误";
                errorMessage = throwable.getMessage();
            } else if (throwable instanceof NullPointerException) {
                errorType = "空指针异常";
                errorMessage = "系统内部错误，请联系管理员";
                errorDetail = throwable.getMessage();
            } else if (throwable instanceof ServletException) {
                errorType = "Servlet错误";
                errorMessage = "请求处理失败";
                errorDetail = throwable.getMessage();
            } else {
                errorType = "系统异常";
                errorMessage = "系统发生异常，请稍后重试";
                errorDetail = throwable.getMessage();
            }
        } else if (statusCode != null) {
            switch (statusCode) {
                case 404:
                    errorType = "页面未找到";
                    errorMessage = "您访问的页面不存在";
                    break;
                case 403:
                    errorType = "访问拒绝";
                    errorMessage = "您没有权限访问此资源";
                    break;
                case 500:
                    errorType = "服务器内部错误";
                    errorMessage = "服务器处理请求时发生错误";
                    break;
                default:
                    errorType = "HTTP错误 " + statusCode;
                    errorMessage = "请求处理失败";
            }
        }

        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"zh-CN\">");
        out.println("<head>");
        out.println("<meta charset=\"UTF-8\">");
        out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("<title>错误 - ChatWithYou</title>");
        out.println("<link rel=\"stylesheet\" href=\"" + req.getContextPath() + "/bootstrap-5.3.0-alpha1-dist/css/bootstrap.css\">");
        out.println("<style>");
        out.println("body { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: #f7f9f7; }");
        out.println(".error-container { max-width: 500px; text-align: center; padding: 40px; background: #fff; border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,0.08); }");
        out.println(".error-icon { font-size: 64px; margin-bottom: 20px; }");
        out.println(".error-title { font-size: 24px; font-weight: 600; color: #dc2626; margin-bottom: 12px; }");
        out.println(".error-message { color: #6b7280; margin-bottom: 24px; }");
        out.println(".error-detail { background: #f3f4f6; padding: 12px 16px; border-radius: 8px; font-size: 12px; color: #9ca3af; margin-bottom: 24px; text-align: left; display: none; }");
        out.println(".btn-back { background: linear-gradient(90deg, #69db7c 0%, #8ce99a 100%); color: #14532d; border: none; padding: 10px 32px; border-radius: 10px; font-weight: 600; cursor: pointer; transition: 0.25s; }");
        out.println(".btn-back:hover { filter: brightness(1.05); }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class=\"error-container\">");
        out.println("<div class=\"error-icon\">🔴</div>");
        out.println("<div class=\"error-title\">" + escapeHtml(errorType) + "</div>");
        out.println("<div class=\"error-message\">" + escapeHtml(errorMessage) + "</div>");
        if (errorDetail != null && !errorDetail.isEmpty()) {
            out.println("<div class=\"error-detail\" id=\"errorDetail\">" + escapeHtml(errorDetail) + "</div>");
        }
        out.println("<button class=\"btn-back\" onclick=\"window.location.href='" + req.getContextPath() + "/index.jsp'\">返回首页</button>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }

    private String escapeHtml(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");
    }
}