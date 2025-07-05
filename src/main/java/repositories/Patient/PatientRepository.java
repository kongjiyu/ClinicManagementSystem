package repositories.Patient;

import models.Patient;

import java.util.List;

public interface PatientRepository {
  List<Patient> findAll();

  void create(Patient patient);

  void update(Patient patient);

  void delete(Patient patient);

}
