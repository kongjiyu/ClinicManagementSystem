package repositories.Prescription;

import models.Prescription;
import utils.ArrayList;
import utils.MultiMap;

import java.nio.channels.MulticastChannel;
import utils.ArrayList;

import java.util.List;

public interface PrescriptionRepository {
  void save(Prescription prescription);
  Prescription findById(String id);
  ArrayList<Prescription> findAll();
  ArrayList<Prescription> findByPatientId(String patientId);
  ArrayList<Prescription> findByMedicineId(String medicineId);
  ArrayList<Prescription> findByConsultationId(String consultationId);
  MultiMap<String, Prescription> groupByMedicineId();
  MultiMap<String, Prescription> groupByConsultationId();
  MultiMap<String, Prescription> groupByPatientId();
  void update(Prescription prescription);
  void delete(String id);

  ArrayList<Prescription> findHistory(String id);
  ArrayList<Prescription> findPrescriptionsByPatientId(String patientId);

}
