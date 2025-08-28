package servlet;

/**
 * Author: Anny Wong Ann Nee
 * Pharmacy Module
 */

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Bill;
import models.Patient;
import models.Consultation;
import models.Staff;
import models.Prescription;
import models.Medicine;
import models.Treatment;
import repositories.Bill.BillRepository;
import repositories.Patient.PatientRepository;
import repositories.Consultation.ConsultationRepository;
import repositories.Staff.StaffRepository;
import repositories.Prescription.PrescriptionRepository;
import repositories.Medicine.MedicineRepository;
import repositories.Treatment.TreatmentRepository;
import utils.ErrorResponse;
import utils.List;
import utils.ListAdapter;
import DTO.BillWithPatientDTO;
import DTO.BillItem;
import DTO.PaymentMethodRequest;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Path("/bills")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Transactional
public class InvoiceResource {

    Gson gson = new GsonBuilder()
            .registerTypeAdapter(java.time.LocalDate.class, new utils.LocalDateAdapter())
            .registerTypeAdapter(java.time.LocalDateTime.class, new utils.LocalDateTimeAdapter())
            .registerTypeAdapter(java.time.LocalTime.class, new utils.LocalTimeAdapter())
            .registerTypeAdapter(utils.List.class, new ListAdapter())
            .create();

    @Inject
    private BillRepository billRepo;

    @Inject
    private PatientRepository patientRepo;

    @Inject
    private ConsultationRepository consultationRepo;

    @Inject
    private StaffRepository staffRepo;

    @Inject
    private PrescriptionRepository prescriptionRepo;

    @Inject
    private MedicineRepository medicineRepo;

    @Inject
    private TreatmentRepository treatmentRepository;

    @POST
    public Response createBill(Bill bill) {
        try {
            billRepo.create(bill);
            String json = gson.toJson(bill);
            return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error creating bill: " + e.getMessage()))
                    .build();
        }
    }

