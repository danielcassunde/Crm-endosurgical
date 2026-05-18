# 📊 CRM Endosurgical - Documentação do Banco de Dados

## 📋 Visão Geral

Este banco de dados foi projetado especificamente para gerenciar um CRM (Customer Relationship Management) para clínicas de endocirurgia. Utiliza PostgreSQL com suporte a UUIDs, garantindo escalabilidade, segurança e performance.

---

## 🗂️ Estrutura das Tabelas

### 1. **users** - Controle de Acesso
Gerencia todos os usuários do sistema com diferentes roles.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `email` | VARCHAR | Email único para login |
| `password_hash` | VARCHAR | Senha criptografada |
| `full_name` | VARCHAR | Nome completo |
| `role` | VARCHAR | admin, doctor, secretary, patient |
| `phone` | VARCHAR | Telefone de contato |
| `is_active` | BOOLEAN | Status ativo/inativo |

**Roles disponíveis:**
- `admin` - Acesso total ao sistema
- `doctor` - Acesso a consultas, cirurgias, prontuários
- `secretary` - Gerenciamento de agendamentos e pacientes
- `patient` - Acesso próprio aos registros

---

### 2. **doctors** - Dados dos Médicos
Informações profissionais dos cirurgiões.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `user_id` | UUID | Referência para users |
| `crm` | VARCHAR | CRM do médico (único) |
| `specialty` | VARCHAR | Especialidade (ex: Endocirurgia) |
| `phone` | VARCHAR | Telefone de contato |
| `email` | VARCHAR | Email profissional |
| `address` | VARCHAR | Endereço do consultório |
| `bio` | TEXT | Biografia/Experiência |

---

### 3. **patients** - Dados dos Pacientes
Informações pessoais e médicas dos pacientes.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `user_id` | UUID | Referência para users |
| `cpf` | VARCHAR | CPF único |
| `date_of_birth` | DATE | Data de nascimento |
| `gender` | VARCHAR | Gênero |
| `emergency_contact_name` | VARCHAR | Contato de emergência |
| `medical_history` | TEXT | Histórico médico |
| `allergies` | TEXT | Alergias conhecidas |
| `current_medications` | TEXT | Medicações em uso |

---

### 4. **insurance_plans** - Planos de Saúde
Cadastro de convênios e seguros.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `name` | VARCHAR | Nome do plano |
| `cnpj` | VARCHAR | CNPJ do convênio |
| `phone` | VARCHAR | Telefone para contato |
| `email` | VARCHAR | Email da operadora |

---

### 5. **patient_insurance** - Relação Paciente x Seguros
Associação entre pacientes e seus planos de saúde (many-to-many).

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `patient_id` | UUID | Referência ao paciente |
| `insurance_id` | UUID | Referência ao plano |
| `policy_number` | VARCHAR | Número da apólice |
| `policy_holder_name` | VARCHAR | Titular da apólice |
| `status` | VARCHAR | active, inactive, expired |

---

### 6. **appointments** - Agendamentos
Gerenciamento de consultas e procedimentos agendados.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `patient_id` | UUID | Paciente da consulta |
| `doctor_id` | UUID | Médico responsável |
| `appointment_date` | TIMESTAMP | Data e hora da consulta |
| `type` | VARCHAR | consultation, procedure, follow-up, exam |
| `status` | VARCHAR | scheduled, completed, cancelled, no-show |
| `duration_minutes` | INTEGER | Duração estimada |
| `notes` | TEXT | Observações |

---

### 7. **procedures** - Catálogo de Procedimentos
Procedimentos disponíveis na clínica.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `name` | VARCHAR | Nome do procedimento |
| `code` | VARCHAR | Código único (TUSS/AMB) |
| `description` | TEXT | Descrição detalhada |
| `estimated_duration_minutes` | INTEGER | Duração média |
| `requires_hospitalization` | BOOLEAN | Requer internação? |
| `category` | VARCHAR | Categoria (Endoscópico, Videolaparoscópico, etc) |

---

