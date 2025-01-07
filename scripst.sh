#!/bin/bash

# Fungsi untuk menjalankan perintah pada setiap branch
process_branches() {
    # Dapatkan daftar branch dengan prefix 'a-'
    branches=$(git branch --list 'a-*' | sed 's/^[* ]*//')

    if [ -z "$branches" ]; then
        echo "Tidak ada branch dengan prefix 'a-' ditemukan."
        exit 1
    fi

    # Loop melalui setiap branch
    for branch in $branches; do
        echo "Berpindah ke branch: $branch"
        git checkout "$branch"

        # Eksekusi perintah yang ingin dijalankan di sini
        echo "Menjalankan perintah pada branch $branch"
        # Contoh perintah:
        git pull origin "$branch"  # Mengupdate branch dari remote
    done

    # Kembali ke branch asal (opsional)
    echo "Kembali ke branch asal"
    git checkout -
}

# Panggil fungsi
process_branches