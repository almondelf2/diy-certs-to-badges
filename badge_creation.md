### How to fill it in

| Placeholder | What to put |
|---|---|
| `BADGE-NAME` | kebab-case slug, e.g. `intro-data-science` |
| `you@example.com` | The email on your **Credly account** (must match exactly, lowercase) |
| `YOUR_SALT_HERE` | Any random alphanumeric string (e.g. `a3f8b2c1` or 17 random characters) |
| `identity` | The full string: `sha256$` followed by the 64-char lowercase hex hash |
| `issuedOn` | Completion date in ISO 8601 format (e.g. `2024-07-22T00:00:00Z`) |

---

### Computing the Hash

The hash is calculated by concatenating your exact Credly email (lowercase) with the salt: `sha256(email + salt)`.

#### Windows (PowerShell)

**Interactive script:**
```powershell
$email = "you@example.com".ToLower()
$salt = "your-salt-here"  # Replace with your salt

# Compute SHA-256 hex digest
$bytes = [System.Text.Encoding]::UTF8.GetBytes($email + $salt)
$hex = ([System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""

Write-Host "salt:     $salt"
Write-Host "identity: sha256`$$hex"
```

**Quick one-liner (prints ready-to-paste `sha256$...` value):**
```powershell
$e="you@example.com"; $s="your-salt-here"; "sha256$" + (([System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($e + $s)) | ForEach-Object { $_.ToString("x2") }) -join "")
```

**Generate a random salt + identity together:**
```powershell
$email = "you@example.com".ToLower()
$salt = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 17 | ForEach-Object { [char]$_ })
$bytes = [System.Text.Encoding]::UTF8.GetBytes($email + $salt)
$hex = ([System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""

Write-Host "salt:     $salt"
Write-Host "identity: sha256`$$hex"
```

#### macOS / Linux (Bash / Zsh)
```bash
EMAIL="you@example.com"
SALT="your-salt-here"
HASH=$(printf '%s%s' "$EMAIL" "$SALT" | shasum -a 256 | awk '{print $1}')
echo "identity: sha256$HASH"
```

---

### Assertion JSON Template (`assertion.json`)

```json
{
  "@context": "https://w3id.org/openbadges/v2",
  "type": "Assertion",
  "id": "https://YOURUSERNAME.github.io/my-badges/BADGE-NAME/assertion.json",
  "recipient": {
    "type": "email",
    "hashed": true,
    "identity": "sha256$SHA256_HEX_DIGEST_HERE",
    "salt": "YOUR_SALT_HERE"
  },
  "badge": {
    "type": "BadgeClass",
    "id": "https://YOURUSERNAME.github.io/my-badges/BADGE-NAME/badge-class.json",
    "name": "Course Name Here",
    "description": "Brief description of what this course covered and what you learned.",
    "image": "https://YOURUSERNAME.github.io/my-badges/BADGE-NAME/badge.png",
    "criteria": {
      "narrative": "Completed all modules, assignments, and requirements for this certification."
    },
    "issuer": {
      "id": "https://YOURUSERNAME.github.io/my-badges/issuer.json",
      "type": "Profile",
      "name": "Your Full Name",
      "url": "https://YOURUSERNAME.github.io",
      "email": "no-reply@YOURUSERNAME.github.io"
    },
    "tags": [
      "Skill 1",
      "Skill 2",
      "Skill 3"
    ]
  },
  "issuedOn": "2024-06-15T00:00:00Z",
  "evidence": [
    {
      "type": "Evidence",
      "id": "https://YOURUSERNAME.github.io/my-badges/BADGE-NAME/certificate.pdf",
      "description": "Original course completion certificate"
    }
  ],
  "verification": {
    "type": "HostedBadge"
  }
}
```

---

### Folder structure for GitHub

```
my-badges/
├── intro-data-science/
│   ├── badge-class.json
│   ├── assertion.json
│   ├── badge.png
│   └── certificate.pdf
├── web-development/
│   ├── badge-class.json
│   ├── assertion.json
│   ├── badge.png
│   └── certificate.pdf
```

---

### Canva Badge Creation

| Property | Requirement |
|---|---|
| Format | **PNG** (not JPG) |
| Shape | **Square** (1:1 ratio) |
| Size | **512 x 512 px** (recommended); minimum 90 x 90 |
| Max file size | **256 KB** |
| Background | Transparent preferred, or solid - just keep it clean |
