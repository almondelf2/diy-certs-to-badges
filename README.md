# 🎖️ DIY Certs to Badges: Unofficial Badges for Official Certificates

[![Open Badges 2.0](https://img.shields.io/badge/Open%20Badges-v2.0%20Compliant-blue.svg)](https://www.imsglobal.org/sites/default/files/Badges/OBv2p0Final/index.html)
[![Credly Compatible](https://img.shields.io/badge/Credly-Import%20Compatible-orange.svg)](https://support.credly.com/hc/en-us/articles/360055746731-Adding-outside-badges-to-your-Credly-profile)
[![GitHub Pages](https://img.shields.io/badge/Hosted%20On-GitHub%20Pages-green.svg)](https://pages.github.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Bridge the gap between certificates and digital badge wallets.** Turn official completion certificates into portable, verifiable, skill-tagged **Open Badges 2.0** credentials that can be imported directly into your [Credly](https://www.credly.com/) profile.

---

## 🎯 Purpose of This Repository

Many reputable educational platforms and industry learning paths (such as **LinkedIn Learning**, vendor workshops, and professional certificates) award certificates of completion or verification URLs—**but do not issue formal digital badges**. 

Without a digital badge, you cannot easily display those verified competencies in modern credential wallets like Credly.

This repository serves a dual purpose:
1. **Personal Hosting Provider:** Serves as the public HTTPS host (via GitHub Pages) for my own credentials, providing the required metadata endpoints (`assertion.json`, `badge-class.json`, `issuer.json`, and graphics) that Credly and Open Badge validators require.
2. **Open Blueprint & Learning Resource:** Provides starter templates, scripts, and a [step-by-step guide](badge_creation.md) so anyone can learn how to create, self-host, and import their own Open Badges into Credly with complete privacy protection.

---

## 📂 Current Badges in This Portfolio

Each badge directory contains the self-contained assertion (`assertion.json`), public class definition (`badge-class.json`), custom 512×512 graphic (`badge.png`), and official certificate evidence:

| Badge / Credential | Provider | Skills & Competencies Tagged |
|---|---|---|
| **[IT Help Desk Specialist](advance-your-skills-as-an-it-help-desk-specialist/)** | LinkedIn Learning | Windows 10, Hardware Maintenance, Active Directory, Troubleshooting, Customer Support |
| **[Career Essentials in Cybersecurity](career-essentials-in-cybersecurity-by-microsoft-and-linkedin/)** | Microsoft & LinkedIn | Network Security, Threat Analysis, Endpoint Protection, Security Operations |
| **[Career Essentials in Generative AI](career-essentials-in-generative-ai-by-microsoft-and-linkedin/)** | Microsoft & LinkedIn | Prompt Engineering, LLMs, AI Ethics, Copilot Integration, Workplace Productivity |
| **[Microsoft Copilot for Productivity](microsoft-copilot-for-productivity-by-microsoft-and-linkedin/)** | Microsoft & LinkedIn | Microsoft 365 Copilot, Prompt Writing, Outlook, Teams, Excel & PowerPoint AI |
| **[Customer Success Foundations](customer-success-foundations-professional-certificate-by-churnzero/)** | ChurnZero | Onboarding, Retention Strategies, Health Scoring, Customer Journey Mapping |
| **[Zendesk Customer Service](zendesk-customer-service-professional-certificate/)** | Zendesk | Ticket Management, SLA Compliance, Omnichannel Support, Incident Resolution |
| **[Business Communication Skills](essential-business-communication-skills-professional-certificate-by-linkedin-learning/)** | LinkedIn Learning | Professional Writing, Cross-Functional Alignment, Active Listening, Executive Presence |
| **[IT Administration](essential-new-skills-in-it-administration/)** | LinkedIn Learning | Enterprise Infrastructure, PowerShell Automation, Systems Management |
| **[IT Support Career Track](explore-a-career-in-it-support/)** | LinkedIn Learning | Help Desk Fundamentals, Hardware Diagnostics, Network Basics |
| **[ChatGPT for Business](building-chatgpt-skills-for-business-professionals/)** | LinkedIn Learning | Workplace Automation, Generative AI Strategies, Data Synthesis |
| **[Generative AI Productivity](build-your-generative-ai-productivity-skills-with-microsoft-and-linkedin/)** | Microsoft & LinkedIn | Modern AI Tools, Workflow Automation, Workplace Productivity |

---

## 🛠️ How It Works (The Open Badges Architecture)

Under the hood, Open Badges 2.0 uses **Linked Data (JSON-LD)**. To import an outside badge into Credly, your files must follow this architecture:

```
┌────────────────────────────────────────────────────────┐
│               1. Issuer Profile (issuer.json)           │
│   Identifies the issuer with a public contact address.  │
└───────────────────────────┬────────────────────────────┘
                            │ is referenced by
┌───────────────────────────▼────────────────────────────┐
│               2. BadgeClass (badge-class.json)          │
│   Defines title, criteria narrative, skill tags, & PNG. │
└───────────────────────────┬────────────────────────────┘
                            │ is embedded in
┌───────────────────────────▼────────────────────────────┐
│               3. Assertion (assertion.json)             │
│   Links badge to recipient using salted SHA-256 hash.   │
│   Uploaded to Credly under "Badge Wallet > Other".      │
└────────────────────────────────────────────────────────┘
```

### Key Technical Standards Enforced Here:
* **Privacy-Preserving Recipient Hashing:** Recipient emails are never stored in plaintext. They are protected using `sha256(lowercase_email + salt)` so Credly can confirm your account ownership without exposing your email to web scrapers.
* **Self-Contained Assertions:** The `BadgeClass` is embedded directly into `assertion.json` to ensure Credly's web importer can render the preview modal and import skills without external dependency timeouts.
* **Strict UTF-8 (No BOM):** Files are formatted strictly as RFC 8259-compliant UTF-8 (no invisible Byte Order Marks) to prevent Credly server-side parser crashes.
* **Public HTTPS Hosting:** Hosted via GitHub Pages with CORS headers, ensuring verification endpoints resolve with `200 OK`.

---

## 🚀 How to Create Your Own Badges

Want to turn your own certificates into Credly-compatible Open Badges?

1. **Read the Full Step-by-Step Guide:**  
   See **[badge_creation.md](badge_creation.md)** for a beginner-friendly walkthrough covering image dimensions, JSON schemas, cryptographic hash generation commands, and Credly upload instructions.

2. **Use the Starter Templates:**  
   Copy the starter templates from the [`templates/`](templates/) folder:
   * [`templates/assertion.json`](templates/assertion.json) — Upload file for Credly
   * [`templates/badge-class.json`](templates/badge-class.json) — Public badge class definition
   * [`templates/issuer.json`](templates/issuer.json) — Issuer profile definition

3. **Generate Your Salted Hash:**  
   Use the copy-pasteable PowerShell or Bash scripts in [badge_creation.md](badge_creation.md) to generate your recipient hash from your Credly email.

4. **Host on GitHub Pages:**  
   Push your files to a GitHub repository, enable **GitHub Pages** (**Settings > Pages > Deploy from branch**), and upload your `assertion.json` to **Credly** under **Profile > Badge Wallet > Other > + Add badge from another provider**.

---

## ⚖️ Disclaimer & Attribution

* These badges are **unofficial digital representations** created to showcase coursework and skills on Open Badge-compliant portfolio platforms.
* All original coursework, curriculum, and certifications belong to their respective copyright holders (e.g., LinkedIn Learning, Microsoft, Zendesk, ChurnZero).
* Each badge's `evidence` block explicitly links back to the original, verifiable certificate of completion or institutional certificate URL.

---

## 📚 References & Standards

* [1EdTech / IMS Global Open Badges 2.0 Final Specification](https://www.imsglobal.org/sites/default/files/Badges/OBv2p0Final/index.html)
* [W3C Open Badges v2 Vocabulary](https://w3id.org/openbadges/v2)
* [Credly Help: Adding Outside Badges to Your Credly Profile](https://support.credly.com/hc/en-us/articles/360055746731-Adding-outside-badges-to-your-Credly-profile)
* [RFC 8259: The JSON Data Interchange Format](https://datatracker.ietf.org/doc/html/rfc8259)
