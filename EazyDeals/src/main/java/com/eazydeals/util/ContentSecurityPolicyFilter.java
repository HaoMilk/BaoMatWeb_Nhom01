package com.eazydeals.util;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")  // Áp dụng cho tất cả URL trong ứng dụng
public class ContentSecurityPolicyFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì đặc biệt
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResp = (HttpServletResponse) response;
            
            // Chính sách CSP mở rộng cho phép nội bộ cùng domain, localhost port 8080,
            // cho phép inline script/style (nếu có), và các CDN phổ biến
            String cspPolicy = 
                "default-src 'self' https://localhost:8443 https://cdnjs.cloudflare.com https://fonts.gstatic.com https://code.jquery.com https://cdn.jsdelivr.net; "
              + "script-src 'self' https://localhost:8443 https://cdnjs.cloudflare.com https://code.jquery.com https://cdn.jsdelivr.net 'unsafe-inline'; "
              + "style-src 'self' https://localhost:8443 https://cdnjs.cloudflare.com https://cdn.jsdelivr.net 'unsafe-inline'; "
              + "img-src 'self' data: https://localhost:8443; "
              + "font-src 'self' https://fonts.gstatic.com; "
              + "object-src 'none'; "
              + "form-action 'self'; "
              + "frame-ancestors 'none'; "
              + "base-uri 'self';";

            httpResp.setHeader("Content-Security-Policy", cspPolicy);
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần xử lý gì khi filter bị hủy
    }
}
