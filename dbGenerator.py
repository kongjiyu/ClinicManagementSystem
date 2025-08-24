import random
from faker import Faker
from datetime import date, time
from datetime import datetime, timedelta

fake = Faker()

def format_sql_value(value):
    if isinstance(value, str):
        escaped = value.replace("'", "''")
        return f"'{escaped}'"
    elif isinstance(value, date):
        return f"'{value}'"
    elif value is None:
        return "NULL"
    else:
        return str(value)

def generate_staff_sql(n=10):
    inserts = []
    staff_ids = []
    doctor_ids = []
    for i in range(n):
        staffID = f"ST{str(i+1).zfill(4)}"
        firstName = fake.first_name()
        lastName = fake.last_name()
        gender = random.choice(["Male", "Female"])
        dob = fake.date_of_birth(minimum_age=22, maximum_age=65)
        nationality = fake.country()
        idType = random.choice(["IC", "Passport"])
        idNumber = fake.ssn()
        prefix = random.choice(["010", "011", "012", "013", "014", "016", "017", "018", "019"])
        contactNumber = f"{prefix}-{random.randint(1000000, 9999999)}"
        email = fake.email()
        address = fake.address().replace("\n", ", ")
        position = random.choice(["Doctor", "Admin"])
        medicalLicenseNumber = fake.bothify(text='MED###') if position == "Doctor" else ""
        password = "Password123!"
        employmentDate = fake.date_between(start_date='-10y', end_date='today')

        values = [
            staffID, firstName, lastName, gender, dob, nationality, idType,
            idNumber, contactNumber, email, address, position,
            medicalLicenseNumber, password, employmentDate
        ]
        formatted_values = [format_sql_value(v) for v in values]

        insert_stmt = f"INSERT INTO Staff (staffID, firstName, lastName, gender, dateOfBirth, nationality, idType, idNumber, contactNumber, email, address, position, medicalLicenseNumber, password, employmentDate) VALUES ({', '.join(formatted_values)});"
        inserts.append(insert_stmt)

        staff_ids.append(staffID)
        if position == "Doctor":
            doctor_ids.append(staffID)
    return inserts, staff_ids, doctor_ids

def generate_patient_sql(n=10):
    inserts = []
    patient_ids = []
    for i in range(n):
        patientID = f"PA{str(i+1).zfill(4)}"
        firstName = fake.first_name()
        lastName = fake.last_name()
        gender = random.choice(["Male", "Female"])
        dob = fake.date_of_birth(minimum_age=18, maximum_age=50)
        # Age calculation based on dob
        today = date.today()
        age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
        nationality = fake.country()
        idType = random.choice(["IC", "Passport"])
        idNumber = fake.ssn()
        # Always generate studentId; remove staffId
        studentId = f"S{str(random.randint(1, 9999)).zfill(5)}"
        contactNumber = f"01{random.randint(0, 9)}-{random.randint(1000000, 9999999)}"
        email = fake.email()
        address = fake.street_address() + ", " + fake.city() + ", Malaysia"
        emergencyContactName = fake.name()
        emergencyContactNumber = f"01{random.randint(0, 9)}-{random.randint(1000000, 9999999)}"
        allergies = random.choice(["None", "Penicillin", "Peanuts", "Latex", "Pollen"])
        bloodType = random.choice(["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"])
        password = fake.password(length=8)

        # The following fields are omitted from the schema per your instructions (if present in the model, add here):
        # chronicDiseases, password, registrationDate

        # Compose values in correct order
        values = [
            patientID,            # patientID
            firstName,            # firstName
            lastName,             # lastName
            gender,               # gender
            dob,                  # dateOfBirth
            age,                  # age
            nationality,          # nationality
            idType,               # idType
            idNumber,             # idNumber
            studentId,            # studentId
            contactNumber,        # contactNumber
            email,                # email
            address,              # address
            emergencyContactName, # emergencyContactName
            emergencyContactNumber, # emergencyContactNumber
            allergies,            # allergies
            bloodType,            # bloodType
            password              # password
        ]
        formatted_values = [format_sql_value(v) for v in values]

        insert_stmt = (
            "INSERT INTO Patient (patientID, firstName, lastName, gender, dateOfBirth, age, nationality, idType, idNumber, studentId, contactNumber, email, address, emergencyContactName, emergencyContactNumber, allergies, bloodType, password) "
            f"VALUES ({', '.join(formatted_values)});"
        )
        inserts.append(insert_stmt)

        patient_ids.append(patientID)
    return inserts, patient_ids

