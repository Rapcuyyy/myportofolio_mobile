# MyPortfolio Mobile

# Tugas 7

## 1. Widget Tree pada Flutter dan hubungan parent-child

Widget tree adalah struktur pohon dari semua widget yang membentuk tampilan aplikasi Flutter. Setiap elemen UI dalam Flutter adalah widget, dan semua widget ini tersusun secara hierarkis seperti pohon. Di bagian akar biasanya terdapat widget yang paling tinggi, seperti `MaterialApp` atau `CupertinoApp`, lalu di dalamnya terdapat widget lain yang menjadi child (anak), dan child tersebut bisa memiliki child lagi.

Contoh hubungan parent-child dalam proyek ini:

```dart
MaterialApp
└── Scaffold
    ├── AppBar
    └── body: Padding
        └── Column
            ├── Row
            │   ├── InfoCard
            │   ├── InfoCard
            │   └── InfoCard
            └── Center
                └── Column
                    ├── Text
                    └── GridView.count
                        ├── ItemCard
                        ├── ItemCard
                        └── ItemCard
```

Penjelasan:
- `MaterialApp` adalah parent utama untuk seluruh aplikasi.
- `Scaffold` adalah parent dari tampilan dasar aplikasi seperti AppBar dan body.
- `Padding` adalah parent dari `Column` dan bertanggung jawab atas jarak antar elemen.
- `Column` menampung beberapa child secara vertikal.
- `Row` menampung beberapa child secara horizontal.
- `InfoCard` dan `ItemCard` adalah child yang dibuat dari kelas khusus untuk menampilkan data tertentu.

Semua hubungan ini bekerja berdasarkan konsep tree: setiap widget memiliki parent dan bisa memiliki banyak child. Ketika sebuah widget dibangun, Flutter membangun seluruh subtree dari widget tersebut, lalu menampilkan hasilnya ke layar. Jika parent berubah atau rebuild terjadi, child juga ikut diperbarui sesuai kebutuhan.

## 2. Widget yang digunakan dalam proyek ini dan fungsinya

Berikut widget yang digunakan dalam proyek ini beserta fungsi masing-masing:

### a. `MaterialApp`
Widget root yang menyediakan konfigurasi material design untuk seluruh aplikasi. Biasanya berisi tema, navigator, dan konfigurasi aplikasi secara global.

### b. `Scaffold`
Menyediakan struktur dasar halaman Flutter seperti `AppBar`, body, floating action button, drawer, dan bottom navigation.

### c. `AppBar`
Menampilkan toolbar di bagian atas halaman. Dalam proyek ini, `AppBar` digunakan untuk menampilkan judul aplikasi `MyPortfolio`.

### d. `Padding`
Memberi jarak di sekitar widget agar tata letak tidak menempel ke tepi layar.

### e. `Column`
Menyusun widget secara vertikal (atas ke bawah). Digunakan untuk menata `Row`, `Center`, dan `Text` dalam layout halaman.

### f. `Row`
Menyusun widget secara horizontal (kiri ke kanan). Dalam proyek ini, `Row` berguna menampilkan tiga `InfoCard` secara sejajar.

### g. `Center`
Membuat child berada di tengah layar atau tengah parent.

### h. `Text`
Menampilkan teks. Digunakan untuk judul, nama, kelas, dan pesan sambutan.

### i. `GridView.count`
Membuat tata letak dalam bentuk grid dengan jumlah kolom tertentu. Dalam proyek ini, `GridView.count` menampilkan menu tombol seperti Lihat Pengalaman, Tambah Pengalaman, dan Logout.

### j. `Card`
Membuat elemen berbentuk kartu dengan bayangan dan tampilan yang lebih terstruktur. `InfoCard` dibuat menggunakan `Card`.

### k. `Container`
Wadah umum untuk memberi padding, margin, warna, border, atau ukuran pada widget child.

### l. `Material`
Mewujudkan efek material design seperti warna, border radius, dan gesture behavior. Digunakan pada `ItemCard` agar tombol seperti kartu yang bisa ditekan dan memiliki latar warna.

