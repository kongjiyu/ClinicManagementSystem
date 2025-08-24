package repositories.Treatment;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Treatment;
import utils.List;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class TreatmentRepositoryImpl implements TreatmentRepository {

    @PersistenceContext
    private EntityManager em;

    @Override
    public void create(Treatment treatment) {
        em.persist(treatment);
    }

    @Override
    public Treatment findById(String id) {
        List<Treatment> treatments = findAll();
        for (Treatment treatment : treatments) {
            if (treatment.getTreatmentID().equals(id)) {
                return treatment;
            }
        }
        return null;
    }

    @Override
    public List<Treatment> findAll() {
        return new List<>(em.createQuery("SELECT t FROM Treatment t", Treatment.class)
                .getResultList());
    }

    @Override
    public void update(Treatment treatment) {
        em.merge(treatment);
    }

    @Override
    public void delete(Treatment treatment) {
        em.remove(treatment);
    }

    @Override
    public List<Treatment> findByPatientId(String patientId) {
        List<Treatment> treatments = findAll();
        List<Treatment> patientTreatments = new List<>();
        
        for (Treatment treatment : treatments) {
            if (treatment.getPatientID().equals(patientId)) {
                patientTreatments.add(treatment);
            }
        }
        return patientTreatments;
    }

    @Override
    public List<Treatment> findByDoctorId(String doctorId) {
        List<Treatment> treatments = findAll();
        List<Treatment> doctorTreatments = new List<>();
        
        for (Treatment treatment : treatments) {
            if (treatment.getDoctorID().equals(doctorId)) {
                doctorTreatments.add(treatment);
            }
        }
        return doctorTreatments;
    }

    @Override
    public List<Treatment> findByStatus(String status) {
        List<Treatment> treatments = findAll();
        List<Treatment> statusTreatments = new List<>();
        
        for (Treatment treatment : treatments) {
            if (treatment.getStatus().equals(status)) {
                statusTreatments.add(treatment);
            }
        }
        return statusTreatments;
    }

    @Override
    public List<Treatment> findByTreatmentType(String treatmentType) {
        List<Treatment> treatments = findAll();
        List<Treatment> typeTreatments = new List<>();
        
        for (Treatment treatment : treatments) {
            if (treatment.getTreatmentType().equals(treatmentType)) {
                typeTreatments.add(treatment);
            }
        }
        return typeTreatments;
    }

    @Override
    public List<Treatment> findByConsultationId(String consultationId) {
        List<Treatment> treatments = findAll();
        List<Treatment> consultationTreatments = new List<>();
        
        for (Treatment treatment : treatments) {
            if (treatment.getConsultationID().equals(consultationId)) {
                consultationTreatments.add(treatment);
            }
        }
        return consultationTreatments;
    }

    @Override
    public MultiMap<String, Treatment> groupByStatus() {
        List<Treatment> treatments = findAll();
        MultiMap<String, Treatment> statusMap = new MultiMap<>();
        
        for (Treatment treatment : treatments) {
            statusMap.put(treatment.getStatus(), treatment);
        }
        return statusMap;
    }

    @Override
    public MultiMap<String, Treatment> groupByTreatmentType() {
        List<Treatment> treatments = findAll();
        MultiMap<String, Treatment> typeMap = new MultiMap<>();
        
        for (Treatment treatment : treatments) {
            typeMap.put(treatment.getTreatmentType(), treatment);
        }
        return typeMap;
    }
}
