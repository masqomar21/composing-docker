# Pindah ke direktori repository Git
# Set-Location -Path "C:\path\to\your\repository"

# Dapatkan daftar branch dengan prefix 'a-'
$branches = git branch --list "m*" | ForEach-Object { $_.TrimStart('* ').Trim() }

if (-not $branches) {
    Write-Host "Tidak ada branch dengan prefix 'a-' ditemukan." -ForegroundColor Red
    exit
}

# Simpan branch aktif saat ini untuk kembali setelah selesai
$currentBranch = (git branch --show-current).Trim()

foreach ($branch in $branches) {
    Write-Host "============================================="
    Write-Host "Berpindah ke branch: $branch" -ForegroundColor Cyan
    git checkout $branch

    # Jalankan perintah pada branch
    Write-Host "Menjalankan perintah pada branch $branch" -ForegroundColor Green
    # Contoh: Update branch dari remote
    # git pull origin $branch
    # jalankan perintah merge dari brance sekarang ke branch yang diinginkan
    git merge $currentBranch
}

# Kembali ke branch asal
if ($currentBranch) {
    Write-Host "============================================="
    Write-Host "Kembali ke branch asal: $currentBranch" -ForegroundColor Yellow
    git checkout $currentBranch
}

Write-Host "Selesai." -ForegroundColor Green
