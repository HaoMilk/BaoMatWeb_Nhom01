<%@page import="com.eazydeals.dao.WishlistDao"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.entities.Review"%>
<%@page import="com.eazydeals.servlets.SubmitReviewServlet"%> <!-- Khai báo servlet -->
<%@page errorPage="error_exception.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<%
int productId = Integer.parseInt(request.getParameter("pid"));
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
Product product = (Product) productDao.getProductsByProductId(productId);
DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%!
    // Hàm escape HTML để ngăn chặn XSS
    public String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
%>
<title>Chi tiết sản phẩm</title>
<%@include file="Components/common_css_js.jsp"%>
<style type="text/css">
.real-price {
	font-size: 26px !important;
	font-weight: 600;
}

.product-price {
	font-size: 18px !important;
	text-decoration: line-through;
}

.product-discount {
	font-size: 16px !important;
	color: #027a3e;
}

.color-options {
    display: flex;
    gap: 10px; /* Khoảng cách giữa các lựa chọn màu sắc */
}

.size-options {
    display: flex;
    gap: 10px; /* Khoảng cách giữa các lựa chọn kích thước */
}

.rating {
    display: flex;
    gap: 5px; /* Khoảng cách giữa các sao */
    font-size: 24px; /* Kích thước sao */
}
</style>
</head>
<body>

	<!--navbar -->
	<%@include file="Components/navbar.jsp"%>

	<div class="container mt-5">
		<%@include file="Components/alert_message.jsp"%>
		<div class="row border border-3">
			<div class="col-md-6">
				<div class="container-fluid text-end my-3">
					<img src="Product_imgs\<%= product.getProductImages()%>"
						class="card-img-top"
						style="max-width: 100%; max-height: 500px; width: auto;">
				</div>
			</div>
			<div class="col-md-6">
				<div class="container-fluid my-5">
					<h4><%= escapeHtml(product.getProductName())%></h4>
					<span class="fs-5"><b>Mô tả sản phẩm</b></span><br> <span><%=escapeHtml(product.getProductDescription())%></span><br>
					<span class="real-price"><%=decimalFormat.format(product.getProductPriceAfterDiscount())%>
						VND</span>&ensp; <span class="product-price"><%=decimalFormat.format(product.getProductPrice())%>
						VND</span>&ensp; <span class="product-discount"><%=product.getProductDiscount()%>&#37;off</span><br>
					<span class="fs-5"><b>Trạng thái </b></span> <span
						id="availability"> <%
 if (product.getProductQunatity() > 0) {
 	out.println("Có sẵn");
 } else {
 	out.println("Hết hàng");
 }
 %>
					</span><br> <span class="fs-5"><b>Danh mục</b></span> <span><%=escapeHtml(catDao.getCategoryName(product.getCategoryId()))%></span>
					<div>
						<span class="fs-5"><b>Màu sắc</b></span><br>
						<div class="color-options">
							<input type="radio" id="color1" name="color" value="red">
							<label for="color1">Đỏ</label>
							<input type="radio" id="color2" name="color" value="blue">
							<label for="color2">Xanh dương</label>
							<input type="radio" id="color3" name="color" value="green">
							<label for="color3">Xanh lá</label>
							<input type="radio" id="color4" name="color" value="black">
							<label for="color4">Đen</label>
						</div>
					</div>
					<div>
						<span class="fs-5"><b>Kích thước</b></span><br>
						<div class="size-options">
							<input type="radio" id="size36" name="size" value="36">
							<label for="size36">36</label>
							<input type="radio" id="size37" name="size" value="37">
							<label for="size37">37</label>
							<input type="radio" id="size38" name="size" value="38">
							<label for="size38">38</label>
							<input type="radio" id="size39" name="size" value="39">
							<label for="size39">39</label>
							<input type="radio" id="size40" name="size" value="40">
							<label for="size40">40</label>
							<input type="radio" id="size41" name="size" value="41">
							<label for="size41">41</label>
							<input type="radio" id="size42" name="size" value="42">
							<label for="size42">42</label>
							<input type="radio" id="size43" name="size" value="43">
							<label for="size43">43</label>
						</div>
					</div>
					<form method="post">
						<div class="container-fluid text-center mt-3">
							<%
							if (user == null) {
							%>
							<button type="button" onclick="window.open('login.jsp', '_self')"
								class="btn btn-primary text-white btn-lg">Thêm vào giỏ
								hàng</button>
							&emsp;
							<button type="button" onclick="window.open('login.jsp', '_self')"
								class="btn btn-info text-white btn-lg">Mua ngay</button>
							<%
							} else {
							%>
							<button type="submit"
								formaction="./AddToCartServlet?uid=<%=user.getUserId()%>&pid=<%=product.getProductId()%>"
								class="btn btn-primary text-white btn-lg">Thêm vào giỏ
								hàng</button>
							&emsp; <a href="checkout.jsp" id="buy-btn"
								class="btn btn-info text-white btn-lg" role="button"
								aria-disabled="true">Mua ngay</a>
							<%
							}
							%>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	
	<script>
		$(document)
				.ready(
						function() {
							if ($('#availability').text().trim() == "Currently Out of stock") {
								$('#availability').css('color', 'red');
								$('.btn').addClass('disabled');
							}
							$('#buy-btn')
									.click(
											function() {
	<%session.setAttribute("pid", productId);
session.setAttribute("from", "buy");%>
		});
						});
	</script>
</body>
</html>