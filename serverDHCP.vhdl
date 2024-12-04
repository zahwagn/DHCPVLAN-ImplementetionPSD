library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dhcp_system_textio is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        enable_dhcp : in  std_logic; 
        vlan_id     : in  std_logic_vector(7 downto 0); 
        ip_address  : out std_logic_vector(31 downto 0);
        status      : out std_logic;
        selesai     : out std_logic -- Output untuk indikasi proses selesai
    );
end dhcp_system_textio;

architecture Structural of dhcp_system_textio is
    signal current_state : std_logic_vector(2 downto 0); 
    signal valid_vlan    : std_logic; 
    signal ip_allocated  : std_logic_vector(31 downto 0); 
    signal ip_valid      : std_logic;
    signal selesai_signal : std_logic; -- Sinyal internal untuk selesai

begin
    -- Instansiasi FSM DHCP
    dhcp_fsm: entity work.dhcp_fsm_textio
        port map (
            clk           => clk,
            reset         => reset,
            enable_dhcp   => enable_dhcp,
            current_state => current_state,
            ip_allocated  => ip_allocated,
            ip_valid      => ip_valid,
            selesai       => selesai_signal -- Menghubungkan ke sinyal internal
        );

    -- Instansiasi VLAN Manager
    vlan_manager: entity work.vlan_manager_textio
        port map (
            clk        => clk,
            vlan_id    => vlan_id,
            valid_vlan => valid_vlan
        );

    -- Logika Output
    ip_address <= ip_allocated when ip_valid = '1' and valid_vlan = '1' else (others => '0');
    status <= '1' when ip_valid = '1' and valid_vlan = '1' else '0';
    selesai <= selesai_signal; -- Menghubungkan sinyal internal ke port output

end Structural;