### 8. **surgeries** - Registro de Cirurgias
Detalhamento completo das cirurgias realizadas.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `patient_id` | UUID | Paciente |
| `doctor_id` | UUID | Cirurgião responsável |
| `procedure_id` | UUID | Procedimento realizado |
| `surgery_date` | TIMESTAMP | Data da cirurgia |
| `start_time` | TIMESTAMP | Horário de início |
| `end_time` | TIMESTAMP | Horário de término |
| `anesthesia_type` | VARCHAR | Tipo de anestesia |
| `surgical_findings` | TEXT | Achados cirúrgicos |
| `complications` | TEXT | Complicações (se houver) |
| `status` | VARCHAR | scheduled, completed, cancelled |

---

### 9. **medical_records** - Prontuário Eletrônico
Registros de consultas e histórico médico.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `patient_id` | UUID | Paciente |
| `doctor_id` | UUID | Médico responsável |
| `record_type` | VARCHAR | consultation, exam, diagnosis, treatment, surgery |
| `diagnosis` | TEXT | Diagnóstico |
| `treatment_plan` | TEXT | Plano de tratamento |
| `medications` | TEXT | Medicações prescritas |
| `next_appointment` | DATE | Próxima consulta agendada |
| `attachments` | JSONB | Arquivos anexados (documentos, imagens) |

---

### 10. **billing** - Faturamento
Sistema de pagamentos e faturas.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `patient_id` | UUID | Paciente |
| `appointment_id` | UUID | Consulta/Procedimento |
| `surgery_id` | UUID | Cirurgia |
| `amount` | DECIMAL | Valor em reais |
| `insurance_id` | UUID | Convênio (se aplicável) |
| `payment_method` | VARCHAR | cash, credit_card, debit_card, insurance, check, pix |
| `status` | VARCHAR | pending, paid, cancelled, refunded |
| `payment_date` | TIMESTAMP | Data do pagamento |
| `due_date` | DATE | Data de vencimento |

---

### 11. **activity_logs** - Auditoria
Rastreamento de todas as ações do sistema.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `user_id` | UUID | Usuário que realizou a ação |
| `action` | VARCHAR | CREATE, UPDATE, DELETE, LOGIN |
| `entity_type` | VARCHAR | Tipo de entidade afetada |
| `entity_id` | UUID | ID da entidade |
| `description` | TEXT | Descrição detalhada |
| `ip_address` | VARCHAR | IP do usuário |
| `user_agent` | TEXT | Navegador/Cliente |

---

## 🔗 Relacionamentos Principais

```
users
├── doctors (1:1 via user_id)
├── patients (1:1 via user_id)
└── activity_logs (1:M)

patients (1:M)
├── appointments
├── surgeries
├── medical_records
├── billing
└── patient_insurance (M:M com insurance_plans)

doctors (1:M)
├── appointments
├── surgeries
└── medical_records

appointments
├── billing (1:1)
└── medical_records (opcional)

surgeries
├── procedures (M:1)
└── billing (1:1)

insurance_plans (1:M)
└── billing
```

---

## 🔐 Segurança

- **UUIDs** para todos os IDs (não sequenciais, difícil de adivinhar)
- **Password Hash** em vez de senhas em texto plano
- **Activity Logs** para auditoria completa
- **Soft Delete** via flag `is_active` (pode ser adaptado)
- **Check Constraints** para validar valores de enum

---

## ⚡ Índices Otimizados

Índices criados para melhor performance em buscas comuns:

- `idx_users_email` - Busca rápida por email (login)
- `idx_patients_cpf` - Busca por CPF
- `idx_appointments_appointment_date` - Agendas por data
- `idx_surgeries_surgery_date` - Histórico de cirurgias
- `idx_medical_records_patient_id` - Prontuários por paciente
- `idx_billing_status` - Relatórios de pagamento

---

## 🚀 Como Usar

### 1. Criar o Database
```sql
CREATE DATABASE crm_endosurgical;
```

### 2. Executar o Schema
```sql
psql -U seu_usuario -d crm_endosurgical -f database/schema.sql
```

### 3. Popular com Dados de Teste
```sql
psql -U seu_usuario -d crm_endosurgical -f database/seeds.sql
```

---

## 📝 Próximos Passos

- [ ] Criar views para relatórios comuns
- [ ] Implementar triggers para auditoria automática
- [ ] Adicionar tabela de agendas/blocos de tempo
- [ ] Criar stored procedures para rotinas complexas
- [ ] Implementar replicação para backup

---

**Desenvolvido para:** CRM Endosurgical | **Data:** 2026-05-18
