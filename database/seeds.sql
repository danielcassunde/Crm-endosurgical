-- CRM Endosurgical Database - Sample Data
-- Created: 2026-05-18

-- Insert Sample Users
INSERT INTO users (email, password_hash, full_name, role, phone, is_active) VALUES
('admin@endosurgical.com.br', '$2b$10$hashedpassword1', 'Administrador Sistema', 'admin', '11988887777', true),
('dr.silva@endosurgical.com.br', '$2b$10$hashedpassword2', 'Dr. Carlos Silva', 'doctor', '11987776666', true),
('dr.santos@endosurgical.com.br', '$2b$10$hashedpassword3', 'Dra. Ana Santos', 'doctor', '11987775555', true),
('secretaria@endosurgical.com.br', '$2b$10$hashedpassword4', 'Maria Secretária', 'secretary', '11987774444', true),
('joao.patient@email.com', '$2b$10$hashedpassword5', 'João Silva', 'patient', '11987773333', true),
('maria.patient@email.com', '$2b$10$hashedpassword6', 'Maria Santos', 'patient', '11987772222', true);

-- Insert Doctors
INSERT INTO doctors (user_id, crm, specialty, phone, email, address, city, state, zip_code, bio) VALUES
((SELECT id FROM users WHERE email = 'dr.silva@endosurgical.com.br'), 
 '123456/SP', 'Cirurgia Endoscópica', '11987776666', 'dr.silva@endosurgical.com.br',
 'Av. Paulista, 1000', 'São Paulo', 'SP', '01311100',
 'Cirurgião especializado em endoscopia com 15 anos de experiência'),

((SELECT id FROM users WHERE email = 'dr.santos@endosurgical.com.br'),
 '654321/SP', 'Cirurgia Videolaparoscópica', '11987775555', 'dr.santos@endosurgical.com.br',
 'Av. Brasil, 2000', 'São Paulo', 'SP', '03125100',
 'Especialista em cirurgias minimamente invasivas');

-- Insert Insurance Plans
INSERT INTO insurance_plans (name, cnpj, phone, email, address, city, state, zip_code) VALUES
('SulAmérica Saúde', '00000000000001', '1133334444', 'contato@sulamerica.com.br', 'Rua A, 100', 'São Paulo', 'SP', '01000000'),
('Unimed São Paulo', '00000000000002', '1144445555', 'contato@unimed.com.br', 'Rua B, 200', 'São Paulo', 'SP', '02000000'),
('Bradesco Saúde', '00000000000003', '1155556666', 'contato@bradesco.com.br', 'Rua C, 300', 'São Paulo', 'SP', '03000000');

-- Insert Patients
INSERT INTO patients (user_id, cpf, date_of_birth, gender, phone, email, address, city, state, zip_code, emergency_contact_name, emergency_contact_phone, medical_history, allergies, current_medications) VALUES
((SELECT id FROM users WHERE email = 'joao.patient@email.com'),
 '12345678901', '1980-05-15', 'M', '11987773333', 'joao.patient@email.com',
 'Rua Paciente, 50', 'São Paulo', 'SP', '04000000',
 'Maria Silva', '11987770000',
 'Histórico de gastrite, cirurgias prévias: apendicectomia em 2010',
 'Penicilina, Sulfa', 'Omeprazol 20mg, Losartana 50mg'),

((SELECT id FROM users WHERE email = 'maria.patient@email.com'),
 '98765432109', '1975-11-22', 'F', '11987772222', 'maria.patient@email.com',
 'Rua Saúde, 75', 'São Paulo', 'SP', '05000000',
 'João Santos', '11987771111',
 'Hipertensão controlada, diabetes tipo 2',
 'Dipirona', 'Metformina 1000mg, Atenolol 50mg');

-- Insert Patient Insurance
INSERT INTO patient_insurance (patient_id, insurance_id, policy_number, policy_holder_name, status, start_date, end_date) VALUES
((SELECT id FROM patients WHERE cpf = '12345678901'), 
 (SELECT id FROM insurance_plans WHERE name = 'SulAmérica Saúde'),
 'POL123456789', 'João Silva', 'active', '2024-01-01', '2025-12-31'),

((SELECT id FROM patients WHERE cpf = '98765432109'),
 (SELECT id FROM insurance_plans WHERE name = 'Unimed São Paulo'),
 'POL987654321', 'Maria Santos', 'active', '2024-06-01', '2026-05-31');

-- Insert Procedures
INSERT INTO procedures (name, code, description, estimated_duration_minutes, category, requires_hospitalization) VALUES
('Colangiopancreatografia Endoscópica Retrógrada - CPRE', '25010', 'Procedimento endoscópico para diagnóstico e tratamento de patologias das vias biliar', 60, 'Endoscopia', false),
('Colecistectomia Videolaparoscópica', '25002', 'Remoção da vesícula biliar por técnica minimamente invasiva', 45, 'Videolaparoscopia', true),
('Gastrectomia Parcial por Videolaparoscopia', '25003', 'Remoção parcial do estômago por técnica minimamente invasiva', 90, 'Videolaparoscopia', true),
('Esofagectomia por Videotoracoscopia', '25004', 'Remoção do esôfago por técnica minimamente invasiva', 120, 'Videotoracoscopia', true),
('Hérnia Hiatal - Fundoplicatura por Videolaparoscopia', '25005', 'Correção de hérnia hiatal com fundoplicatura', 75, 'Videolaparoscopia', true);

