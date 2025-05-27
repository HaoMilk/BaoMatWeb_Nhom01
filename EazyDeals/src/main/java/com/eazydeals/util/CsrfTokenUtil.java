package com.eazydeals.util;

import jakarta.servlet.http.HttpSession;
import java.util.UUID;

public class CsrfTokenUtil {
    public static final String SESSION_CSRF_TOKEN = "csrfToken";

    public static void setToken(HttpSession session) {
        if (session.getAttribute(SESSION_CSRF_TOKEN) == null) {
            session.setAttribute(SESSION_CSRF_TOKEN, UUID.randomUUID().toString());
        }
    }

    public static boolean isValid(HttpSession session, String tokenFromRequest) {
        String tokenInSession = (String) session.getAttribute(SESSION_CSRF_TOKEN);
        return tokenInSession != null && tokenInSession.equals(tokenFromRequest);
    }
}
