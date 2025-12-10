# Windows 11 Shared Workstation Hardening

![Windows 11 shared workstation Hardening](img/logo.png)

This repository contains our final project for the **Computer System Exploitation** course.  
It uses **PowerShell** to harden the security of a fictional roofing company, **SecurePro**, which operates in a **non-standard multi-user, single-endpoint environment** where all employees share one **Windows 11** workstation.

The goal is to apply **30 unique security controls** to this shared workstation, focusing on:

- Least privilege and account management  
- Data security and segmentation  
- System hardening and attack surface reduction  
- Operational security in a shared environment  
- Auditing, monitoring, and basic incident traceability  

> **Note:** This project targets a **standalone Windows 11 shared workstation** (no Active Directory).

---

## Scenario Summary

- Company: **SecurePro Roofing**  
- Endpoint: **1x Windows 11 shared workstation** (all staff log into the same physical machine using their own accounts)  
- Data: Quotes, designs, payroll, invoices, HR records, operations schedules, CRM exports, marketing assets, resources, and archives  
- Requirement: Implement a logical folder structure and enforce security controls that reflect each role’s need-to-know / need-to-do.

---

## Users and Roles

### Estimating & Design

| User              | Role                    | Local Group             |
|-------------------|-------------------------|-------------------------|
| Marcus Vance      | Senior Estimator        | `Estimating_Design`   |
| Chloe Rodriguez   | Design Specialist       | `Estimating_Design`   |
| Ben Carter        | Estimating Assistant    | `Estimating_Design`   |
| Sophie Williams   | Client Liaison          | `Estimating_Design`   |

### Finance & Administration

| User         | Role                  | Local Group       |
|--------------|-----------------------|-------------------|
| David Chen   | Head Bookkeeper       | `Finance_Administration`      |
| Priya Sharma | Payroll Administrator | `Finance_Administration`      |
| Arthur Jenkins | Office Manager      | `Finance_Administration`      |
| Elena Popa   | Financial Assistant   | `Finance_Administration`      |

### Operations & Sales

| User          | Role                  | Local Group             |
|---------------|-----------------------|-------------------------|
| Frank Rossi   | Operations Manager    | `Operations_Sales`    |
| Sarah Blythe  | Sales Lead            | `Operations_Sales`    |
| Leo Mitchell  | Inventory Specialist  | `Operations_Sales`    |
| Tasha Green   | Sales Support         | `Operations_Sales`    |

### IT

| User            | Role          | Local Group      |
|-----------------|---------------|------------------|
| Bobby Bojangles | IT Everything | `IT`   |

---

## Local Security Groups

The script will create and use the following **local security groups** on the Windows 11 workstation:

- `Estimating_Design`  
  - Estimators, designers, and client liaison  
  - Primary access to **Active Jobs**, relevant **Sales/Marketing** assets, and read-only access to shared resources.

- `Finance_Administration`  
  - Bookkeeping, payroll, financial assistant, office manager  
  - Exclusive access to **Finance** and **HR/Employee_Files** data; additional access to financial archives.

- `Operations_Sales`  
  - Operations manager, sales lead, inventory, sales support  
  - Access to **Active Jobs**, **Sales & Marketing**, and **Operations** data.

- `IT`  
  - IT-only admin group (Bobby)  
  - Member of local **Administrators** used only for system administration and hardening tasks.

User accounts will be **standard users** by default, with **only `IT` granted administrative rights**, enforcing the **principle of least privilege** on the shared workstation.

---

## Folder Structure

The project enforces the following **folder structure** on a data volume (e.g. `D:\SecurePro\`).  
These directories are the foundation for NTFS permission design and data segmentation.

```text
D:\
└─ SecurePro\
   ├─ 1_Active_Jobs\
   │  ├─ 2024_001_ElmSt_Mansion\
   │  ├─ 2024_002_MapleAve_Condo\
   │  └─ 2024_003_OakDr_Retail\
   │     (Per-job folders: quotes, contracts, correspondence, diagrams)
   │
   ├─ 2_Company_Administration\
   │  ├─ Finance\
   │  │  ├─ Invoices_Outgoing\
   │  │  ├─ Invoices_Incoming\
   │  │  └─ Payroll_Reports\
   │  │
   │  ├─ HR\
   │  │  ├─ Employee_Files\      (Highly restricted)
   │  │  └─ Policies\
   │  │
   │  └─ Operations\
   │     ├─ Crew_Schedules\
   │     └─ Vehicle_Maintenance\
   │
   ├─ 3_Sales_Marketing\
   │  ├─ CRM_Exports\
   │  ├─ Marketing_Materials\
   │  └─ Proposals_Templates\
   │
   ├─ 4_Resources\
   │  ├─ Material_Catalogs\
   │  ├─ Installation_Manuals\
   │  └─ Safety_Protocols\
   │
   └─ 5_Archives\
      ├─ Completed_Jobs_2023\
      └─ Financial_Records_2023\
