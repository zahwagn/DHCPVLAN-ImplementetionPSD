# Proyek Akhir DHCP VLAN-ImplementationPSD

## Project Description
DHCP dan VLAN Management dalam Jaringan Komputer digunakan untuk **mengalokasikan IP secara dinamis** dengan memisahkan jaringan berdasarkan VLAN ID dengan menggunakan **Top Level** sebagai modul utama yang menghubungkan VLAN Management dengan FSM untuk memberi dan meminta IP Address kepada _client_. Sementara itu, pada implementasi ini menggunakan **VLAN Manager** sebagai _slave_ untuk menerima perintah dari client atau segemnetasi network dengan **VLAN ID**.

## Project Implementation
Mengimplementasikan cara kerja DHCP dan Management VLAN sebagai alokasi yang dinamis, DHCP bekerja dimulai dari *client* yang membutuhkan konfigurasi jaringan (**discover**) untuk menetapkan _gateway_ dan _subnet mask_, DHCP memberikan tawaran (**offer**) konfigurasi kepada _client_ dan jika disetujui maka DHCP akan memberi tawaran (**request**) konfigurasi kepada client, setelah Server dan Client setuju maka DHCP memasuki (**ack**). Proses **Finite State Machine** tersebut (discover, offer, request, dan ack) akan memberikan output berupa _**allocated IP**_ yang ditulis dalam `dhcp_output.txt` sebagai client.

FSM sebagai tahapan dari Sistem DHCP (`fsm_dhcp.vhdl`), di mana _client_ akan **mengaktifkan DHCP** dan memasukkan **VLAN ID**. DHCP Server akan menampilkan **IP Address yang telah disepakati**, **status DHCP**, dan indikasi proses jika sudah **selesai**. FSM akan bekerja berdasarkan Network, Subnet mask, dan jumlah devices (_num_devices_), kemudian DHCP Server akan **menghitung, menetapkan**, dan **mencatat** IP Address, Subnet mask, dan gateway yang telah dialokasikan yang ditampilkan sebagai _output_. 

Segmentasi jaringan dalam DHCP dilakukan menggunakan VLAN (`vlan.vhdl`) untuk mengatur pemberian** VLAN ID dalam rentang** tertentu berdasrkan jumlah VLAN yang dimasukkan client (_total_vlans_), VLAN secara bertahap akan menghitung dan menetapkan VLAN ID (1- 10) dalam iterasi ke-0 sampai iterasi ke-9 ke _array internal_ serta memberikan hasilnya ke _output vlan_. Proses alokasi berjalan secara **inisialisasi, alokasi VLAN, dan penyelesaian** dengan status **done** sebagai indikasi telah berakhir.

Top Level sebagai modul utama (`Top_Level.vhdl`) menghubungkan FSM dari DHCP _(discover, offer request, dan ack_) dengan VLAN Management secara **_structural_**. Top Level akan meminta _client_  memasukkan banyaknya VLAN yang digunakan (_total_vlans_) dan mengaktifkan DHCP, serta menampilkan IP Address dari setiap VLAN dengan array, status setiap VLAN, dan sinyal untuk mengindikasikan jika sudah selesai.  Top Level meng-_generate_ DHCP Server yang berisi konfigurasi DHCP (**IP Address, Subnet mask, dan Gateway**) dengan `loop` untuk membuat 10 VLAN secara paralel. Hasil akhir dari Top Level akan **menampilkan** IP Address yang telah dialokasikan, status setiap VLAN, dan sinyal selesai. 

## Testing
Uji verifikasi dilakukan secara otomatis dengan _testbench_ (`tb.vhdl`) untuk memastikan validasi **hasil DHCP dan VLAN** secara _stimulus_. Uji coba dilakukan dengan **tiga _test case_**, yaitu menggunakan 3 VLAN ID, 5 VLAN ID, 7 VLAN ID, dan 10 VLAN ID yang menampilkan hasilnya pada **Report** dengan Severity **Note**. Testbench menggunakan komponen dari Top Level sebagai modul utama yang menghubungkan FSM (Discover, Offer, Request, dan Ack) dengan VLAN Management untuk mengalokasikan IP Address, Subnet mask, dan Gateway. Pada implementasi ini, desainer menggunakan contant network 192.168.1.0 - 192.168.10.0 dengan subnet mask 255.255.255.0 (/24). Function to_binary_string digunakan untuk convert input VLAN ke dalam bentuk string.

