<%@page import="com.eazydeals.dao.ProductDao"%>
<%@page import="com.eazydeals.entities.Product"%>
<%@page import="com.eazydeals.helper.ConnectionProvider"%>
<%@page errorPage="error_exception.jsp"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
ProductDao productDao = new ProductDao(ConnectionProvider.getConnection());
List<Product> productList = productDao.getAllLatestProducts();
List<Product> topDeals = productDao.getDiscountedProducts();
DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
%>
<!DOCTYPE html>
<html> 
<head>
<meta charset="UTF-8">
<title>Trang chủ</title>
<%@include file="Components/common_css_js.jsp"%>
<style type="text/css">
.cus-card {
	border-radius: 50%;
	border-color: transparent;
	max-height: 200px;
	max-width: 200px;
	max-height: 200px;
}

.real-price {
	font-size: 20px !important;
	font-weight: 600;
}

.product-price {
	font-size: 17px !important;
	text-decoration: line-through;
}

.product-discount {
	font-size: 15px !important;
	color: #027a3e;
}
</style>
</head>
<body>
	<!--navbar -->
	<%@include file="Components/navbar.jsp" %>

	<!-- Category list --> 
	<div class="container-fluid px-3 py-3"
		style="background-color: #e3f7fc;">
		<div class="row">
			<div class="card-group">
				<%
				for (Category c : categoryList) {
				%>
				<div class="col text-center">
					<a href="products.jsp?category=<%=c.getCategoryId()%>"
						style="text-decoration: none;">
						<div class="card cus-card h-100">
							<div class="container text-center">
								<img src="Product_imgs/<%=c.getCategoryImage()%>" class="mt-3 "
									style="max-width: 100%; max-height: 100px; width: auto; height: auto;">
							</div>
							<h6><%=c.getCategoryName()%></h6>
						</div>
					</a>
				</div>

				<%
				}
				%>
			</div>
		</div>
	</div>
	<!-- end of list -->

	<!-- Carousel -->
	<div id="carouselAutoplaying"
		class="carousel slide carousel-dark mt-3 mb-3" data-bs-ride="carousel">
		<div class="carousel-inner">
			<div class="carousel-item active">
				<img src="Images/scroll_img1.png" class="d-block w-100" alt="...">
			</div>
		</div>
	</div>
	<!-- end of carousel -->

	<!-- latest product listed -->
	<div class="container-fluid py-3 px-3" style="background: #f2f2f2;">
		<div class="row row-cols-1 row-cols-md-4 g-3">
			<div class="col">
				<div class="container text-center px-5 py-5">
					<h1>Những sản phẩm mới nhất</h1>
					<img src="Images/shoes.jpg" class="card-img-top"
						style="max-width: 100%; max-height: 200px; width: auto;">
				</div>
			</div>
			<%
			for (int i = 0; i < Math.min(3, productList.size()); i++) {
			%>
			<div class="col">
				<a href="viewProduct.jsp?pid=<%=productList.get(i).getProductId()%>"
					style="text-decoration: none;">
					<div class="card h-100">
						<div class="container text-center">
							<img
								src="Product_imgs/<%=productList.get(i).getProductImages()%>"
								class="card-img-top m-2"
								style="max-width: 100%; max-height: 200px; width: auto;">
						</div>
						<div class="card-body">
							<h5 class="card-title text-center"><%=productList.get(i).getProductName()%></h5>

							<div class="container text-center">
								<span class="real-price"><%=decimalFormat.format(productList.get(i).getProductPriceAfterDiscount())%> VND</span>
								&ensp;<span class="product-price"><%=decimalFormat.format(productList.get(i).getProductPrice())%> VND
								</span>&ensp;<span class="product-discount"><%=productList.get(i).getProductDiscount()%>&#37;
									off</span>
							</div>
						</div>
					</div>
				</a>
			</div>

			<%
			}
			%>
		</div>
	</div>
	<!-- end of list -->

	<!-- confirmation message for successful order -->
	<%
	String order = (String) session.getAttribute("order");
	if (order != null) {
	%>
	<script type="text/javascript">
		console.log("testing..4...");
		Swal.fire({
		  icon : 'success',
		  title: 'Đặt hàng thành công, Cảm ơn !',
		  text: 'Confirmation will be sent to <%=user.getUserEmail()%>',
		  width: 600,
		  padding: '3em',
		  showConfirmButton : false,
		  timer : 3500,
		  backdrop: `
		    rgba(0,0,123,0.4)
		  `
		});
	</script>
	<%
	}
	session.removeAttribute("order");
	%>
	<!-- end of message -->
	
</body>
</html>