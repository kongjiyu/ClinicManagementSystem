package repositories.Prescription;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Consultation;
import models.Prescription;
import repositories.Consultation.ConsultationRepository;
import utils.List;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class PrescriptionRepositoryImpl implements PrescriptionRepository {
  @Inject
  private ConsultationRepository consultationRepo;

  @PersistenceContext
  private EntityManager em;

  @Override
  public void create(Prescription prescription) {
    em.persist(prescription);
  }

  @Override
  public Prescription findById(String id) {
    List<Prescription>prescriptions=findAll();
    for(Prescription prescription:prescriptions){
      if(prescription.getPrescriptionID().equals(id)){
        return prescription;
      }
    }

    return em.find(Prescription.class, id);
  }

  @Override
  public List<Prescription> findAll() {
    return new List<>(em.createQuery(
            "SELECT p FROM Prescription p", Prescription.class)
            .getResultList());
  }

  @Override
  public List<Prescription> findByPatientId(String patientId) {
      MultiMap<String,Prescription> patientPrecriptionMap=groupByPatientId();
      return patientPrecriptionMap.get(patientId);
  }

  @Override
  public MultiMap<String, Prescription> groupByPatientId() {
    List<Prescription> prescriptions = findAll();
    MultiMap<String, Prescription> patientPrescriptionMap = new MultiMap<>();

    for (Prescription prescription : prescriptions) {
      String consultationId = prescription.getConsultationID();
      if (consultationId == null) {
        continue;
      }

      Consultation consultation = consultationRepo.findById(consultationId);
      if (consultation == null) {
        continue;
      }

      String patientId = consultation.getPatientID();
      if (patientId == null) {
        continue;
      }

      patientPrescriptionMap.put(patientId, prescription);
    }

    return patientPrescriptionMap;
  }

  @Override
  public MultiMap<String,Prescription> groupByMedicineId(){
    List<Prescription>prescriptions=findAll();
    MultiMap<String,Prescription> medicinePrescriptionMap=new MultiMap<>();
    for(Prescription prescription:prescriptions){
      if (prescription.getPrescriptionID()!=null) {
        medicinePrescriptionMap.put(prescription.getPrescriptionID(), prescription);
      }
    }
    return medicinePrescriptionMap;
  }

  @Override
  public List<Prescription> findByMedicineId(String patientId) {
    MultiMap<String,Prescription> medicinePrescriptionMap=groupByMedicineId();
    return medicinePrescriptionMap.get(patientId);
  }


  @Override
  public MultiMap<String,Prescription> groupByConsultationId(){
    List<Prescription> prescriptions = findAll();
    MultiMap<String,Prescription> consultationPrescriptionMap = new MultiMap<>();
    for (Prescription prescription : prescriptions) {
      consultationPrescriptionMap.put(prescription.getConsultationID(), prescription);
    }
    return consultationPrescriptionMap;
  }

  @Override
  public List<Prescription> findByConsultationId(String consultationId) {
    MultiMap<String,Prescription> groupByConsultationId = groupByConsultationId();
    return groupByConsultationId.get(consultationId);
  }

  @Override
  public void update(Prescription prescription) {
    em.merge(prescription);
  }

  @Override
  public void delete(String id) {
    Prescription prescription = em.find(Prescription.class, id);
    if (prescription != null) {
      em.remove(prescription);
    }
  }

  @Override
  public List<Prescription> findHistory(String id) {
    return null;
  }

  @Override
  public List<Prescription> findPrescriptionsByPatientId(String patientId) {
    MultiMap<String,Prescription> patientPrescriptionMap = groupByPatientId();
    return patientPrescriptionMap.get(patientId);
  }
}
