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

    constant clk_period : time := 10 ns;

    function to_binary_string(input : std_logic_vector(9 downto 0)) return string is
        variable result : string(1 to 10);
    begin
        for i in 9 downto 0 loop
            if input(i) = '1' then
                result(i+1) := '1';
            else
                result(i+1) := '0';
            end if;
        end loop;
        return result;
    end function;

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

    test_dhcp_vlan: process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Test with 5 VLANs
        total_vlans <= 5;
        enable_dhcp <= '1';
        wait for 100 ns;
        report "Test with 5 VLANs completed. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);
        for i in 0 to 4 loop
            report "VLAN ID " & integer'image(i) & ": IP allocated: " & to_ip_string(ip_addresses(i));
        end loop;

        -- Test with all VLANs
        total_vlans <= 10;
        enable_dhcp <= '1';
        wait for 100 ns;
        report "Test with 10 VLANs completed. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);
        for i in 0 to 9 loop
            report "VLAN ID " & integer'image(i) & ": IP allocated: " & to_ip_string(ip_addresses(i));
        end loop;

        -- Disable DHCP
        enable_dhcp <= '0';
        wait for 50 ns;
        report "DHCP disabled. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);

        -- Test with 3 VLANs
        total_vlans <= 3;
        enable_dhcp <= '1';
        wait for 100 ns;
        report "Test with 3 VLANs completed. Current status: " & to_binary_string(status) & ", Completion: " & to_binary_string(selesai);
        for i in 0 to 2 loop
            report "VLAN ID " & integer'image(i) & ": IP allocated: " & to_ip_string(ip_addresses(i));
        end loop;

        wait;
    end process;

end Behavioral;
