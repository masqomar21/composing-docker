$prifix = "m"

$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Dapatkan daftar branch dengan prefix tertentu
$branches = git branch --list "$prifix*" | ForEach-Object { $_.TrimStart('* ').Trim() }

if (-not $branches) {
    Write-Host "Tidak ada branch dengan prefix '$prifix' ditemukan." -ForegroundColor Red
    exit
}

# Tampilkan daftar branch yang akan diupdate dan buat konfirmasi
Write-Host "Daftar branch yang akan diupdate:" -ForegroundColor Yellow
foreach ($branch in $branches) {
    Write-Host $branch
}

$confirmation = Read-Host "Apakah Anda yakin ingin melanjutkan? (y/n)"
if ($confirmation -ne "y") {
    Write-Host "Proses dibatalkan." -ForegroundColor Red
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
    git fetch origin $branch
    git pull origin $branch
    # jalankan perintah merge dari brance sekarang ke branch yang diinginkan
    git merge $currentBranch -m "Merge branch $currentBranch to $branch on $date"

    # Jika ada conflict, tampilkan pesan
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Conflict terdeteksi pada branch $branch" -ForegroundColor Red
        Write-Host "Silakan selesaikan conflict dan jalankan perintah 'git merge --continue'." -ForegroundColor Red
        exit
    }

    # Push branch ke remote
    Write-Host "Push branch $branch ke remote" -ForegroundColor Green
    git push -u origin $branch
}

# Kembali ke branch asal
if ($currentBranch) {
    Write-Host "============================================="
    Write-Host "Kembali ke branch asal: $currentBranch" -ForegroundColor Yellow
    git checkout $currentBranch
}

Write-Host "Selesai." -ForegroundColor Green
