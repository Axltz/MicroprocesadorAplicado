library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memoria_ROM is
    Port (
        direccion : in  STD_LOGIC_VECTOR(4 downto 0);
        dato     : out STD_LOGIC_VECTOR(8 downto 0)
    );
end memoria_ROM;

architecture Behavioral of memoria_ROM is

    type ROM_type is array (0 to 31) of STD_LOGIC_VECTOR(8 downto 0);
    signal ROM : ROM_type := (
    --01 Hum 10 Luz 5 Temp 11
        0 => "010011010",  -- READ_SENSOR
        1 => "010101010",  -- STORE
        2 => "010111010",  -- FILTRO
        3 => "011001010",  -- COMPARE
        4 => "011011010",  -- ACTIVATE
        5 => "011101010",  -- DEACTIVATE
        6 => "010001010",  -- NOP

        8  => "100010101",  -- READ_SENSOR 
        9  => "100100101",  -- STORE
        10 => "100110101",  -- FILTRO
        11 => "101000101",  -- COMPARE
        12 => "101010101",  -- ACTIVATE
        13 => "101100101",  -- DEACTIVATE
        14 => "100000101",  -- NOP

        16 => "110011011",  -- READ_SENSOR 
        17 => "110101011",  -- STORE
        18 => "110111011",  -- FILTRO
        19 => "111001011",  -- COMPARE
        20 => "111011011",  -- ACTIVATE
        21 => "111101011",  -- DEACTIVATE
        22 => "110001011",  -- NOP

        23 => "111110001",  -- JUMP to 1 

        others => (others => '0')
    );

begin

    dato <= ROM(to_integer(unsigned(direccion)));

end Behavioral;
