package liyu.services.impl;

import liyu.config.DeepSeekConfig;
import liyu.services.DeepSeekService;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class DeepSeekServiceImpl implements DeepSeekService {

    @Override
    public String chat(String message) {
        return chat(message, null);
    }

    public String chat(String message, String history) {
        try {
            URL url = new URL(DeepSeekConfig.getApiUrl());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + DeepSeekConfig.getApiKey());
            conn.setConnectTimeout(DeepSeekConfig.getTimeout());
            conn.setReadTimeout(DeepSeekConfig.getTimeout());
            conn.setDoOutput(true);

            String systemMessage = "{\"role\":\"system\",\"content\":\"You are a helpful assistant.\"}";
            String messagesJson;
            if (history != null && !history.trim().isEmpty() && !"[]".equals(history.trim())) {
                String historyArray = history.trim();
                if (historyArray.startsWith("[") && historyArray.endsWith("]")) {
                    String innerContent = historyArray.substring(1, historyArray.length() - 1);
                    messagesJson = "[" + systemMessage + "," + innerContent + ",{\"role\":\"user\",\"content\":\"" + escapeJson(message) + "\"}]";
                } else {
                    messagesJson = "[" + systemMessage + ",{\"role\":\"user\",\"content\":\"" + escapeJson(message) + "\"}]";
                }
            } else {
                messagesJson = "[" + systemMessage + ",{\"role\":\"user\",\"content\":\"" + escapeJson(message) + "\"}]";
            }

            String jsonBody = "{\"model\":\"" + DeepSeekConfig.getModel() + "\",\"messages\":" + messagesJson + ",\"temperature\":0.7,\"max_tokens\":2048}";
            System.out.println("[DEBUG-AI] Sending request body: " + jsonBody);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                StringBuilder responseBody = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        responseBody.append(line);
                    }
                }
                String fullResponse = responseBody.toString();
                System.out.println("[DEBUG-AI] Full response body: " + fullResponse);
                return fullResponse;
            } else {
                StringBuilder error = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        error.append(line);
                    }
                }
                return "AI服务错误 [" + responseCode + "]: " + error.toString();
            }
        } catch (Exception e) {
            return "AI服务暂不可用: " + e.getMessage();
        }
    }

    @Override
    public void chatStream(String userMessage, OutputStream outputStream) {
        try {
            URL url = new URL(DeepSeekConfig.getApiUrl());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + DeepSeekConfig.getApiKey());
            conn.setConnectTimeout(DeepSeekConfig.getTimeout());
            conn.setReadTimeout(0);
            conn.setDoOutput(true);

            String jsonBody = "{\"model\":\"" + DeepSeekConfig.getModel() + "\",\"messages\":[{\"role\":\"user\",\"content\":\"" + escapeJson(userMessage) + "\"}],\"temperature\":0.7,\"max_tokens\":2048,\"stream\":true}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        if (line.startsWith("data: ")) {
                            String data = line.substring(6);
                            if ("[DONE]".equals(data)) {
                                break;
                            }
                            outputStream.write(data.getBytes("UTF-8"));
                            outputStream.flush();
                        }
                    }
                }
            } else {
                StringBuilder error = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        error.append(line);
                    }
                }
                outputStream.write(("AI服务错误 [" + responseCode + "]: " + error.toString()).getBytes("UTF-8"));
            }
        } catch (Exception e) {
            try {
                outputStream.write(("AI服务暂不可用: " + e.getMessage()).getBytes("UTF-8"));
            } catch (IOException ignored) {}
        }
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