<%@page import="com.eazydeals.entities.Message"%>
<%@page import="com.eazydeals.dao.ProductDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.eazydeals.dao.CartDao"%>
<%@page errorPage="error_exception.jsp"%>
<%@page import="java.text.DecimalFormat"%>
<%
User activeUser = (User) session.getAttribute("activeUser");
if (activeUser == null) {
	Message message = new Message("Bạn chưa đăng nhập, đăng nhập trước!", "error", "alert-danger");
	session.setAttribute("message", message);
	response.sendRedirect("login.jsp");
	return;  
} 
DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
String from = (String)session.getAttribute("from");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thanh toán</title>
<%@include file="Components/common_css_js.jsp"%>
</head> 
<body>
	<!--navbar -->
	<%@include file="Components/navbar.jsp"%>

	<div class="container mt-5" style="font-size: 17px;">
		<div class="row">

			<!-- left column -->
			<div class="col-md-8">
				<div class="card">
					<div class="container px-3 py-3">
						<div class="card">
							<div class="container-fluid text-white"
								style="background-color: #389aeb;">
								<h4>Địa chỉ giao hàng</h4>
							</div>
						</div>
						<div class="mt-3 mb-3">
							<h5><%=user.getUserName()%>
								&nbsp;
								<%=user.getUserPhone()%></h5>
							<%
							StringBuilder str = new StringBuilder();
							str.append(user.getUserAddress() + ", ");
							str.append(user.getUserCity() + ", ");
							str.append(user.getUserCity() + ", ");
							str.append(user.getUserPincode());
							out.println(str);
							%>
							<br>
							<div class="text-end">
								<button type="button" class="btn btn-outline-primary"
									data-bs-toggle="modal" data-bs-target="#exampleModal">
									Đổi địa chỉ</button>
							</div>
						</div>
						<hr>
						<div class="card">
							<div class="container-fluid text-white"
								style="background-color: #389aeb;">
								<h4>Phương thức thanh toán</h4>
							</div>
						</div>
						<form action="OrderOperationServlet" method="post">
							<div class="form-check mt-2">
								<input class="form-check-input" type="radio" name="payementMode"
									value="Card Payment" required><label class="form-check-label">Credit
									/Debit /ATM card</label><br>
								<div class="mb-3">

									<input class="form-control mt-3" type="number"
										placeholder="Nhập số thẻ" name="cardno">
									<div class="row gx-5">
										<div class="col mt-3">
											<input class="form-control" type="number"
												placeholder="Nhập mã CVV" name="cvv">
										</div>
										<div class="col mt-3">
											<input class="form-control" type="text"
												placeholder="Nhập hạn sử dụng thẻ'">
										</div>
									</div>
									<input class="form-control mt-3" type="text"
										placeholder="Nhập tên" name="name">
								</div>
								<input class="form-check-input" type="radio" name="payementMode"
									value="COD"><label
									class="form-check-label">Thanh toán khi nhận hàng</label>
							</div>
							<div class="text-end">
								<button type="submit"
									class="btn btn-lg btn-outline-primary mt-3">Đặt hàng</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<!-- end of column -->

			<!-- right column -->
			<div class="col-md-4">
				<div class="card">
					<div class="container px-3 py-3">
						<h4>Chi tiết</h4>
						<hr>
						<%
						if (from.trim().equals("cart")) {
							CartDao cartDao = new CartDao(ConnectionProvider.getConnection());
							int totalProduct = cartDao.getCartCountByUserId(user.getUserId());
							float totalPrice = (float) session.getAttribute("totalPrice");
						%>
						<table class="table table-borderless">
							<tr>
								<td>Số lượng sản phẩm</td>
								<td><%=totalProduct%></td>
							</tr>
							<tr>
								<td>Tổng tiền hàng</td>
								<td><%=decimalFormat.format(totalPrice)%> VND</td>
							</tr>
							<tr>
								<td>Phí vận chuyển</td>
								<td>40 VND</td>
							</tr>
							<tr>
								<td>Phí đóng gói</td>
								<td>29 VND</td>
							</tr>
							<tr>
								<td><h5>Tổng tiền</h5></td>
								<td><h5>
										
										<%=decimalFormat.format(totalPrice + 69)%> VND</h5></td>
							</tr>
						</table>
						<%
						} else {
							ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
							int pid = (int) session.getAttribute("pid");
							float price = productDao.getProductPriceById(pid);
						%>
						<table class="table table-borderless">
							<tr>
								<td>Số lượng sản phẩm</td>
								<td>1</td>
							</tr>
							<tr>
								<td>Tổng tiền hàng</td>
								<td><%=decimalFormat.format(price)%> VND</td>
							</tr>
							<tr>
								<td>Phí vận chuyển</td>
								<td>40 VND</td>
							</tr>
							<tr>
								<td>Phí đóng gói</td>
								<td>29 VND</td>
							</tr>
							<tr>
								<td><h5>Tổng tiền</h5></td>
								<td><h5>
									
										<%=decimalFormat.format(price + 69)%> VND</h5></td>
							</tr>
						</table>
						<%
						}
						%>
					</div>
				</div>
			</div>
			<!-- end of column -->
		</div>
	</div>


	<!--Change Address Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="exampleModalLabel">Đổi địa chỉ nhận hàng</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="UpdateUserServlet" method="post">
					<input type="hidden" name="operation" value="changeAddress">
					<div class="modal-body mx-3">
						<div class="mt-2">
							<label class="form-label fw-bold">Địa chỉ nhận hàng</label>
							<textarea name="user_address" rows="3"
								placeholder="Nhập địa chỉ"
								class="form-control" required></textarea>
						</div>
						<div class="mt-2">
							<label class="form-label fw-bold">Thành phố</label> <input
								class="form-control" type="text" name="city"
								placeholder="Nhập thành phố" required>
						</div>
						<div class="mt-2">
							<label class="form-label fw-bold">Mã PIN quốc gia</label> <input
								class="form-control" type="number" name="pincode"
								placeholder="Nhập mã PIN quốc gia(Việt Nam 84000)" maxlength="6" required>
						</div>
						<div class="mt-2">
							<label class="form-label">Quốc gia</label> 
									<input type="text" name="state" class="form-control" placeholder="Nhập quốc gia" required>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Đóng</button>
						<button type="submit" class="btn btn-primary">Lưu</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- end modal -->

</body>
</html>