import random
from faker import Faker
from datetime import date, time
from datetime import datetime, timedelta

fake = Faker()

# --- Realistic medicine catalog (id assigned in order) ---
# name, description, typical_unit_price, dosage_unit, form
MED_CATALOG = [
    ("Paracetamol 500mg", "Analgesic/antipyretic for pain and fever.", 0.35, "tablet", "tablet"),
    ("Ibuprofen 200mg", "NSAID for pain and inflammation.", 0.45, "tablet", "tablet"),
    ("Naproxen 250mg", "NSAID for pain and inflammation.", 0.80, "tablet", "tablet"),
    ("Loratadine 10mg", "Antihistamine for allergic rhinitis.", 0.60, "tablet", "tablet"),
    ("Cetirizine 10mg", "Antihistamine for allergic rhinitis.", 0.55, "tablet", "tablet"),
    ("Dextromethorphan Syrup 10mg/5ml", "Cough suppressant.", 6.50, "ml", "syrup"),
    ("Metformin 500mg", "Oral hypoglycemic for type 2 diabetes.", 0.40, "tablet", "tablet"),
    ("Amlodipine 5mg", "Calcium-channel blocker for hypertension.", 0.70, "tablet", "tablet"),
    ("Lisinopril 10mg", "ACE inhibitor for hypertension.", 0.65, "tablet", "tablet"),
    ("Omeprazole 20mg", "Proton pump inhibitor for dyspepsia/GERD.", 0.50, "tablet", "tablet"),
    ("Ondansetron 4mg", "Antiemetic for nausea/vomiting.", 1.20, "tablet", "tablet"),
    ("ORS Sachet", "Oral rehydration salts.", 1.00, "sachet", "sachet"),
    ("Salbutamol Inhaler 100mcg", "Reliever inhaler for bronchospasm.", 18.00, "inhaler", "inhaler"),
    ("Amoxicillin 500mg", "Antibiotic for susceptible infections.", 0.75, "capsule", "capsule"),
    ("Diclofenac Gel 1%", "Topical NSAID for localized pain.", 12.00, "tube", "gel"),
]

# Diagnosis → appropriate medicines (names must match MED_CATALOG)
DIAGNOSIS_TO_MEDS = {
    "Cold": ["Paracetamol 500mg", "Loratadine 10mg"],
    "Flu": ["Paracetamol 500mg", "Dextromethorphan Syrup 10mg/5ml", "Loratadine 10mg"],
    "Fever": ["Paracetamol 500mg"],
    "Cough": ["Dextromethorphan Syrup 10mg/5ml", "Loratadine 10mg"],
    "Back pain": ["Ibuprofen 200mg", "Naproxen 250mg", "Diclofenac Gel 1%"],
    "Nausea": ["Ondansetron 4mg", "Omeprazole 20mg"],
    "Hypertension": ["Amlodipine 5mg", "Lisinopril 10mg"],
    "Diabetes": ["Metformin 500mg"],
    "Healthy": [],
}

# Treatment pricing rules: base fee + per-minute component
TREATMENT_PRICING = {
    "Physical Therapy": {"base": 80.0, "per_min": 1.5},     # RM80 + RM1.5/min
    "Medication":       {"base": 30.0, "per_min": 0.0},     # flat consult/dispense fee
    "Counseling":       {"base": 50.0, "per_min": 0.8},     # RM50 + RM0.8/min
    "Diagnostics":      {"base": 45.0, "per_min": 0.5},     # RM45 + RM0.5/min
    "Surgery":          {"base": 200.0, "per_min": 2.0},    # RM200 + RM2/min
    "Dental":           {"base": 120.0, "per_min": 1.2},    # RM120 + RM1.2/min
    "Physiotherapy":    {"base": 70.0, "per_min": 1.0},     # RM70 + RM1/min
    "Laboratory":       {"base": 25.0, "per_min": 0.3},     # RM25 + RM0.3/min
}

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


