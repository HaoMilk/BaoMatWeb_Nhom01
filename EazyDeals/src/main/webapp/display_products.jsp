<%@page import="com.eazydeals.entities.Message"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@page errorPage="error_exception.jsp"%>
<%@page import="com.eazydeals.dao.UserDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%
Admin activeAdmin = (Admin) session.getAttribute("activeAdmin");
if (activeAdmin == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("adminlogin.jsp");
	return;
}
DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
UserDao userDao = new UserDao(ConnectionProvider.getConnection());
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
%>
<!DOCTYPE html>
<html> 
<head>
<meta charset="UTF-8">
<title>Danh sách sản phẩm</title> 
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>
	<!--navbar -->
	<%@include file="Components/navbar.jsp"%>
 
	<!-- update product -->
	<div class="container mt-3">
		<%@include file="Components/alert_message.jsp"%>
		<table class="table table-hover">
			<tr class="table-primary text-center" style="font-size: 20px;">
				<th>Hình ảnh</th>
				<th>Tên sản phẩm</th>
				<th class="text-start">Danh mục</th>
				<th>Giá tiền</th>
				<th class="text-start">Số lượng</th>
				<th class="text-start">Giảm giá</th>
				<th>Hành động</th>
			</tr>
			<%
			List<Product> productList = productDao.getAllProducts();
			for (Product prod : productList) {
				String category = catDao.getCategoryName(prod.getCategoryId());
			%>
			<tr class="text-center">
				<td><img src="Product_imgs\<%=prod.getProductImages()%>"
					style="width: 60px; height: 60px; width: auto;"></td>
				<td class="text-start"><%=prod.getProductName()%></td>
				<td><%=category%></td>
				<td><%= decimalFormat.format(prod.getProductPriceAfterDiscount())%> VND</td>
				<td><%=prod.getProductQunatity()%></td>
				<td><%=prod.getProductDiscount()%>%</td>
				<td><a href="update_product.jsp?pid=<%=prod.getProductId()%>" role="button" class="btn btn-secondary">Sửa</a>&emsp;<a
					href="AddOperationServlet?pid=<%=prod.getProductId()%>&operation=deleteProduct"
					class="btn btn-danger" role="button">Xóa</a></td>
			</tr>
			<%
			}
			%>
		</table>
	</div>
</body>
</html>

