package liyu.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class DeepSeekConfig {
    private static Properties properties = new Properties();
    
    static {
        try (InputStream input = DeepSeekConfig.class.getClassLoader().getResourceAsStream("ai.properties")) {
            if (input != null) {
                properties.load(input);
            } else {
                System.err.println("ai.properties not found, using defaults");
            }
        } catch (IOException e) {
            System.err.println("Error loading ai.properties: " + e.getMessage());
        }
    }
    
    public static String getApiUrl() {
        return properties.getProperty("ai.deepseek.api.url", "https://cdn.sta1n.cn/v1/chat/completions");
    }
    
    public static String getApiKey() {
        return properties.getProperty("ai.deepseek.api.key", "");
    }
    
    public static String getModel() {
        return properties.getProperty("ai.deepseek.model", "gpt-5.5");
    }
    
    public static int getTimeout() {
        try {
            return Integer.parseInt(properties.getProperty("ai.deepseek.timeout", "30000"));
        } catch (NumberFormatException e) {
            return 30000;
        }
    }
}