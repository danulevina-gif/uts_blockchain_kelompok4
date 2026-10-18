// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract QurbanChain {
    // --- State Variables ---
    mapping(address => bool) public isAdmin;
    
    enum Status { Terdaftar, DalamPerjalanan, SampaiTujuan, Disembelih }
    
    struct Hewan {
        uint256 id;
        string jenis;
        uint256 berat;
        string lokasi;
        address pemilikSaatIni;
        Status status;
    }
    
    uint256 public totalHewan;
    mapping(uint256 => Hewan) public hewanQurban;
    
    // --- Events ---
    event HewanDidaftarkan(uint256 indexed id, string jenis, address indexed pemilik);
    event StatusDiperbarui(uint256 indexed id, Status statusBaru);
    event KepemilikanBerpindah(uint256 indexed id, address pemilikLama, address pemilikBaru);
    event AdminBaruDitambahkan(address indexed adminBaru, address indexed ditambahkanOleh); 
    
    // --- Modifiers ---
    modifier hanyaAdmin() {
        require(isAdmin[msg.sender], "Gagal: Anda bukan admin!");
        _;
    }

    modifier hanyaPemilikAtauAdmin(uint256 _id) {
        require(msg.sender == hewanQurban[_id].pemilikSaatIni || isAdmin[msg.sender], "Gagal: Hanya pemilik atau admin yang berwenang!");
        _;
    }
    
    constructor() {
        isAdmin[msg.sender] = true;
    }
    
    function tambahAdmin(address _adminBaru) public hanyaAdmin {
        require(_adminBaru != address(0), "Alamat dompet tidak valid");
        require(!isAdmin[_adminBaru], "Akun ini sudah terdaftar sebagai admin");
        
        isAdmin[_adminBaru] = true;
        emit AdminBaruDitambahkan(_adminBaru, msg.sender);
    }
    
    function daftarkanHewan(string memory _jenis, uint256 _berat, string memory _lokasi) public hanyaAdmin {
        totalHewan++;
        
        hewanQurban[totalHewan] = Hewan({
            id: totalHewan,
            jenis: _jenis,
            berat: _berat,
            lokasi: _lokasi,
            pemilikSaatIni: msg.sender,
            status: Status.Terdaftar
        });
        
        emit HewanDidaftarkan(totalHewan, _jenis, msg.sender);
    }
    
    function updateStatus(uint256 _id, Status _statusBaru) public hanyaPemilikAtauAdmin(_id) {
        require(_id > 0 && _id <= totalHewan, "Hewan tidak ditemukan");
        hewanQurban[_id].status = _statusBaru;
        
        emit StatusDiperbarui(_id, _statusBaru);
    }
    
    function transferKepemilikan(uint256 _id, address _pemilikBaru) public hanyaPemilikAtauAdmin(_id) {
        require(_id > 0 && _id <= totalHewan, "Hewan tidak ditemukan");
        require(_pemilikBaru != address(0), "Alamat tidak valid");
        
        address pemilikLama = hewanQurban[_id].pemilikSaatIni;
        hewanQurban[_id].pemilikSaatIni = _pemilikBaru;
        
        emit KepemilikanBerpindah(_id, pemilikLama, _pemilikBaru);
    }

    // --- FUNGSI BARU UNTUK MENERJEMAHKAN STATUS KE TEKS ---
    function getDetailHewan(uint256 _id) public view returns (
        uint256 id,
        string memory jenis,
        uint256 berat,
        string memory lokasi,
        address pemilikSaatIni,
        string memory statusSaatIni
    ) {
        require(_id > 0 && _id <= totalHewan, "Hewan tidak ditemukan");
        Hewan memory h = hewanQurban[_id];
        
        // Menerjemahkan Enum angka menjadi Teks (String)
        string memory textStatus;
        if (h.status == Status.Terdaftar) textStatus = "Terdaftar";
        else if (h.status == Status.DalamPerjalanan) textStatus = "Dalam Perjalanan";
        else if (h.status == Status.SampaiTujuan) textStatus = "Sampai Tujuan";
        else if (h.status == Status.Disembelih) textStatus = "Telah Disembelih";

        return (h.id, h.jenis, h.berat, h.lokasi, h.pemilikSaatIni, textStatus);
    }
}