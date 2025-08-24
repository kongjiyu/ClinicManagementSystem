package servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Patient;
import models.Staff;
import repositories.Patient.PatientRepository;
import repositories.Staff.StaffRepository;
import utils.ErrorResponse;

@Path("/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class AuthResource {

    @Inject
    private StaffRepository staffRepository;

    @Inject
    private PatientRepository patientRepository;

    private final Gson gson = new Gson();

    @POST
    @Path("/login")
    public Response login(String requestBody, @Context HttpServletRequest request) {
        try {
            JsonObject loginData = gson.fromJson(requestBody, JsonObject.class);
            String username = loginData.get("username").getAsString();
            String password = loginData.get("password").getAsString();
            String userType = loginData.get("userType").getAsString();
            boolean rememberMe = loginData.has("rememberMe") && loginData.get("rememberMe").getAsBoolean();

            JsonObject response = new JsonObject();

            if ("staff".equals(userType)) {
                // Authenticate staff
                Staff staff = authenticateStaff(username, password);
                if (staff != null) {
                    // Create session
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userType", "staff");
                    session.setAttribute("userId", staff.getStaffID());
                    session.setAttribute("userName", staff.getFirstName() + " " + staff.getLastName());
                    session.setAttribute("userRole", staff.getPosition());
                    
                    if (rememberMe) {
                        session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 days
                    } else {
                        session.setMaxInactiveInterval(8 * 60 * 60); // 8 hours
                    }

                    response.addProperty("success", true);
                    response.addProperty("userType", "staff");
                    response.addProperty("message", "Login successful");
                    response.addProperty("userName", staff.getFirstName() + " " + staff.getLastName());
                    response.addProperty("userRole", staff.getPosition());
                } else {
                    response.addProperty("success", false);
                    response.addProperty("message", "Invalid staff credentials");
                }
            } else if ("patient".equals(userType)) {
                // Authenticate patient
                Patient patient = authenticatePatient(username, password);
                if (patient != null) {
                    // Create session
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userType", "patient");
                    session.setAttribute("userId", patient.getPatientID());
                    session.setAttribute("userName", patient.getFirstName() + " " + patient.getLastName());
                    
                    if (rememberMe) {
                        session.setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 days
                    } else {
                        session.setMaxInactiveInterval(8 * 60 * 60); // 8 hours
                    }

                    response.addProperty("success", true);
                    response.addProperty("userType", "patient");
                    response.addProperty("message", "Login successful");
                    response.addProperty("userName", patient.getFirstName() + " " + patient.getLastName());
                } else {
                    response.addProperty("success", false);
                    response.addProperty("message", "Invalid patient credentials");
                }
            } else {
                response.addProperty("success", false);
                response.addProperty("message", "Invalid user type");
            }

            return Response.ok(gson.toJson(response)).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Login error: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/logout")
    public Response logout(@Context HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            JsonObject response = new JsonObject();
            response.addProperty("success", true);
            response.addProperty("message", "Logout successful");

            return Response.ok(gson.toJson(response)).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Logout error: " + e.getMessage()))
                .build();
        }
    }

    @GET
    @Path("/session")
    public Response getSession(@Context HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            JsonObject response = new JsonObject();

            if (session != null && session.getAttribute("userType") != null) {
                response.addProperty("authenticated", true);
                response.addProperty("userType", (String) session.getAttribute("userType"));
                response.addProperty("userId", (String) session.getAttribute("userId"));
                response.addProperty("userName", (String) session.getAttribute("userName"));
                
                String userRole = (String) session.getAttribute("userRole");
                if (userRole != null) {
                    response.addProperty("userRole", userRole);
                }
            } else {
                response.addProperty("authenticated", false);
            }

            return Response.ok(gson.toJson(response)).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Session error: " + e.getMessage()))
                .build();
        }
    }

    private Staff authenticateStaff(String username, String password) {
        try {
            // Find staff by staffID
            Staff staff = staffRepository.findById(username);
            if (staff != null && password.equals(staff.getPassword())) {
                return staff;
            }
            
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private Patient authenticatePatient(String username, String password) {
        try {
            // Find patient by studentID
            utils.List<Patient> allPatients = patientRepository.findAll();
            for (Patient patient : allPatients) {
                if (username.equals(patient.getStudentId()) && password.equals(patient.getPassword())) {
                    return patient;
                }
            }
            
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
