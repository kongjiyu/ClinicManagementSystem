package utils;

/**
 * Author: Kong Ji Yu
 */

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/views/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Allow access to login page and static resources
        if (requestURI.endsWith("login.jsp") || 
            requestURI.contains("/static/") ||
            requestURI.contains("/api/auth/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is authenticated
        HttpSession session = httpRequest.getSession(false);
        boolean isAuthenticated = session != null && session.getAttribute("userType") != null;
        
        if (!isAuthenticated) {
            // Redirect to login page
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        
        // Check role-based access
        String userType = (String) session.getAttribute("userType");
        
        // Admin/Staff pages
        if (requestURI.contains("admin") || 
            requestURI.contains("staff") || 
            requestURI.contains("reports") ||
            requestURI.contains("order") ||
            requestURI.contains("medicine") ||
            requestURI.contains("consultation") ||
            requestURI.contains("invoice") ||
            requestURI.contains("schedule") ||
            (requestURI.contains("Queue") && !requestURI.contains("userQueue"))) {
            
            if (!"staff".equals(userType)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
        }
        
        // Patient/User pages
        if (requestURI.contains("user") || requestURI.contains("patient")) {
            // Both staff and patients can access these pages
            // Staff can access for administrative purposes
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
