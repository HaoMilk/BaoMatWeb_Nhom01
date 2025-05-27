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
            
            // Ví dụ CSP chỉ cho phép tải nội dung từ chính domain (self) và CDN hợp lệ
            String cspPolicy = "default-src 'self' https://cdnjs.cloudflare.com https://fonts.gstatic.com https://code.jquery.com https://cdn.jsdelivr.net; "
                    + "script-src 'self' https://cdnjs.cloudflare.com https://code.jquery.com https://cdn.jsdelivr.net; "
                    + "style-src 'self' https://cdnjs.cloudflare.com https://cdn.jsdelivr.net; "
                    + "img-src 'self' data:; "
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