# Proyek Akhir DHCP VLAN-ImplementationPSD

## Project Description
DHCP dan VLAN Management dalam Jaringan Komputer digunakan untuk **mengalokasikan IP secara dinamis** dengan memisahkan jaringan berdasarkan VLAN ID dengan menggunakan **Top Level** sebagai modul utama yang menghubungkan VLAN Management dengan FSM untuk memberi dan meminta IP Address kepada _client_. Sementara itu, pada implementasi ini menggunakan **VLAN Manager** sebagai _slave_ untuk menerima perintah dari client atau segemnetasi network dengan **VLAN ID**.

## Project Implementation
Mengimplementasikan cara kerja DHCP dan Management VLAN sebagai alokasi yang dinamis, DHCP bekerja dimulai dari *client* yang membutuhkan konfigurasi jaringan (**discover**) untuk menetapkan _gateway_ dan _subnet mask_, DHCP memberikan tawaran (**offer**) konfigurasi kepada _client_ dan jika disetujui maka DHCP akan memberi tawaran (**request**) konfigurasi kepada client, setelah Server dan Client setuju maka DHCP memasuki (**ack**). Proses **Finite State Machine** tersebut (discover, offer, request, dan ack) akan memberikan output berupa _**allocated IP**_ yang ditulis dalam `dhcp_output.txt` sebagai client.

FSM sebagai tahapan dari Sistem DHCP (`fsm_dhcp.vhdl`), di mana _client_ akan **mengaktifkan DHCP** dan memasukkan **VLAN ID**. DHCP Server akan menampilkan **IP Address yang telah disepakati**, **status DHCP**, dan indikasi proses jika sudah **selesai**. FSM akan bekerja berdasarkan Network, Subnet mask, dan jumlah devices (_num_devices_), kemudian DHCP Server akan **menghitung, menetapkan**, dan **mencatat** IP Address, Subnet mask, dan gateway yang telah dialokasikan yang ditampilkan sebagai _output_. 

Segmentasi jaringan dalam DHCP dilakukan menggunakan VLAN (`vlan.vhdl`) untuk mengatur pemberian** VLAN ID dalam rentang** tertentu berdasrkan jumlah VLAN yang dimasukkan client (_total_vlans_), VLAN secara bertahap akan menghitung dan menetapkan VLAN ID (10 - 100) ke _array internal_ serta memberikan hasilnya ke _output vlan_. Proses alokasi berjalan secara **inisialisasi, alokasi VLAN, dan penyelesaian** dengan status **done** sebagai indikasi telah berakhir.

Top Level sebagai modul utama (`Top_Level.vhdl`) menghubungkan FSM dari DHCP _(discover, offer request, dan ack_) dengan VLAN Management secara **_structural_**. Top Level akan meminta _client_  memasukkan banyaknya VLAN yang digunakan (_total_vlans_) dan mengaktifkan DHCP, serta menampilkan IP Address dari setiap VLAN dengan array, status setiap VLAN, dan sinyal untuk mengindikasikan jika sudah selesai.  Top Level meng-_generate_ DHCP Server yang berisi konfigurasi DHCP (**IP Address, Subnet mask, dan Gateway**). Hasil akhir dari Top Level akan **menampilkan** IP Address yang telah dialokasikan, status setiap VLAN, dan sinyal selesai.

## Testing
Uji verifikasi dilakukan secara otomatis dengan _testbench_ (`tb.vhdl`) untuk memastikan validasi **hasil DHCP dan VLAN** secara _stimulus_. Uji coba dilakukan dengan **tiga _test case_**, yaitu menggunakan 3 VLAN ID, 5 VLAN ID, dan 10 VLAN ID yang menampilkan hasilnya pada **Report** dengan Severity **Note**.

## Result

### Testing 1

### Testing 2


## Authors
- [@Azka-Nabihan](https://github.com/Azka-Nabihan)
- [@zahwagn](https://github.com/zahwagn)
- [@BonifasiusRaditya](https://github.com/BonifasiusRaditya)
- [@r-ediewitsch](https://github.com/r-ediewitsch)