def generate_staff_sql(n=15):  # 10 doctors + 5 admin staff (keeping the same)
    inserts = []
    staff_ids = []
    doctor_ids = []
    
    # Predefined nationality list matching the form
    nationalities = [
        "Malaysian", "Singaporean", "Indonesian", "Thai", "Filipino", "Vietnamese", "Chinese", "Indian", 
        "Pakistani", "Bangladeshi", "Sri Lankan", "Nepalese", "Myanmar", "Cambodian", "Laotian", "Bruneian",
        "American", "Canadian", "British", "Australian", "New Zealander", "German", "French", "Italian", 
        "Spanish", "Portuguese", "Dutch", "Belgian", "Swiss", "Austrian", "Swedish", "Norwegian", "Danish", 
        "Finnish", "Polish", "Czech", "Slovak", "Hungarian", "Romanian", "Bulgarian", "Croatian", "Serbian", 
        "Slovenian", "Bosnian", "Montenegrin", "Macedonian", "Albanian", "Greek", "Turkish", "Russian", 
        "Ukrainian", "Belarusian", "Moldovan", "Georgian", "Armenian", "Azerbaijani", "Kazakh", "Uzbek", 
        "Kyrgyz", "Tajik", "Turkmen", "Afghan", "Iranian", "Iraqi", "Syrian", "Lebanese", "Jordanian", 
        "Palestinian", "Israeli", "Saudi Arabian", "Kuwaiti", "Bahraini", "Qatari", "UAE", "Omani", "Yemeni",
        "Egyptian", "Sudanese", "Libyan", "Tunisian", "Algerian", "Moroccan", "Mauritanian", "Senegalese", 
        "Gambian", "Guinea-Bissauan", "Guinean", "Sierra Leonean", "Liberian", "Ivorian", "Ghanaian", 
        "Togolese", "Beninese", "Nigerian", "Nigerien", "Chadian", "Cameroonian", "Central African", 
        "Equatorial Guinean", "Gabonese", "Congolese", "DR Congolese", "Angolan", "Zambian", "Malawian", 
        "Mozambican", "Zimbabwean", "Botswanan", "Namibian", "South African", "Lesothan", "Eswatini", 
        "Madagascan", "Comorian", "Mauritian", "Seychellois", "Kenyan", "Ugandan", "Tanzanian", "Rwandan", 
        "Burundian", "Ethiopian", "Eritrean", "Djiboutian", "Somali", "South Sudanese", "Brazilian", 
        "Argentine", "Chilean", "Peruvian", "Colombian", "Venezuelan", "Ecuadorian", "Bolivian", 
        "Paraguayan", "Uruguayan", "Guyanese", "Surinamese", "Mexican", "Guatemalan", "Belizean", 
        "Honduran", "Salvadoran", "Nicaraguan", "Costa Rican", "Panamanian", "Cuban", "Jamaican", 
        "Haitian", "Dominican", "Puerto Rican", "Bahamian", "Barbadian", "Trinidadian", "Grenadian", 
        "Saint Lucian", "Vincentian", "Antiguan", "Kittitian", "Other"
    ]
    
    for i in range(n):
        staffID = f"ST{str(i + 1).zfill(4)}"
        firstName = fake.first_name()
        lastName = fake.last_name()
        gender = random.choice(["Male", "Female"])
        nationality = random.choice(nationalities)
        idType = random.choice(["IC", "Passport"])
        
        # Generate proper ID numbers based on type
        if idType == "IC":
            # Malaysian IC format: YYMMDD-PB-XXXX
            year = random.randint(60, 99)  # 1960-1999
            month = random.randint(1, 12)
            day = random.randint(1, 28)  # Use 28 to avoid invalid dates
            pb = random.randint(1, 99)
            xxxx = random.randint(1, 9999)
            idNumber = f"{year:02d}{month:02d}{day:02d}-{pb:02d}-{xxxx:04d}"
            # Set DOB to match IC date
            dob = date(1900 + year, month, day)
        else:  # Passport
            # Passport format: 1-2 letters + 6-9 digits
            letters = random.choice(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
            if random.random() < 0.5:
                letters = letters + random.choice(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
            digits = random.randint(100000, 999999999)
            idNumber = f"{letters}{digits}"
            # For passport, generate random DOB
            dob = fake.date_of_birth(minimum_age=22, maximum_age=65)
        
        prefix = random.choice(["010", "011", "012", "013", "014", "016", "017", "018", "019"])
        contactNumber = f"{prefix}-{random.randint(1000000, 9999999)}"
        email = fake.email()
        address = fake.address().replace("\n", ", ")
        # Ensure we get exactly 10 doctors and 5 admin staff
        if i < 10:
            position = "Doctor"
            medicalLicenseNumber = fake.bothify(text='MED###')
        else:
            position = "Admin"
            medicalLicenseNumber = ""
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


def generate_patient_sql(n=100):
    inserts = []
    patient_ids = []
    
    # Predefined nationality list matching the form
    nationalities = [
        "Malaysian", "Singaporean", "Indonesian", "Thai", "Filipino", "Vietnamese", "Chinese", "Indian", 
        "Pakistani", "Bangladeshi", "Sri Lankan", "Nepalese", "Myanmar", "Cambodian", "Laotian", "Bruneian",
        "American", "Canadian", "British", "Australian", "New Zealander", "German", "French", "Italian", 
        "Spanish", "Portuguese", "Dutch", "Belgian", "Swiss", "Austrian", "Swedish", "Norwegian", "Danish", 
        "Finnish", "Polish", "Czech", "Slovak", "Hungarian", "Romanian", "Bulgarian", "Croatian", "Serbian", 
        "Slovenian", "Bosnian", "Montenegrin", "Macedonian", "Albanian", "Greek", "Turkish", "Russian", 
        "Ukrainian", "Belarusian", "Moldovan", "Georgian", "Armenian", "Azerbaijani", "Kazakh", "Uzbek", 
        "Kyrgyz", "Tajik", "Turkmen", "Afghan", "Iranian", "Iraqi", "Syrian", "Lebanese", "Jordanian", 
        "Palestinian", "Israeli", "Saudi Arabian", "Kuwaiti", "Bahraini", "Qatari", "UAE", "Omani", "Yemeni",
        "Egyptian", "Sudanese", "Libyan", "Tunisian", "Algerian", "Moroccan", "Mauritanian", "Senegalese", 
        "Gambian", "Guinea-Bissauan", "Guinean", "Sierra Leonean", "Liberian", "Ivorian", "Ghanaian", 
        "Togolese", "Beninese", "Nigerian", "Nigerien", "Chadian", "Cameroonian", "Central African", 
        "Equatorial Guinean", "Gabonese", "Congolese", "DR Congolese", "Angolan", "Zambian", "Malawian", 
        "Mozambican", "Zimbabwean", "Botswanan", "Namibian", "South African", "Lesothan", "Eswatini", 
        "Madagascan", "Comorian", "Mauritian", "Seychellois", "Kenyan", "Ugandan", "Tanzanian", "Rwandan", 
        "Burundian", "Ethiopian", "Eritrean", "Djiboutian", "Somali", "South Sudanese", "Brazilian", 
        "Argentine", "Chilean", "Peruvian", "Colombian", "Venezuelan", "Ecuadorian", "Bolivian", 
        "Paraguayan", "Uruguayan", "Guyanese", "Surinamese", "Mexican", "Guatemalan", "Belizean", 
        "Honduran", "Salvadoran", "Nicaraguan", "Costa Rican", "Panamanian", "Cuban", "Jamaican", 
        "Haitian", "Dominican", "Puerto Rican", "Bahamian", "Barbadian", "Trinidadian", "Grenadian", 
        "Saint Lucian", "Vincentian", "Antiguan", "Kittitian", "Other"
    ]
    
    for i in range(n):
        patientID = f"PA{str(i + 1).zfill(4)}"
        firstName = fake.first_name()
        lastName = fake.last_name()
        gender = random.choice(["Male", "Female"])
        nationality = random.choice(nationalities)
        idType = random.choice(["IC", "Passport"])
        
        # Generate proper ID numbers based on type
        if idType == "IC":
            # Malaysian IC format: YYMMDD-PB-XXXX
            year = random.randint(70, 99)  # 1970-1999 for patients (younger than staff)
            month = random.randint(1, 12)
            day = random.randint(1, 28)  # Use 28 to avoid invalid dates
            pb = random.randint(1, 99)
            xxxx = random.randint(1, 9999)
            idNumber = f"{year:02d}{month:02d}{day:02d}-{pb:02d}-{xxxx:04d}"
            # Set DOB to match IC date
            dob_date = date(1900 + year, month, day)
        else:  # Passport
            # Passport format: 1-2 letters + 6-9 digits
            letters = random.choice(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
            if random.random() < 0.5:
                letters = letters + random.choice(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
            digits = random.randint(100000, 999999999)
            idNumber = f"{letters}{digits}"
            # For passport, generate random DOB
            dob_date = fake.date_of_birth(minimum_age=18, maximum_age=50)
        
        # Age calculation based on dob
        today = date.today()
        age = today.year - dob_date.year - ((today.month, today.day) < (dob_date.month, dob_date.day))
        # Convert date to string for the model
        dob = dob_date.strftime('%Y-%m-%d')
        
        # Generate student ID starting from 25WMR00001
        studentId = f"25WMR{str(i + 1).zfill(5)}"
        contactNumber = f"01{random.randint(0, 9)}-{random.randint(1000000, 9999999)}"
        email = fake.email()
        address = fake.street_address() + ", " + fake.city() + ", Malaysia"
        emergencyContactName = fake.name()
        emergencyContactNumber = f"01{random.randint(0, 9)}-{random.randint(1000000, 9999999)}"
        allergies = random.choice(["None", "Penicillin", "Peanuts", "Latex", "Pollen"])
        bloodType = random.choice(["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"])
        password = "Password123!"

        # The following fields are omitted from the schema per your instructions (if present in the model, add here):
        # chronicDiseases, password, registrationDate

        # Compose values in correct order
        values = [
            patientID,  # patientID
            firstName,  # firstName
            lastName,  # lastName
            gender,  # gender
            dob,  # dateOfBirth
            age,  # age
            nationality,  # nationality
            idType,  # idType
            idNumber,  # idNumber
            studentId,  # studentId
            contactNumber,  # contactNumber
            email,  # email
            address,  # address
            emergencyContactName,  # emergencyContactName
            emergencyContactNumber,  # emergencyContactNumber
            allergies,  # allergies
            bloodType,  # bloodType
            password  # password
        ]
        formatted_values = [format_sql_value(v) for v in values]

        insert_stmt = (
            "INSERT INTO Patient (patientID, firstName, lastName, gender, dateOfBirth, age, nationality, idType, idNumber, studentId, contactNumber, email, address, emergencyContactName, emergencyContactNumber, allergies, bloodType, password) "
            f"VALUES ({', '.join(formatted_values)});"
        )
        inserts.append(insert_stmt)

        patient_ids.append(patientID)
    return inserts, patient_ids


def generate_appointment_sql(n=80, patient_ids=None, doctor_ids=None):
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
    # Add a small list of possible reasons
    reasons = [
        "Routine Checkup",
        "Flu Symptoms",
        "Back Pain",
        "Follow-up",
        "Prescription Refill",
        "General Consultation"
    ]
    if not patient_ids:
        return inserts, appointment_ids

    # Generate appointments from January 2025 to December 2025 (1 year only)
    start_date = date(2025, 1, 1)
    end_date = date(2025, 12, 31)

    ap_index = 1
    current = start_date
    statuses_before_sep = ["Cancelled", "Checked-in", "No show"]
    statuses_on_after_sep = ["Cancelled", "Scheduled"]
    while current <= end_date:
        # choose very few slots per day for smaller clinic, and not every day
        if random.random() < 0.3:  # Only 30% of days have appointments
            count = random.randint(1, 2)
        else:
            count = 0
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
            # More realistic status distribution
            if dt.date() < date(2025, 9, 1):
                # Past appointments: mostly completed, some cancelled/no-show
                status = random.choices(statuses_before_sep, weights=[70, 20, 10])[0]
            else:
                # Future appointments: mostly scheduled, some cancelled
                status = random.choices(statuses_on_after_sep, weights=[85, 15])[0]

            reason = random.choice(reasons)
            values = [
                appointmentID,
                patientID,
                dt,
                status,
                random.choice(descriptions),
                reason
            ]
            formatted_values = [format_sql_value(v) for v in values]
            insert_stmt = (
                "INSERT INTO Appointment (appointmentID, patientID, appointmentTime, status, description, reason) "
                f"VALUES ({', '.join(formatted_values)});"
            )
            inserts.append(insert_stmt)
            appointment_ids.append(appointmentID)
            ap_index += 1
        current += timedelta(days=1)

    return inserts, appointment_ids


def generate_consultations(n=200, appointment_ids=None, doctor_ids=None, patient_ids=None, next_ap_index=None):
    records = []
    if not doctor_ids or not patient_ids:
        return records, []

    # starting index for NEW follow-up appointments
    if next_ap_index is not None:
        ap_index = next_ap_index
    else:
        ap_index = (len(appointment_ids) + 1) if appointment_ids else 1

    followup_appt_inserts = []

    # Only Completed or Cancelled status for consultations
    statuses = ["Completed", "Cancelled"]
    mc_index = 1
    for i in range(n):
        consultationID = f"CO{str(i + 1).zfill(4)}"
        patientID = random.choice(patient_ids)
        doctorID = random.choice(doctor_ids)
        staffID = f"ST{str(random.randint(1, 9999)).zfill(4)}"
        symptoms = random.choice([
            "Headache", "Cough", "Fever", "Nausea", "Back pain", "Chest pain", 
            "Dizziness", "Fatigue", "Joint pain", "Skin rash", "Abdominal pain",
            "Shortness of breath", "Insomnia", "Anxiety", "Depression", "Allergic reaction"
        ])
        diagnosis = random.choice([
            "Flu", "Cold", "Diabetes", "Hypertension", "Healthy", "Asthma", 
            "Migraine", "Gastritis", "Dermatitis", "Anxiety", "Depression",
            "Bronchitis", "Sinusitis", "Urinary tract infection", "Conjunctivitis"
        ])
        # Generate consultations from January 2024 to December 2025
        consultationDate = fake.date_between(start_date=date(2024, 1, 1), end_date=date(2025, 12, 31))
        checkInTime = datetime.combine(consultationDate, time(random.randint(8, 16), random.choice([0, 15, 30, 45])))
        status = random.choice(statuses)

        has_mc = random.random() < 0.4  # 40% have MC
        if has_mc:
            mcID = f"MC{str(mc_index).zfill(4)}"
            mc_index += 1
            startDate = consultationDate
            endDate = startDate + timedelta(days=random.randint(1, 5))
        else:
            mcID = None
            startDate = None
            endDate = None

        # random boolean
        is_follow_up_required = random.choice([True, False])

        # create a follow-up appointment if required
        appointmentID = None
        if is_follow_up_required:
            appointmentID = f"AP{str(ap_index).zfill(4)}"
            ap_index += 1
            fu_days = random.randint(7, 14)
            fu_date = consultationDate + timedelta(days=fu_days)
            fu_hour = random.randint(9, 17)
            fu_min = random.choice([0, 30])
            fu_dt = datetime.combine(fu_date, time(fu_hour, fu_min))
            fu_status = "Scheduled"
            fu_description = "Follow-up visit"
            fu_reason = "Follow-up"
            fu_values = [appointmentID, patientID, fu_dt, fu_status, fu_description, fu_reason]
            fu_formatted = [format_sql_value(v) for v in fu_values]
            fu_stmt = (
                "INSERT INTO Appointment (appointmentID, patientID, appointmentTime, status, description, reason) "
                f"VALUES ({', '.join(fu_formatted)});"
            )
            followup_appt_inserts.append(fu_stmt)

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
            'isFollowUpRequired': is_follow_up_required,
            'mcID': mcID,
            'startDate': startDate,
            'endDate': endDate,
            'appointmentID': appointmentID
        })

    return records, followup_appt_inserts


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
            c['isFollowUpRequired'],
            c['mcID'],
            c['startDate'],
            c['endDate'],
            c['appointmentID']
        ]
        formatted_values = [format_sql_value(v) for v in values]
        stmt = (
            "INSERT INTO Consultation (consultationID, patientID, doctorID, staffID, billID, symptoms, diagnosis, consultationDate, checkInTime, status, isFollowUpRequired, mcID, startDate, endDate, appointmentID) "
            f"VALUES ({', '.join(formatted_values)});"
        )
        inserts.append(stmt)
    return inserts

def generate_treatment_sql(consultations):
    """
    Generate 0–1 simple treatment aligned with diagnosis, now with a `price` column.
    Price is computed from TREATMENT_PRICING by treatmentType: base + per_min * duration.
    """
    inserts = []
    tr_index = 1
    treatment_totals_by_consultation = {}

    TREATMENT_BY_DX = {
        "Back pain": [
            ("Physical Therapy", "Back Strengthening", "Therapeutic exercises for lower back pain", "Guided exercises and stretching"),
            ("Physiotherapy", "Spinal Mobilization", "Manual therapy for back pain relief", "Hands-on treatment session")
        ],
        "Flu": [
            ("Medication", "Symptomatic Care", "Antipyretics and cough suppressant as needed", "Dispense and counsel"),
            ("Diagnostics", "Flu Test", "Rapid influenza test to confirm diagnosis", "Nasal swab test")
        ],
        "Cold": [
            ("Medication", "Symptomatic Care", "Antipyretics and antihistamine as needed", "Dispense and counsel"),
            ("Counseling", "Rest and Recovery", "Advice on rest and symptom management", "15-minute counseling")
        ],
        "Hypertension": [
            ("Counseling", "Lifestyle Counseling", "Diet & exercise counseling", "30-minute counseling session"),
            ("Diagnostics", "Blood Pressure Monitoring", "24-hour BP monitoring", "Ambulatory monitoring")
        ],
        "Diabetes": [
            ("Counseling", "Dietary Counseling", "Diet plan and glucose monitoring education", "30-minute counseling session"),
            ("Diagnostics", "Blood Sugar Test", "HbA1c and glucose monitoring", "Laboratory tests")
        ],
        "Asthma": [
            ("Medication", "Inhaler Training", "Proper inhaler technique training", "Hands-on training session"),
            ("Diagnostics", "Lung Function Test", "Spirometry to assess lung function", "Breathing test")
        ],
        "Migraine": [
            ("Medication", "Pain Management", "Prescription of migraine medication", "Medication dispense"),
            ("Counseling", "Trigger Management", "Identify and avoid migraine triggers", "Lifestyle counseling")
        ],
        "Gastritis": [
            ("Medication", "Acid Suppression", "Proton pump inhibitor therapy", "Medication dispense"),
            ("Counseling", "Diet Modification", "Dietary changes for gastritis", "Nutrition counseling")
        ],
        "Dermatitis": [
            ("Medication", "Topical Treatment", "Cream and ointment application", "Topical medication"),
            ("Counseling", "Skin Care", "Proper skin care routine", "Skincare education")
        ],
        "Anxiety": [
            ("Counseling", "Cognitive Behavioral Therapy", "CBT session for anxiety management", "Therapy session"),
            ("Medication", "Anti-anxiety Medication", "Prescription of anxiolytics", "Medication dispense")
        ],
        "Depression": [
            ("Counseling", "Psychotherapy", "Talk therapy for depression", "Therapy session"),
            ("Medication", "Antidepressant", "Prescription of antidepressants", "Medication dispense")
        ],
        "Bronchitis": [
            ("Medication", "Antibiotic Therapy", "Antibiotics for bacterial bronchitis", "Medication dispense"),
            ("Diagnostics", "Chest X-ray", "Imaging to rule out pneumonia", "Radiological examination")
        ],
        "Sinusitis": [
            ("Medication", "Decongestant Therapy", "Nasal decongestants and antibiotics", "Medication dispense"),
            ("Diagnostics", "Sinus CT", "Imaging of sinuses", "Radiological examination")
        ],
        "Urinary tract infection": [
            ("Medication", "Antibiotic Therapy", "Antibiotics for UTI treatment", "Medication dispense"),
            ("Diagnostics", "Urine Culture", "Bacterial culture and sensitivity", "Laboratory test")
        ],
        "Conjunctivitis": [
            ("Medication", "Eye Drops", "Antibiotic eye drops", "Topical medication"),
            ("Counseling", "Eye Care", "Proper eye hygiene instructions", "Education session")
        ],
        "Nausea": [
            ("Diagnostics", "Hydration/Observation", "Assess dehydration; consider ORS", "Monitor and advise"),
            ("Medication", "Antiemetic", "Anti-nausea medication", "Medication dispense")
        ],
        "Fever": [
            ("Diagnostics", "Basic Investigations", "Rule out infection focus", "Order labs if indicated"),
            ("Medication", "Antipyretic", "Fever-reducing medication", "Medication dispense")
        ],
        "Healthy": [],
    }

    status_options = ["In Progress", "Completed", "Cancelled"]
    completed_outcomes = ["Successful", "Partial Success", "Unsuccessful", "Complications", "Patient Discontinued"]

    for c in consultations:
        dx = c['diagnosis']
        options = TREATMENT_BY_DX.get(dx, [])
        count = 0 if not options else 1  # 0 or 1 aligned treatment
        consultation_total = 0.0
        
        for _ in range(count):
            treatment_id = f"TR{str(tr_index).zfill(4)}"
            tr_index += 1

            ttype, tname, tdesc, tproc = random.choice(options)
            base_date = c['consultationDate']
            tr_hour = random.randint(8, 18)
            tr_min = random.choice([0, 15, 30, 45])
            t_datetime = datetime.combine(base_date, time(tr_hour, tr_min))

            # Set status based on treatment date (September 2025 as cutoff)
            september_2025 = date(2025, 9, 1)
            if base_date >= september_2025:
                # After September 2025: Only In Progress
                status = "In Progress"
            else:
                # Before September 2025: Mostly Completed, some Cancelled
                status = random.choices(["Completed", "Cancelled"], weights=[85, 15])[0]

            outcome = random.choice(completed_outcomes) if status == "Completed" else None
            duration = random.randint(15, 60)
            notes = f"Treatment aligned to diagnosis: {dx}"

            # --- NEW: price calculation ---
            rule = TREATMENT_PRICING.get(ttype, {"base": 30.0, "per_min": 0.0})
            price = round(rule["base"] + rule["per_min"] * duration, 2)
            consultation_total += price

            # IMPORTANT: Adjust column order below to match your DB schema.
            # This assumes the table columns are:
            # (treatmentID, consultationID, patientID, treatmentType, treatmentName,
            #  description, treatmentProcedure, treatmentDate, status, outcome, duration, price, notes)
            values = [
                treatment_id,
                c['consultationID'],
                c['patientID'],
                ttype,
                tname,
                tdesc,
                tproc,
                t_datetime,
                status,
                outcome,
                duration,
                price,
                notes,
            ]
            formatted = [format_sql_value(v) for v in values]
            stmt = (
                "INSERT INTO Treatment (treatmentID, consultationID, patientID, treatmentType, treatmentName, description, treatmentProcedure, treatmentDate, status, outcome, duration, price, notes) "
                f"VALUES ({', '.join(formatted)});"
            )
            inserts.append(stmt)
        
        # Store total for this consultation
        treatment_totals_by_consultation[c['consultationID']] = consultation_total

    return inserts, treatment_totals_by_consultation

# --- Bill generation from consultation totals ---
def generate_bill_sql(totals_by_consultation, treatment_totals_by_consultation):
    inserts = []
    bill_ids = []
    bill_map = {}
    payment_methods = ["Cash", "Credit Card", "Debit Card"]

    idx = 1
    for consultation_id, med_total in totals_by_consultation.items():
        bill_id = f"BI{str(idx).zfill(4)}"
        treatment_total = treatment_totals_by_consultation.get(consultation_id, 0.0)
        total_amount = round(med_total + treatment_total + 20.0, 2)  # medicine total + treatment total + consultation fee (20)
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


def generate_medicine_sql(n=0):
    """
    Ignores n; uses MED_CATALOG for deterministic, realistic medicines.
    Returns (insert_stmts, price_map{medID->unit_price}, name_to_id{name->medID})
    """
    inserts = []
    price_map = {}
    name_to_id = {}

    for i, (name, desc, unit_price, dosage_unit, form) in enumerate(MED_CATALOG, start=1):
        medicine_id = f"ME{str(i).zfill(4)}"
        # Match the Medicine model: medicineID, medicineName, description, unit, reorderLevel, sellingPrice
        values = [medicine_id, name, desc, form, 20, round(unit_price, 2)]  # form is the unit
        formatted_values = [format_sql_value(v) for v in values]
        stmt = (
            "INSERT INTO Medicine (medicineID, medicineName, description, unit, reorderLevel, sellingPrice) "
            f"VALUES ({', '.join(formatted_values)});"
        )
        inserts.append(stmt)
        price_map[medicine_id] = round(unit_price, 2)
        name_to_id[name] = medicine_id

    return inserts, price_map, name_to_id


def main():
    staff_inserts, staff_ids, doctor_ids = generate_staff_sql(15)  # 10 doctors + 5 admin
    patient_inserts, patient_ids = generate_patient_sql(100)
    appointment_inserts, appointment_ids = generate_appointment_sql(80, patient_ids, doctor_ids)

    for stmt in staff_inserts:
        print(stmt)
    for stmt in patient_inserts:
        print(stmt)
    for stmt in appointment_inserts:
        print(stmt)

    # Suppliers
    supplier_inserts, supplier_ids = generate_supplier_sql(5)
    for stmt in supplier_inserts:
        print(stmt)

    # Realistic medicines (deterministic IDs ME0001..)
    medicine_inserts, price_map, name_to_id = generate_medicine_sql()
    for stmt in medicine_inserts:
        print(stmt)

    consultations, followup_appt_inserts = generate_consultations(
        200, appointment_ids, doctor_ids, patient_ids, next_ap_index=(len(appointment_ids) + 1)
    )
    consultation_ids = [c['consultationID'] for c in consultations]

    for stmt in followup_appt_inserts:
        print(stmt)

    # Prescriptions consistent with diagnosis (build totals for bills)
    prescription_inserts, totals_by_consultation = generate_prescription_sql(consultations, name_to_id, price_map)

    # Treatments aligned with diagnosis (generate first to get treatment totals)
    treatment_inserts, treatment_totals_by_consultation = generate_treatment_sql(consultations)
    for stmt in treatment_inserts:
        print(stmt)

    # Bills (+20 consultation fee) and write back to consultation via bill_map
    bill_inserts, bill_ids, bill_map = generate_bill_sql(totals_by_consultation, treatment_totals_by_consultation)
    for stmt in bill_inserts:
        print(stmt)

    # Consultations with the correct billID
    consultation_inserts = render_consultation_inserts(consultations, bill_map)
    for stmt in consultation_inserts:
        print(stmt)

    # Finally, prescriptions (after consultations/bills)
    for stmt in prescription_inserts:
        print(stmt)

    # Schedules (July–Sept) and Orders (use real med IDs length)
    schedule_inserts = generate_schedule_sql(doctor_ids)
    for stmt in schedule_inserts:
        print(stmt)

    med_ids_for_orders = [f"ME{str(i+1).zfill(4)}" for i in range(len(MED_CATALOG))]
    order_inserts = generate_order_sql(30, med_ids_for_orders, supplier_ids, staff_ids)
    for stmt in order_inserts:
        print(stmt)

def generate_prescription_sql(consultations, name_to_id, price_map):
    """
    Generate 0–3 prescriptions per consultation, choosing medicines appropriate to diagnosis.
    Returns (list_of_insert_statements, totals_by_consultation)
    """
    prescriptions = []
    totals_by_consultation = {}
    pr_index = 1

    instruction_options = [
        "Take on empty stomach",
        "Take with food",
        "Take before meals",
        "Take after meals",
        "Take with plenty of water",
        "Take at bedtime",
        "Take as needed",
    ]

    for c in consultations:
        diagnosis = c['diagnosis']
        options = DIAGNOSIS_TO_MEDS.get(diagnosis, [])

        if diagnosis == "Healthy":
            num_meds = 0
        else:
            num_meds = random.randint(1, min(3, len(options))) if options else random.randint(0, 2)

        chosen = random.sample(options, k=num_meds) if len(options) >= num_meds else options

        for med_name in chosen:
            med_id = name_to_id.get(med_name)
            if not med_id:
                continue
            unit_price = price_map.get(med_id, 10.0)

            prescription_id = f"PR{str(pr_index).zfill(4)}"
            pr_index += 1

            # Simple rules by form
            is_syrup = "Syrup" in med_name
            is_inhaler = "Inhaler" in med_name
            is_tube = "Gel" in med_name or "tube" in med_name

            dosage = 1 if (is_syrup or is_inhaler) else random.choice([1, 1, 2])
            serving_per_day = 3 if is_syrup else random.choice([1, 2, 2, 3])
            quantity_dispensed = 1 if (is_inhaler or is_tube) else random.randint(5, 20)
            dosage_unit = next((du for (n, _, _, du, _) in MED_CATALOG if n == med_name), "tablet")
            instruction = random.choice(instruction_options)
            description = f"Medication for {diagnosis.lower()}"

            # Bill total per consultation: qty * unit price
            totals_by_consultation[c['consultationID']] = totals_by_consultation.get(
                c['consultationID'], 0.0
            ) + (quantity_dispensed * unit_price)

            values = [
                prescription_id, c['consultationID'], med_id, description,
                dosage, instruction, serving_per_day, quantity_dispensed,
                round(unit_price, 2), dosage_unit
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
            
            # Randomly assign second doctor (30% chance)
            doctor_id2 = None
            if random.random() < 0.3 and len(doctor_ids) > 1:
                other_doctors = [d for d in doctor_ids if d != doctor_id]
                if other_doctors:
                    doctor_id2 = random.choice(other_doctors)
            
            stmt_m = (
                "INSERT INTO Schedule (scheduleID, doctorID1, doctorID2, date, startTime, endTime, shift) "
                f"VALUES ('{schedule_id_m}', '{doctor_id}', {format_sql_value(doctor_id2)}, '{current_date}', "
                f"'{start_time_m.strftime('%Y-%m-%d %H:%M:%S')}', '{end_time_m.strftime('%Y-%m-%d %H:%M:%S')}', 'Morning');"
            )
            inserts.append(stmt_m)
            schedule_index += 1

            # Evening shift 14:00 - 20:00
            schedule_id_e = f"SC{str(schedule_index).zfill(4)}"
            start_time_e = datetime.combine(current_date, time(14, 0))
            end_time_e = datetime.combine(current_date, time(20, 0))
            
            # Randomly assign second doctor (30% chance)
            doctor_id2_evening = None
            if random.random() < 0.3 and len(doctor_ids) > 1:
                other_doctors = [d for d in doctor_ids if d != doctor_id]
                if other_doctors:
                    doctor_id2_evening = random.choice(other_doctors)
            
            stmt_e = (
                "INSERT INTO Schedule (scheduleID, doctorID1, doctorID2, date, startTime, endTime, shift) "
                f"VALUES ('{schedule_id_e}', '{doctor_id}', {format_sql_value(doctor_id2_evening)}, '{current_date}', "
                f"'{start_time_e.strftime('%Y-%m-%d %H:%M:%S')}', '{end_time_e.strftime('%Y-%m-%d %H:%M:%S')}', 'Evening');"
            )
            inserts.append(stmt_e)
            schedule_index += 1

        current_date += timedelta(days=1)

    return inserts


# --- Supplier generation ---
def generate_supplier_sql(n=8):
    inserts = []
    supplier_ids = []
    for i in range(n):
        supplier_id = f"SU{str(i + 1).zfill(4)}"
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
def generate_order_sql(n=30, medicine_ids=None, supplier_ids=None, staff_ids=None):
    inserts = []
    medicine_ids = medicine_ids or [f"ME{str(i + 1).zfill(4)}" for i in range(n)]
    supplier_ids = supplier_ids or [f"SU{str(i + 1).zfill(4)}" for i in range(n)]
    staff_ids = staff_ids or [f"ST{str(i + 1).zfill(4)}" for i in range(n)]

    for i in range(n):
        order_id = f"OR{str(i + 1).zfill(4)}"
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

        # Use realistic medicine prices from MED_CATALOG
        medicine_name = None
        for med_id in medicine_ids:
            if med_id == medicine_id:
                # Find the medicine name from MED_CATALOG
                for i, (name, _, price, _, _) in enumerate(MED_CATALOG, 1):
                    if f"ME{str(i).zfill(4)}" == medicine_id:
                        medicine_name = name
                        unit_price = price
                        break
                break
        
        if not medicine_name:
            unit_price = round(random.uniform(5.0, 50.0), 2)
        
        # Ensure sufficient stock (at least 100 non-expired units per medicine)
        quantity = random.randint(200, 500)  # Larger quantities
        total_amount = round(unit_price * quantity, 2)
        
        # Set expiry date to ensure at least 100 non-expired units
        # Most orders should expire after current date
        if random.random() < 0.8:  # 80% chance of future expiry
            expiry_date = fake.date_between(start_date='+6M', end_date='+2y')
        else:
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