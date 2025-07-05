library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registro8 is
    Port (
        Reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC;  
        Entradas : in  STD_LOGIC_VECTOR(4 downto 0);
        Salidas  : out STD_LOGIC_VECTOR(4 downto 0)
    );
end Registro8;

architecture Behavioral of Registro8 is
    signal Salida_reg    : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal enable_prev   : STD_LOGIC := '0';
begin
    process(enable, Reset)
    begin
        if Reset = '1' then
            Salida_reg <= (others => '0');
        elsif (enable_prev = '0' and enable = '1') then
            Salida_reg <= Entradas;
        end if;
        enable_prev <= enable;  
    end process;

    Salidas <= Salida_reg;
end Behavioral;