## Result
Hasil uji testing ini menggunakan simulation VIVADO yang disertai Report dan Severity Note untuk semua test case:
![image](https://github.com/user-attachments/assets/83dee371-e845-4a8b-b0c0-71877cbf123c)

### Testing 5 VLAN
![image](https://github.com/user-attachments/assets/5ea8b351-7dd2-4c00-ba69-c7f1c8895049)
Proses menguji dengan mengaktifkan DHCP (`enable_dhcp ‘1’`)  dengan alokasi IP Address setiap VLAN ID yaitu **192.168.1.2 - 192.168.5.2.** Testing untuk 5 VLAN (`total_vlans ‘5’`) diakhiri sampai sinyal (`selesai = ‘1111111111’`), setelah selesai maka setiap VLAN bisa dikatakan status aktif dengan status saat ini (`‘0000011111’`). Format pada report untuk IP yang telah dialokasikan dari s_td_logic_vector_ convert ke dalam format **IPv4(192.168.X.X)**.

### Testing 10 VLAN
![image](https://github.com/user-attachments/assets/fb52d2f9-2332-44c4-8bc2-7ce57bd025ef)
Proses menguji dengan mengaktifkan DHCP (`enable_dhcp ‘1’`) dengan alokasi IP Address setiap VLAN ID yaitu** 192.168.1.3 - 192.168.5.3. dan 192.168.6.2 - 192.168.10.2.** Testing untuk 10 VLAN `(total_vlans ‘10’`) diakhiri sampai sinyal `(selesai = ‘1111111111’`), setelah selesai maka setiap VLAN bisa dikatakan status aktif  dengan status saat ini (`‘1111111111’`). Format pada report untuk IP yang telah dialokasikan dari _std_logic_vector_ convert ke dalam format **IPv4 (192.168.X.X)**.

### Testing 3 VLAN
![image](https://github.com/user-attachments/assets/18c403a5-560b-40b6-8464-5765e60c367d)
Proses menguji dengan mengaktifkan DHCP (`enable_dhcp ‘1’`) dengan alokasi IP Address setiap VLAN ID yaitu **192.168.1.4 - 192.168.3.4.** Testing untuk 3 VLAN (`total_vlans ‘3’`) diakhiri sampai sinyal (`selesai = ‘1111111111’`), setelah selesai maka setiap VLAN bisa dikatakan status aktif  dengan status saat ini (`‘0000000111’`). Format pada report untuk IP yang telah dialokasikan dari _std_logic_vector_ convert ke dalam format **IPv4 (192.168.X.X)**. Pada testcase ini setelah iterasi ke-3 menunggu selama 5ns untuk DHCP Disable (`enable_dhcp ‘0’`) sehingga tidak mengalokasikan VLAN.

### Testing 7 VLAN
![image](https://github.com/user-attachments/assets/4ee8bfeb-8ecf-4160-8fb4-4cf730800d22)
Proses menguji dengan mengaktifkan DHCP (`enable_dhcp ‘1’`) dengan alokasi IP Address setiap VLAN ID yaitu **192.168.1.5 - 192.168.3.5., 192.168.4.4 - 192.168.5.4. , dan 192.168.6.3 - 192.168.7.3.** Testing untuk 7 VLAN (`total_vlans ‘7’`) diakhiri sampai sinyal (`selesai = ‘1111111111’`), setelah selesai maka setiap VLAN bisa dikatakan status aktif  dengan status saat ini (`‘0001111111’`). Format pada report untuk IP yang telah dialokasikan dari _std_logic_vector_ convert ke dalam format **IPv4 (192.168.X.X)**.
## Authors
- [@Azka-Nabihan](https://github.com/Azka-Nabihan)
- [@zahwagn](https://github.com/zahwagn)
- [@BonifasiusRaditya](https://github.com/BonifasiusRaditya)
- [@r-ediewitsch](https://github.com/r-ediewitsch)
