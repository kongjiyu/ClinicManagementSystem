package servlet;

/**
 * Author: Yap Ern Tong
 * Patient Module
 */

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Patient;
import repositories.Patient.PatientRepository;

import java.io.IOException;

@WebServlet("/patient/detail")
public class PatientDetailServlet extends HttpServlet {
  @Inject
  private PatientRepository patientRepository;

  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String id = request.getParameter("id");
    Patient patient = patientRepository.findById(id);
    request.setAttribute("patient", patient);
    request.getRequestDispatcher("/views/patientDetail.jsp").forward(request, response);
  }
}
