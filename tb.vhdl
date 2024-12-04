library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_dhcp_system_textio is
end tb_dhcp_system_textio;

architecture Behavioral of tb_dhcp_system_textio is

    -- Komponen yang akan diuji
    component dhcp_system_textio
        Port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            enable_dhcp : in  std_logic;
            vlan_id     : in  std_logic_vector(7 downto 0);
            ip_address  : out std_logic_vector(31 downto 0);
            status      : out std_logic;
            selesai     : out std_logic  -- Tambahkan tanda koma di sini jika ada port lain setelahnya
        );
    end component;

    -- Sinyal internal untuk testbench
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal enable_dhcp : std_logic := '0';
    signal vlan_id     : std_logic_vector(7 downto 0) := (others => '0');
    signal ip_address  : std_logic_vector(31 downto 0);
    signal status      : std_logic;
    signal selesai     : std_logic := '0';

    -- Konstanta untuk simulasi clock
    constant clk_period : time := 20 ns;

    -- Counter untuk simulasi clock
    signal count : integer := 0;

begin

    -- Instansiasi unit under test (UUT)
    uut: dhcp_system_textio
        Port map (
            clk         => clk,
            reset       => reset,
            enable_dhcp => enable_dhcp,
            vlan_id     => vlan_id,
            ip_address  => ip_address,
            status      => status,
            selesai     => selesai
        );

    -- Proses clock
    clk_process: process
    begin
        while count <= 220 loop
            clk <= '1';
            wait for clk_period / 2;
            clk <= '0';
            wait for clk_period / 2;
            count <= count + 1; 
        end loop;
        wait;
    end process;

    -- Stimulus proses untuk menguji desain
    stimulus_process: process
    begin
        -- Reset awal
        reset <= '1';
        wait for clk_period;
        reset <= '0';

        -- Test 1: Aktifkan DHCP dengan VLAN ID tertentu
        enable_dhcp <= '1';
        vlan_id <= "00000001"; -- VLAN ID = 1
        wait until selesai = '1';

        -- Test 2: Ubah VLAN ID untuk alokasi lain
        vlan_id <= "00000010"; -- VLAN ID = 2
        wait until selesai = '1';

        -- Test 3: Matikan DHCP
        enable_dhcp <= '0';
        wait until selesai = '1';

        -- Selesai simulasi
        wait;
    end process;

end Behavioral;