### m. `InkWell`
Widget yang menangkap gestur sentuhan seperti tap. Dalam proyek ini, `InkWell` digunakan agar setiap item menu bisa diklik dan menampilkan `SnackBar`.

### n. `Icon`
Menampilkan ikon dari `Icons.*` dalam aplikasi. Misalnya ikon folder, add_circle, dan logout.

### o. `SnackBar`
Menampilkan pesan singkat di bagian bawah layar ketika pengguna menekan tombol. Digunakan untuk memberi feedback interaksi.

### p. `StatelessWidget` dan `StatefulWidget`
Keduanya merupakan dasar pembuatan widget. Pada projek ini, `MyHomePage`, `InfoCard`, dan `ItemCard` adalah subclass dari `StatelessWidget` karena tampilannya tidak berubah berdasarkan state internal.

## 3. Fungsi `MaterialApp` dan mengapa sering digunakan sebagai root widget

`MaterialApp` adalah widget utama yang membungkus seluruh aplikasi Flutter yang mengikuti desain Material Design. Fungsi utamanya adalah:

- Menyediakan tema aplikasi global.
- Mengatur navigator (`Navigator`) untuk navigasi antar halaman.
- Menyediakan konfigurasi route, home, title, dan theme data.
- Menyesuaikan tampilan aplikasi dengan prinsip Material Design.

Contoh penggunaannya:

```dart
void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}
```

`MaterialApp` umumnya digunakan sebagai root widget karena semua widget yang ada di bawahnya bisa secara konsisten memanfaatkan tema, konfigurasi, dan API navigation. Dengan kata lain, `MaterialApp` berfungsi sebagai “kontainer utama” aplikasi. Tanpa root widget ini, aplikasi Flutter tidak akan memiliki struktur material yang stabil dan tidak akan memiliki lingkungan dasar yang dibutuhkan oleh banyak widget seperti `Scaffold`, `AppBar`, `Theme`, dan `Navigator`.

## 4. Perbedaan `StatelessWidget` dan `StatefulWidget`

### `StatelessWidget`
`StatelessWidget` adalah widget yang tidak memiliki state atau data internal yang berubah. Setelah dibangun, tampilannya tidak berubah kecuali data yang dikirimkan dari parent berubah.

Ciri-ciri:
- Tidak memiliki `setState()`.
- Tidak dapat berubah secara dinamis setelah dibuat.
- Cocok untuk tampilan statis.

Contoh penggunaan:
- `Text`
- `Icon`
- `InfoCard`
- `ItemCard`

### `StatefulWidget`
`StatefulWidget` adalah widget yang memiliki state internal yang bisa berubah selama aplikasi berjalan. Widget ini biasanya digunakan saat ada interaksi seperti klik tombol, input form, perubahan nilai, animasi, atau data yang terus berubah.

Ciri-ciri:
- Memiliki class `State` terpisah.
- Dapat memanggil `setState()` untuk membangun ulang UI.
- Cocok untuk data yang bersifat dinamis.

Contoh penggunaan:
- Form input
- Counter
- Toggle switch
- Todo list
- Halaman yang berinteraksi dengan user

### Kapan memilih yang mana?
Pilih `StatelessWidget` jika:
- Tampilan tidak berubah secara dinamis.
- Data sudah tetap saat widget dibangun.
- Tidak ada state internal yang perlu diubah.

Pilih `StatefulWidget` jika:
- Terdapat interaksi pengguna.
- Data berubah saat aplikasi berjalan.
- Kita perlu memicu update UI seperti menambah item, mengganti tema, atau mengubah nilai.

Dalam proyek ini, `MyHomePage`, `InfoCard`, dan `ItemCard` lebih cocok menggunakan `StatelessWidget` karena tampilannya tidak bergantung pada state internal yang berubah selama runtime.

## 5. `BuildContext` dan pentingnya di Flutter

`BuildContext` adalah konteks atau lokasi tempat widget dibangun dalam tree widget. Ini adalah objek yang diberikan kepada metode `build` dan digunakan agar Flutter tahu di mana widget berada dalam hirarki widget tree.

