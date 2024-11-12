# Identitas

- **Nama**  : Marthin Putra Dwimadyo
- **Kelas** : SI4507
- **NIM**   : 1202210285

# Pengenalan Aplikasi

Aplikasi ini adalah proyek sederhana menggunakan Flutter yang mengambil data resep makanan dari REST API dan menampilkannya dalam daftar yang bisa dicari, serta filter berdasarkan waktu masak dari tercepat maupun terlama untuk kebutuhan UTS Mata Kuliah Mobile Application Development

## Fitur Utama 

1. **Daftar Resep**    - Menampilkan daftar resep makanan populer.
2. **Pencarian Resep** - Menampilkan hasil pencarian resep makanan populer berdasarkan nama.
3. **Filter Resep**    - Menampilkan urutan waktu masak resep makanan dari tercepat maupun terlama.

## Struktur Proyek 

1. **recipe_search.api.dart**  : Mengelola data API feeds/search
2. **recipe.api.dart**         : Mengelola data API feeds/list
3. **recipe.dart**             : Model dari data API feeds/list
4. **recipe_card.dart**        : Mengelola dan menampilkan card dari data API feeds/list
5. **home.dart**               : Mengelola dan menampilkan tampilan aplikasi utama 
6. **main.dart**               : Menjalankan tampilan aplikasi utama