def generate_appointment_sql(n=10, patient_ids=None, doctor_ids=None):
    inserts = []
    appointment_ids = []
    descriptions = [
        "Routine check-up",
        "Follow-up visit",
        "Flu symptoms",
        "Back pain assessment",
        "Prescription refill",
        "Blood test review",
        "Post-op review",
        "General consultation"
    ]
    if not patient_ids:
        return inserts, appointment_ids

    # Generate 2–4 appointments per day for August 2025
    start_date = date(2025, 8, 1)
    end_date = date(2025, 8, 31)

    ap_index = 1
    current = start_date
    statuses_before_sep = ["Cancelled", "Checked-in", "No show"]
    statuses_on_after_sep = ["Cancelled", "Scheduled"]
    while current <= end_date:
        # choose a few slots per day
        count = random.randint(2, 4)
        # generate unique times for the day (08:00–20:00) at 30-min steps
        possible_minutes = [0, 30]
        used_times = set()
        for _ in range(count):
            # ensure unique hour:minute per day
            attempts = 0
            while True:
                hour = random.randint(8, 19)  # last start 19:30 still before 20:00
                minute = random.choice(possible_minutes)
                dt = datetime.combine(current, time(hour, minute))
                if dt not in used_times:
                    used_times.add(dt)
                    break
                attempts += 1
                if attempts > 20:
                    break

            appointmentID = f"AP{str(ap_index).zfill(4)}"
            patientID = random.choice(patient_ids)
            if dt.date() < date(2025, 9, 1):
                status = random.choice(statuses_before_sep)
            else:
                status = random.choice(statuses_on_after_sep)

            values = [
                appointmentID,
                patientID,
                dt,
                status,
                random.choice(descriptions)
            ]
            formatted_values = [format_sql_value(v) for v in values]
            insert_stmt = (
                "INSERT INTO Appointment (appointmentID, patientID, appointmentTime, status, description) "
                f"VALUES ({', '.join(formatted_values)});"
            )
            inserts.append(insert_stmt)
            appointment_ids.append(appointmentID)
            ap_index += 1
        current += timedelta(days=1)

    return inserts, appointment_ids


# --- Consultation records (no bill yet) ---
def generate_consultations(n=10, appointment_ids=None, doctor_ids=None, patient_ids=None):
    records = []
    if not appointment_ids or not doctor_ids or not patient_ids:
        return records

    # Only Completed or Cancelled status for consultations
    statuses = ["Completed", "Cancelled"]
    mc_index = 1
    for i in range(n):
        consultationID = f"CO{str(i+1).zfill(4)}"
        patientID = random.choice(patient_ids)
        doctorID = random.choice(doctor_ids)
        staffID = f"ST{str(random.randint(1, 9999)).zfill(4)}"
        symptoms = random.choice(["Headache", "Cough", "Fever", "Nausea", "Back pain"])
        diagnosis = random.choice(["Flu", "Cold", "Diabetes", "Hypertension", "Healthy"])
        # Only generate consultations up to August 2025 (no September onwards)
        consultationDate = fake.date_between(start_date='-2M', end_date=date(2025, 8, 31))
        checkInTime = datetime.combine(consultationDate, time(random.randint(8, 16), random.choice([0, 15, 30, 45])))
        status = random.choice(statuses)

        has_mc = random.random() < 0.4  # 40% of consultations have MC
        if has_mc:
            mcID = f"MC{str(mc_index).zfill(4)}"
            mc_index += 1
            startDate = consultationDate
            endDate = startDate + timedelta(days=random.randint(1, 5))
        else:
            mcID = None
            startDate = None
            endDate = None

        records.append({
            'consultationID': consultationID,
            'patientID': patientID,
            'doctorID': doctorID,
            'staffID': staffID,
            'symptoms': symptoms,
            'diagnosis': diagnosis,
            'consultationDate': consultationDate,
            'checkInTime': checkInTime,
            'status': status,
            'mcID': mcID,
            'startDate': startDate,
            'endDate': endDate
        })
    return records