Fungsi utama `BuildContext`:
- Mengakses informasi lingkungan aplikasi.
- Menemukan ancestor widget seperti theme, media query, navigator, dan inherited widget.
- Menentukan konteks untuk operasi seperti menampilkan dialog, snackbar, atau navigasi.

Contoh:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('MyPortfolio'),
    ),
  );
}
```

Di sini, `context` adalah parameter yang dipassing ke metode `build`. Flutter menggunakannya untuk mencari informasi yang dibutuhkan dari ancestor widget. Misalnya, saat `ItemCard` ingin menampilkan `SnackBar`, ia menggunakan `ScaffoldMessenger.of(context)` untuk menemukan konteks yang sesuai dari tree widget.

Tanpa `BuildContext`, widget tidak akan memiliki cara untuk berinteraksi dengan lingkungan di atasnya. Oleh karena itu, `BuildContext` sangat penting dalam Flutter, terutama ketika kita ingin:
- Mengakses tema (`Theme.of(context)`)
- Menentukan ukuran layar (`MediaQuery.of(context)`)
- Menampilkan snackbar atau dialog
- Navigasi antar halaman

## 6. Konsep Hot Reload di Flutter dan perbedaannya dengan Hot Restart

### Hot Reload
`Hot reload` adalah fitur Flutter yang memungkinkan perubahan kode diterapkan ke aplikasi yang sedang berjalan tanpa harus menghentikan proses running. Flutter secara cepat mem-build ulang widget tree yang terpengaruh dan memperbarui tampilan aplikasi.

Keunggulan hot reload:
- Prosesnya cepat.
- Sangat cocok saat mengubah UI atau layout.
- Mempercepat iterasi pengembangan.

Contoh penggunaan:
- Mengubah warna, teks, margin, atau tata letak.
- Menambahkan widget baru dalam bagian yang sama.

### Hot Restart
`Hot restart` menghentikan aplikasi lalu menjalankannya ulang dari awal. Prosesnya lebih lambat daripada hot reload, tetapi lebih kuat karena Flutter membangun ulang state aplikasi secara penuh.

Perbedaan utama:
- `Hot reload`: mempertahankan state aplikasi, hanya memperbarui tree yang berubah.
- `Hot restart`: me-reset state aplikasi dan menjalankan ulang dari awal.

### Kapan hot reload tidak cukup?
Hot reload tidak selalu bisa dipakai ketika:
- Kode mengubah logika state dan inisialisasi aplikasi.
- Ada perubahan pada variabel global, inisialisasi awal, atau state yang sudah terlanjur dibuat.
- Kita menambah/mengubah `main()` atau konfigurasi awal aplikasi.
- Kita mengubah dependency atau struktur project yang memerlukan aplikasi dimulai ulang dari awal.

Pada situasi seperti itu, kita harus menggunakan:
- `Hot restart` jika aplikasi masih berjalan tetapi state perlu dibersihkan
- `Full restart` atau menjalankan ulang aplikasi dari awal jika aplikasi sudah berhenti atau perubahan lebih fundamental

Secara umum:
- Gunakan `hot reload` untuk perubahan UI yang cepat.
- Gunakan `hot restart` jika state aplikasi perlu di-reset atau perubahan tidak terserap dengan hot reload.
- Gunakan full restart jika aplikasi harus dimulai ulang sepenuhnya dari kondisi awal.

## Kesimpulan

Flutter bekerja dengan prinsip widget tree, di mana setiap tampilan dibangun dari widget yang memiliki hubungan parent-child. Proyek ini memanfaatkan berbagai widget seperti `MaterialApp`, `Scaffold`, `Row`, `Column`, `GridView`, `Card`, `InkWell`, dan `SnackBar` untuk membangun antarmuka yang rapi dan interaktif. Pemahaman tentang `StatelessWidget`, `StatefulWidget`, `BuildContext`, serta fitur `hot reload` dan `hot restart` sangat penting agar kita bisa membangun aplikasi Flutter dengan struktur yang benar dan efisien.
