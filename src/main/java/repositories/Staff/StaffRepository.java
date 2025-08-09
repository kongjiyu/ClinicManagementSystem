package repositories.Staff;

import models.Staff;
import utils.List;

public interface StaffRepository {
  List<Staff> findAll();
  Staff findById(String id);
  void create(Staff staff);
  void update(String id, Staff updatedStaff);
  void delete(String id);
}
