package repositories.Consultation;

import models.Consultation;
import utils.List;
import utils.MultiMap;

public interface ConsultationRepository {
    List<Consultation> getAvailableSlots();
    MultiMap<String, Consultation> groupByAvailability();
    Consultation create(Consultation consultation);
    Consultation update(String id, Consultation consultation);
    boolean reschedule(String id, Consultation consultation);
    boolean cancel(String id);
    List<Consultation> getUpcoming();
    boolean checkInPatient(String id);
    List<Consultation> findHistory(String id);
    boolean storeConsultationData(String id, Consultation consultation);
    List<Consultation> findAll();
    MultiMap<String, Consultation> groupByPatientID();
    Consultation findById(String id);
  }
