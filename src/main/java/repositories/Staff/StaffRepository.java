package repositories.Staff;

import models.Staff;
import java.util.List;

public interface StaffRepository {
  List<Staff> findAll();
  Staff findById(String id);
  void save(Staff staff);
  void update(String id, Staff updatedStaff);
  void delete(String id);
}
