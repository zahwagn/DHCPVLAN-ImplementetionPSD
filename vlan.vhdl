library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VLAN_Allocation is
    Port ( clk           : in  STD_LOGIC;
           reset         : in  STD_LOGIC;
           total_vlans   : in  integer range 1 to 10;    -- Input total number of VLANs
           done          : out STD_LOGIC                     -- Process completion flag
           );
end VLAN_Allocation;

architecture Behavioral of VLAN_Allocation is

    -- Signal to store VLAN IDs and their corresponding network addresses
    type integer_array is array (0 to 255) of integer;
    signal vlan_id_array : integer_array := (others => 0);

    signal vlan_counter : integer := 0;
    signal state        : integer := 0;

begin

    -- Process to handle VLAN allocation and network addressing
    process(clk, reset)
    begin
        if reset = '1' then
            state <= 0;
            vlan_counter <= 0;
            done <= '0';
            vlan_id_array <= (others => 0);
        elsif rising_edge(clk) then
            case state is
                when 0 =>  -- Initial state, start the process
                    if total_vlans > 0 then
                        state <= 1;  -- Proceed to VLAN allocation
                    end if;

                when 1 =>  -- VLAN allocation and network assignment
                    if vlan_counter < total_vlans then
                        -- Calculate VLAN ID (kelipatan 10 mulai dari 10)
                        vlan_id_array(vlan_counter) <= (vlan_counter + 1) * 10;
                        vlan_counter <= vlan_counter + 1;
                    else
                        state <= 2;  -- Finished VLAN assignment
                    end if;

                when 2 =>  -- Indicate completion
                    done <= '1';
                    state <= 0;  -- Go back to initial state

                when others =>  -- Default case
                    state <= 0;

            end case;
        end if;
    end process;
end Behavioral;