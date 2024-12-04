library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;

entity vlan_manager_textio is
    Port (
        clk        : in  std_logic;
        vlan_id    : in  std_logic_vector(7 downto 0);
        valid_vlan : out std_logic
    );
end vlan_manager_textio;

architecture Behavioral of vlan_manager_textio is

    -- Fungsi konversi string ke std_logic_vector
    function to_stdlogicvector(input: string) return std_logic_vector is
        variable result : std_logic_vector(input'length - 1 downto 0);
    begin
        for i in input'range loop
            if input(i) = '1' then
                result(i) := '1';
            else
                result(i) := '0';
            end if;
        end loop;
        return result;
    end function;

begin
    process(clk)
        -- File eksternal untuk VLAN
        file vlan_table_file : text open read_mode is "vlan_table.txt";
        
        -- Variabel untuk membaca file
        variable vlan_line : line;
        variable vlan_read : string(1 to 8); -- String untuk 8-bit VLAN ID
        variable found : boolean := false;
    begin
        if rising_edge(clk) then
            found := false;

            -- Baca file VLAN dan periksa apakah VLAN ada dalam daftar
            while not endfile(vlan_table_file) loop
                readline(vlan_table_file, vlan_line);
                read(vlan_line, vlan_read);

                -- Konversi string ke std_logic_vector dan bandingkan
                if vlan_id = to_stdlogicvector(vlan_read) then
                    found := true;
                end if;
            end loop;

            -- Jika ditemukan, set valid_vlan ke '1', jika tidak set '0'
            if found then
                valid_vlan <= '1';
            else
                valid_vlan <= '0';
            end if;
        end if;
    end process;

end Behavioral;
