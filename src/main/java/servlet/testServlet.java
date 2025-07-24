package servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;
import repositories.Medicine.MedicineRepository;
import repositories.Order.OrderRepository;
import models.Consultation;
import models.Patient;
import repositories.Consultation.ConsultationRepository;
import repositories.Patient.PatientRepository;
import repositories.Supplier.SupplierRepository;
import utils.ArrayList;

import java.io.IOException;

@WebServlet("/test/output")
public class testServlet extends HttpServlet {
  @Inject
  PatientRepository patientRepository;
  @Inject
  SupplierRepository supplierRepository;
  @Inject
  OrderRepository orderRepository;
  @Inject
  MedicineRepository medicineRepository;
  @Inject
  ConsultationRepository consultationRepository;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String id = req.getParameter("id"); // Fetch "id" from request
    ArrayList<Consultation> consultations = consultationRepository.findHistory(id); // Now pass the actual value


    if (consultations.isEmpty()) {
      System.out.println("No consultations found for patient ID: " + id);
      return;
    }
    for (Consultation consultation : consultations) {
      System.out.println(consultation.getConsultationID());
    }
  }
}
