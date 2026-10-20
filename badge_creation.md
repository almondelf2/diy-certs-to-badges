# Open Badges v2.0 Creation & Publishing Guide

A complete, end-to-end guide for creating compliant **Open Badges 2.0** digital credentials from scratch, hosting them publicly using **GitHub Pages**, and importing them into your **Credly** profile.

---

## Table of Contents
1. [Overview & Core Architecture](#1-overview--core-architecture)
2. [Folder & URL Structure](#2-folder--url-structure)
3. [Step 1: Designing the Badge Image](#step-1-designing-the-badge-image)
4. [Step 2: Defining the Issuer Profile (`issuer.json`)](#step-2-defining-the-issuer-profile-issuerjson)
5. [Step 3: Creating the Badge Class (`badge-class.json`)](#step-3-creating-the-badge-class-badge-classjson)
6. [Step 4: Salting & Hashing Recipient Identity](#step-4-salting--hashing-recipient-identity)
7. [Step 5: Building the Badge Assertion (`assertion.json`)](#step-5-building-the-badge-assertion-assertionjson)
8. [Step 6: Hosting on GitHub Pages](#step-6-hosting-on-github-pages)
9. [Step 7: Importing into Credly](#step-7-importing-into-credly)
10. [Troubleshooting & Common Pitfalls](#troubleshooting--common-pitfalls)
11. [Official Specifications & References](#official-specifications--references)

---

## 1. Overview & Core Architecture

The **Open Badges 2.0 Specification** (maintained by **1EdTech**, formerly IMS Global) is a portable, verifiable JSON-LD format used across platforms such as Credly, Badgr, and Accredible.

An Open Badge system consists of three core JSON objects:

```
┌────────────────────────────────────────────────────────┐
│               1. Issuer Profile (issuer.json)           │
│   Identifies the organization, school, or author.      │
└───────────────────────────┬────────────────────────────┘
                            │ is referenced by
┌───────────────────────────▼────────────────────────────┐
│               2. BadgeClass (badge-class.json)          │
│   Describes the criteria, skills, title, and graphic.   │
└───────────────────────────┬────────────────────────────┘
                            │ is referenced by
┌───────────────────────────▼────────────────────────────┐
│               3. Assertion (assertion.json)             │
│   Records the recipient, completion date, and evidence. │
└────────────────────────────────────────────────────────┘
```

When importing a badge into **Credly**, you upload the **`assertion.json`** file. Credly verifies:
1. That the JSON strictly adheres to the Open Badges 2.0 JSON schema.
2. That the recipient email inside the badge matches an email registered to your Credly account.
3. That external links (badge graphics, issuer profiles, verification endpoints) return `200 OK` on the public internet.

---

## 2. Folder & URL Structure

Host your badge files in a public GitHub repository. For example, if your GitHub username is `YOURUSERNAME` and your repository is named `diy-certs-to-badges`, your GitHub Pages URL root will be:

```
https://YOURUSERNAME.github.io/diy-certs-to-badges/
```

### Recommended Directory Layout

```
diy-certs-to-badges/
├── issuer.json                                        <-- Global Issuer Profile
├── badge_creation.md                                  <-- This guide
├── templates/                                         <-- Starter templates
│   ├── assertion.json
│   ├── badge-class.json
│   └── issuer.json
├── advance-your-skills-in-it/                         <-- Badge slug (kebab-case)
│   ├── assertion.json                                 <-- Credly import file
│   ├── badge-class.json                               <-- Public criteria & metadata
│   ├── badge.png                                      <-- 512x512 badge graphic
│   └── certificate.pdf                                <-- (Optional) Source certificate
└── data-analytics-fundamentals/
    ├── assertion.json
    ├── badge-class.json
    ├── badge.png
    └── certificate.pdf
```

---

## Step 1: Designing the Badge Image

Open Badges require a raster or vector graphic to represent the achievement visually.

### Specifications:
* **Format:** `PNG` (recommended) or `SVG`. Do not use JPG.
* **Aspect Ratio:** `1:1` (square).
* **Dimensions:** Minimum `90 × 90 px`; recommended `512 × 512 px`.
* **File Size:** Must be **under 256 KB**.
* **Background:** Transparent or solid clean background.
* **Location:** Save directly in the badge folder as `badge.png`.

---

## Step 2: Defining the Issuer Profile (`issuer.json`)

The Issuer Profile describes the entity awarding the credential.

Save this file in your root folder as `issuer.json`:
```
https://YOURUSERNAME.github.io/diy-certs-to-badges/issuer.json
```

### Schema & Properties:
| Property | Type | Requirement | Description |
|---|---|---|---|
| `@context` | URI | **Required** | Must be `"https://w3id.org/openbadges/v2"` |
| `type` | String | **Required** | Must be `"Profile"` (legacy `"Issuer"` is tolerated by some, but `"Profile"` is standard) |
| `id` | URI | **Required** | The canonical public HTTPS URL where this `issuer.json` is hosted |
| `name` | String | **Required** | The display name of the issuer or organization |
| `url` | URI | **Required** | Website or homepage of the issuer (e.g. `https://YOURUSERNAME.github.io`) |
| `email` | String | **Required** | Public contact email address for the issuer |

### Example `issuer.json`:
```json
{
  "@context": "https://w3id.org/openbadges/v2",
  "type": "Profile",
  "id": "https://YOURUSERNAME.github.io/diy-certs-to-badges/issuer.json",
  "name": "Your Organization or Full Name",
  "url": "https://YOURUSERNAME.github.io",
  "email": "no-reply@YOURUSERNAME.github.io"
}
```

> **Privacy Note on Issuer Email:**  
> The issuer `email` is publicly visible contact metadata. It does **not** have to be your personal email inbox, and Credly does **not** use the issuer email to verify your badge ownership. Use a no-reply address (such as `no-reply@YOURUSERNAME.github.io`) to protect your private inbox from scrapers.

---

## Step 3: Creating the Badge Class (`badge-class.json`)

The `BadgeClass` defines the achievement, learning outcomes, criteria, and tags.

Save this in each badge subfolder:
```
https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/BADGE-NAME/badge-class.json
```

### Schema & Properties:
| Property | Type | Requirement | Description |
|---|---|---|---|
| `@context` | URI | **Required** | Must be `"https://w3id.org/openbadges/v2"` |
| `type` | String | **Required** | Must be `"BadgeClass"` |
| `id` | URI | **Required** | Canonical public HTTPS URL of this `badge-class.json` |
| `name` | String | **Required** | Official name of the credential |
| `description` | String | **Required** | Overview of competencies, syllabus, or learning outcomes |
| `image` | URI | **Required** | Public HTTPS URL to `badge.png` |
| `criteria` | Object / URI | **Required** | Evaluation requirements. An object with a `narrative` property describing completion requirements |
| `issuer` | Object / URI | **Required** | Link to `issuer.json` or embedded `Profile` object |
| `tags` | Array of Strings | Optional | List of competencies/skills. Credly indexes these and renders them as skill badges |

### Example `badge-class.json`:
```json
{
  "@context": "https://w3id.org/openbadges/v2",
  "type": "BadgeClass",
  "id": "https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/my-badges/intro-data-science/badge-class.json",
  "name": "Introduction to Data Science",
  "description": "Comprehensive course covering exploratory data analysis, statistics, Python, and machine learning fundamentals.",
  "image": "https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/my-badges/intro-data-science/badge.png",
  "criteria": {
    "narrative": "Completed all 10 modular units, passed all weekly coding labs, and scored 80% or higher on the comprehensive final exam."
  },
  "issuer": {
    "id": "https://YOURUSERNAME.github.io/diy-certs-to-badges/issuer.json",
    "type": "Profile",
    "name": "Your Organization or Full Name",
    "url": "https://YOURUSERNAME.github.io",
    "email": "no-reply@YOURUSERNAME.github.io"
  },
  "tags": [
    "Data Analysis",
    "Python",
    "Statistics",
    "Machine Learning"
  ]
}
```

---

## Step 4: Salting & Hashing Recipient Identity

To protect recipient privacy while allowing platforms like Credly to confirm ownership, Open Badges 2.0 uses **salted SHA-256 identity hashing**.

### How Credly Verifies Ownership:
1. Credly takes your registered Credly account email (lowercase).
2. It appends the `salt` declared in your `assertion.json`.
3. It computes the SHA-256 checksum and compares it against your `identity` field:
   $$\text{identity} = \text{"sha256\$"} + \text{SHA256}(\text{lowercase\_email} + \text{salt})$$
4. If the digests match, Credly links the credential to your account.

### Strict Rules for Hashing:
1. **Direct Concatenation Only:** Do **not** prefix with `email:` or add colons `:`. The input must simply be `email + salt`.
2. **Lowercase Email:** Always convert the email address to lowercase before hashing.
3. **Hexadecimal Output:** Must be 64 lowercase hex characters prefixed with `sha256$`. **Do not use Base64** (which ends with `=`).
4. **`hashed` Boolean:** In JSON, `"hashed": true` must be a literal boolean, never a string.

### Generating Your Salt & Hash:

#### Windows (PowerShell)
Run this command in PowerShell (replace `you@example.com` with your real Credly account email):

```powershell
$email = "you@example.com".ToLower()
# Generate a secure 17-character alphanumeric salt:
$salt = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 17 | ForEach-Object { [char]$_ })

# Calculate SHA-256 lowercase hex digest:
$bytes = [System.Text.Encoding]::UTF8.GetBytes($email + $salt)
$hex = ([System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""

Write-Host "salt:     $salt"
Write-Host "identity: sha256`$$hex"
```

#### macOS / Linux (Bash / Zsh)
```bash
EMAIL="you@example.com"
SALT=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 17)
HASH=$(printf '%s%s' "$EMAIL" "$SALT" | shasum -a 256 | awk '{print $1}')

echo "salt:     $SALT"
echo "identity: sha256$HASH"
```

---

## Step 5: Building the Badge Assertion (`assertion.json`)

The `assertion.json` records that a specific recipient earned the badge.

> **Crucial for Credly Import:**  
> When uploading an assertion to Credly, Credly's web importer inspects the badge title, criteria, graphic, and issuer immediately to generate the import preview dialog. Therefore, the `badge` object should be **self-contained (embedded)** directly within the assertion.

### Schema & Properties:
| Property | Type | Requirement | Description |
|---|---|---|---|
| `@context` | URI | **Required** | `"https://w3id.org/openbadges/v2"` |
| `type` | String | **Required** | `"Assertion"` |
| `id` | URI | **Required** | Canonical public HTTPS URL where this `assertion.json` is hosted |
| `recipient` | Object | **Required** | Describes recipient identity: `type`, `hashed` (boolean), `identity` (`sha256$...`), and `salt` |
| `badge` | Object / URI | **Required** | Embedded `BadgeClass` definition (recommended for upload previews) |
| `issuedOn` | ISO 8601 String | **Required** | Date earned (e.g., `"2024-07-22T00:00:00Z"`) |
| `evidence` | Array of Objects | Optional | Proof of work (e.g. link to LinkedIn Learning certificate or PDF) |
| `verification` | Object | **Required** | Verification method: `{"type": "HostedBadge"}` |

### Complete Example `assertion.json`:
```json
{
  "@context": "https://w3id.org/openbadges/v2",
  "type": "Assertion",
  "id": "https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/my-badges/intro-data-science/assertion.json",
  "recipient": {
    "type": "email",
    "hashed": true,
    "identity": "sha256$992518e33e4fdf246f491c6827058df3421528258525b6a524a87c1cb3833b31",
    "salt": "rPKa8sTGwPuK16cFs"
  },
  "badge": {
    "type": "BadgeClass",
    "id": "https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/my-badges/intro-data-science/badge-class.json",
    "name": "Introduction to Data Science",
    "description": "Comprehensive course covering exploratory data analysis, statistics, Python, and machine learning fundamentals.",
    "image": "https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/my-badges/intro-data-science/badge.png",
    "criteria": {
      "narrative": "Completed all 10 modular units, passed all weekly coding labs, and scored 80% or higher on the comprehensive final exam."
    },
    "issuer": {
      "id": "https://YOURUSERNAME.github.io/diy-certs-to-badges/issuer.json",
      "type": "Profile",
      "name": "Your Organization or Full Name",
      "url": "https://YOURUSERNAME.github.io",
      "email": "no-reply@YOURUSERNAME.github.io"
    },
    "tags": [
      "Data Analysis",
      "Python",
      "Statistics",
      "Machine Learning"
    ]
  },
  "issuedOn": "2024-07-22T00:00:00Z",
  "evidence": [
    {
      "type": "Evidence",
      "id": "https://www.linkedin.com/learning/certificates/5c43be2b2e7c6c24358161136cd01668e05eda56702b41b8c63af4677c02e5b8",
      "description": "Original course completion certificate"
    }
  ],
  "verification": {
    "type": "HostedBadge"
  }
}
```

---

## Step 6: Hosting on GitHub Pages

1. **Commit and Push Your Files:**
   ```bash
   git add -A
   git commit -m "Add Open Badges 2.0 files"
   git push origin main
   ```

2. **Enable GitHub Pages:**
   * Go to your repository on GitHub: `https://github.com/YOURUSERNAME/diy-certs-to-badges`.
   * Navigate to **Settings > Pages** (in the left sidebar).
   * Under **Build and deployment > Source**, select **Deploy from a branch**.
   * Under **Branch**, select **`main`** and folder **`/ (root)`**.
   * Click **Save**.

3. **Verify Public Accessibility:**
   Wait 1–2 minutes for the initial deployment. Test using `curl` or open the links in an incognito browser window:
   ```bash
   curl -I https://YOURUSERNAME.github.io/diy-certs-to-badges/my-badges/my-badges/intro-data-science/assertion.json
   ```
   **Expected Response:** `HTTP/1.1 200 OK` (with `Content-Type: application/json`).

---

## Step 7: Importing into Credly

1. Log into your **Credly** account.
2. In the top navigation bar, click on your profile icon and select **Profile**.
3. Scroll down to the **Badge Wallet** section.
4. Select the **Other** tab.
5. Click **+ Add badge from another provider** (or **+ Upload Other Badges**).
6. Click **Upload credential**, browse your computer, and select the local **`assertion.json`** file.
7. Credly will display a preview showing:
   * Badge Graphic
   * Badge Title
   * Issuer Name
   * Description & Tags
8. Click **Add Badge** to finalize. The badge is now linked to your Credly wallet.

---

## Troubleshooting & Common Pitfalls

### 1. Error: *"Uh oh! Something went wrong when processing this badge"*
* **Cause A: UTF-8 BOM (Byte Order Mark).**  
  Windows PowerShell’s default `Set-Content -Encoding UTF8` prepends invisible `0xEF 0xBB 0xBF` bytes to files. Standard JSON parsers (RFC 8259) crash when seeing a BOM.  
  *Fix:* Save files using UTF-8 without BOM. In PowerShell:
  ```powershell
  [System.IO.File]::WriteAllText($path, $jsonText, [System.Text.UTF8Encoding]::new($false))
  ```
* **Cause B: Non-Embedded Badge.**  
  If `badge` is merely an external URL string, Credly’s frontend cannot render the upload preview modal and crashes. Embed the full `BadgeClass` inside `assertion.json`.

### 2. Error: Badge marked *"Unverified"* or recipient mismatch
* Credly calculates `sha256(your_credly_email + salt)`.
* Ensure that the email used during Step 4 exactly matches an email confirmed under **Credly > Settings > Account**.
* Ensure the email was lowercased before hashing and that no extra spaces, `email:` prefixes, or colons were included.

### 3. Error: 404 Not Found on HostedBadge Verification
* Verify your GitHub Pages settings (**Settings > Pages**).
* Make sure repository is **Public** (GitHub Pages on private repos requires GitHub Pro/Enterprise).
* Check for case-sensitive typos in folder slugs.

---

## Official Specifications & References

* **IMS Global / 1EdTech Open Badges 2.0 Specification:**  
  [https://www.imsglobal.org/sites/default/files/Badges/OBv2p0Final/index.html](https://www.imsglobal.org/sites/default/files/Badges/OBv2p0Final/index.html)
* **Open Badges 2.0 Context Vocabulary:**  
  [https://w3id.org/openbadges/v2](https://w3id.org/openbadges/v2)
* **Credly Knowledge Base – Add Badge From Another Provider:**  
  [https://support.credly.com/hc/en-us/articles/360055746731-Adding-outside-badges-to-your-Credly-profile](https://support.credly.com/hc/en-us/articles/360055746731-Adding-outside-badges-to-your-Credly-profile)
* **RFC 8259 – The JSON Data Interchange Format (Section 8.1 - No BOM requirement):**  
  [https://datatracker.ietf.org/doc/html/rfc8259#section-8.1](https://datatracker.ietf.org/doc/html/rfc8259#section-8.1)
