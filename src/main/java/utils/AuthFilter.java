package utils;

/**
 * Author: Kong Ji Yu
 * 
 * Authentication Filter that protects:
 * - /views/* (JSP pages)
 * - /patient/* (Patient-related servlets)
 * - /api/* (API endpoints, except auth)
 * - /test/* (Test endpoints)
 * 
 * Ensures users must be logged in before accessing protected resources.
 */

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/views/*", "/patient/*", "/api/*", "/test/*"})
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
        
        // For API endpoints (except auth), require authentication
        if (requestURI.contains("/api/") && !requestURI.contains("/api/auth/")) {
            if (!isAuthenticated) {
                httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication required");
                return;
            }
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
            // For patient detail pages, ensure proper access control
            if (requestURI.contains("/patient/detail")) {
                // Staff can access any patient detail
                // Patients should only access their own details
                if ("patient".equals(userType)) {
                    // Get the patient ID from the URL parameter
                    String patientId = httpRequest.getParameter("id");
                    String sessionUserId = (String) session.getAttribute("userId");
                    
                    // If no patient ID in URL or no session user ID, deny access
                    if (patientId == null || sessionUserId == null) {
                        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Invalid request");
                        return;
                    }
                    
                    // Check if the patient is trying to access their own details
                    if (!patientId.equals(sessionUserId)) {
                        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: You can only view your own details");
                        return;
                    }
                }
            }
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
