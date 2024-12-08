library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types_pkg.ALL;  -- Include the package for ip_array

entity Top_Level is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        enable_dhcp   : in  STD_LOGIC;
        total_vlans   : in  integer range 1 to 10;  -- Input total number of VLANs
        ip_addresses  : out ip_array;  -- Output IP addresses for each VLAN
        status        : out STD_LOGIC_VECTOR(9 downto 0);  -- Status for each VLAN
        selesai       : out STD_LOGIC_VECTOR(9 downto 0)   -- Completion signal for each VLAN
    );
end Top_Level;

architecture Structural of Top_Level is
    -- Components
    component DHCP_Server is
    Port ( clk         : in  STD_LOGIC;
           reset       : in  STD_LOGIC;
           network     : in  STD_LOGIC_VECTOR(31 downto 0);  -- Network Address
           subnet_mask : in  STD_LOGIC_VECTOR(31 downto 0);  -- Subnet Mask
           num_devices : in  integer;                        -- Number of End Devices
           mulai       : in  STD_LOGIC;                      -- Start Process
           ip_address  : out STD_LOGIC_VECTOR(31 downto 0);  -- Allocated IP Address
           gateway     : out STD_LOGIC_VECTOR(31 downto 0);  -- Default Gateway
           subnet_out  : out STD_LOGIC_VECTOR(31 downto 0);  -- Subnet Mask
           selesai     : out STD_LOGIC                       -- Indication of Process Completion
           );
    end component;
    
    component VLAN_Allocation is
    Port ( clk           : in  STD_LOGIC;
           reset         : in  STD_LOGIC;
           total_vlans   : in  integer range 1 to 10;  -- Input total number of VLANs
           vlan          : out STD_LOGIC_VECTOR(9 downto 0);  -- Output VLAN IDs
           done          : out std_logic  -- Process completion flag
           );               
    end component;

    -- Internal signals
    signal valid_vlan    : std_logic;
    signal vlan_id_internal : std_logic_vector(9 downto 0);
    signal ip_allocated  : ip_array;
    signal selesai_signal : std_logic_vector(9 downto 0);
    signal dhcp_enable   : std_logic_vector(9 downto 0);
    
    constant network_values : ip_array := (
        "11000000101010000000000100000000",  -- 192.168.1.0
        "11000000101010000000001000000000",  -- 192.168.2.0
        "11000000101010000000001100000000",  -- 192.168.3.0
        "11000000101010000000010000000000",  -- 192.168.4.0
        "11000000101010000000010100000000",  -- 192.168.5.0
        "11000000101010000000011000000000",  -- 192.168.6.0
        "11000000101010000000011100000000",  -- 192.168.7.0
        "11000000101010000000100000000000",  -- 192.168.8.0
        "11000000101010000000100100000000",  -- 192.168.9.0
        "11000000101010000000101000000000"   -- 192.168.10.0
    );
    
begin
    -- Instantiate VLAN Manager
    vlan_manager: VLAN_Allocation
        port map (
            clk        => clk,
            reset      => reset,
            total_vlans => total_vlans,
            vlan       => vlan_id_internal,
            done       => valid_vlan
        );
    
    -- Generate DHCP Servers based on VLANs
    gen_dhcp: for i in 0 to 9 generate
        dhcp_inst: if i < 10 generate
            dhcp_inst: DHCP_Server
                port map (
                    clk           => clk,
                    reset         => reset,
                    network       => network_values(i),  -- 192.168.i.0
                    subnet_mask   => "11111111111111111111111100000000",  -- 255.255.255.0
                    num_devices   => 10,
                    mulai         => std_logic(dhcp_enable(i)),
                    ip_address    => ip_allocated(i),
                    gateway       => open,
                    subnet_out    => open,
                    selesai       => selesai_signal(i)
                );
        end generate;
    end generate;

    -- Process to handle reset and clock logic
    process(clk, reset)
    begin
        if rising_edge(clk) then
            for i in 0 to 9 loop
                if i < total_vlans then
                    -- Enable DHCP for active VLANs
                    dhcp_enable(i) <= enable_dhcp;
                else
                    -- Disable DHCP for inactive VLANs
                    dhcp_enable(i) <= '0';
                end if;
            end loop;
        end if;
    end process;

    -- Connect outputs
    ip_addresses <= ip_allocated;
    status <= vlan_id_internal;
    selesai <= selesai_signal;

end Structural;