# 📍 Sistem Pelaporan Trouble IT
Aplikasi mobile berbasis **Flutter** dengan backend API menggunakan **Laravel**, dirancang untuk mempermudah proses pelaporan gangguan IT di lingkungan kerja.

---

## 📍 Latar Belakang dan Tujuan
Dalam operasional sehari-hari, sering terjadi gangguan teknis pada perangkat IT dan jaringan. Proses pelaporan yang masih manual menyulitkan tim IT dalam mendokumentasikan dan menindaklanjuti laporan secara efektif.

**Tujuan proyek:**
- Membangun aplikasi pelaporan trouble IT berbasis mobile.
- Memungkinkan karyawan melaporkan trouble lengkap dengan foto dan video.
- Mempermudah tim IT dalam memantau dan menindaklanjuti laporan secara real-time.
- Menyediakan histori laporan sebagai referensi masa depan.

---

## 📍 Masalah dan Solusi

| Masalah | Solusi |
|---|---|
| Pelaporan manual sulit dilacak | Aplikasi mobile Flutter + Backend Laravel |
| Dokumentasi minim | Foto dan video wajib saat pelaporan |
| Sulit tracking status laporan | Fitur status real-time dan histori |
| Data user tidak selalu sinkron | Auto refresh profile saat membuka halaman profil |

---

## 📍 Teknologi dan Arsitektur Sistem

### 🔧 Teknologi yang Digunakan

| Teknologi | Deskripsi |
|---|---|
| Flutter | Framework UI cross-platform (Android & iOS) |
| Cubit/Bloc | State management terstruktur |
| Laravel | Backend REST API |
| MySQL | Database relasional |
| Hive | Local storage untuk menyimpan sesi user |
| Dio | HTTP client untuk komunikasi API |
| Video Player | Pemutar video langsung di aplikasi |

---

### 🔧 Arsitektur Sistem

- **Mobile App:** Flutter (Cubit/Bloc) mengelola state login, laporan, dan profil.
- **Backend API:** Laravel menyediakan endpoint untuk login, CRUD laporan, dan streaming media.
- **Database:** MySQL menyimpan data user, laporan, dan media.
- **Media Storage:** Laravel menyimpan foto & video di folder `storage/app/public`.

---

## 📍 Fitur Utama

✅ Login dan manajemen sesi menggunakan Hive  
✅ Form pelaporan dengan upload foto dan video  
✅ Daftar laporan lengkap dengan filter dan pencarian  
✅ Detail laporan menampilkan foto & video langsung dari server  
✅ Real-time update status laporan dari tim IT  
✅ Halaman profil lengkap dengan foto profil dari backend  
✅ Logout dan refresh profile otomatis

---

## 📍 Tantangan Dalam Pengembangan

- **Upload Multi-file:** Menangani upload foto dan video bersamaan dari Flutter ke Laravel.
- **Video Streaming iOS:** Mengaktifkan byte-range request agar iOS bisa memutar video langsung.
- **Sync Data User:** Implementasi auto refresh profile agar data user selalu sinkron.
- **State Management:** Mengelola state login, laporan, dan profil secara konsisten menggunakan Cubit.

---

## 📍 Contoh Arsitektur Database
users
| id
| name
| email
| photo
| unit_id
| jenis_karyawan_id
| created_at
| updated_at

it_trouble_reports
| id
| user_id
| unit_id
| name
| description
| status
| solved_at
| result
| created_at
| updated_at

it_trouble_report_media
| id
| report_id
| type (photo/video)
| file_path
| created_at
| updated_at

---

## 📍 Kesimpulan

Proyek ini berhasil membangun **Sistem Pelaporan Trouble IT** berbasis mobile dan backend yang modern dan efisien. Dengan sistem ini:

- Karyawan dapat melaporkan gangguan secara lengkap.
- Tim IT dapat memantau laporan masuk secara real-time.
- Semua laporan terdokumentasi dengan baik.
- Foto profil user, foto laporan, dan video laporan dapat diakses langsung dari aplikasi.

Sistem ini diharapkan meningkatkan efisiensi komunikasi antara karyawan dan tim IT serta mempercepat respons penanganan gangguan.

---

## 📍 Acknowledgement

Terima kasih kepada:
- **Nusacodes** sebagai platform belajar Flutter dan Laravel.
- Komunitas Flutter & Laravel Indonesia.
- Rekan-rekan developer yang memberikan insight selama pengembangan.

---

## 📍 License

MIT License - Feel free to modify and improve this project.
