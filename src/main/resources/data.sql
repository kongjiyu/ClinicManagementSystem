INSERT INTO clinicdb.Patient (
  patientID, firstName, lastName, gender, dateOfBirth, age, nationality,
  idType, idNumber, studentId, staffId, contactNumber, email, address,
  emergencyContactName, emergencyContactNumber, allergies, bloodType
) VALUES
    ('PT00001', 'Ali', 'Bin Abu', 'Male', '1998-03-15', 26, 'Malaysian', 'IC', '980315-14-5678', 'S12345', '', '0123456789', 'ali@gmail.com', 'Kuala Lumpur',
     'Abu Bin Kassim', '0198765432', 'Peanuts', 'O'),
    ('PT00002', 'Chong', 'Mei Ling', 'Female', '2001-11-25', 22, 'Malaysian', 'IC', '011125-10-1234', '', 'STF001', '0132221111', 'mei.ling@example.com', 'Johor Bahru',
     'Chong Ah Kuan', '0126667777', 'None', 'A'),
    ('PT00003', 'Raj', 'Kumar', 'Male', '1985-06-10', 39, 'Malaysian', 'IC', '850610-08-4321', '', '', '0147894561', 'raj.kumar@email.com', 'Ipoh, Perak',
     'Kumar V.', '0119988776', 'Penicillin', 'B'),
    ('PT00004', 'Sarah', 'Tan', 'Female', '1993-09-09', 30, 'Singaporean', 'Passport', 'S9876543F', '', '', '0171234567', 'sarah.tan@domain.sg', 'Singapore',
     'Tan Li Mei', '0163456789', 'Shellfish', 'AB'),
    ('PT00005', 'John', 'Doe', 'Male', '2000-01-01', 24, 'American', 'Passport', 'M123456789', 'S54321', '', '0188888888', 'john.doe@example.com', 'New York, USA',
     'Jane Doe', '0101112222', 'None', 'O');
