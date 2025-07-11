package repositories.Patient;

import models.Patient;

import java.util.List;

public interface PatientRepository {
  Patient findById(int id);

  List<Patient> findAll();

  void create(Patient patient);

  void update(Patient patient);

  void delete(Patient patient);

}
