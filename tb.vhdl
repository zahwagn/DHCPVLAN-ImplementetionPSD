library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types_pkg.ALL; -- Include the package for ip_array

entity Top_Level_tb is
-- Testbench has no ports
end Top_Level_tb;

architecture Behavioral of Top_Level_tb is

    -- Component declaration for the Unit Under Test (UUT)
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

    -- Signals for driving inputs and observing outputs
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal enable_dhcp   : std_logic := '0';
    signal total_vlans   : integer := 1;
    signal ip_addresses  : ip_array;
    signal status        : std_logic_vector(9 downto 0);
    signal selesai       : std_logic_vector(9 downto 0);

    -- Clock period definition
    constant clk_period : time := 1 ns;

    -- Function to convert std_logic_vector to string format
    function to_binary_string(input : std_logic_vector(9 downto 0)) return string is
        variable result : string(1 to 10);
    begin
        for i in 0 downto 9 loop
            if input(i) = '1' then
                result(9-i) := '1';
            else
                result(9-i) := '0';
            end if;
        end loop;
        return result;
    end function;

    -- Function to convert std_logic_vector IP to integer IP format
    function to_ip_string(ip: std_logic_vector) return string is
        variable ip_integer: unsigned(31 downto 0);
        variable octets: string(1 to 15);
    begin
        ip_integer := unsigned(ip);
        octets := integer'image(to_integer(ip_integer(31 downto 24))) & "." &
                  integer'image(to_integer(ip_integer(23 downto 16))) & "." &
                  integer'image(to_integer(ip_integer(15 downto 8))) & "." &
                  integer'image(to_integer(ip_integer(7 downto 0)));
        return octets;
    end function;

begin

    -- Instantiate the Unit Under Test (UUT)
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

    -- Clock generation process
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

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        reset <= '1';
        wait for 2 ns;
        reset <= '0';

        -- Test with 5 VLANs
        total_vlans <= 5;
        enable_dhcp <= '1';
        wait for 10 ns;
        report "Test with 5 VLANs completed. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);
        for i in 0 to 4 loop
            report "VLAN ID " & integer'image(i) & ": IP allocated: " & to_ip_string(ip_addresses(i));
        end loop;

        -- Test with all VLANs
        total_vlans <= 10;
        enable_dhcp <= '1';
        wait for 10 ns;
        report "Test with 10 VLANs completed. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);
        for i in 0 to 9 loop
            report "VLAN ID " & integer'image(i) & ": IP allocated: " & to_ip_string(ip_addresses(i));
        end loop;

        -- Disable DHCP
        enable_dhcp <= '0';
        wait for 5 ns;
        report "DHCP disabled. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);

        -- Test with 3 VLANs
        total_vlans <= 3;
        enable_dhcp <= '1';
        wait for 10 ns;
        report "Test with 3 VLANs completed. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);
        for i in 0 to 2 loop
            report "VLAN ID " & integer'image(i) & ": IP allocated: " & to_ip_string(ip_addresses(i));
        end loop;

        -- Finish simulation
        wait;
    end process;

end Behavioral;
