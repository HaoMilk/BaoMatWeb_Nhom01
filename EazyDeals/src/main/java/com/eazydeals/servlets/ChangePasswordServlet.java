package com.eazydeals.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Random;
import com.eazydeals.dao.UserDao;
import com.eazydeals.entities.Message;
import com.eazydeals.helper.ConnectionProvider;
import com.eazydeals.helper.MailMessenger;

public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String referrer = request.getHeader("referer");
        if (referrer == null) {
            response.sendRedirect("forgot_password.jsp");
            return;
        }

        UserDao userDao = new UserDao(ConnectionProvider.getConnection());
        HttpSession session = request.getSession();

        if (referrer.contains("forgot_password")) {
            String email = request.getParameter("email");
            if (email == null || email.trim().isEmpty()) {
                Message message = new Message("Email không được để trống!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("forgot_password.jsp");
                return;
            }
            email = email.trim();

            List<String> list = userDao.getAllEmail();
            if (list.contains(email)) {
                Random rand = new Random();
                int max = 99999, min = 10000;
                int otp = rand.nextInt(max - min + 1) + min;

                session.setAttribute("otp", otp);
                session.setAttribute("email", email);

                MailMessenger.sendOtp(email, otp);

                Message message = new Message("Chúng tôi đã gửi mã xác nhận về " + email, "success", "alert-success");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
            } else {
                Message message = new Message("Không tìm thấy email!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("forgot_password.jsp");
            }

        } else if (referrer.contains("otp_code")) {
            String codeRaw = request.getParameter("code");
            if (codeRaw == null || codeRaw.trim().isEmpty()) {
                Message message = new Message("Chưa nhập mã xác nhận!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
                return;
            }

            codeRaw = codeRaw.trim();

            if (codeRaw.length() > 5) {
                Message message = new Message("Mã xác nhận không hợp lệ!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
                return;
            }

            Integer code = null;
            try {
                code = Integer.parseInt(codeRaw);
            } catch (NumberFormatException e) {
                Message message = new Message("Mã xác nhận phải là số!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
                return;
            }

            Integer otp = (Integer) session.getAttribute("otp");
            if (otp == null) {
                Message message = new Message("Mã OTP đã hết hạn hoặc không tồn tại!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("forgot_password.jsp");
                return;
            }

            if (code.equals(otp)) {
                session.removeAttribute("otp");
                response.sendRedirect("change_password.jsp");
            } else {
                Message message = new Message("Mã xác nhận không đúng!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("otp_code.jsp");
            }

        } else if (referrer.contains("change_password")) {
            String password = request.getParameter("password");
            if (password == null || password.trim().isEmpty()) {
                Message message = new Message("Mật khẩu không được để trống!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("change_password.jsp");
                return;
            }

            String email = (String) session.getAttribute("email");
            if (email == null) {
                Message message = new Message("Phiên làm việc hết hạn, vui lòng thử lại!", "error", "alert-danger");
                session.setAttribute("message", message);
                response.sendRedirect("forgot_password.jsp");
                return;
            }

            password = password.trim();
            userDao.updateUserPasswordByEmail(password, email);

            session.removeAttribute("email");

            Message message = new Message("Password updated successfully!", "success", "alert-success");
            session.setAttribute("message", message);
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("forgot_password.jsp");
        }
    }
}