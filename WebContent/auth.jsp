<%
	boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
	String defaultId = "0";

	if (!authenticated)
	{
		String loginMessage = "You have not been authorized to access the URL "+request.getRequestURL().toString();
    	session.setAttribute("customerId", defaultId);
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("login.jsp");
	}
%>
