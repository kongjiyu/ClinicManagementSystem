package repositories.Patient;

import jakarta.annotation.Resource;
import jakarta.enterprise.context.ApplicationScoped;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import models.Patient;

@ApplicationScoped
@Transactional
public class PatientRepositoryImpl implements PatientRepository {

  @PersistenceContext
  private EntityManager em;

  @Override
  public List<Patient> findAll() {
      return em.createQuery("select p from Patient p", Patient.class)
        .getResultList();
  }

  @Override
  public void create(Patient patient){
    em.persist(patient);
  }

  @Override
  public void update(Patient patient) {
    em.merge(patient);
  }

  @Override
  public void delete(Patient patient) {
    em.remove(patient);
  }
}