-- Insert Appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, duration_minutes, type, status, notes) VALUES
((SELECT id FROM patients WHERE cpf = '12345678901'),
 (SELECT id FROM doctors WHERE crm = '123456/SP'),
 '2026-06-01 10:00:00', 30, 'consultation', 'completed',
 'Avaliação inicial. Paciente com dor epigástrica intermitente. Solicitado CPRE.'),

((SELECT id FROM patients WHERE cpf = '98765432109'),
 (SELECT id FROM doctors WHERE crm = '654321/SP'),
 '2026-06-05 14:30:00', 45, 'procedure', 'scheduled',
 'Videolaparoscopia diagnóstica para avaliação de alteração hepática.');

-- Insert Surgeries
INSERT INTO surgeries (patient_id, doctor_id, procedure_id, surgery_date, start_time, end_time, location, anesthesia_type, surgical_findings, complications, status) VALUES
((SELECT id FROM patients WHERE cpf = '12345678901'),
 (SELECT id FROM doctors WHERE crm = '123456/SP'),
 (SELECT id FROM procedures WHERE code = '25010'),
 '2026-06-15', '08:00:00', '09:15:00',
 'Centro Cirúrgico - Sala 3', 'Sedação profunda',
 'CPRE com sucesso. Papilose comum dilatada. Esfíncter de Oddi relaxado. Cálculo biliar removido.',
 'Nenhuma',
 'completed'),

((SELECT id FROM patients WHERE cpf = '98765432109'),
 (SELECT id FROM doctors WHERE crm = '654321/SP'),
 (SELECT id FROM procedures WHERE code = '25002'),
 '2026-06-20', '09:00:00', '10:15:00',
 'Centro Cirúrgico - Sala 1', 'Anestesia geral',
 'Colecistectomia videolaparoscópica sem intercorrências. Vesícula inflamada com cálculos.',
 'Nenhuma',
 'completed');

-- Insert Medical Records
INSERT INTO medical_records (patient_id, doctor_id, record_type, diagnosis, treatment_plan, medications, next_appointment, attachments) VALUES
((SELECT id FROM patients WHERE cpf = '12345678901'),
 (SELECT id FROM doctors WHERE crm = '123456/SP'),
 'diagnosis', 'Coledocolitíase com obstrução biliar',
 'CPRE com papilotomia e remoção de cálculo. Dieta branda. Seguimento em 7 dias.',
 'Omeprazol 40mg 1x ao dia, Buscopan 10mg 2x ao dia por 5 dias',
 '2026-06-22', '{"exames": ["Ultrassom", "Ressonância"], "imagens": true}'),

((SELECT id FROM patients WHERE cpf = '98765432109'),
 (SELECT id FROM doctors WHERE crm = '654321/SP'),
 'surgery', 'Colecistite crônica calculosa',
 'Colecistectomia videolaparoscópica com sucesso. Analgesia pós-operatória. Alta hospitalar em 24h.',
 'Dipirona 500mg 3x ao dia por 10 dias, Ciprofloxacino 500mg 2x ao dia por 7 dias',
 '2026-06-27', '{"laudo_patologia": "Vesícula inflamada, mucosa com pólipos", "anatomopatológico": "Colecistite crônica"}');

-- Insert Billing Records
INSERT INTO billing (patient_id, appointment_id, surgery_id, amount, insurance_id, payment_method, status, payment_date, due_date, notes) VALUES
((SELECT id FROM patients WHERE cpf = '12345678901'),
 (SELECT id FROM appointments WHERE patient_id = (SELECT id FROM patients WHERE cpf = '12345678901') LIMIT 1),
 NULL,
 500.00,
 (SELECT id FROM insurance_plans WHERE name = 'SulAmérica Saúde'),
 'insurance',
 'paid',
 '2026-06-02',
 '2026-06-10',
 'Consulta inicial - Cobertura 100% convênio'),

((SELECT id FROM patients WHERE cpf = '98765432109'),
 NULL,
 (SELECT id FROM surgeries WHERE patient_id = (SELECT id FROM patients WHERE cpf = '98765432109') LIMIT 1),
 3500.00,
 (SELECT id FROM insurance_plans WHERE name = 'Unimed São Paulo'),
 'insurance',
 'pending',
 NULL,
 '2026-07-20',
 'Colecistectomia videolaparoscópica - aguardando aprovação convênio');

-- Insert Activity Logs
INSERT INTO activity_logs (user_id, action, entity_type, entity_id, description, ip_address, user_agent) VALUES
((SELECT id FROM users WHERE email = 'admin@endosurgical.com.br'),
 'CREATE',
 'appointment',
 (SELECT id FROM appointments LIMIT 1),
 'Criada nova consulta para João Silva',
 '192.168.1.100',
 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),

((SELECT id FROM users WHERE email = 'dr.silva@endosurgical.com.br'),
 'UPDATE',
 'surgery',
 (SELECT id FROM surgeries LIMIT 1),
 'Atualizado relatório cirúrgico com achados finais',
 '192.168.1.101',
 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)'),

((SELECT id FROM users WHERE email = 'secretaria@endosurgical.com.br'),
 'UPDATE',
 'billing',
 (SELECT id FROM billing LIMIT 1),
 'Registrado pagamento de consulta - João Silva',
 '192.168.1.102',
 'Mozilla/5.0 (X11; Linux x86_64)');
