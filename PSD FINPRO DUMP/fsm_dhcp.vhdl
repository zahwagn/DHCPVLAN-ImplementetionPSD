library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity DHCP_Server is
    Port ( clk         : in  STD_LOGIC;
           reset       : in  STD_LOGIC;
           network     : in  STD_LOGIC_VECTOR(31 downto 0);  -- Network Address
           subnet_mask : in  STD_LOGIC_VECTOR(31 downto 0);  -- Subnet Mask
           num_devices : in  integer;                         -- Number of End Devices
           mulai       : in  STD_LOGIC;                       -- Start Process
           ip_address  : out STD_LOGIC_VECTOR(31 downto 0);   -- Allocated IP Address
           gateway     : out STD_LOGIC_VECTOR(31 downto 0);   -- Default Gateway
           subnet_out  : out STD_LOGIC_VECTOR(31 downto 0);   -- Subnet Mask
           selesai     : out STD_LOGIC                         -- Indication of Process Completion
           );
end DHCP_Server;

architecture Behavioral of DHCP_Server is

    type state_type is (idle, discover, offer, request, ack, finish);
    signal current_state, next_state : state_type;

    signal last_ip        : std_logic_vector(31 downto 0) := (others => '0'); -- Tracking last IP assigned
    signal allocated_ip   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); 

    file input_file  : text open read_mode is "dhcp_input.txt";
    file output_file : text open write_mode is "dhcp_output.txt";

    -- Procedure to write to output.txt
    procedure write_ip_to_file(
        variable ip_to_write : in std_logic_vector(31 downto 0)
    ) is
        variable write_buffer : line;
        variable ip_str        : string(1 to 32);  -- Buffer to store IP as string
    begin
        -- Convert std_logic_vector to string
        for i in 1 to 32 loop
            if ip_to_write(32 - i) = '1' then
                ip_str(i) := '1';
            else
                ip_str(i) := '0';
            end if;
        end loop;

        -- Write to file
        write(write_buffer, ip_str);
        writeline(output_file, write_buffer);
    end procedure;

begin
    -- FSM Process
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- State Machine Logic
    process(current_state, mulai, num_devices)
        variable host_bits : integer := 0; -- Count of '0' in subnet mask
        variable set_gateway   : STD_LOGIC_VECTOR(7 downto 0);
        variable set_ip        : STD_LOGIC_VECTOR(7 downto 0);
        variable count        : integer := 0;
        variable temp_ip      : std_logic_vector(31 downto 0);  -- Temporary variable for allocated IP
        variable var_last_ip  : std_logic_vector(31 downto 0) := (others => '0'); -- Tracking last IP assigned
    begin
        -- Default output values
        next_state <= current_state;

        case current_state is
            when idle =>
                ip_address <= (others => '0');
                gateway <= (others => '0');
                subnet_out <= (others => '0');
                if mulai = '1' and count < num_devices then
                    next_state <= discover;
                    count := count + 1;
                    selesai <= '0';
                else
                    next_state <= idle;
                    selesai <= '1';
                end if;

            when discover =>
                -- Set gateway and subnet mask
                set_gateway := std_logic_vector(unsigned(subnet_mask(7 downto 0)) + 1);
                gateway <= network(31 downto 8) & set_gateway;
                if count = 1 then last_ip <= network(31 downto 8) & set_gateway;
                end if;

                next_state <= offer;

            when offer =>
                -- Calculate next IP
                set_ip := std_logic_vector(unsigned(last_ip(7 downto 0)) + 1);
                allocated_ip <= network(31 downto 8) & set_ip;

                subnet_out <= subnet_mask;
                next_state <= request;

            when request =>
                ip_address <= allocated_ip;
                last_ip <= allocated_ip;
                next_state <= ack;

            when ack =>
                next_state <= finish;

            when finish =>
                -- Write the allocated IP to the output file
                temp_ip := allocated_ip;  -- Use temporary variable
                write_ip_to_file(temp_ip);  -- Call procedure to write to file
                next_state <= idle;

        end case;
    end process;

end Behavioral;
