package servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;
import repositories.Consultation.ConsultationRepository;
import repositories.Medicine.MedicineRepository;
import repositories.Order.OrderRepository;
import repositories.Patient.PatientRepository;
import repositories.Supplier.SupplierRepository;


import java.io.IOException;

@WebServlet("/test/output")
public class testServlet extends HttpServlet {
  @Inject
  ScheduleRepository scheduleRepository;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{

  }

}