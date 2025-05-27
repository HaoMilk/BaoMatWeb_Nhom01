<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.UserDao"%>
<%@page errorPage="error_exception.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.eazydeals.entities.OrderedProduct"%>
<%@page import="com.eazydeals.entities.Order"%>
<%@page import="java.util.List"%>
<%@page import="com.eazydeals.dao.OrderedProductDao"%>
<%@page import="com.eazydeals.dao.OrderDao"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page import="java.text.DecimalFormat"%>
<%
Admin activeAdmin = (Admin) session.getAttribute("activeAdmin");
if (activeAdmin == null) {
	Message message = new Message("You are not logged in! Login first!!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("adminlogin.jsp");
	return;
} 
DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
OrderDao orderDao = new OrderDao(ConnectionProvider.getConnection());
OrderedProductDao ordProdDao = new OrderedProductDao(ConnectionProvider.getConnection());
List<Order> orderList = orderDao.getAllOrder();
UserDao userDao = new UserDao(ConnectionProvider.getConnection()); 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Danh sách đơn hàng</title>
<%@include file="Components/common_css_js.jsp"%>
</head>
<body>
	<!--navbar -->
	<%@include file="Components/navbar.jsp"%>
 
	<!-- order details -->

	<div class="container-fluid px-3 py-3">
		<%
		if (orderList == null || orderList.size() == 0) {
		%>
		<div class="container mt-5 mb-5 text-center">
			<img src="Images/empty-cart.png" style="max-width: 200px;"
				class="img-fluid">
			<h4 class="mt-3">Zero Order found</h4>
		</div>
		<%
		} else {
		%>
		<div class="container-fluid">
			<table class="table table-hover">
				<tr class="table-primary" style="font-size: 18px;">
					<th class="text-center">Sản phẩm</th>
					<th>Mã đơn hàng</th>
					<th>Chii tiết sản phẩm</th>
					<th>Địa chỉ giao hàng</th>
					<th>Thời gian</th>
					<th>Kiểu thanh toán</th>
					<th>Trạng thái đơn hàng</th>
					<th colspan="2" class="text-center">Hành động</th>
				</tr>
				<%
				for (Order order : orderList) {
					List<OrderedProduct> ordProdList = ordProdDao.getAllOrderedProduct(order.getId());
					for (OrderedProduct orderProduct : ordProdList) {
				%>
				<form action="UpdateOrderServlet?oid=<%=order.getId()%>"
					method="post">
					
					<%@ include file="Components/csrf.jsp" %>
					
				<tr>
					<td class="text-center"><img
						src="Product_imgs/<%=orderProduct.getImage()%>"
						style="width: 50px; height: 50px; width: auto;"></td>
					<td><%=order.getOrderId()%></td>
					<td><%=orderProduct.getName()%><br>Quantity: <%=orderProduct.getQuantity()%><br>Total
						Price:<%=decimalFormat.format(orderProduct.getPrice() * orderProduct.getQuantity())%> VND</td>
					<td><%=userDao.getUserName(order.getUserId())%><br>Mobile No. <%=userDao.getUserPhone(order.getUserId())%><br><%=userDao.getUserAddress(order.getUserId())%></td>
					<td><%=order.getDate()%></td>
					<td><%=order.getPayementType()%></td>
					<td><%=order.getStatus()%></td>
					<td><select id="operation" name="status" class="form-select">
							<option>Chọn</option>
							<option value="Xác nhận đơn hàng">Xác nhận đơn hàng</option>
							<option value="Đã vận chuyển">Đã vận chuyển</option>
							<option value="Đang giao hàng">Đang giao hàng</option>
							<option value="Đã được giao">Đã được giao</option>
					</select></td>
					<td>
						<%
						if (order.getStatus().equals("Delivered")) {
						%>
						<button type="submit" class="btn btn-success disabled">Cập nhật</button>
						<%
						} else {
						%>
						<button type="submit" class="btn btn-secondary">Cập nhật</button> 
						<%
						 }
						 %>
					</td>
				</tr>
				</form>
				<%
				}
				}
				%>
			</table>

		</div>
		<%
		}
		%>
	</div>
</body>
</html>