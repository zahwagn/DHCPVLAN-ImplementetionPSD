library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DHCP_Server is
    Port ( clk         : in  STD_LOGIC;
           reset       : in  STD_LOGIC;
           network     : in  STD_LOGIC_VECTOR(31 downto 0);  -- Network Address
           subnet_mask : in  STD_LOGIC_VECTOR(31 downto 0);  -- Subnet Mask
           num_devices : in  integer;                         -- Number of End Devices
           mulai       : in  STD_LOGIC;                       -- Start Process
           ip_address  : out STD_LOGIC_VECTOR(31 downto 0);   -- Allocated IP Address
           gateway     : out STD_LOGIC_VECTOR(31 downto 0);   -- Default Gateway
           subnet_out  : out STD_LOGIC_VECTOR(31 downto 0);    -- Subnet Mask
           selesai     : out STD_LOGIC                         -- Indication of Process Completion
           );
end DHCP_Server;

architecture Behavioral of DHCP_Server is

    type state_type is (idle, discover, offer, request, ack, finish);
    signal current_state, next_state : state_type;
    
    signal ip_pool        : STD_LOGIC_VECTOR(31 downto 0);  -- To keep track of the IP pool
    signal allocated_ip   : STD_LOGIC_VECTOR(31 downto 0);  -- Currently allocated IP
    signal count          : integer := 0;                    -- Counter for the loop

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
    process(current_state, num_devices)
    begin
        -- Default output values
        next_state <= current_state;
        ip_address <= (others => '0');
        gateway <= (others => '0');
        subnet_out <= (others => '0');
        case current_state is
            when idle =>
                if mulai = '1' and count < num_devices then
                    next_state <= discover;
                else
                    next_state <= idle;
                end if;

            when discover =>
                selesai <= '0';  -- Indicate that the process is ongoing
                -- Discover state: the server receives a DHCPDISCOVER message
                -- The server prepares to offer an IP
                next_state <= offer;

            when offer =>
                -- Offer state: the server offers an IP address
                -- The IP address to offer is network + 1 (the first available IP)
                ip_address <= network + "00000001";  -- Assign first IP
                gateway <= network + "00000001";    -- Assign default gateway
                subnet_out <= subnet_mask;          -- Assign subnet mask
                next_state <= request;

            when request =>
                -- Request state: the server receives DHCPREQUEST
                next_state <= ack;

            when ack =>
                -- Acknowledge state: The server sends DHCPACK
                -- Finalize the allocation of the IP address
                next_state <= finish;

            when finish =>
                -- Finish state: DHCP process is complete
                selesai <= '1';  -- Indicate that the process is complete
                next_state <= idle;
        end case;
    end process;

    -- Looping Construct (Simple Example for IP Address Pool Allocation)
    process(num_devices)
    begin
        -- Initialize the IP pool based on the network address
        ip_pool <= network + 1;  -- Starting IP in the network range
        for i in 1 to num_devices loop
            -- Increment the IP pool for each device
            ip_pool <= ip_pool + 1;  -- This is the signal assignment
        end loop;
    end process;

end Behavioral;
