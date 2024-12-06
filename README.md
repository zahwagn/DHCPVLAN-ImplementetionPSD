# Proyek AKhir DHCPVLAN-ImplementetionPSD

## Project Description
DHCP dan VLAN Management dalam Jaringan Komputer digunakan untuk **mengalokasikan IP secara dinamis** dengan memisahkan jaringan berdasarkan VLAN ID dengan menggunakan **DHCP Server** sebagai _master_ yang menghubungkan VLAN dengan DHCP untuk memberi dan meminta IP Address kepada _client_. Sementara itu, pada implementasi ini menggunakan **VLAN Manager** sebagai _slave_ untuk menerima perintah dari client.

Mengimplementasikan cara kerja DHCP dan Management VLAN sebagai alokasi yang dinamis, DHCP bekerja dimulai dari *client* yang membutuhkan konfigurasi jaringan (**discover**) untuk menetapkan _gateway_ dan _subnet mask_, DHCP memberikan tawaran (**offer**) konfigurasi kepada _client_ dan jika disetujui maka DHCP akan memberi tawaran (**request**) konfigurasi kepada client, setelah Server dan Client setuju maka DHCP memasuki (**ack**). Proses **Finite State Machine** tersebut (discover, offer, request, dan ack) akan memberikan output berupa _**allocated IP**_ yang ditulis dalam `dhcp_output.txt` sebagai client.

Server DHCP meggunakan FSM sebagai jalannya dari Sistem DHCP, di mana client akan mengaktifkan DHCP dan memasukkan VLAN ID. DHCP Server akan menampilkan IP Address yang telah disepakati, status DHCP, dan indikasi proses jika sudah selesai, selain itu
## How it works
Sistem Image-ColorScaler ini bekerja dengan cara membaca file gambar berwarna dalam format .bmp. File gambar .bmp merupakan format gambar yang umum digunakan dan didukung oleh berbagai perangkat lunak. File gambar .bmp terdiri dari header yang berisi informasi tentang ukuran, resolusi, dan format gambar, serta data gambar yang berisi nilai-nilai pixel gambar.

Sistem Image-ColorScaler ini membaca header file gambar untuk mendapatkan informasi tentang ukuran dan resolusi gambar. Informasi ini kemudian digunakan untuk menginisialisasi memori yang akan digunakan untuk menyimpan data gambar.

Data gambar kemudian dibaca dan diproses untuk mengubahnya menjadi grayscale. Data gambar grayscale kemudian disimpan kembali ke memori. File gambar grayscale kemudian dapat ditulis ke disk. File gambar .bmp merupakan format gambar yang umum digunakan dan didukung oleh berbagai perangkat lunak. Format gambar .bmp memiliki struktur yang sederhana dan mudah untuk diimplementasikan dalam bahasa VHDL.

Format gambar lain, seperti file gambar .jpg atau .png, memiliki struktur yang lebih kompleks dan sulit untuk diimplementasikan dalam bahasa VHDL. Selain itu, format gambar lain juga sering menggunakan kompresi, yang dapat menyulitkan proses dekompresi dalam bahasa VHDL. Oleh karena itu, dalam proyek ini hanya file gambar .bmp yang digunakan.

## How to use
| OPCODE | Keterangan |
| --- | --- |
| `000000` | Mengubah gambar menjadi grayscale |
| `000001` | Mengubah gambar menjadi greenscale, grayscale tapi dengan tone hijau |
| `000010` | Mengubah gambar menjadi redscale, grayscale tapi dengan tone red |
| `000011` | Mengubah gambar menjadi bluescale, grayscale tapi dengan tone biru |

Pada program VHDL yang sudah ada, masukan `INSTRUCTION_IN` yang berisi `OPCODE` yang sesuai. Apabial `OPCODE` tidak tertera pada table, maka program otomatis akan langsung melakukan copy dari source file ke destination file

## Testing
Kita melakukan testing terhadap program yang telah kita buat, untuk hasil testing selengkapnya dapat dilihat pada laporan proyek akhir
## Authors

- []()
- []()
- []()
- []()