# Render consultation INSERTs with a provided bill map
# bill_map: { consultationID -> billID }
def render_consultation_inserts(consultations, bill_map):
    inserts = []
    for c in consultations:
        values = [
            c['consultationID'],
            c['patientID'],
            c['doctorID'],
            c['staffID'],
            bill_map.get(c['consultationID']),  # billID from bill table
            c['symptoms'],
            c['diagnosis'],
            c['consultationDate'],
            c['checkInTime'],
            c['status'],
            c['mcID'],
            c['startDate'],
            c['endDate']
        ]
        formatted_values = [format_sql_value(v) for v in values]
        stmt = (
            "INSERT INTO Consultation (consultationID, patientID, doctorID, staffID, billID, symptoms, diagnosis, consultationDate, checkInTime, status, mcID, startDate, endDate) "
            f"VALUES ({', '.join(formatted_values)});"
        )
        inserts.append(stmt)
    return inserts


# --- Bill generation from consultation totals ---
def generate_bill_sql(totals_by_consultation):
    inserts = []
    bill_ids = []
    bill_map = {}
    payment_methods = ["Cash", "Credit Card", "Debit Card", "Insurance"]

    idx = 1
    for consultation_id, med_total in totals_by_consultation.items():
        bill_id = f"BI{str(idx).zfill(4)}"
        total_amount = round(med_total + 20.0, 2)  # medicine total + consultation fee (20)
        payment_method = random.choice(payment_methods)

        values = [bill_id, total_amount, payment_method]
        formatted = [format_sql_value(v) for v in values]
        stmt = (
            "INSERT INTO Bill (billID, totalAmount, paymentMethod) "
            f"VALUES ({', '.join(formatted)});"
        )
        inserts.append(stmt)
        bill_ids.append(bill_id)
        bill_map[consultation_id] = bill_id
        idx += 1

    return inserts, bill_ids, bill_map


# --- Medicine generation ---
def generate_medicine_sql(n=10):
    inserts = []
    price_map = {}

    for i in range(n):
        medicine_id = f"ME{str(i+1).zfill(4)}"
        medicine_name = fake.word().capitalize() + "Med"
        description = fake.sentence(nb_words=6)
        reorder_level = random.randint(10, 30)
        selling_price = round(random.uniform(5.0, 100.0), 2)

        values = [
            medicine_id, medicine_name, description,
            reorder_level, selling_price
        ]
        formatted = [format_sql_value(v) for v in values]

        stmt = (
            "INSERT INTO Medicine (medicineID, medicineName, description, reorderLevel, sellingPrice) "
            f"VALUES ({', '.join(formatted)});"
        )
        inserts.append(stmt)
        price_map[medicine_id] = selling_price

    return inserts, price_map

