<#
.SYNOPSIS
    Automates the creation of a new Open Badges 2.0 digital credential.
.DESCRIPTION
    Creates a new badge folder, generates a cryptographically secure salt,
    computes the recipient SHA-256 hash according to Open Badges 2.0 rules,
    and writes strictly compliant, self-contained JSON files (UTF-8 without BOM).
.EXAMPLE
    .\new-badge.ps1 -Slug "aws-cloud-practitioner" -Name "AWS Cloud Practitioner" `
                    -Description "Fundamentals of AWS Cloud infrastructure." `
                    -Tags @("Cloud Computing", "AWS", "Infrastructure") `
                    -EvidenceUrl "https://..."
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, HelpMessage="Slug name for folder (kebab-case, e.g. intro-to-python)")]
    [string]$Slug,

    [Parameter(Mandatory=$false, HelpMessage="Full official name of the credential")]
    [string]$Name,

    [Parameter(Mandatory=$false, HelpMessage="Description of competencies and course overview")]
    [string]$Description,

    [Parameter(Mandatory=$false, HelpMessage="Comma-separated skill tags (e.g. Python, Data Analysis)")]
    [string[]]$Tags = @(),

    [Parameter(Mandatory=$false, HelpMessage="Link to official certificate of completion or course URL")]
    [string]$EvidenceUrl = "",

    [Parameter(Mandatory=$false, HelpMessage="Recipient email on your Credly account")]
    [string]$Email,

    [Parameter(Mandatory=$false, HelpMessage="GitHub username")]
    [string]$Username = "almondelf2",

    [Parameter(Mandatory=$false, HelpMessage="Issuer Profile Name")]
    [string]$IssuerName = "Chelf"
)

$baseDir = $PSScriptRoot
if (-not $baseDir) { $baseDir = Get-Location }

# Interactive prompts if parameters were omitted
if (-not $Slug) {
    $Slug = Read-Host "Badge slug / folder name (e.g. data-science-basics)"
}
$Slug = $Slug.ToLower().Trim() -replace "[^a-z0-9\-]", "-"

if (-not $Name) {
    $Name = Read-Host "Badge Name (e.g. Data Science Basics)"
}

if (-not $Description) {
    $Description = Read-Host "Description of course / skills covered"
}

if ($Tags.Count -eq 0) {
    $rawTags = Read-Host "Skill tags (comma-separated, e.g. Python, SQL, Statistics)"
    if ($rawTags) {
        $Tags = $rawTags.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
}

if (-not $EvidenceUrl) {
    $EvidenceUrl = Read-Host "Official certificate URL (optional)"
}

if (-not $Email) {
    $Email = Read-Host "Your Credly account email (used for salted hash)"
}

if (-not $Email) {
    Write-Error "A recipient email address is required to calculate the Credly identity hash."
    exit 1
}

$targetFolder = Join-Path (Join-Path $baseDir "my-badges") $Slug
if (Test-Path $targetFolder) {
    Write-Warning "Directory '$Slug' already exists! Files may be overwritten."
} else {
    New-Item -Path $targetFolder -ItemType Directory -Force | Out-Null
}

# 1. Generate 17-character salt and SHA-256 hash
$salt = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 17 | ForEach-Object { [char]$_ })
$cleanEmail = $Email.ToLower().Trim()
$combined = $cleanEmail + $salt
$bytes = [System.Text.Encoding]::UTF8.GetBytes($combined)
$hex = ([System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""
$identity = "sha256$" + $hex

$nowIso = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddT00:00:00Z")

# 2. Build BadgeClass Object
$badgeClassObj = [ordered]@{
    "@context" = "https://w3id.org/openbadges/v2"
    type = "BadgeClass"
    id = "https://$Username.github.io/diy-certs-to-badges/my-badges/$Slug/badge-class.json"
    name = $Name
    description = $Description
    image = "https://$Username.github.io/diy-certs-to-badges/my-badges/my-badges/$Slug/badge.png"
    criteria = [ordered]@{
        narrative = "Successfully completed all curriculum, assignments, and requirements for $Name."
    }
    issuer = [ordered]@{
        id = "https://$Username.github.io/diy-certs-to-badges/issuer.json"
        type = "Profile"
        name = $IssuerName
        url = "https://$Username.github.io"
        email = "no-reply@$Username.github.io"
    }
    tags = $Tags
}

# 3. Build Evidence array
$evidenceArray = @()
if ($EvidenceUrl) {
    $evidenceArray += [ordered]@{
        type = "Evidence"
        id = $EvidenceUrl
        description = "Original course completion certificate"
    }
}

# 4. Build Self-Contained Assertion Object
$assertionObj = [ordered]@{
    "@context" = "https://w3id.org/openbadges/v2"
    type = "Assertion"
    id = "https://$Username.github.io/diy-certs-to-badges/my-badges/my-badges/$Slug/assertion.json"
    recipient = [ordered]@{
        type = "email"
        hashed = $true
        identity = $identity
        salt = $salt
    }
    badge = $badgeClassObj
    issuedOn = $nowIso
    evidence = $evidenceArray
    verification = [ordered]@{
        type = "HostedBadge"
    }
}

# 5. Write JSON files using strict UTF-8 without BOM
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

$badgeClassPath = Join-Path $targetFolder "badge-class.json"
$assertionPath = Join-Path $targetFolder "assertion.json"

$badgeClassJson = $badgeClassObj | ConvertTo-Json -Depth 10
$assertionJson = $assertionObj | ConvertTo-Json -Depth 10

[System.IO.File]::WriteAllText($badgeClassPath, $badgeClassJson, $utf8NoBom)
[System.IO.File]::WriteAllText($assertionPath, $assertionJson, $utf8NoBom)

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " Badge created successfully in: $Slug/" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Name:       $Name"
Write-Host "  Salt:       $salt"
Write-Host "  Identity:   $identity"
Write-Host "  Assertion:  $assertionPath"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Add your 512x512 badge graphic: my-badges/$Slug/badge.png"
Write-Host "  2. Commit and push changes: git add $Slug; git commit -m 'Add $Name badge'; git push"
Write-Host "  3. Upload my-badges/$Slug/assertion.json to Credly!"
Write-Host "==========================================================" -ForegroundColor Green
