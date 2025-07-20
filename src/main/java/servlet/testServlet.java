package servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Consultation;
import models.Patient;
import repositories.Patient.PatientRepository;
import utils.ArrayList;

import java.io.IOException;

@WebServlet("/test/output")
public class testServlet extends HttpServlet {
  @Inject
  PatientRepository patientRepository;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    ArrayList<Patient> patients = patientRepository.findAll();
    for (Patient patient : patients) {
      System.out.println(patient.getPatientID());
    }

  }
}
