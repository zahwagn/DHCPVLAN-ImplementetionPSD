library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types_pkg.ALL;

entity Top_Level_tb is
-- Port();
end Top_Level_tb;

architecture Behavioral of Top_Level_tb is
    component Top_Level
        Port (
            clk           : in  STD_LOGIC;
            reset         : in  STD_LOGIC;
            enable_dhcp   : in  STD_LOGIC;
            total_vlans   : in  integer range 1 to 10;
            ip_addresses  : out ip_array;
            status        : out STD_LOGIC_VECTOR(9 downto 0);
            selesai       : out STD_LOGIC_VECTOR(9 downto 0)
        );
    end component;

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal enable_dhcp   : std_logic := '0';
    signal total_vlans   : integer := 1;
    signal ip_addresses  : ip_array;
    signal status        : std_logic_vector(9 downto 0);
    signal selesai       : std_logic_vector(9 downto 0);

    constant clk_period : time := 1 ns;

begin
    uut: Top_Level
        port map (
            clk           => clk,
            reset         => reset,
            enable_dhcp   => enable_dhcp,
            total_vlans   => total_vlans,
            ip_addresses  => ip_addresses,
            status        => status,
            selesai       => selesai
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    dhcp_vlan_test: process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Test with 5 VLANs
        total_vlans <= 5;
        enable_dhcp <= '1';
        wait for 100 ns;

        -- Test with all VLANs
        total_vlans <= 10;
        enable_dhcp <= '1';
        wait for 100 ns;

        -- Disable DHCP
        enable_dhcp <= '0';
        wait for 50 ns;

        -- Test with 3 VLANs
        total_vlans <= 3;
        enable_dhcp <= '1';
        wait for 100 ns;

        -- Finish simulation
        wait;
    end process;

end Behavioral;