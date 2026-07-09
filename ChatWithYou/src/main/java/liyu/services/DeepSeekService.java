package liyu.services;

import java.io.OutputStream;

public interface DeepSeekService {
    String chat(String userMessage);
    
    String chat(String userMessage, String history);
    
    void chatStream(String userMessage, OutputStream outputStream);
}