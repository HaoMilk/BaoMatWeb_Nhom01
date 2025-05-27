package com.eazydeals.util;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebFilter;

import java.io.IOException;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // Sử dụng tiện ích để tạo token nếu chưa có
        CsrfTokenUtil.setToken(session);

        // Nếu là POST thì kiểm tra token
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String tokenFromRequest = req.getParameter("csrfToken");
            if (!CsrfTokenUtil.isValid(session, tokenFromRequest)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token invalid or missing.");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
