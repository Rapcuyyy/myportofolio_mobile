[![CI](https://github.com/Rapcuyyy/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/Rapcuyyy/myportofolio_mobile/actions/workflows/main.yaml)

## Persiapan dan Menjalankan Aplikasi

Aplikasi Flutter ini terintegrasi dengan backend Django melalui REST API.

- **Deployed API:** [https://rafa-darussalam-myportofolio.pws.cs.ui.ac.id/](https://rafa-darussalam-myportofolio.pws.cs.ui.ac.id/)
- **Repository backend:** backend Django dikelola pada deployment di URL API di atas.

Persyaratan:

- Flutter SDK dengan channel `stable`
- Dart SDK yang sesuai dengan versi Flutter
- Android Emulator, browser Chrome, atau perangkat yang terhubung

Jalankan perintah berikut dari root proyek:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Untuk menjalankan aplikasi dengan backend deployment:

```bash
flutter run --dart-define=API_BASE_URL=https://rafa-darussalam-myportofolio.pws.cs.ui.ac.id
```

Saat menjalankan aplikasi lokal dengan Android Emulator, URL contoh untuk backend lokal adalah `http://10.0.2.2:8000`. Untuk browser/Chrome, gunakan `http://localhost:8000` atau alamat backend yang dapat diakses browser. Nilai `--dart-define=API_BASE_URL=...` mengubah `API_BASE_URL` pada [lib/config.dart](lib/config.dart); tanpa argumen ini, aplikasi menggunakan `http://10.0.2.2:8000`.

Jika model Dart diubah, buat kembali serializer JSON dengan:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Menjalankan pengujian:

```bash
flutter test
flutter analyze
```

## Tugas 7

### AI Closure

Karena tugas dari ketentuan tugas 7 ini sudah terselesaikan lewat tutorial, jadi untuk mengubah beberapa kode pada tugas ini saya hanya mengandalkan hint yang telah diberikan pada berkas tugas 7. AI digunakan untuk membantu saya memahami lebih dalam tentang flutter. Pertanyaan reflektif tugas ini juga menggunakan AI untuk lebih memahami jawaban saya yang telah saya peroleh sedikit demi sedikit dari beberapa sumber seperti PPT 09 dan 10 PBP kelas F, dokumentasi Flutter, W3Schools, GeeksforGeeks, dan juga Medium.

### Pertanyaan Reflektif

1. Widget tree adalah struktur dari semua widget yang membentuk tampilan aplikasi Flutter. Setiap elemen UI dalam Flutter adalah widget, dan semua widget ini tersusun secara hierarkis seperti pohon. Di bagian akar biasanya terdapat widget yang paling tinggi, seperti `MaterialApp` atau `CupertinoApp`, lalu di dalamnya terdapat widget lain yang menjadi child (anak), dan child tersebut bisa memiliki child lagi.

    Biasanya widget terdiri dari node berikut:
    - `MaterialApp` adalah parent utama untuk seluruh aplikasi.
    - `Scaffold` adalah parent dari tampilan dasar aplikasi seperti AppBar dan body.
    - `Padding` adalah parent dari `Column` dan bertanggung jawab atas jarak antar elemen.
    - `Column` menampung beberapa child secara vertikal.
    - `Row` menampung beberapa child secara horizontal.
    - `InfoCard` dan `ItemCard` adalah child yang dibuat dari kelas khusus untuk menampilkan data tertentu.

    Semua hubungan ini bekerja berdasarkan konsep tree: setiap widget memiliki parent dan bisa memiliki banyak child. Ketika sebuah widget dibangun, Flutter membangun seluruh subtree dari widget tersebut, lalu menampilkan hasilnya ke layar. Jika parent berubah atau rebuild terjadi, child juga ikut diperbarui sesuai kebutuhan.

2. Berikut widget yang digunakan dalam proyek ini beserta fungsi masing-masing:

    a. `MaterialApp`:
    Widget root yang menyediakan konfigurasi material design untuk seluruh aplikasi. Biasanya berisi tema, navigator, dan konfigurasi aplikasi secara global.

    b. `Scaffold`:
    Menyediakan struktur dasar halaman Flutter seperti `AppBar`, body, floating action button, drawer, dan bottom navigation.

    c. `AppBar`:
    Menampilkan toolbar di bagian atas halaman. Dalam proyek ini, `AppBar` digunakan untuk menampilkan judul aplikasi `MyPortfolio`.

    d. `Padding`:
    Memberi jarak di sekitar widget agar tata letak tidak menempel ke tepi layar.

    e. `Column`:
    Menyusun widget secara vertikal (atas ke bawah). Digunakan untuk menata `Row`, `Center`, dan `Text` dalam layout halaman.

    f. `Row`:
    Menyusun widget secara horizontal (kiri ke kanan). Dalam proyek ini, `Row` berguna menampilkan tiga `InfoCard` secara sejajar.

    g. `Center`:
    Membuat child berada di tengah layar atau tengah parent.

    h. `Text`:
    Menampilkan teks. Digunakan untuk judul, nama, kelas, dan pesan sambutan.

    i. `GridView.count`:
    Membuat tata letak dalam bentuk grid dengan jumlah kolom tertentu. Dalam proyek ini, `GridView.count` menampilkan menu tombol seperti Lihat Pengalaman, Tambah Pengalaman, dan Logout.

    j. `Card`:
    Membuat elemen berbentuk kartu dengan bayangan dan tampilan yang lebih terstruktur. `InfoCard` dibuat menggunakan `Card`.

    k. `Container`:
    Wadah umum untuk memberi padding, margin, warna, border, atau ukuran pada widget child.

    l. `Material`:
    Mewujudkan efek material design seperti warna, border radius, dan gesture behavior. Digunakan pada `ItemCard` agar tombol seperti kartu yang bisa ditekan dan memiliki latar warna.

    m. `InkWell`:
    Widget yang menangkap gestur sentuhan seperti tap. Dalam proyek ini, `InkWell` digunakan agar setiap item menu bisa diklik dan menampilkan `SnackBar`.

    n. `Icon`:
    Menampilkan ikon dari `Icons.*` dalam aplikasi. Misalnya ikon folder, add_circle, dan logout.

    o. `SnackBar`:
    Menampilkan pesan singkat di bagian bawah layar ketika pengguna menekan tombol. Digunakan untuk memberi feedback interaksi.

    p. `StatelessWidget` dan `StatefulWidget`:
    Keduanya merupakan dasar pembuatan widget. Pada projek ini, `MyHomePage`, `InfoCard`, dan `ItemCard` adalah subclass dari `StatelessWidget` karena tampilannya tidak berubah berdasarkan state internal.

3. `MaterialApp` adalah widget utama yang membungkus seluruh aplikasi Flutter yang mengikuti desain Material Design. `MaterialApp` berfungsi sebagai “kontainer utama” aplikasi. Tanpa root widget ini, aplikasi Flutter tidak akan memiliki struktur material yang stabil dan tidak akan memiliki lingkungan dasar yang dibutuhkan oleh banyak widget seperti `Scaffold`, `AppBar`, `Theme`, dan `Navigator`.

4. `StatelessWidget` adalah widget yang tidak memiliki state atau data internal yang berubah. Setelah dibangun, tampilannya tidak berubah kecuali data yang dikirimkan dari parent berubah.

    Ciri-ciri:
    - Tidak memiliki `setState()`.
    - Tidak dapat berubah secara dinamis setelah dibuat.
    - Cocok untuk tampilan statis.

    Contoh penggunaan:
    - `Text`
    - `Icon`
    - `InfoCard`
    - `ItemCard`

    Sedangkan `StatefulWidget` adalah widget yang memiliki state internal yang bisa berubah selama aplikasi berjalan. Widget ini biasanya digunakan saat ada interaksi seperti klik tombol, input form, perubahan nilai, animasi, atau data yang terus berubah.

    Ciri-ciri:
    - Memiliki class `State` terpisah.
    - Dapat memanggil `setState()` untuk membangun ulang UI.
    - Cocok untuk data yang bersifat dinamis.

    Contoh penggunaan:
    - Form input
    - Counter
    - Toggle switch
    - Halaman yang berinteraksi dengan user

    Pilih `StatelessWidget` jika:
    - Tampilan tidak berubah secara dinamis.
    - Data sudah tetap saat widget dibangun.
    - Tidak ada state internal yang perlu diubah.

    Pilih `StatefulWidget` jika:
    - Terdapat interaksi pengguna.
    - Data berubah saat aplikasi berjalan.
    - Kita perlu memicu update UI seperti menambah item, mengganti tema, atau mengubah nilai.

5. `BuildContext` adalah konteks atau lokasi tempat widget dibangun dalam tree widget. Ini adalah objek yang diberikan kepada metode `build` dan digunakan agar Flutter tahu di mana widget berada dalam hirarki widget tree.

    Fungsi utama `BuildContext`:
    - Mengakses informasi lingkungan aplikasi.
    - Menemukan ancestor widget seperti theme, media query, navigator, dan inherited widget.
    - Menentukan konteks untuk operasi seperti menampilkan dialog, snackbar, atau navigasi.

    Tanpa `BuildContext`, widget tidak akan memiliki cara untuk berinteraksi dengan lingkungan di atasnya. Oleh karena itu, `BuildContext` sangat penting dalam Flutter, terutama ketika kita ingin:
    - Mengakses tema (`Theme.of(context)`)
    - Menentukan ukuran layar (`MediaQuery.of(context)`)
    - Menampilkan snackbar atau dialog
    - Navigasi antar halaman

6. `Hot reload` adalah fitur Flutter yang memungkinkan perubahan kode diterapkan ke aplikasi yang sedang berjalan tanpa harus menghentikan proses running. Flutter secara cepat mem-build ulang widget tree yang terpengaruh dan memperbarui tampilan aplikasi.

    Sedangkan `Hot restart` menghentikan aplikasi lalu menjalankannya ulang dari awal. Prosesnya lebih lambat daripada hot reload, tetapi lebih kuat karena Flutter membangun ulang state aplikasi secara penuh.

    Hot reload tidak selalu bisa dipakai ketika:
    - Kode mengubah logika state dan inisialisasi aplikasi.
    - Ada perubahan pada variabel global, inisialisasi awal, atau state yang sudah terlanjur dibuat.
    - Kita menambah/mengubah `main()` atau konfigurasi awal aplikasi.
    - Kita mengubah dependency atau struktur project yang memerlukan aplikasi dimulai ulang dari awal.

    Pada situasi seperti itu, kita harus menggunakan:
    - `Hot restart` jika aplikasi masih berjalan tetapi state perlu dibersihkan
    - `Full restart` atau menjalankan ulang aplikasi dari awal jika aplikasi sudah berhenti atau perubahan lebih fundamental



## Tugas 8

### AI Closure

Pada tugas ini, AI digunakan untuk lebih memahami materi tentang Forms, dan inputs. AI juga digunakan untuk menyusun layouts yang redundant terutama pada bagian `Scaffold` di `education.dart`. Selebihnya saya masih bisa menyusun `education.dart` dengan mengikuti tutorail, seperti bagian Navigations, dan juga validasi input.

### Pertanyaan Reflektif

1. `Navigator.push()` menambahkan halaman baru di atas halaman saat ini. Contohnya pada drawer Tambah Pengalaman, _method_ ini membuka formulir pengalaman, dan kemudian tombol kembali atau `Navigator.pop()` dapat menutupnya dan kembali ke halaman sebelumnya. `Navigator.pushReplacement()` membuka halaman baru sekaligus menggantikan halaman saat ini di tumpukan navigasi. Opsi _Home_ di drawer digunakan untuk mengganti halaman yang sedang dibuka dengan halaman utama. `Navigator.pop()` menutup halaman atau dialog paling atas, lalu tombol OK menutup dialog setelah formulir disimpan. Fitur ini dapat dilihat pada `project_card.dart`, `left_drawer.dart`, dan `education_form.dart`.

2. `Scaffold` menyediakan kerangka halaman, sementara `AppBar` dan `Drawer` menempati bagian yang konsisten di dalam kerangka itu. Dengan begitu, halaman utama dan formulir memiliki pola navigasi serta struktur dasar yang serupa. Contoh warna tema: `main.dart` memakai **indigo** sebagai warna utama; `AppBar` halaman utama mengambil warna utama dari tema, sedangkan formulir dan header drawer juga menggunakan indigo. Contoh penggunaan warna ini dapa dilihat pada `main.dart`, `menu.dart`, `experience_form.dart`, dan `left_drawer.dart`.

3. Formulir disusun vertikal agar label dan kolom input mudah diikuti. `Padding` memberi jarak dari tepi dan antarbagian, kemudian `SizedBox` memberi jarak tetap di antara kolom, seperti pada formulir pendidikan. Saat tinggi layar terbatas, seperti ketika papan ketik terbuka, maka `SingleChildScrollView` pada formulir pengalaman dan `ListView` pada formulir pendidikan memungkinkan pengguna menggulir untuk menjangkau kolom atau tombol yang tidak muat di layar.

4. `GlobalKey<FormState>` menghubungkan kode dengan `Form` agar status formulir dapat diperiksa. Setiap `validator` memeriksa nilai kolom dan mengembalikan pesan kesalahan bila tidak valid. Saat tombol Simpan ditekan, `validate()` menjalankan validator pada kolom-kolom formulir, hasil `true` berarti formulir boleh diproses, sedangkan `false` membuat penyimpanan dihentikan dan pesan kesalahan ditampilkan. Contohnya, nama pengalaman yang kosong atau hanya berisi spasi ditolak. Pada formulir pendidikan, tahun seperti `abcd` juga ditolak meskipun kolomnya memakai `TextInputType.number`: jenis papan ketik hanya membantu memasukkan angka, bukan menjamin nilai yang dimasukkan valid. Contohnya dapat dilihat pada `experience_form.dart` dan `education_form.dart`.