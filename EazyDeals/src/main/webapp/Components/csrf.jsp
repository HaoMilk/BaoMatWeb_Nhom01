<%-- <%@ page import="com.eazydeals.util.CsrfTokenUtil" %>
<%

    CsrfTokenUtil.setToken(session);
    String csrfToken = (String) session.getAttribute("csrfToken");
%>
<input type="hidden" name="csrfToken" value="<%= csrfToken %>">
 --%>
 
 <%-- Components/csrf.jsp --%>
<%@ page import="com.eazydeals.util.CsrfTokenUtil" %>
<%
    CsrfTokenUtil.setToken(session);
%>
<input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">