package liyu.control;

import liyu.services.DeepSeekService;
import liyu.services.impl.DeepSeekServiceImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/ai/chat")
public class AIChatServlet extends HttpServlet {

    private DeepSeekService deepSeekService;

    @Override
    public void init() {
        deepSeekService = new DeepSeekServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        System.out.println("[DEBUG-AI] AIChatServlet doPost called");
        System.out.println("[DEBUG-AI] Request URI: " + request.getRequestURI());
        System.out.println("[DEBUG-AI] Request method: " + request.getMethod());
        
        response.setContentType("application/json;charset=UTF-8");
        
        String message = null;
        String history = null;
        
        String contentType = request.getContentType();
        System.out.println("[DEBUG-AI] Content-Type: " + contentType);
        
        if (contentType != null && contentType.contains("application/json")) {
            StringBuilder sb = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            String jsonBody = sb.toString();
            System.out.println("[DEBUG-AI] JSON body received: " + (jsonBody.length() > 200 ? jsonBody.substring(0, 200) + "..." : jsonBody));
            
            if (jsonBody.contains("\"message\":")) {
                int start = jsonBody.indexOf("\"message\":\"") + 11;
                int end = jsonBody.indexOf("\"", start);
                if (end > start) {
                    message = jsonBody.substring(start, end);
                }
            }
            if (jsonBody.contains("\"history\":")) {
                int historyKeyIdx = jsonBody.indexOf("\"history\":");
                int colonIdx = jsonBody.indexOf(":", historyKeyIdx);
                String afterColon = jsonBody.substring(colonIdx + 1).trim();
                if (afterColon.startsWith("[")) {
                    // JSON数组格式：提取 [...] 内容
                    int depth = 0;
                    int arrayEnd = colonIdx + 1;
                    for (int i = colonIdx + 1; i < jsonBody.length(); i++) {
                        char c = jsonBody.charAt(i);
                        if (c == '[') depth++;
                        else if (c == ']') {
                            depth--;
                            if (depth == 0) { arrayEnd = i + 1; break; }
                        }
                    }
                    history = jsonBody.substring(colonIdx + 1, arrayEnd).trim();
                } else {
                    // 字符串格式：向后兼容
                    int start = jsonBody.indexOf("\"history\":\"") + 11;
                    int end = jsonBody.indexOf("\"", start);
                    if (end > start) {
                        history = jsonBody.substring(start, end);
                        history = history.replace("\\\"", "\"");
                    }
                }
            }
        } else {
            message = request.getParameter("message");
            history = request.getParameter("history");
            System.out.println("[DEBUG-AI] message parameter: " + message);
            System.out.println("[DEBUG-AI] history parameter: " + (history != null ? history.substring(0, 100) + "..." : "null"));
        }
        
        System.out.println("[DEBUG-AI] Final message: " + message);
        System.out.println("[DEBUG-AI] Final history: " + (history != null ? "exists, length=" + history.length() : "null"));
        
        if (message == null || message.trim().isEmpty()) {
            System.out.println("[DEBUG-AI] Message is null or empty");
            try (OutputStream os = response.getOutputStream()) {
                os.write("{\"success\":false,\"msg\":\"消息内容不能为空\"}".getBytes("UTF-8"));
            }
            return;
        }

        String result = deepSeekService.chat(message.trim(), history);
        System.out.println("[DEBUG-AI] Chat result: " + (result.length() > 200 ? result.substring(0, 200) + "..." : result));
        
        if (result.contains("AI服务错误") || result.contains("AI服务暂不可用")) {
            System.out.println("[DEBUG-AI] AI service error, returning error response");
            try (OutputStream os = response.getOutputStream()) {
                os.write(("{\"success\":false,\"msg\":\"" + escapeJson(result) + "\"}").getBytes("UTF-8"));
            }
        } else {
            System.out.println("[DEBUG-AI] AI service success, returning raw response");
            try (OutputStream os = response.getOutputStream()) {
                os.write(result.getBytes("UTF-8"));
            }
        }
        
        System.out.println("[DEBUG-AI] Response sent successfully");
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        StringBuilder sb = new StringBuilder();
        for (char c : str.toCharArray()) {
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '/': sb.append("\\/"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default: sb.append(c); break;
            }
        }
        return sb.toString();
    }
}