    @POST
    @Path("/from-consultation/{consultationId}")
    public Response createBillFromConsultation(@PathParam("consultationId") String consultationId) {
        try {
            // Find the consultation
            Consultation consultation = consultationRepo.findById(consultationId);
            if (consultation == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Consultation not found"))
                        .build();
            }

            // Check if consultation already has a bill
            if (consultation.getBillID() != null && !consultation.getBillID().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(new ErrorResponse("Consultation already has a bill"))
                        .build();
            }

            // Calculate total amount from prescriptions
            double totalAmount = calculateConsultationTotal(consultationId);

            // Create the bill
            Bill bill = new Bill();
            bill.setTotalAmount(totalAmount);
            bill.setPaymentMethod(null); // Leave payment method blank initially

            // Save the bill (ID will be generated automatically)
            billRepo.create(bill);

            // Update consultation with the generated bill ID
            consultation.setBillID(bill.getBillID());
            consultationRepo.update(consultationId, consultation);

            // Return the created bill with patient information (using the consultation we already have)
            BillWithPatientDTO dto = convertToDTOWithPatientNameFromConsultation(bill, consultation);
            String json = gson.toJson(dto);
            return Response.status(Response.Status.CREATED).entity(json).type(MediaType.APPLICATION_JSON).build();

        } catch (Exception e) {
            e.printStackTrace(); // Add stack trace for debugging
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error creating bill from consultation: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    public Response getAllBills() {
        try {
            List<Bill> bills = billRepo.findAll();
            List<BillWithPatientDTO> dtos = convertToDTOWithPatientNames(bills);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching bills: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/{id}")
    public Response getBillById(@PathParam("id") String id) {
        try {
            Bill bill = billRepo.findById(id);
            if (bill != null) {
                BillWithPatientDTO dto = convertToDTOWithPatientName(bill);
                String json = gson.toJson(dto);
                return Response.ok(json, MediaType.APPLICATION_JSON).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Bill not found"))
                        .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching bill: " + e.getMessage()))
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response updateBill(@PathParam("id") String id, Bill bill) {
        try {
            Bill existingBill = billRepo.findById(id);
            if (existingBill == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Bill not found"))
                        .build();
            }

            bill.setBillID(id); // Ensure the ID is set correctly
            billRepo.update(bill);
            String json = gson.toJson(bill);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error updating bill: " + e.getMessage()))
                    .build();
        }
    }

    @PUT
    @Path("/{id}/payment-method")
    public Response updatePaymentMethod(@PathParam("id") String id, PaymentMethodRequest request) {
        try {
            Bill existingBill = billRepo.findById(id);
            if (existingBill == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Bill not found"))
                        .build();
            }

            if (request.getPaymentMethod() == null || request.getPaymentMethod().trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(new ErrorResponse("Payment method is required"))
                        .build();
            }

            existingBill.setPaymentMethod(request.getPaymentMethod());
            billRepo.update(existingBill);
            
            String json = gson.toJson(existingBill);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error updating payment method: " + e.getMessage()))
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteBill(@PathParam("id") String id) {
        try {
            Bill existingBill = billRepo.findById(id);
            if (existingBill == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Bill not found"))
                        .build();
            }

            billRepo.delete(id);
            return Response.ok("{\"message\": \"Bill deleted successfully\"}")
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error deleting bill: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/by-patient/{patientId}")
    public Response getBillsByPatient(@PathParam("patientId") String patientId) {
        try {
            List<Bill> bills = billRepo.findByPatientId(patientId);
            List<BillWithPatientDTO> dtos = convertToDTOWithPatientNames(bills);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error fetching patient bills: " + e.getMessage()))
                    .build();
        }
    }



    @GET
    @Path("/by-date/{date}")
    public Response getBillsByDate(@PathParam("date") String dateStr) {
        try {
            LocalDate date = LocalDate.parse(dateStr);
            List<Bill> bills = billRepo.findByDate(date);
            List<BillWithPatientDTO> dtos = convertToDTOWithPatientNames(bills);
            String json = gson.toJson(dtos);
            return Response.ok(json, MediaType.APPLICATION_JSON).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Error fetching bills by date: " + e.getMessage()))
                    .build();
        }
    }

    @GET
    @Path("/{id}/pdf")
    @Produces(MediaType.TEXT_HTML)
    public Response generatePDF(@PathParam("id") String id) {
        try {
            Bill bill = billRepo.findById(id);
            if (bill == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("Bill not found"))
                        .build();
            }

            BillWithPatientDTO dto = convertToDTOWithPatientName(bill);

            // Generate HTML content for PDF
            String htmlContent = generateInvoiceHTML(dto);

            return Response.ok(htmlContent, MediaType.TEXT_HTML)
                    .header("Content-Disposition", "attachment; filename=\"invoice-" + id + ".html\"")
                    .build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Error generating PDF: " + e.getMessage()))
                    .build();
        }
    }

    private String generateInvoiceHTML(BillWithPatientDTO bill) {
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html><head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>Invoice ").append(bill.getBillID()).append("</title>");
        html.append("<style>");
        html.append("@media print {");
        html.append("  body { margin: 0; padding: 20px; }");
        html.append("  .no-print { display: none; }");
        html.append("}");
        html.append("body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }");
        html.append(".header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 20px; }");
        html.append(".section { margin-bottom: 25px; }");
        html.append(".section h3 { border-bottom: 1px solid #ccc; padding-bottom: 5px; color: #333; }");
        html.append("table { width: 100%; border-collapse: collapse; margin-top: 10px; }");
        html.append("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
        html.append("th { background-color: #f8f9fa; font-weight: bold; }");
        html.append(".total { text-align: right; font-size: 18px; font-weight: bold; margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px; }");
        html.append(".info-table { width: 100%; margin-bottom: 20px; }");
        html.append(".info-table td { border: none; padding: 8px 0; }");
        html.append(".info-table td:first-child { font-weight: bold; width: 150px; }");
        html.append(".print-btn { position: fixed; top: 20px; right: 20px; padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; z-index: 1000; }");
        html.append("</style>");
        html.append("</head><body>");

        // Print button
        html.append("<button class='print-btn no-print' onclick='window.print()'>Print PDF</button>");

        // Header
        html.append("<div class='header'>");
        html.append("<h1>MEDICAL INVOICE</h1>");
        html.append("<p><strong>Invoice #:</strong> ").append(bill.getBillID()).append("</p>");
        html.append("<p><strong>Date:</strong> ").append(bill.getConsultationDate() != null ? bill.getConsultationDate().toString() : "N/A").append("</p>");
        html.append("</div>");

        // Patient Information
        html.append("<div class='section'>");
        html.append("<h3>Patient Information</h3>");
        html.append("<table class='info-table'>");
        html.append("<tr><td>Name:</td><td>").append(bill.getPatientName()).append("</td></tr>");
        html.append("<tr><td>Contact:</td><td>").append(bill.getPatientContact()).append("</td></tr>");
        html.append("<tr><td>Email:</td><td>").append(bill.getPatientEmail()).append("</td></tr>");
        html.append("</table>");
        html.append("</div>");

        // Consultation Information
        html.append("<div class='section'>");
        html.append("<h3>Consultation Information</h3>");
        html.append("<table class='info-table'>");
        html.append("<tr><td>Consultation ID:</td><td>").append(bill.getConsultationID()).append("</td></tr>");
        html.append("<tr><td>Doctor:</td><td>").append(bill.getDoctorName()).append("</td></tr>");
        html.append("<tr><td>Date:</td><td>").append(bill.getConsultationDate() != null ? bill.getConsultationDate().toString() : "N/A").append("</td></tr>");
        html.append("<tr><td>Payment Method:</td><td>").append(bill.getPaymentMethod()).append("</td></tr>");
        html.append("</table>");
        html.append("</div>");

        // Bill Items
        html.append("<div class='section'>");
        html.append("<h3>Bill Items</h3>");
        html.append("<table>");
        html.append("<thead><tr><th>Item</th><th>Description</th><th>Quantity</th><th>Unit Price</th><th>Total</th></tr></thead>");
        html.append("<tbody>");

        if (bill.getBillItems() != null) {
            for (BillItem item : bill.getBillItems()) {
                html.append("<tr>");
                html.append("<td>").append(item.getItemName()).append("</td>");
                html.append("<td>").append(item.getDescription()).append("</td>");
                html.append("<td>").append(item.getQuantity()).append("</td>");
                html.append("<td>RM ").append(String.format("%.2f", item.getUnitPrice())).append("</td>");
                html.append("<td>RM ").append(String.format("%.2f", item.getTotalPrice())).append("</td>");
                html.append("</tr>");
            }
        }

        html.append("</tbody></table>");
        html.append("</div>");

        // Total
        html.append("<div class='total'>");
        html.append("<p>Total Amount: RM ").append(String.format("%.2f", bill.getTotalAmount())).append("</p>");
        html.append("</div>");

        html.append("</body></html>");

        return html.toString();
    }

    // Helper method to convert Bill to DTO with patient information
    private List<BillWithPatientDTO> convertToDTOWithPatientNames(List<Bill> bills) {
        List<BillWithPatientDTO> dtos = new List<>();
        for (Bill bill : bills) {
            dtos.add(convertToDTOWithPatientName(bill));
        }
        return dtos;
    }

    private BillWithPatientDTO convertToDTOWithPatientName(Bill bill) {
        // Find consultation that references this bill
        Consultation consultation = consultationRepo.findByBillId(bill.getBillID());

        if (consultation == null) {
            // If no consultation found, return basic bill info
            return new BillWithPatientDTO(
                bill.getBillID(),
                null,
                null,
                "Unknown Patient",
                "",
                "",
                null,
                "",
                null,
                bill.getTotalAmount(),
                bill.getPaymentMethod(),
                new List<>()
            );
        }

        return convertToDTOWithPatientNameFromConsultation(bill, consultation);
    }

    private BillWithPatientDTO convertToDTOWithPatientNameFromConsultation(Bill bill, Consultation consultation) {
        // Get patient information
        Patient patient = null;
        if (consultation.getPatientID() != null && !consultation.getPatientID().isEmpty()) {
            patient = patientRepo.findById(consultation.getPatientID());
        }
        String patientName = patient != null ?
            patient.getFirstName() + " " + patient.getLastName() :
            "Unknown Patient";
        String patientContact = patient != null ? patient.getContactNumber() : "";
        String patientEmail = patient != null ? patient.getEmail() : "";

        // Get doctor information
        Staff doctor = null;
        if (consultation.getDoctorID() != null && !consultation.getDoctorID().isEmpty()) {
            doctor = staffRepo.findById(consultation.getDoctorID());
        }
        String doctorName = doctor != null ?
            doctor.getFirstName() + " " + doctor.getLastName() :
            "Unknown Doctor";

        // Calculate bill items from prescriptions
        List<BillItem> billItems = calculateBillItems(consultation.getConsultationID());
        double calculatedTotal = calculateTotalAmount(billItems);

        return new BillWithPatientDTO(
            bill.getBillID(),
            consultation.getConsultationID(),
            consultation.getPatientID(),
            patientName,
            patientContact,
            patientEmail,
            consultation.getDoctorID(),
            doctorName,
            consultation.getConsultationDate(),
            calculatedTotal, // Use calculated total instead of stored total
            bill.getPaymentMethod(),
            billItems
        );
    }





    // Helper method to calculate bill items from prescriptions and treatments
    private List<BillItem> calculateBillItems(String consultationId) {
        List<BillItem> billItems = new List<>();
        double totalAmount = 0.0;

        // Add consultation fee (fixed at RM 50.00)
        double consultationFee = 50.0;
        billItems.add(new BillItem(
            "Consultation Fee",
            "Medical consultation service",
            1,
            consultationFee,
            consultationFee,
            null,
            null
        ));
        totalAmount += consultationFee;

        // Get prescriptions for this consultation
        List<Prescription> prescriptions = prescriptionRepo.findByConsultationId(consultationId);

        for (Prescription prescription : prescriptions) {
            // Get medicine information
            Medicine medicine = medicineRepo.findById(prescription.getMedicineID());
            String medicineName = medicine != null ? medicine.getMedicineName() : "Unknown Medicine";

            // Calculate prescription total (price * quantity dispensed)
            double prescriptionTotal = prescription.getPrice() * prescription.getQuantityDispensed();

            BillItem item = new BillItem(
                medicineName,
                prescription.getDescription(),
                prescription.getQuantityDispensed(),
                prescription.getPrice(),
                prescriptionTotal,
                prescription.getMedicineID(),
                prescription.getDosageUnit()
            );

            billItems.add(item);
            totalAmount += prescriptionTotal;
        }

        // Get treatments for this consultation and add them to bill items
        try {
            List<Treatment> treatments = treatmentRepository.findByConsultationId(consultationId);
            for (Treatment treatment : treatments) {
                if (treatment.getPrice() > 0) {
                    BillItem treatmentItem = new BillItem(
                        treatment.getTreatmentName(),
                        treatment.getDescription() + " (" + treatment.getTreatmentType() + ")",
                        1,
                        treatment.getPrice(),
                        treatment.getPrice(),
                        null,
                        null
                    );
                    billItems.add(treatmentItem);
                    totalAmount += treatment.getPrice();
                }
            }
        } catch (Exception e) {
            // If treatment repository is not available, continue without treatment items
            System.out.println("Warning: Could not fetch treatment items: " + e.getMessage());
        }

        return billItems;
    }

    // Helper method to calculate total amount
    private double calculateTotalAmount(List<BillItem> billItems) {
        double total = 0.0;
        for (BillItem item : billItems) {
            total += item.getTotalPrice();
        }
        return total;
    }

    // Helper method to calculate consultation total from prescriptions and treatments
    private double calculateConsultationTotal(String consultationId) {
        double total = 50.0; // Base consultation fee

        // Get prescriptions for this consultation
        List<Prescription> prescriptions = prescriptionRepo.findByConsultationId(consultationId);

        for (Prescription prescription : prescriptions) {
            // Calculate prescription total (price * quantity dispensed)
            double prescriptionTotal = prescription.getPrice() * prescription.getQuantityDispensed();
            total += prescriptionTotal;
        }

        // Get treatments for this consultation and add their costs
        try {
            List<Treatment> treatments = treatmentRepository.findByConsultationId(consultationId);
            for (Treatment treatment : treatments) {
                if (treatment.getPrice() > 0) {
                    total += treatment.getPrice();
                }
            }
        } catch (Exception e) {
            // If treatment repository is not available, continue without treatment costs
            System.out.println("Warning: Could not fetch treatment costs: " + e.getMessage());
        }

        return total;
    }


}