def main():
    staff_inserts, staff_ids, doctor_ids = generate_staff_sql(10)
    patient_inserts, patient_ids = generate_patient_sql(20)
    appointment_inserts, appointment_ids = generate_appointment_sql(50, patient_ids, doctor_ids)
    consultations = generate_consultations(40, appointment_ids, doctor_ids, patient_ids)
    consultation_ids = [c['consultationID'] for c in consultations]

    for stmt in staff_inserts:
        print(stmt)
    for stmt in patient_inserts:
        print(stmt)
    for stmt in appointment_inserts:
        print(stmt)
    # AFTER printing appointment_inserts
    supplier_inserts, supplier_ids = generate_supplier_sql(5)
    for stmt in supplier_inserts:
        print(stmt)

    # Medicines generated (no supplierID; suppliers are linked via Orders)
    medicine_inserts, price_map = generate_medicine_sql(15)
    for stmt in medicine_inserts:
        print(stmt)

    medicine_ids = [f"ME{str(i+1).zfill(4)}" for i in range(15)]
    prescription_inserts, totals_by_consultation = generate_prescription_sql(60, consultation_ids, medicine_ids=medicine_ids, price_map=price_map)

    # Generate Bills from totals and map them back to consultations
    bill_inserts, bill_ids, bill_map = generate_bill_sql(totals_by_consultation)
    for stmt in bill_inserts:
        print(stmt)

    # Now render consultations with the correct billID from bill_map
    consultation_inserts = render_consultation_inserts(consultations, bill_map)
    for stmt in consultation_inserts:
        print(stmt)

    # Finally, print prescriptions
    for stmt in prescription_inserts:
        print(stmt)
    schedule_inserts = generate_schedule_sql(doctor_ids)
    for stmt in schedule_inserts:
        print(stmt)

    # --- Order inserts ---
    order_inserts = generate_order_sql(20, medicine_ids, supplier_ids, staff_ids)
    for stmt in order_inserts:
        print(stmt)




# --- Prescription generation ---
def generate_prescription_sql(n=10, consultation_ids=None, medicine_ids=None, price_map=None):
    prescriptions = []
    totals_by_consultation = {}
    consultation_ids = consultation_ids or [f"CO{str(i+1).zfill(4)}" for i in range(n)]
    medicine_ids = medicine_ids or [f"ME{str(i+1).zfill(4)}" for i in range(n)]
    price_map = price_map or {}

    instruction_options = [
        "Take on empty stomach",
        "Take with food",
        "Take before meals",
        "Take after meals",
        "Take with plenty of water",
        "Take at bedtime",
        "Take as needed",
    ]

    for i in range(n):
        prescription_id = f"PR{str(i+1).zfill(4)}"
        consultation_id = random.choice(consultation_ids)
        medicine_id = random.choice(medicine_ids)
        description = fake.sentence(nb_words=6)
        dosage = random.randint(1, 3)
        instruction = random.choice(instruction_options)
        serving_per_day = random.randint(1, 4)
        quantity_dispensed = random.randint(1, 5)
        unit_price = price_map.get(medicine_id, round(random.uniform(5.0, 50.0), 2))
        price = unit_price  # keep in table as unit price
        dosage_unit = random.choice(["mg", "ml", "capsule", "tablet"])

        # accumulate total per consultation: qty * unit price
        totals_by_consultation[consultation_id] = totals_by_consultation.get(consultation_id, 0.0) + (quantity_dispensed * unit_price)

        values = [
            prescription_id, consultation_id, medicine_id, description,
            dosage, instruction, serving_per_day, quantity_dispensed, price, dosage_unit,
        ]
        formatted = [format_sql_value(v) for v in values]

        stmt = (
            "INSERT INTO Prescription (prescriptionID, consultationID, medicineID, description, dosage, instruction, servingPerDay, quantityDispensed, price, dosageUnit) "
            f"VALUES ({', '.join(formatted)});"
        )
        prescriptions.append(stmt)

    return prescriptions, totals_by_consultation


# --- Schedule generation ---
from datetime import datetime, timedelta

