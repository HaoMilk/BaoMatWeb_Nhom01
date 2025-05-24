package com.eazydeals.servlets;

import com.eazydeals.entities.Review; // Giả sử bạn đã tạo một lớp Review để đại diện cho đánh giá
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;
import java.io.IOException; 
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SubmitReviewServlet")
public class SubmitReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Danh sách đánh giá tạm thời
    private static List<Review> reviews = new ArrayList<>();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form
        String reviewText = request.getParameter("review");
        int rating = Integer.parseInt(request.getParameter("rating"));
        int productId = Integer.parseInt(request.getParameter("pid")); // Lấy productId từ request nếu cần

        // Tạo đối tượng Review
        Review review = new Review();
        review.setReviewText(reviewText);
        review.setRating(rating);
        review.setProductId(productId);
        // Giả sử bạn có một phương thức để lấy userId từ session
        review.setUserId((Integer) request.getSession().getAttribute("userId"));

        // Lưu đánh giá vào danh sách tạm thời
        reviews.add(review);

        // Chuyển hướng về trang sản phẩm hoặc thông báo thành công
        response.sendRedirect("viewProduct.jsp?pid=" + productId + "&success=true");
    }

    // Phương thức để lấy danh sách đánh giá (có thể gọi từ nơi khác)
    public static List<Review> getReviews() {
        return reviews;
    }
}