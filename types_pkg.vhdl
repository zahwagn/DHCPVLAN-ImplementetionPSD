library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package types_pkg is
    -- Type declaration for array of STD_LOGIC_VECTOR
    type ip_array is array (0 to 9) of STD_LOGIC_VECTOR(31 downto 0);
end types_pkg;
