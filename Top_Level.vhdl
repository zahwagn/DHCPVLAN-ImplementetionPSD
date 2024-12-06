library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Level is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        enable_dhcp   : in  STD_LOGIC;
        vlan_id       : in  STD_LOGIC_VECTOR(7 downto 0);
        ip_address    : out STD_LOGIC_VECTOR(31 downto 0);
        status        : out STD_LOGIC;
        selesai       : out STD_LOGIC
    );
end Top_Level;

architecture Structural of Top_Level is
    -- Internal signals
    signal valid_vlan    : std_logic;
    signal ip_allocated  : std_logic_vector(31 downto 0);
    signal ip_valid      : std_logic;
    signal selesai_signal : std_logic;

begin
    -- Instantiate FSM DHCP
    dhcp_fsm: entity work.DHCP_Server
        port map (
            clk           => clk,
            reset         => reset,
            network       => "11000000101010000000000000000000",  -- 192.168.0.0
            subnet_mask   => "11111111111111111111111100000000",  -- 255.255.255.0
            num_devices   => 10,
            mulai         => enable_dhcp,
            ip_address    => ip_allocated,
            gateway       => open,
            subnet_out    => open,
            selesai       => selesai_signal
        );

    -- Instantiate VLAN Manager
    vlan_manager: entity work.VLAN_Allocation
        port map (
            clk        => clk,
            reset      => reset,
            total_vlans => 10,  -- Assuming a fixed number of VLANs for simplicity
            vlan       => vlan_id, -- Use vlan_id input
            done       => valid_vlan
        );

    -- Connect outputs
    ip_address <= ip_allocated when valid_vlan = '1' else (others => '0');
    status     <= ip_valid and valid_vlan;
    selesai    <= selesai_signal;

end Structural;