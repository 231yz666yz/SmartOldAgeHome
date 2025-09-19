/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */

 -- Q!: List all patients name and ages 
SELECT name, age FROM patients;

 -- Q2: List all doctors specializing in 'Cardiology'
SELECT name FROM doctors WHERE specialization = 'Cardiology';


 
 -- Q3: Find all patients that are older than 80
SELECT * FROM patients WHERE age > 80;




-- Q4: List all the patients ordered by their age (youngest first)
SELECT * FROM patients ORDER BY age ASC;





-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(*) AS doctor_count FROM doctors GROUP BY specialization;



-- Q6: List patients and their doctors' names
SELECT p.name, d.name 
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;


-- Q7: Show treatments along with patient names and doctor names
SELECT 
    t.treatment_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    t.treatment_type,
    t.treatment_time
FROM 
    treatments t
JOIN 
    patients p ON t.patient_id = p.patient_id
JOIN 
    doctors d ON p.doctor_id = d.doctor_id
ORDER BY 
    t.treatment_time DESC;


-- Q8: Count how many patients each doctor supervises
SELECT d.name, COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name;


-- Q9: List the average age of patients and display it as average_age
SELECT AVG(age) AS average_age FROM patients;


-- Q10: Find the most common treatment type, and display only that
SELECT treatment_type, COUNT(*) AS treatment_count
FROM treatments
GROUP BY treatment_type
HAVING COUNT(*) = (
    SELECT MAX(count) FROM (
        SELECT COUNT(*) AS count FROM treatments GROUP BY treatment_type
    ) AS subquery
);


-- Q11: List patients who are older than the average age of all patients
SELECT * FROM patients
WHERE age > (SELECT AVG(age) FROM patients);


-- Q12: List all the doctors who have more than 5 patients
SELECT d.name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 5;



-- Q13: List all the treatments that are provided by nurses that work in the morning shift. List patient name as well. 
SELECT t.treatment_id, t.treatment_type, p.name, n.name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'morning';



-- Q14: Find the latest treatment for each patient
SELECT t1.*, p.name
FROM treatments t1
JOIN patients p ON t1.patient_id = p.patient_id
WHERE t1.treatment_time = (
    SELECT MAX(t2.treatment_time)
    FROM treatments t2
    WHERE t2.patient_id = t1.patient_id
);


-- Q15: List all the doctors and average age of their patients
SELECT d.name, AVG(p.age) AS average_patient_age
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name;


-- Q16: List the names of the doctors who supervise more than 3 patients
ELECT d.name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(p.patient_id) > 3;


-- Q17: List all the patients who have not received any treatments (HINT: Use NOT IN)
SELECT * FROM patients
WHERE patient_id NOT IN (
    SELECT DISTINCT patient_id FROM treatments
);



-- Q18: List all the medicines whose stock (quantity) is less than the average stock
SELECT * FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);



-- Q19: For each doctor, rank their patients by age
SELECT 
    d.name,
    p.name,
    p.age,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age) AS age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
ORDER BY d.doctor_id, age_rank;

-- Q20: For each specialization, find the doctor with the oldest patient
WITH doctor_oldest_patient AS (
    SELECT 
        d.doctor_id,
        d.name,
        d.specialization,
        MAX(p.age) AS max_patient_age
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
    GROUP BY d.doctor_id, d.name, d.specialization
)
SELECT 
    specialization,
    name,
    max_patient_age
FROM doctor_oldest_patient dop
WHERE (specialization, max_patient_age) IN (
    SELECT specialization, MAX(max_patient_age)
    FROM doctor_oldest_patient
    GROUP BY specialization
);





