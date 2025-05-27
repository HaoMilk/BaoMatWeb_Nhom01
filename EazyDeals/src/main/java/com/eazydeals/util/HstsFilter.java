package com.eazydeals.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class HstsFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        // Chỉ thêm header nếu là HTTPS (scheme là "https")
        if ("https".equalsIgnoreCase(httpReq.getScheme())) {
            httpResp.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload");
        }

        chain.doFilter(request, response);
    }
}
