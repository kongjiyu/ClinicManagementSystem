package repositories.Treatment;

/**
 * Author: Oh Wan Ting
 * Treatment Module
 */

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
    
    // Sorting method implementations
    @Override
    public List<Treatment> findAllSortedByDate() {
        List<Treatment> treatments = findAll();
        return (List<Treatment>) treatments.sort((a, b) -> {
            if (a.getTreatmentDate() == null && b.getTreatmentDate() == null) return 0;
            if (a.getTreatmentDate() == null) return 1;
            if (b.getTreatmentDate() == null) return -1;
            return b.getTreatmentDate().compareTo(a.getTreatmentDate()); // Newest first
        });
    }
    
    @Override
    public List<Treatment> findAllSortedByStatus() {
        List<Treatment> treatments = findAll();
        return (List<Treatment>) treatments.sort((a, b) -> {
            if (a.getStatus() == null && b.getStatus() == null) return 0;
            if (a.getStatus() == null) return 1;
            if (b.getStatus() == null) return -1;
            return a.getStatus().compareToIgnoreCase(b.getStatus()); // Alphabetical by status
        });
    }
    
    @Override
    public List<Treatment> findAllSortedByType() {
        List<Treatment> treatments = findAll();
        return (List<Treatment>) treatments.sort((a, b) -> {
            if (a.getTreatmentType() == null && b.getTreatmentType() == null) return 0;
            if (a.getTreatmentType() == null) return 1;
            if (b.getTreatmentType() == null) return -1;
            return a.getTreatmentType().compareToIgnoreCase(b.getTreatmentType()); // Alphabetical by type
        });
    }
    
    @Override
    public List<Treatment> findByPatientIdSorted(String patientId) {
        List<Treatment> patientTreatments = findByPatientId(patientId);
        return (List<Treatment>) patientTreatments.sort((a, b) -> {
            if (a.getTreatmentDate() == null && b.getTreatmentDate() == null) return 0;
            if (a.getTreatmentDate() == null) return 1;
            if (b.getTreatmentDate() == null) return -1;
            return b.getTreatmentDate().compareTo(a.getTreatmentDate()); // Newest first
        });
    }
    
    @Override
    public List<Treatment> findByStatusSorted(String status) {
        List<Treatment> statusTreatments = findByStatus(status);
        return (List<Treatment>) statusTreatments.sort((a, b) -> {
            if (a.getTreatmentDate() == null && b.getTreatmentDate() == null) return 0;
            if (a.getTreatmentDate() == null) return 1;
            if (b.getTreatmentDate() == null) return -1;
            return a.getTreatmentDate().compareTo(b.getTreatmentDate()); // Oldest first for status-based queries
        });
    }
}
