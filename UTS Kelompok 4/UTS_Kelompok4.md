# Sistem Pelacakan Rantai Pasok Hewan Qurban

**Mata Kuliah:** Blockchain  
**Proyek:** Implementasi *Smart Contract* Rantai Pasok Hewan Qurban

**Anggota Kelompok:**
1. Moh. Nukhas H [2530801107]
2. Danu Suryana [2530801070]   
3. Moh. Farizul Haq [2530801084]

Laporan ini mendokumentasikan skenario *Happy Path* (alur normal) interaksi pengguna dengan Smart Contract di jaringan Ethereum (Remix VM), lengkap dengan bukti hasil eksekusinya.

---

## 1. Fase Inisialisasi Kontrak (Deployment)
* **Aktor:** Super Admin
* **Aksi:** Melakukan kompilasi `QurbanChain.sol` (Solidity `^0.8.20`) dan klik *Deploy*.
* **Hasil:** Kontrak cerdas aktif. *Address* milik *deployer* tercatat di dalam *state variable* sebagai `isAdmin = true`.
*(Masukkan Screenshot kotak Deployed Contracts dari Remix di sini)*

## 2. Pendelegasian Akses (Tambah Admin)
* **Aktor:** Super Admin
* **Aksi:** Memasukkan *address* dompet Akun ke-2 ke dalam fungsi `tambahAdmin(address)` dan melakukan transaksi.
* **Hasil:** Akun ke-2 kini memiliki hak mendaftarkan hewan. Log terminal mencetak *Event* `AdminBaruDitambahkan`.
*(Masukkan Screenshot eksekusi tambahAdmin dan logs terminal hijau di sini)*

## 3. Pendaftaran Hewan Qurban (Create Data)
* **Aktor:** Admin Baru / Peternak
* **Aksi:** Memanggil fungsi `daftarkanHewan` dengan parameter:
  * `_jenis`: "Sapi Limousin"
  * `_berat`: 350
  * `_lokasi`: "Peternakan Bantul"
* **Hasil:** Aset hewan tercipta dengan ID = 1. Status bawaan = `Terdaftar`. 
*(Masukkan Screenshot tombol daftarkanHewan beserta inputannya di sini)*

## 4. Pembaruan Status (Update Pengiriman)
* **Aktor:** Pemilik Hewan Saat Ini
* **Aksi:** Memanggil fungsi `updateStatus` dengan parameter:
  * `_idHewan`: 1
  * `_statusBaru`: 1 *(mewakili Enum 'DalamPerjalanan')*
* **Hasil:** Status hewan pada sistem berubah.
*(Masukkan Screenshot eksekusi fungsi updateStatus di sini)*

## 5. Pemantauan Data Terbaca (View Function)
* **Aktor:** Publik / Pekurban
* **Aksi:** Memanggil fungsi pembacaan data `getDetailHewan(1)`.
* **Hasil:** Sistem merespon dengan data lengkap. Berkat algoritma penerjemah pada *Smart Contract*, status angka (1) diterjemahkan otomatis menjadi teks string **"Dalam Perjalanan"** tanpa membebani Gas Fee.
*(Masukkan Screenshot hasil keluaran fungsi getDetailHewan berwarna biru yang menunjukkan output teks "Dalam Perjalanan" di sini)*

## 6. Serah Terima Kepemilikan (Transfer Aset)
* **Aktor:** Pemilik Lama
* **Aksi:** Memanggil fungsi `transferKepemilikan` dan memasukkan *address* dompet milik Panitia Masjid (Akun ke-3).
* **Hasil:** Hak kontrol atas hewan ID 1 berpindah sepenuhnya ke Panitia Masjid.
*(Masukkan Screenshot eksekusi transferKepemilikan di sini)*

## 7. Finalisasi (Penyembelihan)
* **Aktor:** Pemilik Baru (Panitia Masjid)
* **Aksi:** Memanggil fungsi `updateStatus(1, 3)` *(mewakili Enum 'Disembelih')*.
* **Hasil:** Siklus hidup rantai pasok qurban berakhir secara valid dan tercatat utuh di buku besar (ledger) *blockchain*.

---
**Kesimpulan:** 
Sistem berhasil mengunci (mengamankan) seluruh tahapan transaksi. Terbukti dengan modifikasi *state* yang hanya bisa dilakukan oleh entitas yang memiliki hak kepemilikan yang sah secara kriptografi (tervalidasi melalui dompet *address* Ethereum).