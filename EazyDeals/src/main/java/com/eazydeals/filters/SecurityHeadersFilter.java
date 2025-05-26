package com.eazydeals.filters;

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
public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì đặc biệt
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResp = (HttpServletResponse) response;

            // Thêm header X-Content-Type-Options
            httpResp.setHeader("X-Content-Type-Options", "nosniff");
        }

        // Tiếp tục chuỗi xử lý request/response
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần xử lý gì khi filter bị hủy
    }
}
