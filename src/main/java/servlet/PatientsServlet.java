package servlet;

import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Patient;
import jakarta.inject.Inject;
import repositories.Patient.PatientRepository;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/patients")
public class PatientsServlet extends HttpServlet {
  @Inject
  private PatientRepository repo;


  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException {

    List<Patient> patients = repo.findAll();
    response.setContentType("application/json");
    response.getWriter().write(new Gson().toJson(patients));
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
//    // Parse JSON from request body
//    Patient newPatient = new Gson().fromJson(request.getReader(), Patient.class);
//
//    // Validate basic fields
//    if (newPatient.getName() == null || newPatient.getGender() == null) {
//      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//      response.getWriter().write("{\"error\": \"Missing name or gender\"}");
//      return;
//    }
//
//    // Save patient
//    repo.create(newPatient);
//
//    // Respond with the created object as JSON
//    response.setContentType("application/json");
//    response.setStatus(HttpServletResponse.SC_CREATED);
//    response.getWriter().write(new Gson().toJson(newPatient));
  }
}
