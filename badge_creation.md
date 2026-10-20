### How to fill it in

| Placeholder | What to put |
|---|---|
| `YOURUSERNAME.github.io` | Your actual GitHub Pages domain (e.g. `almondelf2.github.io`) |
| `BADGE-NAME` | kebab-case slug, e.g. `intro-data-science` |
| `you@example.com` | The email on your **Credly account** (must match exactly, lowercase) |
| `random-salt-123` | Any random alphanumeric string (e.g. `a3f8b2c1` or 16 random characters) |
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
  "id": "https://almondelf2.github.io/my-badges/BADGE-NAME/assertion.json",
  "recipient": {
    "type": "email",
    "hashed": true,
    "identity": "sha256$SHA256_HEX_DIGEST_HERE",
    "salt": "YOUR_SALT_HERE"
  },
  "badge": "https://almondelf2.github.io/my-badges/BADGE-NAME/badge-class.json",
  "issuedOn": "2024-07-22T00:00:00Z",
  "evidence": [
    {
      "type": "Evidence",
      "id": "https://www.linkedin.com/learning/certificates/...",
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
â”œâ”€â”€ intro-data-science/
â”‚   â”œâ”€â”€ badge-class.json
â”‚   â”œâ”€â”€ assertion.json
â”‚   â”œâ”€â”€ issuer.json
â”‚   â”œâ”€â”€ badge.png
â”‚   â””â”€â”€ certificate.pdf
â”œâ”€â”€ web-development/
â”‚   â”œâ”€â”€ badge-class.json
â”‚   â”œâ”€â”€ assertion.json
â”‚   â”œâ”€â”€ issuer.json
â”‚   â”œâ”€â”€ badge.png
â”‚   â””â”€â”€ certificate.pdf
```

---

### Canva Badge Creation

| Property | Requirement |
|---|---|
| Format | **PNG** (not JPG) |
| Shape | **Square** (1:1 ratio) |
| Size | **512 Ã— 512 px** (recommended); minimum 90 Ã— 90 |
| Max file size | **256 KB** |
| Background | Transparent preferred, or solid â€” just keep it clean |

