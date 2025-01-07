#!/bin/bash

# Prefix yang ingin digunakan
prifix="m"

# Tanggal dan waktu saat ini
date=$(date +"%Y-%m-%d %H:%M:%S")

# Dapatkan daftar branch dengan prefix tertentu
branches=$(git branch --list "${prifix}*" | sed 's/^* //;s/^ //')

if [ -z "$branches" ]; then
    echo -e "\e[31mTidak ada branch dengan prefix '$prifix' ditemukan.\e[0m"
    exit 1
fi

# Simpan branch aktif saat ini untuk kembali setelah selesai
currentBranch=$(git branch --show-current)

# Iterasi melalui branch yang ditemukan
for branch in $branches; do
    echo "============================================="
    echo -e "\e[36mBerpindah ke branch: $branch\e[0m"
    git checkout "$branch"

    # Jalankan perintah pada branch
    echo -e "\e[32mMenjalankan perintah pada branch $branch\e[0m"
    # Contoh: Update branch dari remote
    git fetch origin "$branch"
    git pull origin "$branch"
    # Lakukan merge dari branch asal ke branch yang diinginkan
    git merge "$currentBranch" -m "Merge branch $currentBranch to $branch on $date"

    # Jika ada konflik, tampilkan pesan
    if [ $? -ne 0 ]; then
        echo -e "\e[31mConflict terdeteksi pada branch $branch\e[0m"
        echo -e "\e[31mSilakan selesaikan conflict dan jalankan perintah 'git merge --continue'.\e[0m"
        exit 1
    fi

    # Push branch ke remote
    echo -e "\e[32mPush branch $branch ke remote\e[0m"
    git push -u origin "$branch"
done

# Kembali ke branch asal
if [ -n "$currentBranch" ]; then
    echo "============================================="
    echo -e "\e[33mKembali ke branch asal: $currentBranch\e[0m"
    git checkout "$currentBranch"
fi

echo -e "\e[32mSelesai.\e[0m"
