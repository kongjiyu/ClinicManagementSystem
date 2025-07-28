package repositories.Prescription;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Consultation;
import models.Prescription;
import repositories.Consultation.ConsultationRepository;
import utils.ArrayList;
import java.util.List;
import utils.MultiMap;

@ApplicationScoped
@Transactional
public class PrescriptionRepositoryImpl implements PrescriptionRepository {
  @Inject
  private ConsultationRepository consultationRepo;

  @PersistenceContext
  private EntityManager em;

  @Override
  public void save(Prescription prescription) {
    em.persist(prescription);
  }

  @Override
  public Prescription findById(String id) {
    ArrayList<Prescription>prescriptions=findAll();
    for(Prescription prescription:prescriptions){
      if(prescription.getPrescriptionID().equals(id)){
        return prescription;
      }
    }

    return em.find(Prescription.class, id);
  }

  @Override
  public ArrayList<Prescription> findAll() {
    return new ArrayList<>(em.createQuery(
            "SELECT p FROM Prescription p", Prescription.class)
            .getResultList());
  }

  @Override
  public ArrayList<Prescription> findByPatientId(String patientId) {
      MultiMap<String,Prescription> patientPrecriptionmap=groupByPatientId();
      return patientPrecriptionmap.get(patientId);
  }

  @Override
  public MultiMap<String, Prescription> groupByPatientId() {
    ArrayList<Prescription> prescriptions = findAll();
    MultiMap<String, Prescription> patientPrescriptionMap = new MultiMap<>();

    for (Prescription prescription : prescriptions) {
      String consultationId = prescription.getConsultationID();
      if (consultationId != null) {
        Consultation consultation = consultationRepo.findById(consultationId);
        if (consultation != null && consultation.getPatientID() != null) {
          patientPrescriptionMap.put(consultation.getPatientID(), prescription);
        }
      }
    }

    return patientPrescriptionMap;
  }

  @Override
  public MultiMap<String,Prescription> groupByMedicineId(){
    ArrayList<Prescription>prescriptions=findAll();
    MultiMap<String,Prescription> medicinePrecriptionmap=new MultiMap<>();
    for(Prescription prescription:prescriptions){
      if (prescription.getPrescriptionID()!=null) {
        medicinePrecriptionmap.put(prescription.getPrescriptionID(), prescription);
      }
    }
    return medicinePrecriptionmap;
  }

  @Override
  public ArrayList<Prescription> findByMedicineId(String patientId) {
    MultiMap<String,Prescription> medicinePrecriptionmap=groupByMedicineId();
    return medicinePrecriptionmap.get(patientId);
  }


  @Override
  public MultiMap<String,Prescription> groupByConsultationId(){
    ArrayList<Prescription>prescriptions=findAll();
    MultiMap<String,Prescription> consultationPrescriptionMap=new MultiMap<>();
    for(Prescription prescription:prescriptions){
      consultationPrescriptionMap.put(prescription.getPrescriptionID(), prescription);
    }
    return consultationPrescriptionMap;
  }

  @Override
  public ArrayList<Prescription> findByConsultationId(String patientId) {
    MultiMap<String,Prescription> findByConsultationId=groupByConsultationId();
    return  findByConsultationId(patientId);
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
  public ArrayList<Prescription> findHistory(String id) {
    return null;
  }

  @Override
  public ArrayList<Prescription> findPrescriptionsByPatientId(String patientId) {
    MultiMap<String,Prescription> patientPrescriptionMap = groupByPatientId();
    return patientPrescriptionMap.get(patientId);
  }
}
