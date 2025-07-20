package repositories.Consultation;

import models.Consultation;
import utils.ArrayList;
import utils.MultiMap;

import java.util.List;

public interface ConsultationRepository {
    List<Consultation> getAvailableSlots();
    Consultation create(Consultation consultation);
    Consultation update(String id, Consultation consultation);
    boolean reschedule(String id, Consultation consultation);
    boolean cancel(String id);
    List<Consultation> getUpcoming();
    boolean checkInPatient(String id);
    List<Consultation> findHistory(String id);
    boolean storeConsultationData(String id, Consultation consultation);
    ArrayList<Consultation> findAll();
}
