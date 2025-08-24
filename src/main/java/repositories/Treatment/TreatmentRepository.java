package repositories.Treatment;

import models.Treatment;
import utils.List;
import utils.MultiMap;

public interface TreatmentRepository {
    void create(Treatment treatment);
    Treatment findById(String id);
    List<Treatment> findAll();
    void update(Treatment treatment);
    void delete(Treatment treatment);
    
    // Additional methods for treatment management
    List<Treatment> findByPatientId(String patientId);
    List<Treatment> findByDoctorId(String doctorId);
    List<Treatment> findByStatus(String status);
    List<Treatment> findByTreatmentType(String treatmentType);
    List<Treatment> findByConsultationId(String consultationId);
    MultiMap<String, Treatment> groupByStatus();
    MultiMap<String, Treatment> groupByTreatmentType();
}
