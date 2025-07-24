package servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.*;
import repositories.Appointment.AppointmentRepository;
import repositories.Bill.BillRepository;
import repositories.Consultation.ConsultationRepository;
import repositories.Patient.PatientRepository;
import repositories.Prescription.PrescriptionRepository;
import utils.ArrayList;

import java.io.IOException;

@WebServlet("/test/output")
public class testServlet extends HttpServlet {
  @Inject
  PatientRepository patientRepository;

  @Inject
  PrescriptionRepository prescriptionRepository;

  @Inject
  AppointmentRepository appointmentRepository;

  @Inject
  BillRepository billRepository;



  //appointment
//  @Override
//  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//    ArrayList<Appointment> patients = appointmentRepository.findAll();
//    for (Appointment appointment: patients) {
//      System.out.println(appointment.getPatientID());
//    }

//  @Override
//  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//    ArrayList<Patient> patients = patientRepository.findAll();
//    for (Patient patient : patients) {
//      System.out.println(patient.getPatientID());
//    }

  //bill
//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//      ArrayList<Bill> consultation = billRepository.findAll();
//      for (Bill bill: consultation) {
//        System.out.println(bill.getBillID());
//      }

//
   //consultation> prescription
//  @Override
//  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//    ArrayList<Prescription> consultations = prescriptionRepository.findAll();
//    for (Prescription prescription : consultations) {
//      System.out.println(prescription.getConsultationID());
//      }
//    }

  //patient > prescription
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    ArrayList<Prescription> patient = prescriptionRepository.findAll();
    for (Prescription prescription : patient) {
      System.out.println(prescription.getPatientID());
    }

    //medicine > prescription
//  @Override
//  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//    ArrayList<Prescription> medicine = prescriptionRepository.findAll();
//    for (Prescription prescription :  medicine) {
//      System.out.println(prescription.getMedicineID());
//    }
//  }
  }
}
