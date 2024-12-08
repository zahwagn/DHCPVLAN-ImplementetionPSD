library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VLAN_Allocation is
    Port ( clk           : in  STD_LOGIC;
           reset         : in  STD_LOGIC;
           total_vlans   : in  integer range 1 to 10;  -- Input total number of VLANs
           vlan          : out STD_LOGIC_VECTOR(9 downto 0);  -- Output VLAN IDs
           done          : out std_logic
           );               -- Process completion flag
end VLAN_Allocation;

architecture Behavioral of VLAN_Allocation is

    -- Signal declarations
    type integer_array is array (0 to 9) of integer;  -- Define the integer array type for internal signals
    signal vlan_id_array_sig : integer_array := (others => 0);  -- Signal to store VLAN IDs
    signal vlan_counter      : integer := 0;
    signal state             : integer := 0;
    signal all_vlans         : std_logic_vector(9 downto 0) := (others => '1');

begin

    -- Process to handle VLAN allocation
    process(clk, reset)
    begin
        if reset = '1' then
            state <= 0;
            vlan_counter <= 0;
            vlan_id_array_sig <= (others => 0);
            all_vlans <= (others => '1');
        elsif rising_edge(clk) then
            case state is
                when 0 =>  -- Initial state, start the process
                    if total_vlans > 0 then
                        done <= '0';
                        state <= 1;  -- Proceed to VLAN allocation
                    end if;

                when 1 =>  -- VLAN allocation
                    if vlan_counter < total_vlans then
                        -- Calculate VLAN ID (kelipatan 10 mulai dari 10)
                        vlan_id_array_sig(vlan_counter) <= (vlan_counter + 1) * 10;
                        vlan <= (others => '0');  -- Reset output
                        vlan(vlan_counter downto 0) <= all_vlans(vlan_counter downto 0);  -- Output all VLAN IDs
                        -- Move to next VLAN
                        vlan_counter <= vlan_counter + 1;
                    else
                        state <= 2;
                    end if;

                when 2 =>  -- Indicate completion
                    done <= '1';
                    vlan_counter <= 0;
                    state <= 0;  -- Go back to initial state

                when others =>  -- Default case
                    state <= 0;

            end case;
        end if;
    end process;
end Behavioral;