def generate_schedule_sql(doctor_ids):
    inserts = []
    schedule_index = 1

    # Generate from July to end of September 2025
    start_date = date(2025, 7, 1)
    end_date = date(2025, 9, 30)

    current_date = start_date
    while current_date <= end_date:
        for doctor_id in doctor_ids:
            # Morning shift 08:00 - 14:00
            schedule_id_m = f"SC{str(schedule_index).zfill(4)}"
            start_time_m = datetime.combine(current_date, time(8, 0))
            end_time_m = datetime.combine(current_date, time(14, 0))
            stmt_m = (
                "INSERT INTO Schedule (scheduleID, doctorID, date, startTime, endTime, shift) "
                f"VALUES ('{schedule_id_m}', '{doctor_id}', '{current_date}', "
                f"'{start_time_m.strftime('%Y-%m-%d %H:%M:%S')}', '{end_time_m.strftime('%Y-%m-%d %H:%M:%S')}', 'Morning');"
            )
            inserts.append(stmt_m)
            schedule_index += 1

            # Evening shift 14:00 - 20:00
            schedule_id_e = f"SC{str(schedule_index).zfill(4)}"
            start_time_e = datetime.combine(current_date, time(14, 0))
            end_time_e = datetime.combine(current_date, time(20, 0))
            stmt_e = (
                "INSERT INTO Schedule (scheduleID, doctorID, date, startTime, endTime, shift) "
                f"VALUES ('{schedule_id_e}', '{doctor_id}', '{current_date}', "
                f"'{start_time_e.strftime('%Y-%m-%d %H:%M:%S')}', '{end_time_e.strftime('%Y-%m-%d %H:%M:%S')}', 'Evening');"
            )
            inserts.append(stmt_e)
            schedule_index += 1

        current_date += timedelta(days=1)

    return inserts




# --- Supplier generation ---
def generate_supplier_sql(n=10):
    inserts = []
    supplier_ids = []
    for i in range(n):
        supplier_id = f"SU{str(i+1).zfill(4)}"
        supplier_name = fake.company()
        contact_person = fake.name()
        phone_number = fake.phone_number()
        email = fake.email()
        address = fake.address().replace('\n', ', ')
        bank_name = random.choice(["Bank of America", "CitiBank", "HSBC", "OCBC", "Maybank"])
        account_number = fake.bban()

        values = [
            supplier_id, supplier_name, contact_person, phone_number,
            email, address, bank_name, account_number
        ]
        formatted = [format_sql_value(v) for v in values]
        stmt = (
            "INSERT INTO Supplier (supplierId, supplierName, contactPerson, phoneNumber, email, address, bankName, accountNumber) "
            f"VALUES ({', '.join(formatted)});"
        )
        inserts.append(stmt)
        supplier_ids.append(supplier_id)

    return inserts, supplier_ids


# --- Order generation ---
def generate_order_sql(n=10, medicine_ids=None, supplier_ids=None, staff_ids=None):
    inserts = []
    medicine_ids = medicine_ids or [f"ME{str(i+1).zfill(4)}" for i in range(n)]
    supplier_ids = supplier_ids or [f"SU{str(i+1).zfill(4)}" for i in range(n)]
    staff_ids = staff_ids or [f"ST{str(i+1).zfill(4)}" for i in range(n)]

    for i in range(n):
        order_id = f"OR{str(i+1).zfill(4)}"
        medicine_id = random.choice(medicine_ids)
        supplier_id = random.choice(supplier_ids)
        staff_id = random.choice(staff_ids)
        order_date = fake.date_between(start_date='-1y', end_date='today')
        
        # Determine order status based on date
        september_2025 = date(2025, 9, 1)
        if order_date >= september_2025:
            # After September 2025: Pending or Shipped
            order_status = random.choice(["Pending", "Shipped"])
        else:
            # Before September 2025: Completed or Cancelled
            order_status = random.choice(["Completed", "Cancelled"])
        
        unit_price = round(random.uniform(10.0, 100.0), 2)
        quantity = random.randint(10, 100)
        total_amount = round(unit_price * quantity, 2)
        expiry_date = fake.date_between(start_date=order_date, end_date='+1y')
        stock = quantity

        values = [
            order_id, medicine_id, supplier_id, staff_id, order_date,
            order_status, unit_price, quantity, total_amount, expiry_date, stock
        ]
        formatted = [format_sql_value(v) for v in values]

        stmt = (
            "INSERT INTO Orders (ordersID, medicineID, supplierID, staffID, orderDate, orderStatus, unitPrice, quantity, totalAmount, expiryDate, stock) "
            f"VALUES ({', '.join(formatted)});"
        )
        inserts.append(stmt)
    return inserts


if __name__ == "__main__":
    main()